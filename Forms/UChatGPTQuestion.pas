{***************************************************}
{                                                   }
{   This is the main form of the plugin.            }
{   Could be open/close in the main menu.           }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UChatGPTQuestion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Menus, UChatGPTSetting, Vcl.Clipbrd, UChatGPTQFrame, System.Win.Registry, UConsts;

type
  TFrmChatGPT = class(TForm)
    Fram_Question: TFram_Question;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FInitialQuestionDraft: string;
    FShowInlineQuestionTip: Boolean;
    procedure SaveLastQuestion;
  public
    property InitialQuestionDraft: string read FInitialQuestionDraft write FInitialQuestionDraft;
    property ShowInlineQuestionTip: Boolean read FShowInlineQuestionTip write FShowInlineQuestionTip;
  end;

var
  FrmChatGPT: TFrmChatGPT;

implementation

{$R *.dfm}

procedure TFrmChatGPT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveLastQuestion;
  Fram_Question.TerminateAll;
end;

procedure TFrmChatGPT.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
  begin
    Fram_Question.TerminateAll;
    Close;
  end;
end;

procedure TFrmChatGPT.FormShow(Sender: TObject);
begin
  with Fram_Question do
  begin
    pnlMain.Parent := Fram_Question;
    pnlMain.Align := alClient;
    Cs.Enter;
    mmoQuestion.Lines.Clear;
    UpdateQuestionDraftHint(False);
    if FShowInlineQuestionTip or (not FInitialQuestionDraft.Trim.IsEmpty) then
      PrepareQuestionDraft(FInitialQuestionDraft, FShowInlineQuestionTip)
    else if not TSingletonSettingObj.Instance.MainFormLastQuestion.Trim.IsEmpty then
      mmoQuestion.Lines.Add(TSingletonSettingObj.Instance.MainFormLastQuestion);
    Cs.Leave;
    ConfigureProviderPages;
    ActivityIndicator1.Visible := False;
    FreeAndNil(pgcMain);
  end;
  FShowInlineQuestionTip := False;
  FInitialQuestionDraft := '';
end;

procedure TFrmChatGPT.SaveLastQuestion;
var
  LvRegKey: TRegistry;
begin
  try
    LvRegKey := TRegistry.Create;
    try
      LvRegKey.CloseKey;
      LvRegKey.RootKey := HKEY_CURRENT_USER;
      if (LvRegKey.OpenKey(CRegistryRoot, True)) and
         (not Trim(Fram_Question.mmoQuestion.Text).IsEmpty) and
         (Pos(CQuestionDraftPlaceholder, Fram_Question.mmoQuestion.Text) = 0) then
        LvRegKey.WriteString(CMainFormLastQuestionValueName, Fram_Question.mmoQuestion.text);
    finally
      LvRegKey.Free;
    end;
  except
  end;
end;

end.
