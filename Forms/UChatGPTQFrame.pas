{***************************************************}
{                                                   }
{   This unit contains a frame that will be         }
{   used in dockable form.                          }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UChatGPTQFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Clipbrd,
  UChatGPTSetting, UChatGPTLexer, System.Generics.Collections,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Data.DB, System.DateUtils,System.StrUtils,
  System.Math,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, UHistory,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLite, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, UConsts,
  Vcl.WinXCtrls, System.ImageList, Vcl.ImgList, ShellApi, UAICommon,
  UAIProviders, UAIRequestCoordinator, UAIHistory, UEditorHelpers;

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
    tsClaudeAnswer: TTabSheet;
    mmoClaudeAnswer: TMemo;
    tsOllamaAnswer: TTabSheet;
    mmoOllamaAnswer: TMemo;
    ActivityIndicator1: TActivityIndicator;
    GetQuestion: TMenuItem;
    pmClear: TPopupMenu;
    ClearQuestion1: TMenuItem;
    ClearAnswer1: TMenuItem;
    Clearallhistoryitems1: TMenuItem;
    N1: TMenuItem;
    btnHelp: TSpeedButton;
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
    FCoordinator: TAIRequestCoordinator;
    FClassList: TClassList;
    FClassTreeView: TTreeView;
    FCellCloseBtn: TSpeedButton;
    FBtnStop: TButton;
    FHistoryGrid: THistoryDBGrid;
    FLastQuestion: string;
    FClassViewIsBusy: Boolean;
    FProviderTabs: TObjectDictionary<string, TTabSheet>;
    FProviderMemos: TObjectDictionary<string, TMemo>;
    FChatGPTAnswerTab: TTabSheet;
    FChatGPTAnswerMemo: TMemo;
    FProviderFilter: TComboBox;
    FModelFilter: TComboBox;
    FRequestTimer: TTimer;
    FRequestStartedAt: TDateTime;
    FInlineHintLabel: TLabel;

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
    function IslegacyModel: Boolean;
    procedure Btn_StopClick(Sender: TObject);
    function ValidateProviderBatch(AIsClassView: Boolean; const AActiveProviderId: string): Boolean;
    function GetActiveProviderId: string;
    procedure EnsureProviderControls;
    function MemoForProvider(const AProviderId: string): TMemo;
    function TabForProvider(const AProviderId: string): TTabSheet;
    procedure UpdateHistoryFilterCombos;
    procedure RequestTimeoutTimer(Sender: TObject);
    procedure BeginRequestTimeoutWatch;
    procedure EndRequestTimeoutWatch;
    procedure ApplyTimeoutState;
    function TryGetSelectedClassSource(out AClassName, AClassSource: string; ASilent: Boolean = False): Boolean;
    procedure ShowClassSelectionUnavailable;
  public
    procedure InitialFrame;
    procedure InitialClassViewMenueItems(AClassList: TClassList);
    procedure ReloadClassList(AClassList: TClassList);
    procedure TerminateAll;
    procedure UpdateTopButtonLayout;
    procedure UpdateQuestionDraftHint(AShowInlineHint: Boolean);
    procedure PrepareQuestionDraft(const ASelectedText: string; AShowInlineHint: Boolean = False);
    function LoadHistory: Boolean;
    procedure AddToHistory(const AQuestion: string; const AResponse: TProviderResponse);
    procedure ConfigureProviderPages;

    procedure OnProviderMessage(var Msg: TMessage); message WM_PROVIDER_MESSAGE;

    property HistoryGrid: THistoryDBGrid read FHistoryGrid write FHistoryGrid;
    property ClassViewIsBusy: Boolean read FClassViewIsBusy write FClassViewIsBusy;
  end;

implementation

{$R *.dfm}

const
  CaptionProviderGemini = 'Gemini';
  CaptionProviderClaude = 'Claude';
  CaptionProviderOllama = 'Ollama';
  CaptionProviderChatGPT = 'ChatGPT';

procedure TFram_Question.AddToHistory(const AQuestion: string; const AResponse: TProviderResponse);
begin
  if (TSingletonSettingObj.Instance.HistoryEnabled) then
  begin
    if not FDConnection.Connected then
      LoadHistory;

    if FDConnection.Connected then
    begin
      THistoryService.InsertEntry(FDConnection, AQuestion, AResponse);
      TSingletonSettingObj.Instance.ShouldReloadHistory := True;
    end;
  end;
end;

procedure TFram_Question.btnHelpClick(Sender: TObject);
var
  LvUrl: string;
begin
  LvUrl := CPluginRepositoryUrl;
  ShellExecute(0, nil, PChar(LvUrl), nil, nil, SW_SHOWNORMAL);
end;

