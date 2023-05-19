{****************************************************}
{                                                    }
{    This unit contains a frame that will be         }
{    used in dockable form.                          }
{    Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{                                                    }
{****************************************************}
unit UChatGPTQFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Clipbrd,
  UChatGPTThread, UChatGPTSetting, UChatGPTLexer, System.Generics.Collections,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Data.DB, System.DateUtils,System.StrUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, UHistory,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLite, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, UConsts,
  Vcl.WinXCtrls, System.ImageList, Vcl.ImgList, ShellApi
  {$IF CompilerVersion >= 32.0}, UWriteSonicThread, UYouChatThread{$ENDIF};

type
  TOnClickProc = procedure(Sender: TObject) of object;
  TClassList = TObjectDictionary<string, TStringList>;

  TObDicHelper = class helper for TClassList
  public
    procedure FillTreeView(var ATree: TTreeView);
  end;

  TFram_Question = class(TFrame)
    pnlMain: TPanel;
    Lbl_Question: TLabel;
    pnlTop: TPanel;
    Btn_Clipboard: TButton;
    Btn_Ask: TButton;
    pmMemo: TPopupMenu;
    CopytoClipboard1: TMenuItem;
    Btn_Clear: TButton;
    chk_AutoCopy: TCheckBox;
    pnlQuestion: TPanel;
    pnlAnswer: TPanel;
    mmoQuestion: TMemo;
    pnlBottom: TPanel;
    mmoAnswer: TMemo;
    splitter: TSplitter;
    pnlCenter: TPanel;
    pgcMain: TPageControl;
    tsChatGPT: TTabSheet;
    tsClassView: TTabSheet;
    pmClassOperations: TPopupMenu;
    pnlClasses: TPanel;
    pnlPredefinedCmdAnswer: TPanel;
    splClassView: TSplitter;
    mmoClassViewDetail: TMemo;
    tsHistory: TTabSheet;
    pnlHistoryTop: TPanel;
    pnlHistoryBottom: TPanel;
    splHistory: TSplitter;
    mmoHistoryDetail: TMemo;
    FDConnection: TFDConnection;
    DSHistory: TDataSource;
    FDQryHistory: TFDQuery;
    FDQryHistoryHID: TFDAutoIncField;
    FDQryHistoryQuestion: TWideMemoField;
    FDQryHistoryAnswer: TWideMemoField;
    FDQryHistoryDate: TLargeintField;
    pmGrdHistory: TPopupMenu;
    ReloadHistory: TMenuItem;
    pnlSearchHistory: TPanel;
    Chk_CaseSensitive: TCheckBox;
    Edt_Search: TEdit;
    SearchMnu: TMenuItem;
    Chk_FuzzyMatch: TCheckBox;
    mmoClassViewResult: TMemo;
    splClassViewResult: TSplitter;
    pgcAnswers: TPageControl;
    tsChatGPTAnswer: TTabSheet;
    tsWriteSonicAnswer: TTabSheet;
    mmoWriteSonicAnswer: TMemo;
    tsYouChat: TTabSheet;
    mmoYouChatAnswer: TMemo;
    ActivityIndicator1: TActivityIndicator;
    GetQuestion: TMenuItem;
    pmClear: TPopupMenu;
    ClearQuestion1: TMenuItem;
    ClearAnswer1: TMenuItem;
    Clearallhistoryitems1: TMenuItem;
    N1: TMenuItem;
    btnHelp: TSpeedButton;
    ImageList1: TImageList;
    procedure Btn_AskClick(Sender: TObject);
    procedure Btn_ClipboardClick(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_ClearClick(Sender: TObject);
    procedure tvOnChange(Sender: TObject; Node: TTreeNode);
    procedure pmClassOperationsPopup(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure FDQryHistoryQuestionGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FDQryHistoryAfterScroll(DataSet: TDataSet);
    procedure FDQryHistoryDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure GridResize(Sender: TObject);
    procedure DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure CloseBtnClick(Sender: TObject);
    procedure ReloadHistoryClick(Sender: TObject);
    procedure SearchMnuClick(Sender: TObject);
    procedure Edt_SearchChange(Sender: TObject);
    procedure FDQryHistoryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure Chk_CaseSensitiveClick(Sender: TObject);
    procedure mmoClassViewDetailDblClick(Sender: TObject);
    procedure mmoClassViewResultDblClick(Sender: TObject);

    // Convert commands.
    procedure CSharpClick(Sender: TObject);
    procedure JavaClick(Sender: TObject);
    procedure PythonClick(Sender: TObject);
    procedure JavascriptClick(Sender: TObject);
    procedure CClick(Sender: TObject);
    procedure GoClick(Sender: TObject);
    procedure RustClick(Sender: TObject);
    procedure CPlusPlusClick(Sender: TObject);

    // Dynamic Commands.
    procedure ClassViewMenuItemClick(Sender: TObject);

    // Custom Command.
    procedure CustomCommandClick(Sender: TObject);
    procedure pgcMainChanging(Sender: TObject; var AllowChange: Boolean);
    procedure pgcAnswersChange(Sender: TObject);
    procedure GetQuestionClick(Sender: TObject);
    procedure ClearQuestion1Click(Sender: TObject);
    procedure ClearAnswer1Click(Sender: TObject);
    procedure HistoryDBGridDblClick(Sender: TObject);
    procedure Clearallhistoryitems1Click(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    FChatGPTTrd: TExecutorTrd;
    {$IF CompilerVersion >= 32.0}
    FWriteSonicTrd: TWriteSonicTrd;
    FYouChatTrd: TYouChatTrd;
    {$ENDIF}
    FClassList: TClassList;
    FClassTreeView: TTreeView;
    FCellCloseBtn: TSpeedButton;
    FHistoryGrid: THistoryDBGrid;
    FLastQuestion: string;
    FClassViewIsBusy: Boolean;

    procedure CopyToClipBoard;
    procedure CallThread(APrompt: string; AIsClassView: Boolean = False);
    function XPos(APattern, AStr: string; ACaseSensitive: Boolean): Integer;
    function LowChar(AChar: Char): Char; inline;
    function FuzzyMatchStr(const APattern, AStr: string; AMatchedIndexes: TList; ACaseSensitive: Boolean): Boolean;
    procedure HighlightCellTextFull(AGrid: THistoryDBGrid; const ARect: TRect; AField: TField; AFilterText: string; AState: TGridDrawState;
                                    ACaseSensitive: Boolean; ABkColor: TColor; ASelectedBkColor: TColor);
    procedure HighlightCellTextFuzzy(AGrid: TDbGrid; const ARect: TRect; AField: TField; AMatchedIndexes : TList; AState: TGridDrawState ;
                                ACaseSensitive: Boolean; ABkColor: TColor; ASelectedBkColor: TColor);
    procedure EnableUI(ATaskName: string);
    procedure ClearAnswers;
  public
    procedure InitialFrame;
    procedure InitialClassViewMenueItems(AClassList: TClassList);
    procedure ReloadClassList(AClassList: TClassList);
    procedure TerminateAll;
    function LoadHistory: Boolean;
    procedure AddToHistory(AQuestion, AAnswer: string);

    procedure OnUpdateMessage(var Msg: TMessage); message WM_UPDATE_MESSAGE;
    procedure OnProgressMessage(var Msg: TMessage); message WM_PROGRESS_MESSAGE;
    {$IF CompilerVersion >= 32.0}
    procedure OnWriteSonicUpdateMessage(var Msg: TMessage); message WM_WRITESONIC_UPDATE_MESSAGE;
    procedure OnYouChatUpdateMessage(var Msg: TMessage); message WM_YOUCHAT_UPDATE_MESSAGE;
    {$ENDIF}

    property HistoryGrid: THistoryDBGrid read FHistoryGrid write FHistoryGrid;
    property ClassViewIsBusy: Boolean read FClassViewIsBusy write FClassViewIsBusy;
  end;

implementation

{$R *.dfm}

procedure TFram_Question.AddToHistory(AQuestion, AAnswer: string);
begin
  if (TSingletonSettingObj.Instance.HistoryEnabled) then
  begin
    if not FDConnection.Connected then
      LoadHistory;

    if FDConnection.Connected then
    begin
      FDQryHistory.Append;
      FDQryHistoryQuestion.AsString := AQuestion;
      FDQryHistoryAnswer.AsString := AAnswer;
      FDQryHistoryDate.AsLargeInt := DateTimeToUnix(Date);
      FDQryHistory.Post;

      TSingletonSettingObj.Instance.ShouldReloadHistory := True;
    end;
  end;
end;

procedure TFram_Question.btnHelpClick(Sender: TObject);
var
  LvUrl: string;
begin
  LvUrl := 'https://github.com/AliDehbansiahkarbon/ChatGPTWizard';
  ShellExecute(0, nil, PChar(LvUrl), nil, nil, SW_SHOWNORMAL);
end;

procedure TFram_Question.Btn_AskClick(Sender: TObject);
begin
  if mmoQuestion.Lines.Text.Trim.IsEmpty then
  begin
    ShowMessage('Really?!😂' + #13 + 'You need to type a question first.');
    if mmoQuestion.CanFocus then
      mmoQuestion.SetFocus;

    Exit;
  end;
  mmoAnswer.Lines.Clear;
  CallThread(mmoQuestion.Lines.Text);
end;

procedure TFram_Question.Btn_ClearClick(Sender: TObject);
begin
  mmoQuestion.Lines.Clear;
  mmoAnswer.Lines.Clear;
  mmoWriteSonicAnswer.Lines.Clear;
  mmoYouChatAnswer.Lines.Clear;
end;

procedure TFram_Question.Btn_ClipboardClick(Sender: TObject);
begin
  CopyToClipBoard;
end;

procedure TFram_Question.CSharpClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to C# code: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.CClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to C code: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.CPlusPlusClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to C++ code: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.CallThread(APrompt: string; AIsClassView: Boolean);
var
  LvChatGPTApiKey: string;
  LvChatGPTBaseUrl: string;

  LvEnableWriteSonic: Boolean;
  LvWriteSonicAPIKey: string;
  LvWriteSonicBaseUrl: string;

  LvEnableYouChat: Boolean;
  LvYouChatAPIKey: string;
  LvYouChatBaseUrl: string;

  LvModel: string;
  LvQuestion: string;
  LvMaxToken: Integer;
  LvTemperature: Integer;

  LvIsProxyActive: Boolean;
  LvProxyHost: string;
  LvProxyPort: Integer;
  LvProxyUsername: string;
  LvProxyPassword: string;
  LvAnimatedLetters: Boolean;
  LvTimeOut: Integer;

  MultiAI: Boolean;
  LvSetting: TSingletonSettingObj;
begin
  Cs.Enter;
  LvSetting := TSingletonSettingObj.Instance;
  LvChatGPTApiKey := LvSetting.ApiKey;
  LvChatGPTBaseUrl := LvSetting.URL;
  LvModel := LvSetting.Model;
  LvMaxToken := LvSetting.MaxToken;
  LvTemperature := LvSetting.Temperature;
  LvQuestion := APrompt;

  LvIsProxyActive :=  LvSetting.ProxySetting.Active;
  LvProxyHost := LvSetting.ProxySetting.ProxyHost;
  LvProxyPort := LvSetting.ProxySetting.ProxyPort;
  LvProxyUsername := LvSetting.ProxySetting.ProxyUsername;
  LvProxyPassword := LvSetting.ProxySetting.ProxyPassword;
  LvAnimatedLetters := LvSetting.AnimatedLetters;
  LvTimeOut := LvSetting.TimeOut;

  LvEnableWriteSonic := LvSetting.EnableWriteSonic;
  LvWriteSonicAPIKey := LvSetting.WriteSonicAPIKey;
  LvWriteSonicBaseUrl := LvSetting.WriteSonicBaseURL;

  LvEnableYouChat := LvSetting.EnableYouChat;
  LvYouChatAPIKey := LvSetting.YouChatAPIKey;
  LvYouChatBaseUrl := LvSetting.YouChatBaseURL;

  MultiAI := LvSetting.MultiAI;

  LvSetting.TaskList.Clear;
  if not AIsClassView then
  begin
    FClassViewIsBusy := False;
    LvSetting.TaskList.Add('GPT');
    if (CompilerVersion >= 32) and (LvEnableWriteSonic) then
      LvSetting.TaskList.Add('WS');

    if (CompilerVersion >= 32) and (LvEnableYouChat) then
      LvSetting.TaskList.Add('YC');
  end
  else
  begin
    LvSetting.TaskList.Add('CLS');
    FClassViewIsBusy := True;
  end;

  Cs.Leave;

  FChatGPTTrd := TExecutorTrd.Create(Self.Handle, LvChatGPTApiKey, LvModel, LvQuestion, LvChatGPTBaseUrl,
    LvMaxToken, LvTemperature, LvIsProxyActive, LvProxyHost, LvProxyPort, LvProxyUsername,
    LvProxyPassword, LvAnimatedLetters, LvTimeOut);
  FChatGPTTrd.Start;

  {$IF CompilerVersion >= 32.0}
  if (not AIsClassView) and (MultiAI) then
  begin
    if LvEnableWriteSonic then
    begin
      mmoWriteSonicAnswer.Lines.Clear;
      FWriteSonicTrd := TWriteSonicTrd.Create(Self.Handle, LvWriteSonicAPIKey, LvWriteSonicBaseUrl, LvQuestion, LvIsProxyActive,
        LvProxyHost, LvProxyPort, LvProxyUsername, LvProxyPassword, LvAnimatedLetters, LvTimeOut);

      FWriteSonicTrd.Start;
    end;

    if LvEnableYouChat then
    begin
      mmoYouChatAnswer.Lines.Clear;
      FYouChatTrd := TYouChatTrd.Create(Self.Handle, LvYouChatAPIKey, LvYouChatBaseUrl, LvQuestion, LvIsProxyActive,
        LvProxyHost, LvProxyPort, LvProxyUsername, LvProxyPassword, LvAnimatedLetters, LvTimeOut);

      FYouChatTrd.Start;
    end;
  end;
  {$ENDIF}
end;

procedure TFram_Question.Chk_CaseSensitiveClick(Sender: TObject);
begin
  Edt_Search.OnChange(Edt_Search);
end;

procedure TFram_Question.ClassViewMenuItemClick(Sender: TObject);
var
  LvSettingObj: TSingletonSettingObj;
  LvQuestion: string;
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then // Not applicable to the first node of the TreeView.
  begin
    Cs.Enter;
    LvSettingObj := TSingletonSettingObj.Instance;
    if LvSettingObj.TryFindQuestion(TMenuItem(Sender).Caption.Replace('&', '') , LvQuestion) > -1 then
    begin
      Cs.Leave;
      if not LvQuestion.Trim.IsEmpty then
      begin
        FLastQuestion := LvQuestion + #13 + FClassTreeView.Selected.Text; // Shorter string will be logged.
        LvQuestion  := LvQuestion  + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
        mmoClassViewResult.Lines.Clear;
        CallThread(LvQuestion, True);
      end;
    end;
  end;
end;

procedure TFram_Question.Clearallhistoryitems1Click(Sender: TObject);
begin
  if FDQryHistory.IsEmpty then
    Exit;

  if MessageDlg('Are you sure you want to clear all history items?', TMsgDlgType.mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes then
  begin
    FDConnection.ExecSQL('Delete from TbHistory');
    FDQryHistory.Close;
    FDQryHistory.Open;
    mmoHistoryDetail.Clear;
    FCellCloseBtn.Parent := Self;
  end;
end;

procedure TFram_Question.ClearAnswer1Click(Sender: TObject);
begin
  ClearAnswers;
end;

procedure TFram_Question.ClearAnswers;
begin
  mmoAnswer.Lines.Clear;
  mmoWriteSonicAnswer.Lines.Clear;
  mmoYouChatAnswer.Lines.Clear;
end;

procedure TFram_Question.ClearQuestion1Click(Sender: TObject);
begin
  mmoQuestion.Clear;
end;

procedure TFram_Question.CloseBtnClick(Sender: TObject);
begin
  if FDQryHistory.RecordCount > 0 then
    FDQryHistory.Delete;
end;

procedure TFram_Question.CopyToClipBoard;
begin
  if Assigned(pgcMain) then
  begin
    if pgcMain.ActivePage = tsChatGPT then
      Clipboard.SetTextBuf(pwidechar(mmoAnswer.Lines.Text))
    else if pgcMain.ActivePage = tsClassView then
      Clipboard.SetTextBuf(pwidechar(mmoClassViewDetail.Lines.Text))
    else if pgcMain.ActivePage = tsHistory then
      Clipboard.SetTextBuf(pwidechar(mmoHistoryDetail.Lines.Text));
  end
  else
    Clipboard.SetTextBuf(pwidechar(mmoAnswer.Lines.Text));
end;

procedure TFram_Question.CopytoClipboard1Click(Sender: TObject);
begin
  CopyToClipBoard;
end;

procedure TFram_Question.CustomCommandClick(Sender: TObject);
begin
  FLastQuestion := '';
  if InputQuery('Custom Command(use @Class to represent the selected class)', 'Write your command here', FLastQuestion) then
  begin
    if FLastQuestion.Trim = '' then
      Exit;
  end
  else
    Exit;

  if FLastQuestion.ToLower.Trim.Contains('@class') then
    FLastQuestion := StringReplace(FLastQuestion, '@class', ' ' + FClassList.Items[FClassTreeView.Selected.Text].Text + ' ', [rfReplaceAll, rfIgnoreCase])
  else
    FLastQuestion := FLastQuestion + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;

  mmoClassViewResult.Lines.Clear;
  CallThread(FLastQuestion, True);
end;

procedure TFram_Question.DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
Var
  DataRect: TRect;// Used for delete button in cell.
  //=========================
  LvPattern, LvValue: string; //used for HighLight
  LvMatchedIndexes: TList;
begin
  //================= Drawing delete button ============================
  if (not FDQryHistory.IsEmpty) and (not FDQryHistoryHID.IsNull) and (Column.Title.Caption = '^_^') Then
  begin
    DataRect := FHistoryGrid.CellRect(Column.Index + 1, FHistoryGrid.Row);
    If FCellCloseBtn.Parent <> FHistoryGrid Then
      FCellCloseBtn.Parent := FHistoryGrid;

    FCellCloseBtn.Left := DataRect.Left +  (DataRect.Right - DataRect.Left - FCellCloseBtn.Width) div 2;

    If FCellCloseBtn.Top <> DataRect.Top Then
      FCellCloseBtn.Top := DataRect.Top;

    // Make sure the button's height fits in row.
    If FCellCloseBtn.Height <> (DataRect.Bottom - DataRect.Top) Then
      FCellCloseBtn.Height := DataRect.Bottom - DataRect.Top;
  end;
  //====================================================================

  //====================== HighLisght ==================================
  if (Assigned(Column.Field)) and (Column.Field.FieldName = 'Question') then
  begin
    if not Chk_FuzzyMatch.Checked then
      HighlightCellTextFull(THistoryDBGrid(Sender), Rect, Column.Field, Trim(Edt_Search.Text), State, Chk_CaseSensitive.Checked, TSingletonSettingObj.Instance.HighlightColor, clGray)
    else
    begin
      THistoryDBGrid(Sender).Canvas.Font.Color := clBlack;
      LvMatchedIndexes := TList.Create;

      try
        if (gdFocused in State) then
        begin
          THistoryDBGrid(Sender).Canvas.Brush.Color := clBlack;
          THistoryDBGrid(Sender).Canvas.Font.Color := clWhite;
        end
        else if Column.Field.DataType in [ftString, ftInteger, ftFloat, ftCurrency, ftMemo, ftWideString, ftLargeint, ftWideMemo, ftLongWord] then
        begin
          LvPattern := Trim(Edt_Search.Text);
          LvValue := Column.Field.AsString;

          if FuzzyMatchStr(LvPattern, LvValue, LvMatchedIndexes, Chk_CaseSensitive.Checked) then
            HighlightCellTextFuzzy(THistoryDBGrid(Sender),Rect, Column.Field, LvMatchedIndexes, State, Chk_CaseSensitive.Checked, TSingletonSettingObj.Instance.HighlightColor, clGray);
        end
        else
          THistoryDBGrid(Sender).Canvas.Brush.Color := clWhite;
      finally
        LvMatchedIndexes.Free;
      end;
    end;
  end;
  //====================================================================
end;

procedure TFram_Question.Edt_SearchChange(Sender: TObject);
var
  LvAfterScroll: TDataSetNotifyEvent;
begin
  if Trim(Edt_Search.Text).IsEmpty then
    FDQryHistory.Filtered := False
  else
  begin
    LvAfterScroll := FDQryHistory.AfterScroll;
    FDQryHistory.AfterScroll := nil;
    FDQryHistory.DisableControls;
    FDQryHistory.Filtered := False;
    FDQryHistory.Filtered := True;
    FDQryHistory.AfterScroll := LvAfterScroll;
    FDQryHistory.AfterScroll(FDQryHistory);
    FDQryHistory.EnableControls;
    LvAfterScroll := nil;
  end;

  FHistoryGrid.Repaint;
end;

procedure TFram_Question.EnableUI(ATaskName: string);
begin
  Cs.Enter;
  TSingletonSettingObj.Instance.TaskList.Remove(ATaskName);
  if TSingletonSettingObj.Instance.TaskList.Count = 0 then
  begin
    Btn_Ask.Enabled := True;
    if ATaskName = 'CLS' then
    begin
      FClassViewIsBusy := False;
      mmoClassViewResult.Visible := True;
      splClassViewResult.Visible := True;
    end;
  end;
  Cs.Leave;
end;

procedure TFram_Question.FDQryHistoryAfterScroll(DataSet: TDataSet);
begin
  if Assigned(pgcMain) then
  begin
    mmoHistoryDetail.Lines.Clear;
    mmoHistoryDetail.Lines.Add(FDQryHistoryAnswer.AsString);
  end;
end;

procedure TFram_Question.FDQryHistoryDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not Sender.IsNull then
    Text := DateTimeToStr(UnixToDateTime(Sender.AsLargeInt));
end;

procedure TFram_Question.FDQryHistoryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  if Chk_FuzzyMatch.Checked then
    Accept := FuzzyMatchStr(Edt_Search.Text, DataSet.FieldByName('Question').AsString, nil, Chk_CaseSensitive.Checked)
  else
    Accept := XPos(Edt_Search.Text, DataSet.FieldByName('Question').AsString, Chk_CaseSensitive.Checked) > 0;
end;

procedure TFram_Question.FDQryHistoryQuestionGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not Sender.IsNull then
    Text := Sender.AsString;
end;

function TFram_Question.FuzzyMatchStr(const APattern, AStr: string; AMatchedIndexes: TList; ACaseSensitive: Boolean): Boolean;
var
  PIdx, SIdx: Integer;
begin
  Result := False;
  if (APattern = '') or (AStr = '') then
    Exit;

  PIdx := 1;
  SIdx := 1;
  if AMatchedIndexes <> nil then
    AMatchedIndexes.Clear;

  if ACaseSensitive then
  begin
    while (PIdx <= Length(APattern)) and (SIdx <= Length(AStr)) do
    begin
      if APattern[PIdx] = AStr[SIdx] then
      begin
        Inc(PIdx);
        if AMatchedIndexes <> nil then
          AMatchedIndexes.Add(Pointer(SIdx));
      end;
      Inc(SIdx);
    end;
  end
  else
  begin
    while (PIdx <= Length(APattern)) and (SIdx <= Length(AStr)) do
    begin
      if LowChar(APattern[PIdx]) = LowChar(AStr[SIdx]) then
      begin
        Inc(PIdx);
        if AMatchedIndexes <> nil then
          AMatchedIndexes.Add(Pointer(SIdx));
      end;
      Inc(SIdx);
    end;
  end;
  Result := PIdx > Length(APattern);
end;

procedure TFram_Question.GetQuestionClick(Sender: TObject);
begin
  if (FDQryHistory.Active) and (FDQryHistory.RecordCount > 0) and (not FDQryHistoryQuestion.IsNull) then
  begin
    mmoQuestion.Lines.Clear;
    mmoQuestion.Lines.Add(FDQryHistoryQuestion.AsString);
    pgcMain.TabIndex := 0;
  end;
end;

procedure TFram_Question.GoClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to the GO programming language code: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.GridResize(Sender: TObject);
begin
  FHistoryGrid.FitGrid;
end;

procedure TFram_Question.HighlightCellTextFull(AGrid: THistoryDBGrid; const ARect: TRect; AField: TField; AFilterText: string; AState: TGridDrawState;
                                               ACaseSensitive: Boolean; ABkColor: TColor; ASelectedBkColor: TColor);
var
  LvHlRect: TRect;
  LvPosition, LvOffset: Integer;
  LvHlText, LvDisplayText: string;
begin
  LvPosition := 0;
  LvDisplayText := AField.AsString;
  LvPosition := XPos(LowerCase(AFilterText), LowerCase(LvDisplayText), ACaseSensitive);

  if LvPosition > 0 then
  begin
    case AField.Alignment of
      taLeftJustify:
      begin
        LvHlRect.Left := ARect.Left + AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, LvPosition - 1)) + 1;
      end;

      taRightJustify:
      begin
        LvOffset := AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1,1)) - 1;
        LvHlRect.Left :=  (ARect.Right - AGrid.Canvas.TextWidth(LvDisplayText) - LvOffset) + AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, LvPosition - 1));
      end;

      taCenter:
      begin
       LvOffset := ((ARect.Right - ARect.Left) div 2) - (AGrid.Canvas.TextWidth(LvDisplayText) div 2) - (AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, 1)) - 1);
       LvHlRect.Left := (ARect.Right - AGrid.Canvas.TextWidth(LvDisplayText) - LvOffset) + AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, LvPosition - 1)) - 8;
      end;
    end;

    LvHlRect.Top    := ARect.Top + 1;
    LvHlRect.Right  := LvHlRect.Left + AGrid.Canvas.TextWidth(Copy(LvDisplayText, LvPosition, Length(AFilterText))) + 1;
    LvHlRect.Bottom := ARect.Bottom - 1;

    if LvHlRect.Right > ARect.Right then  //check for  limit of the cell
      LvHlRect.Right := ARect.Right;

    if gdSelected in AState then  // setup the color and draw the rectangle in a width of the matching text
      AGrid.Canvas.Brush.Color := ASelectedBkColor
    else
      AGrid.Canvas.Brush.Color := ABkColor;

    AGrid.Canvas.FillRect(LvHlRect);
    LvHlText := Copy(LvDisplayText, LvPosition, Length(AFilterText));
    AGrid.Canvas.TextRect(LvHlRect, LvHlRect.Left + 1, LvHlRect.Top + 1, LvHlText);
  end;
