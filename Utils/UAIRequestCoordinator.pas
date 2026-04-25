unit UAIRequestCoordinator;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.Math,
  System.SysUtils,
  System.Generics.Collections,
  UAICommon,
  UAIProviders,
  UChatGPTSetting,
  UConsts;

type
  TProviderExecutionThread = class(TThread)
  private
    FTargetHandle: HWND;
    FProvider: IAIProvider;
    FRequest: TProviderRequest;
    FSettings: TAIProviderSetting;
    FLastResponse: TProviderResponse;
    procedure PostPayload(APayload: TProviderMessagePayload);
    function BuildFailedResponse(const AMessage: string): TProviderResponse;
  protected
    procedure Execute; override;
  public
    constructor Create(ATargetHandle: HWND; const AProvider: IAIProvider; const ARequest: TProviderRequest;
      const ASettings: TAIProviderSetting);
    destructor Destroy; override;

    property LastResponse: TProviderResponse read FLastResponse;
    property Request: TProviderRequest read FRequest;
  end;

  TAIRequestCoordinator = class(TComponent)
  private
    FTargetHandle: HWND;
    FThreads: TObjectDictionary<string, TProviderExecutionThread>;
    FCurrentBatchId: string;
    FSignalBatchCompleted: Boolean;
    procedure ThreadTerminated(Sender: TObject);
    procedure PostBatchCompleted(const ABatchId: string);
    function NewId: string;
    function BuildRequest(const AProviderId, APrompt, AQuestionLabel: string): TProviderRequest;
    function GetProviderIdsForPrompt(const AActiveProviderId: string): TArray<string>;
  public
    constructor Create(AOwner: TComponent; ATargetHandle: HWND); reintroduce;
    destructor Destroy; override;

    procedure StartPromptBatch(const APrompt, AQuestionLabel, AActiveProviderId: string);
    procedure StartSingleProvider(const AProviderId, APrompt, AQuestionLabel: string; ASignalBatchCompleted: Boolean = True);
    procedure CancelAll;
    function PendingCount: Integer;
    function HasPendingRequests: Boolean;
    property CurrentBatchId: string read FCurrentBatchId;
    property TargetHandle: HWND read FTargetHandle write FTargetHandle;
end;

implementation

function TProviderExecutionThread.BuildFailedResponse(const AMessage: string): TProviderResponse;
begin
  Result := TProviderResponse.Create;
  Result.RequestId := FRequest.RequestId;
  Result.BatchId := FRequest.BatchId;
  Result.ProviderId := FRequest.ProviderId;
  if Assigned(FProvider) then
    Result.ProviderDisplayName := FProvider.GetDisplayName
  else
    Result.ProviderDisplayName := FRequest.ProviderId;
  Result.ModelId := FRequest.ModelId;
  Result.QuestionText := FRequest.QuestionText;
  Result.QuestionLabel := FRequest.QuestionLabel;
  Result.Status := prsFailed;
  Result.ErrorText := AMessage;
  Result.StartedAt := Now;
  Result.FinishedAt := Result.StartedAt;
  Result.DurationMs := 0;
end;

constructor TProviderExecutionThread.Create(ATargetHandle: HWND; const AProvider: IAIProvider; const ARequest: TProviderRequest;
  const ASettings: TAIProviderSetting);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FTargetHandle := ATargetHandle;
  FProvider := AProvider;
  FRequest := ARequest;
  FSettings := ASettings.Clone;
end;

destructor TProviderExecutionThread.Destroy;
begin
  FRequest.Free;
  FSettings.Free;
  inherited;
end;

procedure TProviderExecutionThread.Execute;
begin
  inherited;
  try
    if Terminated then
      Exit;

    if not Assigned(FProvider) then
      FLastResponse := BuildFailedResponse(CProviderUnavailableMessage)
    else
      FLastResponse := FProvider.Execute(FRequest, FSettings);

    if not Assigned(FLastResponse) then
      FLastResponse := BuildFailedResponse(CProgressFailed);

    if Terminated and Assigned(FLastResponse) then
    begin
      FLastResponse.Status := prsCancelled;
      if FLastResponse.ErrorText = '' then
        FLastResponse.ErrorText := CProgressCancelled;
      FLastResponse.FinishedAt := Now;
    end;
  except
    on E: Exception do
      FLastResponse := BuildFailedResponse(E.Message);
  end;

  if Assigned(FLastResponse) then
    PostPayload(TProviderMessagePayload.Create(pmRequestCompleted, FRequest.BatchId, FRequest.ProviderId, FLastResponse.Clone));
