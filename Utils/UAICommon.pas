unit UAICommon;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

type
  TProviderRequestStatus = (prsQueued, prsRunning, prsSucceeded, prsFailed, prsCancelled);

  TAIProviderCapability = (pcModelListing, pcStreaming, pcCustomEndpoint, pcOffline);
  TAIProviderCapabilities = set of TAIProviderCapability;

  TProxySetting = class
  private
    FActive: Boolean;
    FProxyHost: string;
    FProxyPort: Integer;
    FProxyUsername: string;
    FProxyPassword: string;
  public
    procedure Assign(const ASource: TProxySetting);
    function Clone: TProxySetting;

    property Active: Boolean read FActive write FActive;
    property ProxyHost: string read FProxyHost write FProxyHost;
    property ProxyPort: Integer read FProxyPort write FProxyPort;
    property ProxyUsername: string read FProxyUsername write FProxyUsername;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
  end;

  TModelDescriptor = class
  private
    FProviderId: string;
    FModelId: string;
    FDisplayName: string;
    FFetchedAt: TDateTime;
    FCapabilities: TAIProviderCapabilities;
  public
    procedure Assign(const ASource: TModelDescriptor);
    function Clone: TModelDescriptor;

    property ProviderId: string read FProviderId write FProviderId;
    property ModelId: string read FModelId write FModelId;
    property DisplayName: string read FDisplayName write FDisplayName;
    property FetchedAt: TDateTime read FFetchedAt write FFetchedAt;
    property Capabilities: TAIProviderCapabilities read FCapabilities write FCapabilities;
  end;

  TModelDescriptorList = TObjectList<TModelDescriptor>;

  TAIProviderSetting = class
  private
    FProviderId: string;
    FDisplayName: string;
    FEnabled: Boolean;
    FApiKey: string;
    FBaseURL: string;
    FDefaultModel: string;
    FMaxTokens: Integer;
    FTemperature: Double;
    FTopP: Double;
    FTopK: Integer;
    FApiVersion: string;
  public
    procedure Assign(const ASource: TAIProviderSetting);
    function Clone: TAIProviderSetting;

    property ProviderId: string read FProviderId write FProviderId;
    property DisplayName: string read FDisplayName write FDisplayName;
    property Enabled: Boolean read FEnabled write FEnabled;
    property ApiKey: string read FApiKey write FApiKey;
    property BaseURL: string read FBaseURL write FBaseURL;
    property DefaultModel: string read FDefaultModel write FDefaultModel;
    property MaxTokens: Integer read FMaxTokens write FMaxTokens;
    property Temperature: Double read FTemperature write FTemperature;
    property TopP: Double read FTopP write FTopP;
    property TopK: Integer read FTopK write FTopK;
    property ApiVersion: string read FApiVersion write FApiVersion;
  end;

  TProviderRequest = class
  private
    FRequestId: string;
    FBatchId: string;
    FProviderId: string;
    FQuestionText: string;
    FQuestionLabel: string;
    FModelId: string;
    FMaxTokens: Integer;
    FTemperature: Double;
    FTimeoutSeconds: Integer;
    FAnimated: Boolean;
    FLogEnabled: Boolean;
    FLogDirectory: string;
    FProxySetting: TProxySetting;
  public
    constructor Create;
    destructor Destroy; override;

    property RequestId: string read FRequestId write FRequestId;
    property BatchId: string read FBatchId write FBatchId;
    property ProviderId: string read FProviderId write FProviderId;
    property QuestionText: string read FQuestionText write FQuestionText;
    property QuestionLabel: string read FQuestionLabel write FQuestionLabel;
    property ModelId: string read FModelId write FModelId;
    property MaxTokens: Integer read FMaxTokens write FMaxTokens;
    property Temperature: Double read FTemperature write FTemperature;
    property TimeoutSeconds: Integer read FTimeoutSeconds write FTimeoutSeconds;
    property Animated: Boolean read FAnimated write FAnimated;
    property LogEnabled: Boolean read FLogEnabled write FLogEnabled;
    property LogDirectory: string read FLogDirectory write FLogDirectory;
    property ProxySetting: TProxySetting read FProxySetting;
  end;

  TProviderResponse = class
  private
    FRequestId: string;
    FBatchId: string;
    FProviderId: string;
    FProviderDisplayName: string;
    FModelId: string;
    FQuestionText: string;
    FQuestionLabel: string;
    FResponseText: string;
    FErrorText: string;
    FStatus: TProviderRequestStatus;
    FCreatedAt: TDateTime;
    FStartedAt: TDateTime;
    FFinishedAt: TDateTime;
    FDurationMs: Int64;
  public
    constructor Create;
    function Clone: TProviderResponse;

    property RequestId: string read FRequestId write FRequestId;
    property BatchId: string read FBatchId write FBatchId;
    property ProviderId: string read FProviderId write FProviderId;
    property ProviderDisplayName: string read FProviderDisplayName write FProviderDisplayName;
    property ModelId: string read FModelId write FModelId;
    property QuestionText: string read FQuestionText write FQuestionText;
    property QuestionLabel: string read FQuestionLabel write FQuestionLabel;
    property ResponseText: string read FResponseText write FResponseText;
    property ErrorText: string read FErrorText write FErrorText;
    property Status: TProviderRequestStatus read FStatus write FStatus;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property StartedAt: TDateTime read FStartedAt write FStartedAt;
    property FinishedAt: TDateTime read FFinishedAt write FFinishedAt;
    property DurationMs: Int64 read FDurationMs write FDurationMs;
  end;

  TProviderMessageKind = (pmRequestStarted, pmRequestCompleted, pmBatchCompleted);

  TProviderMessagePayload = class
  private
    FKind: TProviderMessageKind;
    FBatchId: string;
    FProviderId: string;
    FResponse: TProviderResponse;
  public
    constructor Create(AKind: TProviderMessageKind; const ABatchId, AProviderId: string; AResponse: TProviderResponse = nil);
    destructor Destroy; override;

    property Kind: TProviderMessageKind read FKind;
    property BatchId: string read FBatchId;
    property ProviderId: string read FProviderId;
    property Response: TProviderResponse read FResponse;
  end;

