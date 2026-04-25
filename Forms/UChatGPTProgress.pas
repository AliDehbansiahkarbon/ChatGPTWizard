{***************************************************}
{                                                   }
{   This unit contains a progressbar that           }
{   will be used in inline processes.               }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UChatGPTProgress;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Winapi.Messages, Vcl.Buttons, UChatGPTSetting, UConsts, UAIRequestCoordinator,
  System.StrUtils, System.DateUtils, System.Math,
  UAICommon, UAIProviders, UEditorHelpers
  {$IF CompilerVersion >= 32.0}
  , Vcl.WinXCtrls
  {$IFEND};

type
  TControlAccess = class(TControl);

  TFrm_Progress = class(TForm)
    pnlContainer: TPanel;
    ProgressBar: TProgressBar;
    Lbl_Top: TLabel;
    Lbl_Status: TLabel;
    btnClose: TBitBtn;
    TimerStatus: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerStatusTimer(Sender: TObject);
  private
    FCoordinator: TAIRequestCoordinator;
    FStartedAt: TDateTime;
    FTimeoutSeconds: Integer;
    FProviderName: string;
    FFinished: Boolean;
    {$IF CompilerVersion >= 32.0}
    FActivityIndicator: TActivityIndicator;
    {$IFEND}
    procedure CancelAndCloseWithMessage(const AMessage: string; AHasError: Boolean);
    function ResolvePrimaryProviderName: string;
    procedure ValidateAndStart;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure DragWindowMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    { Private declarations }
  public
    SelectedText: string;
    HasError: Boolean;
    Answer: TStringList;
    procedure OnProviderMessage(var Msg: TMessage); message WM_PROVIDER_MESSAGE;
  end;

var
  Frm_Progress: TFrm_Progress;

implementation

{$R *.dfm}

const
  ProviderNameGemini = 'Gemini';
  ProviderNameClaude = 'Claude';
  ProviderNameOllama = 'Ollama';
  ProviderNameChatGPT = 'ChatGPT';

procedure TFrm_Progress.btnCloseClick(Sender: TObject);
begin
  CancelAndCloseWithMessage(CProgressCancelled, True);
end;

procedure TFrm_Progress.CancelAndCloseWithMessage(const AMessage: string; AHasError: Boolean);
begin
  if Assigned(FCoordinator) then
    FCoordinator.CancelAll;

  TimerStatus.Enabled := False;
  {$IF CompilerVersion >= 32.0}
  if Assigned(FActivityIndicator) then
  begin
    FActivityIndicator.Animate := False;
    FActivityIndicator.Visible := False;
  end;
  {$IFEND}
  if AMessage <> '' then
    Answer.Text := AMessage;
  HasError := AHasError;
  FFinished := True;
  if Showing and (fsModal in FormState) then
    ModalResult := mrCancel
  else
    Close;
end;

procedure TFrm_Progress.CMDialogKey(var Message: TCMDialogKey);
begin
  if Message.CharCode = VK_ESCAPE then
  begin
    btnCloseClick(Self);
    Message.Result := 1;
    Exit;
  end;
  inherited;
end;

procedure TFrm_Progress.DragWindowMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure TFrm_Progress.FormCreate(Sender: TObject);
begin
  Answer := TStringList.Create;
  HasError := False;
  KeyPreview := True;
  Lbl_Top.Caption := CProgressPleaseWait;
  Lbl_Status.Caption := '';
  FFinished := False;
  FCoordinator := TAIRequestCoordinator.Create(Self, Handle);
  OnMouseDown := DragWindowMouseDown;
  pnlContainer.OnMouseDown := DragWindowMouseDown;
  Lbl_Top.OnMouseDown := DragWindowMouseDown;
  Lbl_Status.OnMouseDown := DragWindowMouseDown;
  ProgressBar.OnMouseDown := DragWindowMouseDown;
  {$IF CompilerVersion >= 32.0}
  FActivityIndicator := TActivityIndicator.Create(Self);
  FActivityIndicator.Parent := pnlContainer;
  FActivityIndicator.Width := 18;
  FActivityIndicator.Height := 18;
  FActivityIndicator.Left := pnlContainer.ClientWidth - FActivityIndicator.Width - 8;
  FActivityIndicator.Top := pnlContainer.ClientHeight - FActivityIndicator.Height - 6;
  FActivityIndicator.Anchors := [akRight, akBottom];
  FActivityIndicator.Visible := False;
  FActivityIndicator.IndicatorSize := aisSmall;
  TControlAccess(FActivityIndicator).OnMouseDown := DragWindowMouseDown;
  {$IFEND}
end;

procedure TFrm_Progress.FormDestroy(Sender: TObject);
begin
  TimerStatus.Enabled := False;
  if Assigned(FCoordinator) then
    FCoordinator.CancelAll;
  Answer.Free;
end;

procedure TFrm_Progress.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
  begin
    Key := 0;
    btnClose.Click;
  end;
end;

procedure TFrm_Progress.FormShow(Sender: TObject);
begin
  if Assigned(FCoordinator) then
    FCoordinator.TargetHandle := Handle;
  ProgressBar.Style := pbstMarquee;
  ProgressBar.MarqueeInterval := 30;
  {$IF CompilerVersion >= 32.0}
  if Assigned(FActivityIndicator) then
  begin
    FActivityIndicator.Visible := True;
    FActivityIndicator.Animate := True;
  end;
  {$IFEND}
  FStartedAt := Now;
  if TSingletonSettingObj.Instance.TimeOut > 0 then
    FTimeoutSeconds := Max(CMinRequestTimeoutSeconds, TSingletonSettingObj.Instance.TimeOut)
  else
    FTimeoutSeconds := CDefaultRequestTimeoutSeconds;
  FProviderName := ResolvePrimaryProviderName;
  Lbl_Status.Caption := Format(CProgressStartingFmt, [FProviderName]);
  TimerStatus.Enabled := True;
  ValidateAndStart;