procedure TFram_Question.Btn_AskClick(Sender: TObject);
begin
  if IslegacyModel then
  begin
    ShowIDEMessage('You are trying to use the model "' + TSingletonSettingObj.Instance.Model +
      '" which is deprecated, you can change the model in the settings form.');
    Exit;
  end;
  
  if mmoQuestion.Lines.Text.Trim.IsEmpty then
  begin
    ShowIDEMessage(CQuestionRequiredMsg);
    if mmoQuestion.CanFocus then
      mmoQuestion.SetFocus;

    Exit;
  end;
  CallThread(mmoQuestion.Lines.Text);
end;

procedure TFram_Question.Btn_StopClick(Sender: TObject);
begin
  TerminateAll;
end;

procedure TFram_Question.Btn_ClearClick(Sender: TObject);
begin
  mmoQuestion.Lines.Clear;
  ClearAnswers;
end;

procedure TFram_Question.Btn_ClipboardClick(Sender: TObject);
begin
  CopyToClipBoard;
end;

procedure TFram_Question.CSharpClick(Sender: TObject);
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to C# code: ' + #13 + LClassSource;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.CClick(Sender: TObject);
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to C code: ' + #13 + LClassSource;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.CPlusPlusClick(Sender: TObject);
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to C++ code: ' + #13 + LClassSource;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.CallThread(APrompt: string; AIsClassView: Boolean);
begin
  if not ValidateProviderBatch(AIsClassView, GetActiveProviderId) then
    Exit;

  if Assigned(FCoordinator) then
    FCoordinator.TargetHandle := Handle;
  ClearAnswers;
  Btn_Ask.Enabled := False;
  if Assigned(FBtnStop) then
    FBtnStop.Enabled := True;
  ActivityIndicator1.Visible := True;
  BeginRequestTimeoutWatch;
  if AIsClassView then
  begin
    FClassViewIsBusy := True;
    FCoordinator.StartSingleProvider(TSingletonSettingObj.Instance.GetPrimaryProviderId, APrompt, 'CLS');
  end
  else
  begin
    FClassViewIsBusy := False;
    FCoordinator.StartPromptBatch(APrompt, 'ASK', GetActiveProviderId);
  end;
end;

procedure TFram_Question.Chk_CaseSensitiveClick(Sender: TObject);
begin
  Edt_Search.OnChange(Edt_Search);
end;

procedure TFram_Question.ClassViewMenuItemClick(Sender: TObject);
var
  LvSettingObj: TSingletonSettingObj;
  LvQuestion: string;
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    Cs.Enter;
    LvSettingObj := TSingletonSettingObj.Instance;
    if LvSettingObj.TryFindQuestion(TMenuItem(Sender).Caption.Replace('&', '') , LvQuestion) > -1 then
    begin
      Cs.Leave;
      if not LvQuestion.Trim.IsEmpty then
      begin
        FLastQuestion := LvQuestion + #13 + LClassName; // Shorter string will be logged.
        LvQuestion := LvQuestion + #13 + LClassSource;
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
var
  LMemo: TMemo;
begin
  EnsureProviderControls;
  for LMemo in FProviderMemos.Values do
    LMemo.Clear;
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
var
  LMemo: TMemo;
begin
  if Assigned(pgcMain) then
  begin
    if pgcMain.ActivePage = tsChatGPT then
    begin
      LMemo := MemoForProvider(GetActiveProviderId);
      if Assigned(LMemo) then
        Clipboard.SetTextBuf(PWideChar(LMemo.Lines.Text));
    end
    else if pgcMain.ActivePage = tsClassView then
      Clipboard.SetTextBuf(PWideChar(mmoClassViewDetail.Lines.Text))
    else if pgcMain.ActivePage = tsHistory then
      Clipboard.SetTextBuf(PWideChar(mmoHistoryDetail.Lines.Text));
  end
  else
  begin
    LMemo := MemoForProvider(GetActiveProviderId);
    if Assigned(LMemo) then
      Clipboard.SetTextBuf(PWideChar(LMemo.Lines.Text));
  end;
end;

procedure TFram_Question.CopytoClipboard1Click(Sender: TObject);
begin
  CopyToClipBoard;
end;

procedure TFram_Question.CustomCommandClick(Sender: TObject);
var
  LClassName: string;
  LClassSource: string;
begin
  if not TryGetSelectedClassSource(LClassName, LClassSource) then
    Exit;

  FLastQuestion := '';
  if InputQuery('Custom Command(use @Class to represent the selected class)', 'Write your command here', FLastQuestion) then
  begin
    if FLastQuestion.Trim = '' then
      Exit;
  end
  else
    Exit;

  if FLastQuestion.ToLower.Trim.Contains('@class') then
    FLastQuestion := StringReplace(FLastQuestion, '@class', ' ' + LClassSource + ' ', [rfReplaceAll, rfIgnoreCase])
  else
    FLastQuestion := FLastQuestion + #13 + LClassSource;

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

