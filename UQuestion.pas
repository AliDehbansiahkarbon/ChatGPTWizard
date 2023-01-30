unit UQuestion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, UThread,
  Vcl.Menus;

type
  TFrmChatGPT = class(TForm)
    pnlMain: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Btn_Ask: TButton;
    mmoQuestion: TMemo;
    mmoAnswer: TMemo;
    ProgressBar1: TProgressBar;
    PopupMenu1: TPopupMenu;
    CopytoClipboard1: TMenuItem;
    Btn_Clipboard: TButton;
    procedure mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_AskClick(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure Btn_ClipboardClick(Sender: TObject);
  public
    ApiKey: string;
    procedure OnUpdateMessage(var Msg: TMessage); message WM_UPDATE_MESSAGE;
    procedure OnProgressMessage(var Msg: TMessage); message WM_PROGRESS_MESSAGE;
  end;

var
  FrmChatGPT: TFrmChatGPT;

implementation

{$R *.dfm}

procedure TFrmChatGPT.Btn_AskClick(Sender: TObject);
var
  LvTrd: TExecutorTrd;
begin
  mmoAnswer.Clear;
  LvTrd := TExecutorTrd.Create(Self.Handle, ApiKey, 'text-davinci-003', mmoQuestion.Lines.Text);
  LvTrd.Start;
end;

procedure TFrmChatGPT.Btn_ClipboardClick(Sender: TObject);
begin
  mmoAnswer.CopyToClipboard;
end;

procedure TFrmChatGPT.CopytoClipboard1Click(Sender: TObject);
begin
  mmoAnswer.CopyToClipboard;
end;

procedure TFrmChatGPT.mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Ord(Key) = 13) then
    Btn_Ask.Click;
end;

procedure TFrmChatGPT.OnProgressMessage(var Msg: TMessage);
begin
  ProgressBar1.Visible := Msg.WParam <> 0;
  Btn_Ask.Enabled := Msg.WParam = 0;
end;

procedure TFrmChatGPT.OnUpdateMessage(var Msg: TMessage);
begin
  mmoAnswer.Lines.Clear;
  mmoAnswer.Lines.Add(string(Msg.WParam));
end;

end.