end;

procedure TProviderExecutionThread.PostPayload(APayload: TProviderMessagePayload);
begin
  if IsWindow(FTargetHandle) then
  begin
    if not PostMessage(FTargetHandle, WM_PROVIDER_MESSAGE, WPARAM(APayload), 0) then
      APayload.Free;
  end
  else
    APayload.Free;
end;

function TAIRequestCoordinator.BuildRequest(const AProviderId, APrompt, AQuestionLabel: string): TProviderRequest;
var
  LSettings: TSingletonSettingObj;
  LProviderSetting: TAIProviderSetting;
begin
  LSettings := TSingletonSettingObj.Instance;
  Result := TProviderRequest.Create;
  Result.RequestId := NewId;
  Result.BatchId := FCurrentBatchId;
  Result.ProviderId := AProviderId;
  Result.QuestionText := APrompt;
  Result.QuestionLabel := AQuestionLabel;
  if LSettings.TimeOut > 0 then
    Result.TimeoutSeconds := Max(CMinRequestTimeoutSeconds, LSettings.TimeOut)
  else
  Result.TimeoutSeconds := CDefaultRequestTimeoutSeconds;
  Result.Animated := LSettings.AnimatedLetters;
  Result.LogEnabled := LSettings.EnableFileLog;
  Result.LogDirectory := LSettings.LogDirectory;
  Result.ProxySetting.Assign(LSettings.ProxySetting);
  LProviderSetting := LSettings.GetProviderSetting(AProviderId);
  try
    Result.ModelId := LSettings.GetEffectiveModel(AProviderId);
    if LProviderSetting.MaxTokens > 0 then
      Result.MaxTokens := LProviderSetting.MaxTokens
    else
      Result.MaxTokens := LSettings.MaxToken;

    if LProviderSetting.Temperature >= 0 then
      Result.Temperature := LProviderSetting.Temperature
    else
      Result.Temperature := LSettings.Temperature;
  finally
    LProviderSetting.Free;
  end;
end;

procedure TAIRequestCoordinator.CancelAll;
var
  LThread: TProviderExecutionThread;
begin
  for LThread in FThreads.Values do
  begin
    LThread.OnTerminate := nil;
    LThread.Terminate;
  end;
  FThreads.Clear;
  FCurrentBatchId := '';
end;

constructor TAIRequestCoordinator.Create(AOwner: TComponent; ATargetHandle: HWND);
begin
  inherited Create(AOwner);
  FTargetHandle := ATargetHandle;
  FThreads := TObjectDictionary<string, TProviderExecutionThread>.Create;
end;

destructor TAIRequestCoordinator.Destroy;
begin
  CancelAll;
  FThreads.Free;
  inherited;
end;

function TAIRequestCoordinator.GetProviderIdsForPrompt(const AActiveProviderId: string): TArray<string>;
var
  LSettings: TSingletonSettingObj;
begin
  LSettings := TSingletonSettingObj.Instance;
  Result := LSettings.GetEnabledProviderIds;

  if Length(Result) <= 1 then
  begin
    if (Length(Result) = 0) and (AActiveProviderId <> '') then
    begin
      SetLength(Result, 1);
      Result[0] := AActiveProviderId;
    end;
    Exit;
  end;
end;

function TAIRequestCoordinator.HasPendingRequests: Boolean;
begin
  Result := PendingCount > 0;
end;

function TAIRequestCoordinator.NewId: string;
var
  LGUID: TGUID;
begin
  CreateGUID(LGUID);
  Result := GUIDToString(LGUID);
end;

function TAIRequestCoordinator.PendingCount: Integer;
begin
  Result := FThreads.Count;
end;

procedure TAIRequestCoordinator.PostBatchCompleted(const ABatchId: string);
var
  LPayload: TProviderMessagePayload;