procedure TFram_Question.EnsureProviderControls;

  procedure PrepareMemo(AMemo: TMemo);
  begin
    AMemo.ReadOnly := True;
    AMemo.ScrollBars := ssVertical;
  end;

begin
  if not Assigned(FCoordinator) then
    FCoordinator := TAIRequestCoordinator.Create(Self, Handle);

  if not Assigned(FProviderTabs) then
    FProviderTabs := TObjectDictionary<string, TTabSheet>.Create
  else
    FProviderTabs.Clear;

  if not Assigned(FProviderMemos) then
    FProviderMemos := TObjectDictionary<string, TMemo>.Create
  else
    FProviderMemos.Clear;

  if not Assigned(FChatGPTAnswerTab) then
  begin
    FChatGPTAnswerTab := TTabSheet.Create(Self);
    FChatGPTAnswerTab.PageControl := pgcAnswers;
    FChatGPTAnswerTab.Caption := CaptionProviderChatGPT;

    FChatGPTAnswerMemo := TMemo.Create(Self);
    FChatGPTAnswerMemo.Parent := FChatGPTAnswerTab;
    FChatGPTAnswerMemo.Align := alClient;
    FChatGPTAnswerMemo.Font.Assign(mmoAnswer.Font);
    PrepareMemo(FChatGPTAnswerMemo);
  end;

  PrepareMemo(mmoAnswer);
  PrepareMemo(mmoClaudeAnswer);
  PrepareMemo(mmoOllamaAnswer);

  tsChatGPTAnswer.Caption := CaptionProviderGemini;
  tsClaudeAnswer.Caption := CaptionProviderClaude;
  tsOllamaAnswer.Caption := CaptionProviderOllama;
  FChatGPTAnswerTab.Caption := CaptionProviderChatGPT;

  FProviderTabs.AddOrSetValue(ProviderGemini, tsChatGPTAnswer);
  FProviderTabs.AddOrSetValue(ProviderClaude, tsClaudeAnswer);
  FProviderTabs.AddOrSetValue(ProviderOllama, tsOllamaAnswer);
  FProviderTabs.AddOrSetValue(ProviderChatGPT, FChatGPTAnswerTab);

  FProviderMemos.AddOrSetValue(ProviderGemini, mmoAnswer);
  FProviderMemos.AddOrSetValue(ProviderClaude, mmoClaudeAnswer);
  FProviderMemos.AddOrSetValue(ProviderOllama, mmoOllamaAnswer);
  FProviderMemos.AddOrSetValue(ProviderChatGPT, FChatGPTAnswerMemo);
end;

procedure TFram_Question.FDQryHistoryAfterScroll(DataSet: TDataSet);
var
  LProviderName: string;
  LModelId: string;
  LStatus: string;
  LError: string;
begin
  if Assigned(pgcMain) then
  begin
    mmoHistoryDetail.Lines.Clear;
    LProviderName := FDQryHistory.FieldByName('provider_display_name').AsString;
    LModelId := FDQryHistory.FieldByName('model_id').AsString;
    LStatus := FDQryHistory.FieldByName('status').AsString;
    LError := FDQryHistory.FieldByName('error_text').AsString;

    if not LProviderName.IsEmpty then
      mmoHistoryDetail.Lines.Add('Provider: ' + LProviderName);
    if not LModelId.IsEmpty then
      mmoHistoryDetail.Lines.Add('Model: ' + LModelId);
    if not LStatus.IsEmpty then
      mmoHistoryDetail.Lines.Add('Status: ' + LStatus);
    if not LError.IsEmpty then
      mmoHistoryDetail.Lines.Add('Error: ' + LError);
    if mmoHistoryDetail.Lines.Count > 0 then
      mmoHistoryDetail.Lines.Add('');
    mmoHistoryDetail.Lines.Add(FDQryHistoryAnswer.AsString);
  end;
end;

procedure TFram_Question.FDQryHistoryDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not Sender.IsNull then
    Text := DateTimeToStr(UnixToDateTime(Sender.AsLargeInt));
end;

