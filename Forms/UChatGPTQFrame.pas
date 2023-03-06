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
  FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TClassList = TObjectDictionary<string, TStringList>;

  TObDicHelper = class helper for TClassList
  public
    procedure FillTreeView(var ATree: TTreeView);
  end;

  TFram_Question = class(TFrame)
    pnlMain: TPanel;
    Lbl_Question: TLabel;
    Lbl_Answer: TLabel;
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
    CreateTestUnit1: TMenuItem;
    ConverttoSingletone1: TMenuItem;
    Findpossibleproblems1: TMenuItem;
    ImproveNaming1: TMenuItem;
    Rewriteinmoderncodingstyle1: TMenuItem;
    CrreateInterface1: TMenuItem;
    ConverttoGenericType1: TMenuItem;
    CustomCommand1: TMenuItem;
    Convertto1: TMenuItem;
    CSharp: TMenuItem;
    Java1: TMenuItem;
    Python1: TMenuItem;
    Javascript1: TMenuItem;
    Go1: TMenuItem;
    C3: TMenuItem;
    C2: TMenuItem;
    Rust1: TMenuItem;
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
    WriteXMLdoc1: TMenuItem;
    pmGrdHistory: TPopupMenu;
    ReloadHistory1: TMenuItem;
    pnlSearchHistory: TPanel;
    Chk_CaseSensitive: TCheckBox;
    Edt_Search: TEdit;
    Search1: TMenuItem;
    Chk_FuzzyMatch: TCheckBox;
    mmoClassViewResult: TMemo;
    splClassViewResult: TSplitter;
    procedure Btn_AskClick(Sender: TObject);
    procedure Btn_ClipboardClick(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_ClearClick(Sender: TObject);
    procedure CreateTestUnit1Click(Sender: TObject);
    procedure tvOnChange(Sender: TObject; Node: TTreeNode);
    procedure pmClassOperationsPopup(Sender: TObject);
    procedure ConverttoSingletone1Click(Sender: TObject);
    procedure Findpossibleproblems1Click(Sender: TObject);
    procedure ImproveNaming1Click(Sender: TObject);
    procedure Rewriteinmoderncodingstyle1Click(Sender: TObject);
    procedure CrreateInterface1Click(Sender: TObject);
    procedure ConverttoGenericType1Click(Sender: TObject);
    procedure CSharpClick(Sender: TObject);
    procedure Java1Click(Sender: TObject);
    procedure Python1Click(Sender: TObject);
    procedure Javascript1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure Go1Click(Sender: TObject);
    procedure Rust1Click(Sender: TObject);
    procedure CustomCommand1Click(Sender: TObject);
    procedure C3Click(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure FDQryHistoryQuestionGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FDQryHistoryAfterScroll(DataSet: TDataSet);
    procedure FDQryHistoryDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure GridResize(Sender: TObject);
    procedure DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure CloseBtnClick(Sender: TObject);
    procedure WriteXMLdoc1Click(Sender: TObject);
    procedure ReloadHistory1Click(Sender: TObject);
    procedure Search1Click(Sender: TObject);
    procedure Edt_SearchChange(Sender: TObject);
    procedure FDQryHistoryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure Chk_CaseSensitiveClick(Sender: TObject);
  private
    FTrd: TExecutorTrd;
    FPrg: TProgressBar;
    FClassList: TClassList;
    FClassTreeView: TTreeView;
    FCellCloseBtn: TSpeedButton;
    FHistoryGrid: THistoryDBGrid;
    FLastQuestion: string;
    procedure CopyToClipBoard;
    procedure CreateProgressbar;
    procedure CallThread(APrompt: string);
    function XPos(APattern, AStr: string; ACaseSensitive: Boolean): Integer;
    function LowChar(AChar: Char): Char; inline;
    function FuzzyMatchStr(const APattern, AStr: string; AMatchedIndexes: TList; ACaseSensitive: Boolean): Boolean;
    procedure HighlightCellTextFull(AGrid: THistoryDBGrid; const ARect: TRect; AField: TField; AFilterText: string; AState: TGridDrawState;
                                    ACaseSensitive: Boolean; ABkColor: TColor = clRed; ASelectedBkColor: TColor = clGray);
    procedure HighlightCellTextFuzzy(AGrid: TDbGrid; const ARect: TRect; AField: TField; AMatchedIndexes : TList; AState: TGridDrawState ;
                                ACaseSensitive: Boolean; ABkColor: TColor = clRed; ASelectedBkColor: TColor = clGray);
  public
    procedure InitialFrame;
    procedure TerminateThred;
    procedure ReloadClassList(AClassList: TClassList);
    procedure LoadHistory;
    procedure AddToHistory(AQuestion, AAnswer: string);
    procedure OnUpdateMessage(var Msg: TMessage); message WM_UPDATE_MESSAGE;
    procedure OnProgressMessage(var Msg: TMessage); message WM_PROGRESS_MESSAGE;
  end;

implementation

{$R *.dfm}

procedure TFram_Question.AddToHistory(AQuestion, AAnswer: string);
begin
  if (TSingletonSettingObj.Instance.HistoryEnabled) and
     (FDConnection.Connected) and (FDQryHistory.Active) then
  begin
    FDQryHistory.Append;
    FDQryHistoryQuestion.AsString := AQuestion;
    FDQryHistoryAnswer.AsString := AAnswer;
    FDQryHistoryDate.AsLargeInt := DateTimeToUnix(Date);
    FDQryHistory.Post;
  end;
end;

procedure TFram_Question.Btn_AskClick(Sender: TObject);
begin
  if mmoQuestion.Lines.Text.Trim.IsEmpty then
  begin
    ShowMessage('Really?!' + #13 + 'You need to type a question first.');
    if mmoQuestion.CanFocus then
      mmoQuestion.SetFocus;

    Exit;
  end;
  CallThread(mmoQuestion.Lines.Text);
end;

procedure TFram_Question.Btn_ClearClick(Sender: TObject);
begin
  mmoQuestion.Lines.Clear;
  mmoAnswer.Lines.Clear;
end;

procedure TFram_Question.Btn_ClipboardClick(Sender: TObject);
begin
  CopyToClipBoard;
end;

procedure TFram_Question.CSharpClick(Sender: TObject);
begin
  ShowMessage(TMenuItem(Sender).Caption);
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to C#: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.C2Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to C++: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.C3Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to C: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.CallThread(APrompt: string);
var
  LvApiKey: string;
  LvUrl: string;
  LvModel: string;
  LvQuestion: string;
  LvMaxToken: Integer;
  LvTemperature: Integer;
  LvSetting: TSingletonSettingObj;
begin
  Cs.Enter;
  LvSetting := TSingletonSettingObj.Instance;
  LvApiKey := LvSetting.ApiKey;
  LvUrl := LvSetting.URL;
  LvModel := LvSetting.Model;
  LvMaxToken := LvSetting.MaxToken;
  LvTemperature := LvSetting.Temperature;
  LvQuestion := APrompt;
  Cs.Leave;
  FTrd := TExecutorTrd.Create(Self.Handle, LvApiKey, LvModel, LvQuestion, LvUrl,
    LvMaxToken, LvTemperature, LvSetting.ProxySetting.Active,
    LvSetting.ProxySetting.ProxyHost, LvSetting.ProxySetting.ProxyPort,
    LvSetting.ProxySetting.ProxyUsername, LvSetting.ProxySetting.ProxyPassword);
  FTrd.Start;

  if Assigned(pgcMain) then
    pgcMain.Enabled := False;
end;

procedure TFram_Question.Chk_CaseSensitiveClick(Sender: TObject);
begin
  Edt_Search.OnChange(Edt_Search);
end;

procedure TFram_Question.CloseBtnClick(Sender: TObject);
begin
  FDQryHistory.Delete;
end;

procedure TFram_Question.ConverttoGenericType1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this class to generic class in Delphi: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.ConverttoSingletone1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this class to singleton in Delphi: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
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

// progressbar is not working properly inside the docking form,
// had to create and destroy each time!
procedure TFram_Question.CreateProgressbar;
begin
  FPrg := TProgressBar.Create(Self);
  FPrg.Parent := pnlBottom;
  with FPrg do
  begin
    Left := 11;
    Top := 10;
    Width := 120;
    Height := 16;
    Anchors := [akLeft, akBottom];
    Style := pbstMarquee;
    TabOrder := 1;
    Visible := True;
  end;
end;

procedure TFram_Question.CreateTestUnit1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Create a Test Unit for the following class in Delphi: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.CrreateInterface1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Create necessary interfaces for this Class in Delphi: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.CustomCommand1Click(Sender: TObject);
begin
  FClassTreeView.HideSelection := False;
  InputQuery('Custom Command(use @Class to represent the selected class)', 'Write your command here', FLastQuestion);
  if FLastQuestion.Trim = '' then
    Exit;

  if FLastQuestion.ToLower.Trim.Contains('@class') then
  begin
    FLastQuestion := StringReplace(FLastQuestion, '@class', ' ' + FClassList.Items[FClassTreeView.Selected.Text].Text + ' ', [rfReplaceAll, rfIgnoreCase]);
  end
  else
    FLastQuestion := FLastQuestion + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;

  CallThread(FLastQuestion);
end;

procedure TFram_Question.DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
Var
  DataRect: TRect;// Used for delete button in cell.
  //=========================
  LvPattern, LvValue: string; //used for HighLight
  LvMatchedIndexes: TList;
begin
  //================= Drawing delete button ============================
  if (not FDQryHistoryHID.IsNull) and (Column.Title.Caption = '^_^') Then
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
      HighlightCellTextFull(THistoryDBGrid(Sender), Rect, Column.Field, Trim(Edt_Search.Text), State, Chk_CaseSensitive.Checked)
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
            HighlightCellTextFuzzy(THistoryDBGrid(Sender),Rect, Column.Field, LvMatchedIndexes, State, Chk_CaseSensitive.Checked);
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

procedure TFram_Question.FDQryHistoryAfterScroll(DataSet: TDataSet);
begin
  mmoHistoryDetail.Lines.Clear;
  mmoHistoryDetail.Lines.Add(FDQryHistoryAnswer.AsString);
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

procedure TFram_Question.Findpossibleproblems1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'What is wrong with this class in Delphi? : ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
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

procedure TFram_Question.Go1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to the GO programming language: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
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

procedure TFram_Question.ImproveNaming1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Improve naming of the members of this class in Delphi: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.InitialFrame;
begin
  FLastQuestion := '';
  Align := alClient;

  FCellCloseBtn := TSpeedButton.Create(Self);
  FCellCloseBtn.Glyph.LoadFromResourceName(HInstance, 'CLOSE');
  FCellCloseBtn.OnClick := CloseBtnClick;

  FHistoryGrid := THistoryDBGrid.Create(Self);
  with FHistoryGrid do
  begin
    Parent := pnlHistoryTop;
    Align := alClient;
    DataSource := DSHistory;
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
end;

procedure TFram_Question.Java1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Java: ' + #13 + FClassList.Items [FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.Javascript1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Javascript: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
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
    if Assigned(FPrg) then
      FreeAndNil(FPrg);
  end
  else
    CreateProgressbar;

  Btn_Ask.Enabled := Msg.WParam = 0;
end;

procedure TFram_Question.OnUpdateMessage(var Msg: TMessage);
begin
  if Assigned(pgcMain) then
  begin
    pgcMain.Enabled := True;

    if pgcMain.ActivePage = tsChatGPT then
    begin
      Btn_Ask.Enabled := True;
      mmoAnswer.Lines.Clear;
      mmoAnswer.Lines.Add(String(Msg.WParam));

      if Msg.LParam <> 1 then  // if it's not error
        AddToHistory(mmoQuestion.Lines.Text, mmoAnswer.Lines.Text);
    end
    else if pgcMain.ActivePage = tsClassView then
    begin
      mmoClassViewResult.Lines.Clear;
      mmoClassViewResult.Lines.Add(String(Msg.WParam));
      mmoClassViewResult.Visible := True;
      splClassViewResult.Visible := True;
      if Msg.LParam <> 1 then
        AddToHistory(FLastQuestion , mmoClassViewResult.Lines.Text);
    end;
  end
  else
  begin
    Btn_Ask.Enabled := True;
    mmoAnswer.Lines.Clear;
    mmoAnswer.Lines.Add(String(Msg.WParam));
    if Msg.LParam <> 1 then // if it's not error
      AddToHistory(mmoQuestion.Lines.Text, mmoAnswer.Lines.Text);
  end;

  if (Msg.LParam <> 1) and (chk_AutoCopy.Checked) then  // if it's not error
    CopyToClipBoard;

  if Msg.LParam <> 1 then  // if it's not error
    TSingletonSettingObj.Instance.ShouldReloadHistory := True;
end;

procedure TFram_Question.pgcMainChange(Sender: TObject);
begin
  if pgcMain.ActivePage = tsClassView then
    ReloadClassList(FClassList);

  if pgcMain.ActivePage = tsHistory then
  begin
    if TSingletonSettingObj.Instance.ShouldReloadHistory then
    begin
      LoadHistory;
      TSingletonSettingObj.Instance.ShouldReloadHistory := False;
      Width := Width + 1; // Doesn't really change the width, it's a trick to force the grid to fit columns!
    end;

    if FDQryHistory.RecordCount > 0  then
      FDQryHistory.AfterScroll(FDQryHistory);
  end;
end;

procedure TFram_Question.pmClassOperationsPopup(Sender: TObject);
begin
  FClassTreeView.OnChange(FClassTreeView, FClassTreeView.Selected);
  if FClassTreeView.Selected = FClassTreeView.TopItem then
    keybd_event(VK_ESCAPE, Mapvirtualkey(VK_ESCAPE, 0), 0, 0);
end;

procedure TFram_Question.Python1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Pyhton: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.ReloadClassList(AClassList: TClassList);
var
  LvLexer: TcpLexer;
begin
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

procedure TFram_Question.ReloadHistory1Click(Sender: TObject);
begin
  LoadHistory;
end;

procedure TFram_Question.LoadHistory;
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
    except on E: Exception do
      ShowMessage('SQLite Connection didn''t established.' + #13 + 'Error: ' + E.Message);
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

procedure TFram_Question.Rewriteinmoderncodingstyle1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Rewrite this class with modern coding style in Delphi: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.Rust1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Convert this Delphi Code to Rust programming language: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
end;

procedure TFram_Question.Search1Click(Sender: TObject);
begin
  pnlSearchHistory.Visible := Search1.Checked;
end;

procedure TFram_Question.TerminateThred;
begin
  try
    if Assigned(FTrd) then FTrd.Terminate;
  except
  end;

  if Assigned(FPrg) then
    FreeAndNil(FPrg);

  pgcMain.Enabled := True;
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

procedure TFram_Question.WriteXMLdoc1Click(Sender: TObject);
begin
  if FClassTreeView.Selected <> FClassTreeView.TopItem then
  begin
    FLastQuestion := 'Write Documentation using inline XML based comments for this class in Delphi: ' + #13 + FClassList.Items[FClassTreeView.Selected.Text].Text;
    CallThread(FLastQuestion);
  end;
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
