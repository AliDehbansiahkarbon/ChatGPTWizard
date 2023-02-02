{********************************************}
{                                            }
{   This unit contains a progressbar that    }
{    will be used in inline processes.       }
{                                            }
{********************************************}
unit UChatGPTProgress;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Winapi.Messages, UChatGPTThread, Vcl.Buttons, UChatGPTSetting;

type
  TFrm_Progress = class(TForm)
    pnlContainer: TPanel;
    ProgressBar: TProgressBar;
    Lbl_Top: TLabel;
    btnClose: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FTrd: TExecutorTrd;
    { Private declarations }
  public
    SelectedText: string;
    HasError: Boolean;
    Answer: TStringList;
    procedure OnUpdateMessage(var Msg: TMessage); message WM_UPDATE_MESSAGE;
    procedure OnProgressMessage(var Msg: TMessage); message WM_PROGRESS_MESSAGE;
  end;

var
  Frm_Progress: TFrm_Progress;

implementation

{$R *.dfm}

procedure TFrm_Progress.btnCloseClick(Sender: TObject);
begin
  FTrd.Terminate;
  Close;
end;

procedure TFrm_Progress.FormCreate(Sender: TObject);
begin
  Answer := TStringList.Create;
  HasError := False;
end;

procedure TFrm_Progress.FormDestroy(Sender: TObject);
begin
  Answer.Free;
end;

procedure TFrm_Progress.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
    btnClose.Click;
end;

procedure TFrm_Progress.FormShow(Sender: TObject);
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

  FTrd := TExecutorTrd.Create(Self.Handle, LvApiKey, LvModel, SelectedText, LvUrl);
  FTrd.Start;
end;

procedure TFrm_Progress.OnProgressMessage(var Msg: TMessage);
begin
  if Msg.WParam = 0 then
    Close;
end;

procedure TFrm_Progress.OnUpdateMessage(var Msg: TMessage);
begin
  Answer.Text := string(Msg.WParam);
  HasError := Msg.LParam = 1;
end;

end.