end;

procedure TFram_Question.HighlightCellTextFuzzy(AGrid: TDbGrid; const ARect: TRect; AField: TField; AMatchedIndexes: TList; AState: TGridDrawState;
                                                ACaseSensitive: Boolean; ABkColor, ASelectedBkColor: TColor);
var
  LvRectArray: array of TRect;
  I, LvPosition, LvOffset: Integer;
  LvHlText, LvDisplayText: string;
begin
  LvDisplayText := AField.AsString;
  SetLength(LvRectArray, AMatchedIndexes.Count);

  for I := 0 to Pred(AMatchedIndexes.Count) do
  begin
    LvPosition := Integer(AMatchedIndexes.Items[I]);
    if LvPosition > 0 then
    begin
      case AField.Alignment of
        taLeftJustify: LvRectArray[I].Left := ARect.Left + AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, LvPosition - 1)) + 1;

        taRightJustify:
        begin
          LvOffset := AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, 1)) - 1;
          LvRectArray[I].Left :=  (ARect.Right - AGrid.Canvas.TextWidth(LvDisplayText) - LvOffset) + AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, LvPosition - 1));
        end;

        taCenter:
        begin
          LvOffset := ((ARect.Right - ARect.Left) div 2) - (AGrid.Canvas.TextWidth(LvDisplayText) div 2) - (AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, 1)) - 2);
          LvRectArray[I].Left := (ARect.Right - AGrid.Canvas.TextWidth(LvDisplayText) - LvOffset) + AGrid.Canvas.TextWidth(Copy(LvDisplayText, 1, LvPosition - 1)) - 8;
        end;
      end;

      LvRectArray[I].Top := ARect.Top + 1;
      LvRectArray[I].Right := LvRectArray[I].Left + AGrid.Canvas.TextWidth(Copy(LvDisplayText, LvPosition, length(LvDisplayText[LvPosition]))) + 1 ;
      LvRectArray[I].Bottom := ARect.Bottom - 1;

      if LvRectArray[I].Right > ARect.Right then  //check for  limitation of the cell
        LvRectArray[I].Right := ARect.Right;

      if gdSelected in AState then // Setup the color and draw the rectangle in a width of the matching text
        AGrid.Canvas.Brush.Color := ASelectedBkColor
      else
        AGrid.Canvas.Brush.Color := ABkColor;

      AGrid.Canvas.FillRect(LvRectArray[I]);
      LvHlText := Copy(LvDisplayText,LvPosition, length(LvDisplayText[LvPosition]));
      AGrid.Canvas.TextRect(LvRectArray[I], LvRectArray[I].Left + 1, LvRectArray[I].Top + 1, LvHlText);
    end;
  end;