procedure TFram_Question.FDQryHistoryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  LSearchAccept: Boolean;
begin
  Accept := True;

  if Assigned(FProviderFilter) and (FProviderFilter.ItemIndex > 0) then
    Accept := Accept and SameText(DataSet.FieldByName('provider_display_name').AsString, FProviderFilter.Text);

  if Assigned(FModelFilter) and (FModelFilter.ItemIndex > 0) then
    Accept := Accept and SameText(DataSet.FieldByName('model_id').AsString, FModelFilter.Text);

  if not Accept then
    Exit;

  if Trim(Edt_Search.Text).IsEmpty then
    Exit;

  if Chk_FuzzyMatch.Checked then
    LSearchAccept := FuzzyMatchStr(Edt_Search.Text, DataSet.FieldByName('Question').AsString, nil, Chk_CaseSensitive.Checked)
  else
    LSearchAccept := XPos(Edt_Search.Text, DataSet.FieldByName('Question').AsString, Chk_CaseSensitive.Checked) > 0;

  Accept := LSearchAccept;
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
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to the GO programming language code: ' + #13 + LClassSource;
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
  EnsureProviderControls;
  ConfigureProviderPages;

  if not Assigned(FBtnStop) then
  begin
    FBtnStop := TButton.Create(Self);
    FBtnStop.Parent := pnlTop;
    FBtnStop.Top := Btn_Ask.Top;
    FBtnStop.Width := 70;
    FBtnStop.Height := Btn_Ask.Height;
    FBtnStop.Caption := 'Stop';
    FBtnStop.Enabled := False;
    FBtnStop.OnClick := Btn_StopClick;
  end;
  if not Assigned(FRequestTimer) then
  begin
    FRequestTimer := TTimer.Create(Self);
    FRequestTimer.Enabled := False;
    FRequestTimer.Interval := 500;
    FRequestTimer.OnTimer := RequestTimeoutTimer;
  end;
  UpdateTopButtonLayout;
  UpdateQuestionDraftHint(False);

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

procedure TFram_Question.ConfigureProviderPages;
var
  LPrimaryProviderId: string;
  LTab: TTabSheet;
begin
  EnsureProviderControls;

  tsChatGPTAnswer.Caption := CaptionProviderGemini;
  tsClaudeAnswer.Caption := CaptionProviderClaude;
  tsOllamaAnswer.Caption := CaptionProviderOllama;
  FChatGPTAnswerTab.Caption := CaptionProviderChatGPT;

  tsChatGPTAnswer.TabVisible := TSingletonSettingObj.Instance.EnableGemini;
  tsClaudeAnswer.TabVisible := TSingletonSettingObj.Instance.EnableClaude;
  tsOllamaAnswer.TabVisible := TSingletonSettingObj.Instance.EnableOllama;
  FChatGPTAnswerTab.TabVisible := TSingletonSettingObj.Instance.EnableChatGPT;

  LPrimaryProviderId := TSingletonSettingObj.Instance.GetPrimaryProviderId;
  LTab := TabForProvider(LPrimaryProviderId);
  if Assigned(LTab) and LTab.TabVisible then
    pgcAnswers.ActivePage := LTab;
end;

function TFram_Question.GetActiveProviderId: string;
var
  LProviderId: string;
begin
  EnsureProviderControls;
  Result := TSingletonSettingObj.Instance.GetPrimaryProviderId;

  if not Assigned(pgcAnswers) or not Assigned(pgcAnswers.ActivePage) then
    Exit;

  for LProviderId in FProviderTabs.Keys do
    if FProviderTabs[LProviderId] = pgcAnswers.ActivePage then
      Exit(LProviderId);
end;

function TFram_Question.MemoForProvider(const AProviderId: string): TMemo;
begin
  EnsureProviderControls;
  if not FProviderMemos.TryGetValue(AProviderId, Result) then
    Result := nil;
end;

function TFram_Question.TabForProvider(const AProviderId: string): TTabSheet;
begin
  EnsureProviderControls;
  if not FProviderTabs.TryGetValue(AProviderId, Result) then
    Result := nil;
end;

procedure TFram_Question.UpdateHistoryFilterCombos;
var
  LProviders: TStringList;
  LModels: TStringList;