end;

procedure TFrm_Progress.OnProviderMessage(var Msg: TMessage);
var
  LPayload: TProviderMessagePayload;
begin
  if csDestroying in ComponentState then
    Exit;

  LPayload := TProviderMessagePayload(Msg.WParam);
  try
    if not Assigned(LPayload) then
      Exit;

    case LPayload.Kind of
      pmRequestStarted:
        begin
          FProviderName := LPayload.ProviderId;
          if SameText(FProviderName, ProviderGemini) then
            FProviderName := ProviderNameGemini
          else if SameText(FProviderName, ProviderClaude) then
            FProviderName := ProviderNameClaude
          else if SameText(FProviderName, ProviderOllama) then
            FProviderName := ProviderNameOllama
          else if SameText(FProviderName, ProviderChatGPT) then
            FProviderName := ProviderNameChatGPT;
          Lbl_Status.Caption := Format(CProgressStartingFmt, [FProviderName]);
        end;
      pmRequestCompleted:
        if Assigned(LPayload.Response) then
        begin
          Answer.Text := IfThen(LPayload.Response.Status = prsSucceeded,
                                LPayload.Response.ResponseText,
                                LPayload.Response.ErrorText);
          HasError := LPayload.Response.Status <> prsSucceeded;
          if HasError and (Answer.Text = '') then
            Answer.Text := CProgressFailed;
          if TSingletonSettingObj.Instance.EnableFileLog then
            AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
              'Inline request finished for "' + LPayload.Response.ProviderDisplayName + '" with status "' +
              ProviderStatusToString(LPayload.Response.Status) + '".');
          Lbl_Status.Caption := IfThen(HasError,
                                       LPayload.Response.ProviderDisplayName + ': ' + Answer.Text,
                                       Format(CProgressCompletedFmt, [LPayload.Response.ProviderDisplayName]));
          TimerStatus.Enabled := False;
          FFinished := True;
          {$IF CompilerVersion >= 32.0}
          if Assigned(FActivityIndicator) then
            FActivityIndicator.Animate := False;
          {$IFEND}
          if TSingletonSettingObj.Instance.EnableFileLog then
            AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
              'Inline request: setting ModalResult to mrOk.');
          ModalResult := mrOk;
        end;
      pmBatchCompleted:
        begin
          if FFinished then
            Exit;
          if TSingletonSettingObj.Instance.EnableFileLog then
            AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
              'Inline request: received unexpected batch completed message.');
          TimerStatus.Enabled := False;
          FFinished := True;
          {$IF CompilerVersion >= 32.0}
          if Assigned(FActivityIndicator) then
            FActivityIndicator.Animate := False;
          {$IFEND}
          Close;
        end;
    end;
  finally
    LPayload.Free;
  end;
end;

function TFrm_Progress.ResolvePrimaryProviderName: string;
var
  LProviderId: string;
begin
  LProviderId := TSingletonSettingObj.Instance.GetPrimaryProviderId;
  if SameText(LProviderId, ProviderGemini) then
    Exit(ProviderNameGemini);
  if SameText(LProviderId, ProviderClaude) then
    Exit(ProviderNameClaude);
  if SameText(LProviderId, ProviderOllama) then
    Exit(ProviderNameOllama);
  Result := ProviderNameChatGPT;
end;

procedure TFrm_Progress.TimerStatusTimer(Sender: TObject);
var
  LElapsedSeconds: Integer;
begin
  if FFinished then
  begin
    TimerStatus.Enabled := False;
    Exit;
  end;

  LElapsedSeconds := SecondsBetween(Now, FStartedAt);
  Lbl_Status.Caption := Format(CProgressRunningFmt, [FProviderName, LElapsedSeconds]);
  if LElapsedSeconds >= FTimeoutSeconds then
  begin
    if TSingletonSettingObj.Instance.EnableFileLog then
      AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
        'Inline request timed out after ' + IntToStr(FTimeoutSeconds) + ' seconds for provider "' + FProviderName + '".');
    CancelAndCloseWithMessage(Format(CProgressTimeoutFmt, [FTimeoutSeconds]), True);
  end;
end;

procedure TFrm_Progress.ValidateAndStart;
var
  LProviderId: string;
  LProvider: IAIProvider;
  LSettings: TAIProviderSetting;
  LError: string;
begin
  if Assigned(FCoordinator) then
    FCoordinator.TargetHandle := Handle;
  LProviderId := TSingletonSettingObj.Instance.GetPrimaryProviderId;
  LProvider := TAIProviderRegistry.Instance.GetProvider(LProviderId);
  if TSingletonSettingObj.Instance.EnableFileLog then
    AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
      'Starting inline request with provider "' + LProviderId + '".');
  if not Assigned(LProvider) then
  begin
    CancelAndCloseWithMessage(CProviderUnavailableMessage, True);
    Exit;
  end;

  LSettings := TSingletonSettingObj.Instance.GetProviderSetting(LProviderId);
  try
    if not LProvider.ValidateSettings(LSettings, LError) then
    begin
      CancelAndCloseWithMessage(LProvider.GetDisplayName + ': ' + LError, True);
      Exit;
    end;
  finally
    LSettings.Free;
  end;

  FCoordinator.StartSingleProvider(LProviderId, SelectedText, CInlineQuestionLabel, False);
end;

end.