end;

procedure TFram_Question.HistoryDBGridDblClick(Sender: TObject);
begin
  if (FDQryHistory.Active) and (FDQryHistory.RecordCount > 0) then
  begin
    mmoQuestion.Lines.Clear;
    mmoQuestion.Lines.Add(FDQryHistory.FieldByName('Question').AsString);
    pgcMain.ActivePageIndex := 0;
  end;
end;

procedure TFram_Question.InitialClassViewMenueItems(AClassList: TClassList);
var
  LvKey: Integer;
  LvMenuItem: TMenuItem;
  LvTempSortingArray : TArray<Integer>;

  procedure AddMenuItem(ACaption: string);
  begin
    LvMenuItem := TMenuItem.Create(Self);
    LvMenuItem.Caption := ACaption;
    LvMenuItem.OnClick := ClassViewMenuItemClick;
    pmClassOperations.Items.Add(LvMenuItem);
  end;

  procedure AddSubMenu(ACaption: string; AParent: TMenuItem; AOnClickProc: TOnClickProc);
  var
    LvSubMenu: TMenuItem;
  begin
    LvSubMenu := TMenuItem.Create(Self);
    LvSubMenu.Caption := ACaption;
    LvSubMenu.OnClick := AOnClickProc;
    AParent.Add(LvSubMenu);
  end;

