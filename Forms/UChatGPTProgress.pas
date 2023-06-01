{***************************************************}
{                                                   }
{   This unit contains a progressbar that           }
{   will be used in inline processes.               }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UChatGPTProgress;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Winapi.Messages, UChatGPTThread, Vcl.Buttons, UChatGPTSetting, UConsts;

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
  LvMaxToken: Integer;
  LvTemperature: Integer;

  LvIsProxyActive: Boolean;
  LvProxyHost: string;
  LvProxyPort: Integer;
  LvProxyUsername: string;
  LvProxyPassword: string;
  LvTimeOut: Integer;
  LvSetting: TSingletonSettingObj;
begin
  Cs.Enter;
  LvSetting := TSingletonSettingObj.Instance;
  LvApiKey := LvSetting.ApiKey;
  LvUrl := LvSetting.URL;
  LvModel := LvSetting.Model;
  LvMaxToken := LvSetting.MaxToken;
  LvTemperature := LvSetting.Temperature;

  LvIsProxyActive :=  LvSetting.ProxySetting.Active;
  LvProxyHost := LvSetting.ProxySetting.ProxyHost;
  LvProxyPort := LvSetting.ProxySetting.ProxyPort;
  LvProxyUsername := LvSetting.ProxySetting.ProxyUsername;
  LvProxyPassword := LvSetting.ProxySetting.ProxyPassword;
  LvTimeOut := LvSetting.TimeOut;
  Cs.Leave;

  FTrd := TExecutorTrd.Create(Self.Handle, LvApiKey, LvModel, SelectedText, LvUrl, LvMaxToken, LvTemperature,
                              LvIsProxyActive, LvProxyHost, LvProxyPort, LvProxyUsername, LvProxyPassword, False, LvTimeOut);
  FTrd.Start;
end;

procedure TFrm_Progress.OnProgressMessage(var Msg: TMessage);
begin
  if Msg.WParam = 0 then
    Close;
end;

procedure TFrm_Progress.OnUpdateMessage(var Msg: TMessage);
begin
  Answer.Add(string(Msg.WParam));
  HasError := Msg.LParam = 3;
end;

end.