begin
  LPayload := TProviderMessagePayload.Create(pmBatchCompleted, ABatchId, '');
  if IsWindow(FTargetHandle) then
  begin
    if not PostMessage(FTargetHandle, WM_PROVIDER_MESSAGE, WPARAM(LPayload), 0) then
      LPayload.Free;
  end
  else
    LPayload.Free;
end;

procedure TAIRequestCoordinator.StartPromptBatch(const APrompt, AQuestionLabel, AActiveProviderId: string);
var
  LRegistry: IAIProviderRegistry;
  LProviderIds: TArray<string>;
  LProviderId: string;
  LThread: TProviderExecutionThread;
  LPayload: TProviderMessagePayload;
begin
  CancelAll;
  FCurrentBatchId := NewId;
  FSignalBatchCompleted := True;
  LRegistry := TAIProviderRegistry.Instance;
  LProviderIds := GetProviderIdsForPrompt(AActiveProviderId);

  for LProviderId in LProviderIds do
  begin
    LThread := TProviderExecutionThread.Create(
      FTargetHandle,
      LRegistry.GetProvider(LProviderId),
      BuildRequest(LProviderId, APrompt, AQuestionLabel),
      TSingletonSettingObj.Instance.GetProviderSetting(LProviderId)
    );
    LThread.OnTerminate := ThreadTerminated;
    FThreads.Add(LThread.Request.RequestId, LThread);
    LPayload := TProviderMessagePayload.Create(pmRequestStarted, FCurrentBatchId, LProviderId);
    if IsWindow(FTargetHandle) then
    begin
      if not PostMessage(FTargetHandle, WM_PROVIDER_MESSAGE, WPARAM(LPayload), 0) then
        LPayload.Free;
    end
    else
      LPayload.Free;
    LThread.Start;
  end;
end;

procedure TAIRequestCoordinator.StartSingleProvider(const AProviderId, APrompt, AQuestionLabel: string; ASignalBatchCompleted: Boolean);
var
  LThread: TProviderExecutionThread;
  LRegistry: IAIProviderRegistry;
  LPayload: TProviderMessagePayload;
begin
  CancelAll;
  FCurrentBatchId := NewId;
  FSignalBatchCompleted := ASignalBatchCompleted;
  LRegistry := TAIProviderRegistry.Instance;
  LThread := TProviderExecutionThread.Create(
    FTargetHandle,
    LRegistry.GetProvider(AProviderId),
    BuildRequest(AProviderId, APrompt, AQuestionLabel),
    TSingletonSettingObj.Instance.GetProviderSetting(AProviderId)
  );
  LThread.OnTerminate := ThreadTerminated;
  FThreads.Add(LThread.Request.RequestId, LThread);
  LPayload := TProviderMessagePayload.Create(pmRequestStarted, FCurrentBatchId, AProviderId);
  if IsWindow(FTargetHandle) then
  begin
    if not PostMessage(FTargetHandle, WM_PROVIDER_MESSAGE, WPARAM(LPayload), 0) then
      LPayload.Free;
  end
  else
    LPayload.Free;
  LThread.Start;
end;

procedure TAIRequestCoordinator.ThreadTerminated(Sender: TObject);
var
  LThread: TProviderExecutionThread;
  LBatchId: string;
  LPendingThread: TProviderExecutionThread;
  LHasPendingCurrentBatch: Boolean;
begin
  LThread := Sender as TProviderExecutionThread;
  LBatchId := '';
  if Assigned(LThread) and Assigned(LThread.Request) then
  begin
    LBatchId := LThread.Request.BatchId;
    FThreads.Remove(LThread.Request.RequestId);
  end;

  if (LBatchId = '') or (not SameText(LBatchId, FCurrentBatchId)) then
    Exit;

  LHasPendingCurrentBatch := False;
  for LPendingThread in FThreads.Values do
    if Assigned(LPendingThread.Request) and SameText(LPendingThread.Request.BatchId, LBatchId) then
    begin
      LHasPendingCurrentBatch := True;
      Break;
    end;

  if FSignalBatchCompleted and (not LHasPendingCurrentBatch) then
    PostBatchCompleted(LBatchId);
end;

end.