begin
  //pmClassOperations.Items.Clear;
  FClassList := AClassList;

  LvTempSortingArray := TSingletonSettingObj.Instance.PredefinedQuestions.Keys.ToArray; // TObjectDictionary is not sorted!
  TArray.Sort<Integer>(LvTempSortingArray);

  for LvKey in LvTempSortingArray do
    AddMenuItem(TSingletonSettingObj.Instance.PredefinedQuestions.Items[LvKey].Caption);

  // Add Convert commands
  LvMenuItem := TMenuItem.Create(Self);
  LvMenuItem.Caption := 'Convert to';
  pmClassOperations.Items.Add(LvMenuItem);

  AddSubMenu('C#', LvMenuItem, CSharpClick);
  AddSubMenu('Java', LvMenuItem, JavaClick);
  AddSubMenu('Python', LvMenuItem, PythonClick);
  AddSubMenu('Javascript', LvMenuItem, JavascriptClick);
  AddSubMenu('C', LvMenuItem, CClick);
  AddSubMenu('C++', LvMenuItem, CPlusPlusClick);
  AddSubMenu('Go', LvMenuItem, GoClick);
  AddSubMenu('Rust', LvMenuItem, RustClick);

  // Add Custom Commands
  LvMenuItem := TMenuItem.Create(Self);
  LvMenuItem.Caption := 'Custom Command';
  LvMenuItem.OnClick := CustomCommandClick;
  pmClassOperations.Items.Add(LvMenuItem);