begin
  if not Assigned(FProviderFilter) then
  begin
    FProviderFilter := TComboBox.Create(Self);
    FProviderFilter.Parent := pnlSearchHistory;
    FProviderFilter.Left := 3;
    FProviderFilter.Top := 8;
    FProviderFilter.Width := 100;
    FProviderFilter.Style := csDropDownList;
    FProviderFilter.OnChange := Edt_SearchChange;
  end;

  if not Assigned(FModelFilter) then
  begin
    FModelFilter := TComboBox.Create(Self);
    FModelFilter.Parent := pnlSearchHistory;
    FModelFilter.Left := 108;
    FModelFilter.Top := 8;
    FModelFilter.Width := 100;
    FModelFilter.Style := csDropDownList;
    FModelFilter.OnChange := Edt_SearchChange;
  end;

  Edt_Search.Left := 213;
  Edt_Search.Width := 108;

  LProviders := TStringList.Create;
  LModels := TStringList.Create;
  try
    LProviders.Sorted := True;
    LProviders.Duplicates := dupIgnore;
    LModels.Sorted := True;
    LModels.Duplicates := dupIgnore;

    if FDQryHistory.Active then
    begin
      FDQryHistory.DisableControls;
      try
        FDQryHistory.First;
        while not FDQryHistory.Eof do
        begin
          if not FDQryHistory.FieldByName('provider_display_name').IsNull then
            LProviders.Add(FDQryHistory.FieldByName('provider_display_name').AsString);
          if not FDQryHistory.FieldByName('model_id').IsNull then
            LModels.Add(FDQryHistory.FieldByName('model_id').AsString);
          FDQryHistory.Next;
        end;
        FDQryHistory.First;
      finally
        FDQryHistory.EnableControls;
      end;
    end;

    FProviderFilter.Items.BeginUpdate;
    try
      FProviderFilter.Items.Clear;
      FProviderFilter.Items.Add('All Providers');
      FProviderFilter.Items.AddStrings(LProviders);
      FProviderFilter.ItemIndex := 0;
    finally
      FProviderFilter.Items.EndUpdate;
    end;

    FModelFilter.Items.BeginUpdate;
    try
      FModelFilter.Items.Clear;
      FModelFilter.Items.Add('All Models');
      FModelFilter.Items.AddStrings(LModels);
      FModelFilter.ItemIndex := 0;
    finally
      FModelFilter.Items.EndUpdate;
    end;
  finally
    LProviders.Free;
    LModels.Free;
  end;
end;

procedure TFram_Question.OnProviderMessage(var Msg: TMessage);
var
  LPayload: TProviderMessagePayload;
  LResponse: TProviderResponse;
  LMemo: TMemo;
begin
  if csDestroying in ComponentState then
    Exit;

  LPayload := TProviderMessagePayload(Msg.WParam);
  try
    if not Assigned(LPayload) then
      Exit;

    if Assigned(FCoordinator) and (LPayload.BatchId <> '') and
       (not SameText(LPayload.BatchId, FCoordinator.CurrentBatchId)) then
      Exit;

    case LPayload.Kind of
      pmRequestStarted:
        begin
          ActivityIndicator1.Visible := True;
          Btn_Ask.Enabled := False;
          if Assigned(FBtnStop) then
            FBtnStop.Enabled := True;
        end;

      pmRequestCompleted:
        begin
          LResponse := LPayload.Response;
          if not Assigned(LResponse) then
            Exit;

          if SameText(LResponse.QuestionLabel, 'CLS') then
          begin
            if LResponse.Status = prsSucceeded then
              mmoClassViewResult.Lines.Text := LResponse.ResponseText
            else
              mmoClassViewResult.Lines.Text := LResponse.ErrorText;
          end
          else
          begin
            LMemo := MemoForProvider(LResponse.ProviderId);
            if Assigned(LMemo) then
            begin
              if LResponse.Status = prsSucceeded then
                LMemo.Lines.Text := LResponse.ResponseText
              else
                LMemo.Lines.Text := LResponse.ErrorText;
            end;
          end;

          AddToHistory(IfThen(SameText(LResponse.QuestionLabel, 'CLS'), FLastQuestion, mmoQuestion.Lines.Text), LResponse);
        end;

      pmBatchCompleted:
        begin
          EndRequestTimeoutWatch;
          Btn_Ask.Enabled := True;
          ActivityIndicator1.Visible := False;
          if Assigned(FBtnStop) then
            FBtnStop.Enabled := False;
          FClassViewIsBusy := False;
          if chk_AutoCopy.Checked then
            CopyToClipBoard;
          TSingletonSettingObj.Instance.ShouldReloadHistory := True;
        end;
    end;
  finally
    LPayload.Free;
  end;
end;

function TFram_Question.IslegacyModel: Boolean;
begin
  Result := SameText(GetActiveProviderId, ProviderChatGPT) and
            (TSingletonSettingObj.Instance.Model.Equals('text-davinci-003') or
             TSingletonSettingObj.Instance.URL.Equals('https://api.openai.com/v1/completions'));
end;

procedure TFram_Question.JavaClick(Sender: TObject);
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to Java code: ' + #13 + LClassSource;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.JavascriptClick(Sender: TObject);
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to Javascript code: ' + #13 + LClassSource;
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

procedure TFram_Question.pgcAnswersChange(Sender: TObject);
var
  LMemo: TMemo;
begin
  if chk_AutoCopy.Checked then
  begin
    LMemo := MemoForProvider(GetActiveProviderId);
    if Assigned(LMemo) then
      Clipboard.SetTextBuf(PWideChar(LMemo.Lines.Text));
  end;
  ActivityIndicator1.Visible := Assigned(FCoordinator) and FCoordinator.HasPendingRequests;
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
  AllowChange := (not Assigned(FCoordinator)) or (not FCoordinator.HasPendingRequests);
end;

