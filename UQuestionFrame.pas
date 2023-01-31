unit UQuestionFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Clipbrd, UThread, USetting;

type
  TFram_Question = class(TFrame)
    pnlMain: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    mmoQuestion: TMemo;
    mmoAnswer: TMemo;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    Btn_Clipboard: TButton;
    Btn_Ask: TButton;
    PopupMenu1: TPopupMenu;
    CopytoClipboard1: TMenuItem;
    Btn_Clear: TButton;
    chk_AutoCopy: TCheckBox;
    procedure Btn_AskClick(Sender: TObject);
    procedure Btn_ClipboardClick(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_ClearClick(Sender: TObject);
  private
    FTrd: TExecutorTrd;
    procedure CopyToClipBoard;
  public
    procedure OnUpdateMessage(var Msg: TMessage); message WM_UPDATE_MESSAGE;
    procedure OnProgressMessage(var Msg: TMessage); message WM_PROGRESS_MESSAGE;
  end;

implementation

{$R *.dfm}

procedure TFram_Question.Btn_AskClick(Sender: TObject);
var
  LvApiKey: string;
  LvUrl: string;
  LvModel: string;
begin
  Cs.Enter;
  LvApiKey := TSingletonSettingObj.Instance.ApiKey;
  LvUrl := TSingletonSettingObj.Instance.URL;
  LvModel := TSingletonSettingObj.Instance.Model;
  Cs.Leave;

  mmoAnswer.Clear;
  FTrd := TExecutorTrd.Create(Self.Handle, LvApiKey, LvModel, mmoQuestion.Lines.Text, LvUrl);
  FTrd.Start;
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

procedure TFram_Question.CopyToClipBoard;
begin
  Clipboard.SetTextBuf(pwidechar(mmoAnswer.Lines.Text));
end;

procedure TFram_Question.CopytoClipboard1Click(Sender: TObject);
begin
  CopyToClipBoard;
end;

procedure TFram_Question.mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Ord(Key) = 13) then
    Btn_Ask.Click;
end;

procedure TFram_Question.OnProgressMessage(var Msg: TMessage);
begin
  ProgressBar1.Visible := Msg.WParam <> 0;
  Btn_Ask.Enabled := Msg.WParam = 0;
end;

procedure TFram_Question.OnUpdateMessage(var Msg: TMessage);
begin
  mmoAnswer.Lines.Clear;
  mmoAnswer.Lines.Add(string(Msg.WParam));
  if chk_AutoCopy.Checked then
    CopyToClipBoard;
end;

end.