function ProviderStatusToString(AStatus: TProviderRequestStatus): string;
function ProviderStatusFromString(const AValue: string): TProviderRequestStatus;

implementation

procedure TProxySetting.Assign(const ASource: TProxySetting);
begin
  if not Assigned(ASource) then
    Exit;

  FActive := ASource.Active;
  FProxyHost := ASource.ProxyHost;
  FProxyPort := ASource.ProxyPort;
  FProxyUsername := ASource.ProxyUsername;
  FProxyPassword := ASource.ProxyPassword;
end;

function TProxySetting.Clone: TProxySetting;
begin
  Result := TProxySetting.Create;
  Result.Assign(Self);
end;

procedure TModelDescriptor.Assign(const ASource: TModelDescriptor);
begin
  if not Assigned(ASource) then
    Exit;

  FProviderId := ASource.ProviderId;
  FModelId := ASource.ModelId;
  FDisplayName := ASource.DisplayName;
  FFetchedAt := ASource.FetchedAt;
  FCapabilities := ASource.Capabilities;
end;

function TModelDescriptor.Clone: TModelDescriptor;
begin
  Result := TModelDescriptor.Create;
  Result.Assign(Self);
end;

procedure TAIProviderSetting.Assign(const ASource: TAIProviderSetting);
begin
  if not Assigned(ASource) then
    Exit;

  FProviderId := ASource.ProviderId;
  FDisplayName := ASource.DisplayName;
  FEnabled := ASource.Enabled;
  FApiKey := ASource.ApiKey;
  FBaseURL := ASource.BaseURL;
  FDefaultModel := ASource.DefaultModel;
  FMaxTokens := ASource.MaxTokens;
  FTemperature := ASource.Temperature;
  FTopP := ASource.TopP;
  FTopK := ASource.TopK;
  FApiVersion := ASource.ApiVersion;
end;

function TAIProviderSetting.Clone: TAIProviderSetting;
begin
  Result := TAIProviderSetting.Create;
  Result.Assign(Self);
end;

constructor TProviderRequest.Create;
begin
  inherited Create;
  FProxySetting := TProxySetting.Create;
end;

destructor TProviderRequest.Destroy;
begin
  FProxySetting.Free;
  inherited;
end;

constructor TProviderResponse.Create;
begin
  inherited Create;
  FCreatedAt := Now;
  FStartedAt := Now;
end;

function TProviderResponse.Clone: TProviderResponse;
begin
  Result := TProviderResponse.Create;
  Result.RequestId := FRequestId;
  Result.BatchId := FBatchId;
  Result.ProviderId := FProviderId;
  Result.ProviderDisplayName := FProviderDisplayName;
  Result.ModelId := FModelId;
  Result.QuestionText := FQuestionText;
  Result.QuestionLabel := FQuestionLabel;
  Result.ResponseText := FResponseText;
  Result.ErrorText := FErrorText;
  Result.Status := FStatus;
  Result.CreatedAt := FCreatedAt;
  Result.StartedAt := FStartedAt;
  Result.FinishedAt := FFinishedAt;
  Result.DurationMs := FDurationMs;
end;

constructor TProviderMessagePayload.Create(AKind: TProviderMessageKind; const ABatchId, AProviderId: string; AResponse: TProviderResponse);
begin
  inherited Create;
  FKind := AKind;
  FBatchId := ABatchId;
  FProviderId := AProviderId;
  FResponse := AResponse;
end;

destructor TProviderMessagePayload.Destroy;
begin
  FResponse.Free;
  inherited;
end;

function ProviderStatusFromString(const AValue: string): TProviderRequestStatus;
begin
  if SameText(AValue, 'queued') then
    Exit(prsQueued);

  if SameText(AValue, 'running') then
    Exit(prsRunning);

  if SameText(AValue, 'failed') then
    Exit(prsFailed);

  if SameText(AValue, 'cancelled') then
    Exit(prsCancelled);

  Result := prsSucceeded;
end;

function ProviderStatusToString(AStatus: TProviderRequestStatus): string;
begin
  case AStatus of
    prsQueued: Result := 'queued';
    prsRunning: Result := 'running';
    prsSucceeded: Result := 'succeeded';
    prsFailed: Result := 'failed';
    prsCancelled: Result := 'cancelled';
  else
    Result := 'unknown';
  end;
end;

end.