procedure TFram_Question.pmClassOperationsPopup(Sender: TObject);
begin
  if not Assigned(FClassTreeView) then
    Exit;

  if Assigned(FClassTreeView.OnChange) then
    FClassTreeView.OnChange(FClassTreeView, FClassTreeView.Selected);
  if Assigned(FClassTreeView.Selected) and (FClassTreeView.Selected = FClassTreeView.TopItem) then
    keybd_event(VK_ESCAPE, Mapvirtualkey(VK_ESCAPE, 0), 0, 0);
end;

procedure TFram_Question.PythonClick(Sender: TObject);
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to Pyhton code: ' + #13 + LClassSource;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.ReloadClassList(AClassList: TClassList);
var
  LvLexer: TcpLexer;
begin
  if Assigned(FClassTreeView) then
    FreeAndNil(FClassTreeView);

  FClassList := AClassList;
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
    mmoClassViewResult.Lines.Clear;
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
    try
      ForceDirectories(ExtractFileDir(TSingletonSettingObj.Instance.GetHistoryFullPath));
      FDConnection.Close;
      FDConnection.Params.Clear;
      FDConnection.Params.Add('DriverID=SQLite');
      FDConnection.Params.Add('Database=' + TSingletonSettingObj.Instance.GetHistoryFullPath);
      FDConnection.Open;
      THistoryService.EnsureSchema(FDConnection);

      FDQryHistory.Close;
      FDQryHistory.SQL.Text :=
        'SELECT HID, ' +
        'COALESCE(question_text, Question) AS Question, ' +
        'COALESCE(answer_text, Answer) AS Answer, ' +
        'COALESCE(completed_at, Date) AS Date, ' +
        'COALESCE(provider_display_name, provider_id, ''Unknown'') AS provider_display_name, ' +
        'COALESCE(model_id, '''') AS model_id, ' +
        'COALESCE(status, ''succeeded'') AS status, ' +
        'COALESCE(error_text, '''') AS error_text, ' +
        'COALESCE(batch_id, '''') AS batch_id, ' +
        'COALESCE(request_id, '''') AS request_id ' +
        'FROM TbHistory ORDER BY HID DESC';
      FDQryHistory.Open;
      UpdateHistoryFilterCombos;
      Result := True;
    except
      on E: Exception do
        ShowIDEMessage('SQLite connection could not be established.' + sLineBreak + 'Error: ' + E.Message);
    end;
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
var
  LClassName: string;
  LClassSource: string;
begin
  if TryGetSelectedClassSource(LClassName, LClassSource) then
  begin
    FLastQuestion := 'Convert this Delphi Code to Rust code: ' + #13 + LClassSource;
    mmoClassViewResult.Lines.Clear;
    CallThread(FLastQuestion, True);
  end;
end;

procedure TFram_Question.SearchMnuClick(Sender: TObject);
begin
  pnlSearchHistory.Visible := SearchMnu.Checked;
  if not SearchMnu.Checked then
    Edt_Search.Clear;
  UpdateHistoryFilterCombos;
end;

procedure TFram_Question.TerminateAll;
begin
  if Assigned(FCoordinator) then
    FCoordinator.CancelAll;
  EndRequestTimeoutWatch;
  Btn_Ask.Enabled := True;
  if Assigned(FBtnStop) then
    FBtnStop.Enabled := False;
  FClassViewIsBusy := False;
  ActivityIndicator1.Visible := False;
end;

procedure TFram_Question.ShowClassSelectionUnavailable;
begin
  ShowIDEMessage('The selected class/type could not be resolved. Please reopen the Class View tab and select the item again.');
end;

function TFram_Question.TryGetSelectedClassSource(out AClassName, AClassSource: string; ASilent: Boolean): Boolean;
var
  LLines: TStringList;
begin
  Result := False;
  AClassName := '';
  AClassSource := '';

  if (not Assigned(FClassTreeView)) or (not Assigned(FClassList)) then
  begin
    if not ASilent then
      ShowClassSelectionUnavailable;
    Exit;
  end;

  if (not Assigned(FClassTreeView.Selected)) or (FClassTreeView.Selected = FClassTreeView.TopItem) then
  begin
    if not ASilent then
      ShowClassSelectionUnavailable;
    Exit;
  end;

  AClassName := FClassTreeView.Selected.Text;
  if not FClassList.TryGetValue(AClassName, LLines) or (not Assigned(LLines)) then
  begin
    if not ASilent then
      ShowClassSelectionUnavailable;
    Exit;
  end;

  AClassSource := Trim(LLines.Text);
  if AClassSource = '' then
  begin
    if not ASilent then
      ShowClassSelectionUnavailable;
    Exit;
  end;

  Result := True;
end;