end;

procedure TFram_Question.InitialFrame;
begin
  FLastQuestion := '';
  FClassViewIsBusy := False;
  Align := alClient;
  tsWriteSonicAnswer.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableWriteSonic);
  tsYouChat.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableYouChat);

  FCellCloseBtn := TSpeedButton.Create(Self);
  FCellCloseBtn.Glyph.LoadFromResourceName(HInstance, 'CLOSE');
  FCellCloseBtn.OnClick := CloseBtnClick;
  ActivityIndicator1.Visible := False;

  FHistoryGrid := THistoryDBGrid.Create(Self);
  with FHistoryGrid do
  begin
    Parent := pnlHistoryTop;
    Align := alClient;
    DataSource := DSHistory;
    OnDblClick := HistoryDBGridDblClick;
    Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack];

    with Columns.Add do
    begin
      Alignment := taCenter;
      Expanded := False;
      FieldName := 'Question';
      Title.Alignment := taCenter;
      Visible := True;
    end;

    with Columns.Add do
    begin
      Alignment := taCenter;
      Expanded := False;
      FieldName := 'Date';
      Title.Alignment := taCenter;
      Width := 60;
      Visible := True;
    end;

    with Columns.Add do
    begin
      Title.Caption := '^_^';
      Alignment := taCenter;
      Title.Alignment := taCenter;
      Width := 25;
      Visible := True;
    end;

    OnResize := GridResize;
    OnDrawColumnCell := DrawColumnCell;
  end;

  // Styling does not work properly in Tokyo and Rio the following lines will make it better.
  if (CompilerVersion = 32{Tokyo}) or (CompilerVersion = 33{Rio}) then
  begin
    pgcMain.StyleElements := [seFont, seBorder, seClient];
    pnlMain.StyleElements := [seFont, seBorder];
    pnlCenter.StyleElements := [seFont, seBorder];
    pnlAnswer.StyleElements := [seFont, seBorder];
    pgcAnswers.StyleElements := [seFont, seBorder, seClient];
    tsChatGPT.StyleElements := [seFont, seBorder, seClient];
    pnlTop.StyleElements := [seFont, seBorder];
    pnlQuestion.StyleElements := [seFont, seBorder];
    pnlHistoryTop.StyleElements := [seFont, seBorder];
    FHistoryGrid.StyleElements := [seFont, seBorder];
    FHistoryGrid.ParentColor := True;
  end;
