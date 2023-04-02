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
  Vcl.Menus, UChatGPTSetting, Vcl.Clipbrd, UChatGPTQFrame;

type
  TFrmChatGPT = class(TForm)
    Fram_Question: TFram_Question;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  FrmChatGPT: TFrmChatGPT;

implementation

{$R *.dfm}

procedure TFrmChatGPT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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
    Cs.Leave;
    FreeAndNil(pgcMain);
  end;
end;

end.