procedure TFram_Question.BeginRequestTimeoutWatch;
begin
  FRequestStartedAt := Now;
  if Assigned(FRequestTimer) then
    FRequestTimer.Enabled := True;
end;

procedure TFram_Question.EndRequestTimeoutWatch;
begin
  if Assigned(FRequestTimer) then
    FRequestTimer.Enabled := False;
end;

procedure TFram_Question.ApplyTimeoutState;
var
  LMemo: TMemo;
  LMessage: string;
begin
  if TSingletonSettingObj.Instance.TimeOut > 0 then
    LMessage := Format(CProgressTimeoutFmt, [Max(CMinRequestTimeoutSeconds, TSingletonSettingObj.Instance.TimeOut)])
  else
    LMessage := Format(CProgressTimeoutFmt, [CDefaultRequestTimeoutSeconds]);
  if FClassViewIsBusy then
    mmoClassViewResult.Lines.Text := LMessage
  else
    for LMemo in FProviderMemos.Values do
      LMemo.Lines.Text := LMessage;
end;

procedure TFram_Question.RequestTimeoutTimer(Sender: TObject);
var
  LElapsedSeconds: Integer;
  LTimeoutSeconds: Integer;
begin
  if not Assigned(FCoordinator) or not FCoordinator.HasPendingRequests then
  begin
    EndRequestTimeoutWatch;
    Exit;
  end;

  if TSingletonSettingObj.Instance.TimeOut > 0 then
    LTimeoutSeconds := Max(CMinRequestTimeoutSeconds, TSingletonSettingObj.Instance.TimeOut)
  else
    LTimeoutSeconds := CDefaultRequestTimeoutSeconds;
  LElapsedSeconds := SecondsBetween(Now, FRequestStartedAt);
  if LElapsedSeconds >= LTimeoutSeconds then
  begin
    if Assigned(FCoordinator) then
      FCoordinator.CancelAll;
    EndRequestTimeoutWatch;
    ApplyTimeoutState;
    Btn_Ask.Enabled := True;
    if Assigned(FBtnStop) then
      FBtnStop.Enabled := False;
    FClassViewIsBusy := False;
    ActivityIndicator1.Visible := False;
  end;
end;

procedure TFram_Question.UpdateTopButtonLayout;
const
  Gap = 6;
begin
  Btn_Ask.Width := 74;
  Btn_Clipboard.Width := 110;
  Btn_Clear.Width := 74;

  if not Assigned(FBtnStop) then
    Exit;

  FBtnStop.Width := 70;
  FBtnStop.Height := Btn_Ask.Height;
  FBtnStop.Top := Btn_Ask.Top;

  if TSingletonSettingObj.Instance.RighToLeft then
  begin
    Btn_Ask.Anchors := [akTop, akRight];
    FBtnStop.Anchors := [akTop, akRight];
    Btn_Clipboard.Anchors := [akTop, akRight];
    Btn_Clear.Anchors := [akTop, akRight];

    Btn_Ask.Left := btnHelp.Left - Gap - Btn_Ask.Width;
    FBtnStop.Left := Btn_Ask.Left - Gap - FBtnStop.Width;
    Btn_Clipboard.Left := FBtnStop.Left - Gap - Btn_Clipboard.Width;
    Btn_Clear.Left := Btn_Clipboard.Left - Gap - Btn_Clear.Width;
  end
  else
  begin
    Btn_Ask.Anchors := [akTop, akLeft];
    FBtnStop.Anchors := [akTop, akLeft];
    Btn_Clipboard.Anchors := [akTop, akLeft];
    Btn_Clear.Anchors := [akTop, akLeft];

    Btn_Ask.Left := 40;
    FBtnStop.Left := Btn_Ask.Left + Btn_Ask.Width + Gap;
    Btn_Clipboard.Left := FBtnStop.Left + FBtnStop.Width + Gap;
    Btn_Clear.Left := Btn_Clipboard.Left + Btn_Clipboard.Width + Gap;
  end;
end;

function TFram_Question.ValidateProviderBatch(AIsClassView: Boolean; const AActiveProviderId: string): Boolean;
var
  LRegistry: IAIProviderRegistry;
  LProviderIds: TArray<string>;
  LProviderId: string;
  LProvider: IAIProvider;
  LSettings: TAIProviderSetting;
  LError: string;