end;

procedure TFram_Question.JavaClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Java code: ' + #13 + FClassList.Items [FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.JavascriptClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Javascript code: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.mmoClassViewDetailDblClick(Sender: TObject);
begin
  mmoClassViewResult.Visible := True;
  splClassViewResult.Visible := True;
end;

procedure TFram_Question.mmoClassViewResultDblClick(Sender: TObject);
begin
  mmoClassViewResult.Visible := False;
  splClassViewResult.Visible := False;
end;

procedure TFram_Question.mmoQuestionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Ord(Key) = 13) then
    Btn_Ask.Click;
end;

procedure TFram_Question.OnProgressMessage(var Msg: TMessage);
begin
  if Msg.WParam = 0 then
  begin
    Cs.Enter;
    if TSingletonSettingObj.Instance.TaskList.Count = 0 then
    begin
      Btn_Ask.Enabled := True;
      ActivityIndicator1.Visible := False;
    end;
    Cs.Leave;
  end
  else if Msg.WParam = 1 then
    ActivityIndicator1.Visible := True;
end;

procedure TFram_Question.OnUpdateMessage(var Msg: TMessage);
begin
  if Assigned(pgcMain) then
  begin
    if pgcMain.ActivePage = tsChatGPT then
    begin
      if Msg.LParam = 0 then //whole string in one message.
      begin
        mmoAnswer.Lines.Clear;
        mmoAnswer.Lines.Add(String(Msg.WParam));
      end
      else if Msg.LParam = 1 then // Char by Char.
      begin
        mmoAnswer.Lines[Pred(mmoAnswer.Lines.Count)] := mmoAnswer.Lines[Pred(mmoAnswer.Lines.Count)] + char(Msg.WParam);
      end
      else if Msg.LParam = 2 then // Finished.
      begin
        EnableUI('GPT');
        AddToHistory(mmoQuestion.Lines.Text, mmoAnswer.Lines.Text);
      end
      else if Msg.LParam = 3 then // Exception.
      begin
        mmoAnswer.Lines.Clear;
        mmoAnswer.Lines.Add(String(Msg.WParam));
        EnableUI('GPT');
      end;
    end
    else if pgcMain.ActivePage = tsClassView then
    begin
      if Msg.LParam = 0 then //whole string in one message.
      begin
        mmoClassViewResult.Lines.Clear;
        mmoClassViewResult.Lines.Add(String(Msg.WParam));
      end
      else if Msg.LParam = 1 then // Char by Char.
      begin
        mmoClassViewResult.Lines[Pred(mmoClassViewResult.Lines.Count)] := mmoClassViewResult.Lines[Pred(mmoClassViewResult.Lines.Count)] + char(Msg.WParam);
      end
      else if Msg.LParam = 2 then // Finished.
      begin
        EnableUI('CLS');
        AddToHistory(FLastQuestion , mmoClassViewResult.Lines.Text);
      end
      else if Msg.LParam = 3 then // Exception.
      begin
        EnableUI('CLS');
        mmoClassViewResult.Lines.Clear;
        mmoClassViewResult.Lines.Add(String(Msg.WParam));
      end;
    end;
  end
  else
  begin
    if Msg.LParam = 0 then //whole string in one message.
    begin
      mmoAnswer.Lines.Clear;
      mmoAnswer.Lines.Add(String(Msg.WParam));
    end
    else if Msg.LParam = 1 then // Char by Char.
    begin
      mmoAnswer.Lines[Pred(mmoAnswer.Lines.Count)] := mmoAnswer.Lines[Pred(mmoAnswer.Lines.Count)] + char(Msg.WParam);
    end
    else if Msg.LParam = 2 then // Finished.
    begin
      EnableUI('GPT');
      AddToHistory(mmoQuestion.Lines.Text, mmoAnswer.Lines.Text);
    end;
  end;

  if Msg.LParam = 2 then
  begin
    if chk_AutoCopy.Checked then
      CopyToClipBoard;

    Cs.Enter;
    TSingletonSettingObj.Instance.ShouldReloadHistory := True;
    Cs.Leave;
  end;
