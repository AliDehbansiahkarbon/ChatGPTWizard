{********************************************}
{                                            }
{   This is the main form of the plugin.     }
{   Could be open/close in the main menu.    }
{                                            }
{********************************************}
unit UChatGPTQuestion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, UChatGPTThread,
  Vcl.Menus, UChatGPTSetting, Vcl.Clipbrd, UChatGPTQFrame;

type
  TFrmChatGPT = class(TForm)
    Fram_Question1: TFram_Question;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

var
  FrmChatGPT: TFrmChatGPT;

implementation

{$R *.dfm}

procedure TFrmChatGPT.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
  begin
    Fram_Question1.TerminateThred;
    Close;
  end;
end;

end.
