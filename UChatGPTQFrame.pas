unit UChatGPTQFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Clipbrd, UChatGPTThread, UChatGPTSetting;

type
  TFram_Question = class(TFrame)
    pnlMain: TPanel;
    pnlTop: TPanel;
    Btn_Clipboard: TButton;
    Btn_Ask: TButton;
    PopupMenu: TPopupMenu;
    CopytoClipboard1: TMenuItem;
    Btn_Clear: TButton;
    chk_AutoCopy: TCheckBox;
    pnlQuestion: TPanel;
    pnlAnswer: TPanel;
    mmoQuestion: TMemo;
    Label1: TLabel;
    pnlBottom: TPanel;
    Label2: TLabel;
    mmoAnswer: TMemo;
    procedure Btn_AskClick(Sender: TObject);
    procedure Btn_ClipboardClick(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_ClearClick(Sender: TObject);
  private
    FTrd: TExecutorTrd;
    FPrg: TProgressBar;
    procedure CopyToClipBoard;
    procedure CreateProgressbar;
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
  LvQuestion: string;
begin
  Cs.Enter;
  LvApiKey := TSingletonSettingObj.Instance.ApiKey;
  LvUrl := TSingletonSettingObj.Instance.URL;
  LvModel := TSingletonSettingObj.Instance.Model;
  Cs.Leave;

  LvQuestion := mmoQuestion.Lines.Text;
  FTrd := TExecutorTrd.Create(Self.Handle, LvApiKey, LvModel, LvQuestion, LvUrl);
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

//progressbar is not working properly inside the docking form,
//had to create and destroy each time!
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

procedure TFram_Question.mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Ord(Key) = 13) then
    Btn_Ask.Click;
end;

procedure TFram_Question.OnProgressMessage(var Msg: TMessage);
begin
  if Msg.WParam <> 0 then
    CreateProgressbar
  else
    FPrg.Visible := False;

  Btn_Ask.Enabled := Msg.WParam = 0;
end;

procedure TFram_Question.OnUpdateMessage(var Msg: TMessage);
begin
  mmoAnswer.Lines.Clear;
  mmoAnswer.Lines.Add(string(Msg.WParam));
  if chk_AutoCopy.Checked then
    CopyToClipBoard;

  FPrg.Free;
end;

end.