begin
  if AIsClassView then
  begin
    SetLength(LProviderIds, 1);
    LProviderIds[0] := TSingletonSettingObj.Instance.GetPrimaryProviderId;
  end
  else
    LProviderIds := TSingletonSettingObj.Instance.GetEnabledProviderIds;

  if (Length(LProviderIds) = 0) and (AActiveProviderId <> '') then
  begin
    SetLength(LProviderIds, 1);
    LProviderIds[0] := AActiveProviderId;
  end;

  if Length(LProviderIds) = 0 then
  begin
    ShowIDEMessage(CNoProviderConfiguredMsg);
    Exit(False);
  end;

  LRegistry := TAIProviderRegistry.Instance;
  for LProviderId in LProviderIds do
  begin
    LProvider := LRegistry.GetProvider(LProviderId);
    if not Assigned(LProvider) then
    begin
      ShowIDEMessage('The selected provider "' + LProviderId + '" is not available.');
      Exit(False);
    end;

    LSettings := TSingletonSettingObj.Instance.GetProviderSetting(LProviderId);
    try
      if not LProvider.ValidateSettings(LSettings, LError) then
      begin
        ShowIDEMessage(LProvider.GetDisplayName + ': ' + LError + sLineBreak + CReviewProviderSettingsMsg);
        Exit(False);
      end;
    finally
      LSettings.Free;
    end;
  end;

  Result := True;
end;

procedure TFram_Question.UpdateQuestionDraftHint(AShowInlineHint: Boolean);
var
  LHintTop: Integer;
  LHintLeft: Integer;
  LQuestionTop: Integer;
begin
  LHintTop := Btn_Ask.Top + Btn_Ask.Height + 5;
  LHintLeft := 14;
  LQuestionTop := Lbl_Question.Top + Lbl_Question.Height + 6;

  if not Assigned(FInlineHintLabel) then
  begin
    FInlineHintLabel := TLabel.Create(Self);
    FInlineHintLabel.Parent := pnlTop;
    FInlineHintLabel.Left := LHintLeft;
    FInlineHintLabel.Top := LHintTop;
    FInlineHintLabel.Width := pnlTop.ClientWidth - LHintLeft - btnHelp.Width - 16;
    FInlineHintLabel.Height := 16;
    FInlineHintLabel.Anchors := [akLeft, akTop, akRight];
    FInlineHintLabel.WordWrap := False;
    FInlineHintLabel.Transparent := True;
    FInlineHintLabel.ShowHint := False;
    FInlineHintLabel.Font.Assign(Font);
    FInlineHintLabel.Font.Size := 8;
    FInlineHintLabel.Font.Color := clSilver;
  end;

  FInlineHintLabel.Caption := Format(CInlineEditorHintFmt,
    [TSingletonSettingObj.Instance.LeftIdentifier, TSingletonSettingObj.Instance.RightIdentifier]);
  FInlineHintLabel.Visible := AShowInlineHint;
  FInlineHintLabel.Left := LHintLeft;
  FInlineHintLabel.Top := LHintTop;
  FInlineHintLabel.Width := pnlTop.ClientWidth - LHintLeft - btnHelp.Width - 16;

  pnlTop.Height := IfThen(AShowInlineHint, 60, 44);
  if pnlQuestion.Height < 120 then
    pnlQuestion.Height := 120;
  mmoQuestion.SetBounds(5, LQuestionTop, pnlQuestion.ClientWidth - 10, pnlQuestion.ClientHeight - LQuestionTop - 6);
end;

procedure TFram_Question.PrepareQuestionDraft(const ASelectedText: string; AShowInlineHint: Boolean);
var
  LDraft: TStringList;
  LPlaceholderPos: Integer;
begin
  if Assigned(pgcMain) then
    pgcMain.ActivePage := tsChatGPT;

  LDraft := TStringList.Create;
  try
    LDraft.Add(CQuestionPromptLabel);
    LDraft.Add(CQuestionDraftPlaceholder);
    if ASelectedText.Trim <> '' then
    begin
      LDraft.Add('');
      LDraft.Add(CSelectedCodeLabel);
      LDraft.Add(ASelectedText);
    end;
    mmoQuestion.Lines.Text := LDraft.Text;
  finally
    LDraft.Free;
  end;

  UpdateQuestionDraftHint(AShowInlineHint);
  if mmoQuestion.CanFocus then
    mmoQuestion.SetFocus;

  LPlaceholderPos := Pos(CQuestionDraftPlaceholder, mmoQuestion.Text);
  if LPlaceholderPos > 0 then
  begin
    mmoQuestion.SelStart := LPlaceholderPos - 1;
    mmoQuestion.SelLength := Length(CQuestionDraftPlaceholder);
  end
  else
    mmoQuestion.SelStart := mmoQuestion.GetTextLen;
end;

procedure TFram_Question.tvOnChange(Sender: TObject; Node: TTreeNode);
var
  LClassName: string;
  LClassSource: string;
begin
  mmoClassViewDetail.Lines.Clear;
  mmoClassViewDetail.ScrollBars := TScrollStyle.ssNone;
  if TryGetSelectedClassSource(LClassName, LClassSource, True) then
    mmoClassViewDetail.Lines.Text := LClassSource;
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
