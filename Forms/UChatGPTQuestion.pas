{***************************************************}
{                                                   }
{   This is the main form of the plugin.            }
{   Could be open/close in the main menu.           }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{                                                   }
{***************************************************}
unit UChatGPTQuestion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, UChatGPTThread,
  Vcl.Menus, UChatGPTSetting, Vcl.Clipbrd, UChatGPTQFrame, System.Win.Registry;

type
  TFrmChatGPT = class(TForm)
    Fram_Question: TFram_Question;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure SaveLastQuestion;
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
    tsWriteSonicAnswer.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableWriteSonic);
    tsYouChat.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableYouChat);
    mmoQuestion.Lines.Clear;
    mmoQuestion.Lines.Add(TSingletonSettingObj.Instance.MainFormLastQuestion);
    Cs.Leave;
    ActivityIndicator1.Visible := False;
    FreeAndNil(pgcMain);
  end;
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
      if LvRegKey.OpenKey('\SOFTWARE\ChatGPTWizard', True) then
        LvRegKey.WriteString('ChatGPTMainFormLastQuestion', Fram_Question.mmoQuestion.text);
    finally
      LvRegKey.Free;
    end;
  except
  end;
end;

end.