end;

{$IF CompilerVersion >= 32.0}
procedure TFram_Question.OnWriteSonicUpdateMessage(var Msg: TMessage);
begin
  if Msg.LParam = 0 then //whole string in one message.
  begin
    mmoWriteSonicAnswer.Lines.Clear;
    mmoWriteSonicAnswer.Lines.Add(String(Msg.WParam));
  end
  else if Msg.LParam = 1 then // Char by Char.
  begin
    mmoWriteSonicAnswer.Lines[Pred(mmoWriteSonicAnswer.Lines.Count)] := mmoWriteSonicAnswer.Lines[Pred(mmoWriteSonicAnswer.Lines.Count)] + char(Msg.WParam);
    if Char(Msg.WParam) = CrLf then
      mmoWriteSonicAnswer.Lines.Add('');
  end
  else if Msg.LParam = 2 then // Finished.
  begin
    EnableUI('WS');
    AddToHistory(mmoQuestion.Lines.Text, '***** WriteSonic *****' + #13 + mmoWriteSonicAnswer.Lines.Text);
    Cs.Enter;
    TSingletonSettingObj.Instance.ShouldReloadHistory := True;
    Cs.Leave;
  end
  else if Msg.LParam = 3 then // Exception
  begin
    mmoWriteSonicAnswer.Lines.Clear;
    mmoWriteSonicAnswer.Lines.Add(String(Msg.WParam));
    EnableUI('WS');
  end;
end;

procedure TFram_Question.OnYouChatUpdateMessage(var Msg: TMessage);
begin
  if Msg.LParam = 0 then //whole string in one message.
  begin
    mmoYouChatAnswer.Lines.Clear;
    mmoYouChatAnswer.Lines.Add(String(Msg.WParam));
  end
  else if Msg.LParam = 1 then // Char by Char.
  begin
    mmoYouChatAnswer.Lines[Pred(mmoYouChatAnswer.Lines.Count)] := mmoYouChatAnswer.Lines[Pred(mmoYouChatAnswer.Lines.Count)] + char(Msg.WParam);
    if Char(Msg.WParam) = CrLf then
      mmoYouChatAnswer.Lines.Add('');
  end
  else if Msg.LParam = 2 then // Finished.
  begin
    EnableUI('YC');
    AddToHistory(mmoQuestion.Lines.Text, '***** YouChat *****' + #13 + mmoYouChatAnswer.Lines.Text);
    Cs.TryEnter;
    TSingletonSettingObj.Instance.ShouldReloadHistory := True;
    Cs.Leave;
  end
  else if Msg.LParam = 3 then // Exception
  begin
    mmoYouChatAnswer.Lines.Clear;
    mmoYouChatAnswer.Lines.Add(String(Msg.WParam));
    EnableUI('YC');
  end;
end;
{$ENDIF}

procedure TFram_Question.pgcAnswersChange(Sender: TObject);
begin
  if chk_AutoCopy.Checked then
  begin
    case pgcAnswers.ActivePageIndex of
      0: Clipboard.SetTextBuf(pwidechar(mmoAnswer.Lines.Text));
      1: Clipboard.SetTextBuf(pwidechar(mmoWriteSonicAnswer.Lines.Text));
      2: Clipboard.SetTextBuf(pwidechar(mmoYouChatAnswer.Lines.Text));
    end;
  end;
  ActivityIndicator1.Visible := TSingletonSettingObj.Instance.TaskList.Count > 0;
end;

procedure TFram_Question.pgcMainChange(Sender: TObject);
var
  LvShouldReloadHistory: Boolean;
begin
  if (pgcMain.ActivePage = tsClassView) and (not FClassViewIsBusy) then
    ReloadClassList(FClassList);

  if pgcMain.ActivePage = tsHistory then
  begin
    Cs.Enter;
    LvShouldReloadHistory := TSingletonSettingObj.Instance.ShouldReloadHistory;
    Cs.Leave;

    if LvShouldReloadHistory then
    begin
      LoadHistory;
      Width := Width + 1; // Do not remove!
                          // Doesn't really change the width, it's a trick to force the grid to fit columns!

      Cs.Enter;
      TSingletonSettingObj.Instance.ShouldReloadHistory := False;
      Cs.Leave;
    end;

    if FDQryHistory.RecordCount > 0  then
      FDQryHistory.AfterScroll(FDQryHistory);
  end;
end;

procedure TFram_Question.pgcMainChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange := TSingletonSettingObj.Instance.TaskList.Count = 0;
end;

procedure TFram_Question.pmClassOperationsPopup(Sender: TObject);
begin
  FClassTreeView.OnChange(FClassTreeView, FClassTreeView.Selected);
  if FClassTreeView.Selected = FClassTreeView.TopItem then
    keybd_event(VK_ESCAPE, Mapvirtualkey(VK_ESCAPE, 0), 0, 0);
end;

procedure TFram_Question.PythonClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Pyhton code: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.ReloadClassList(AClassList: TClassList);
var
  LvLexer: TcpLexer;
begin
  FClassTreeView := TTreeView.Create(tsClassView);
  with FClassTreeView do
  begin
    Parent := pnlClasses;
    Align := alClient;
    AlignWithMargins := True;
    Indent := 19;
    TabOrder := 0;
    RightClickSelect := True;
    HideSelection := False;
    PopupMenu := pmClassOperations;
    OnChange := tvOnChange;
  end;

  LvLexer := TcpLexer.Create(FClassList);
  try
    LvLexer.Reload;
    FClassList.FillTreeView(FClassTreeView);
    mmoClassViewDetail.Lines.Clear;
  finally
    LvLexer.Free;
  end;
end;

procedure TFram_Question.ReloadHistoryClick(Sender: TObject);
begin
  LoadHistory;
end;

function TFram_Question.LoadHistory: Boolean;
begin
  Result := False;
  if TSingletonSettingObj.Instance.HistoryEnabled then
  begin
    if FileExists(TSingletonSettingObj.Instance.GetHistoryFullPath) then
    begin
      try
        FDConnection.Close;
        FDConnection.Params.Clear;
        FDConnection.Params.Add('DriverID=SQLite');
        FDConnection.Params.Add('Database=' + TSingletonSettingObj.Instance.GetHistoryFullPath);
        FDConnection.Open;
        FDQryHistory.Open;
        Result := True;
      except on E: Exception do
        ShowMessage('SQLite Connection didn''t established.' + #13 + 'Error: ' + E.Message);
      end;
    end
    else
      ShowMessage('The database file doesn''t exist.')
  end;
end;

function TFram_Question.LowChar(AChar: Char): Char;
begin
  if AChar in ['A'..'Z'] then
    Result := Chr(Ord(AChar) + 32)
  else
    Result := AChar;
end;

procedure TFram_Question.RustClick(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Rust code: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.SearchMnuClick(Sender: TObject);
begin
  pnlSearchHistory.Visible := SearchMnu.Checked;
  if not SearchMnu.Checked then
    Edt_Search.Clear;
end;

procedure TFram_Question.TerminateAll;
begin
  try
    if Assigned(FChatGPTTrd) then FChatGPTTrd.Terminate;
  except
  end;

  {$IF CompilerVersion >= 32.0}
  try
    if Assigned(FWriteSonicTrd) then FWriteSonicTrd.Terminate;
  except
  end;

  try
    if Assigned(FYouChatTrd) then FYouChatTrd.Terminate;
  except
  end;
  {$ENDIF}
  Btn_Ask.Enabled := True;
end;

procedure TFram_Question.tvOnChange(Sender: TObject; Node: TTreeNode);
begin
  mmoClassViewDetail.Lines.Clear;
  mmoClassViewDetail.ScrollBars := TScrollStyle.ssNone;
  if Node <> FClassTreeView.TopItem then
    mmoClassViewDetail.Lines.Add(FClassList.Items[Node.Text].Text);
  mmoClassViewDetail.ScrollBars := TScrollStyle.ssVertical;
end;

function TFram_Question.XPos(APattern, AStr: string; ACaseSensitive: Boolean): Integer;
var
  PIdx, SIdx: Integer;
begin
  Result := 0;
  if (APattern.Trim.IsEmpty) or (AStr.Trim.IsEmpty) then
    Exit;

  if ACaseSensitive then
  begin
    PIdx := 1;
    SIdx := 1;
    while (PIdx <= Length(APattern)) and (SIdx <= Length(AStr)) do
    begin
      if APattern[PIdx] = AStr[SIdx] then
      begin
        Inc(PIdx);
        Result := SIdx;
        Break;
      end;
      Inc(SIdx);
    end;
  end
  else
    Result := Pos(LowerCase(APattern), LowerCase(AStr));
end;

{ TObDicHelper }
procedure TObDicHelper.FillTreeView(var ATree: TTreeView);
var
  LvNode: TTreeNode;
  LvKey: string;
begin
  if Assigned(ATree) and (Self.Count > 0) then
  begin
    try
      LvNode := ATree.Items.Add(nil, 'Classes');
      for LvKey in Self.Keys do
        ATree.Items.AddChild(LvNode, LvKey);
    except
    end;

    ATree.AutoExpand := True;
    ATree.FullExpand;
  end;
end;

end.
