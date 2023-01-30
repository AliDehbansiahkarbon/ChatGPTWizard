unit USetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Win.Registry, System.SyncObjs;

const
  DefaultURL = 'https://api.openai.com/v1/completions';
  DefaultModel = 'text-davinci-003';
  DefaultMaxToken = 2048;
  DefaultTemperature = 0;
  DefaultIdentifier = 'cpt';

type
  // Note: This class is thread-safe, since accessing the class variable is done in a critical section!
  TSingletonSettingObj = class(TObject)
  private
    FApiKey: string;
    FURL: string;
    FModel: string;
    FMaxToken: Integer;
    FTemperature: Integer;
    FIdentifier: string;
    class var FInstance: TSingletonSettingObj;
    class function GetInstance: TSingletonSettingObj; static;
    procedure LoadDefaults;
    constructor Create;
  public
    procedure ReadRegistry;
    procedure WriteToRegistry;
    function GetSetting: string;

    class property Instance: TSingletonSettingObj read GetInstance;
    property ApiKey: string read FApiKey write FApiKey;
    property URL: string read FURL write FURL;
    property Model: string read FModel write FModel;
    property MaxToken: Integer read FMaxToken write FMaxToken;
    property Temperature: Integer read FTemperature write FTemperature;
    property Identifier: string read FIdentifier write FIdentifier;
  end;

  TFrm_Setting = class(TForm)
    pnl1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edt_Url: TEdit;
    Edt_ApiKey: TEdit;
    Edt_MaxToken: TEdit;
    Edt_Temperature: TEdit;
    cbbModel: TComboBox;
    Btn_Save: TButton;
    Btn_Default: TButton;
    Lbl_SourceIdentifier: TLabel;
    Edt_SourceIdentifier: TEdit;
    procedure Btn_SaveClick(Sender: TObject);
    procedure Btn_DefaultClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Setting: TFrm_Setting;
  Cs: TCriticalSection;
implementation

{$R *.dfm}

{ TSingletonSettingObj }

constructor TSingletonSettingObj.Create;
begin
  inherited;
  FApiKey := '';
  FURL := DefaultURL;
  FModel:= DefaultModel;
  FMaxToken:= DefaultMaxToken;
  FTemperature := DefaultTemperature;
  FIdentifier := DefaultIdentifier;
end;

class function TSingletonSettingObj.GetInstance: TSingletonSettingObj;
begin
  if not Assigned(FInstance) then
    FInstance := TSingletonSettingObj.Create;
  Result := FInstance;
end;

function TSingletonSettingObj.GetSetting: string;
begin
  Result := EmptyStr;
  ShowMessage('You need an API key, please fill the setting parameters.');
  Frm_Setting := TFrm_Setting.Create(nil);
  try
    Frm_Setting.ShowModal;
  finally
    FreeAndNil(Frm_Setting);
  end;
  Result := TSingletonSettingObj.Instance.ApiKey;
end;

procedure TSingletonSettingObj.LoadDefaults;
begin
  FApiKey := '';
  FURL := DefaultURL;
  FModel := DefaultModel;
  FMaxToken := DefaultMaxToken;
  FTemperature := DefaultTemperature;
  FIdentifier := 'cpt';
end;

procedure TSingletonSettingObj.ReadRegistry;
var
  LvRegKey: TRegistry;
begin
  FApiKey := '';

  LvRegKey := TRegistry.Create;
  try
    try
      with LvRegKey do
      begin
        CloseKey;
        RootKey := HKEY_CURRENT_USER;

        if OpenKey('\SOFTWARE\ChatGPTWizard', False) then
        begin
          FApiKey := ReadString('ChatGPTApiKey');
          FURL := ReadString('ChatGPTURL');
          if FURL.Trim.IsEmpty then
            FURL := DefaultURL;

          FModel := ReadString('ChatGPTModel');
          if FModel.Trim.IsEmpty then
            FModel := DefaultModel;

          FMaxToken := ReadInteger('ChatGPTMaxToken');
          if FMaxToken <= 0 then
            FMaxToken := DefaultMaxToken;

          FTemperature := ReadInteger('ChatGPTTemperature');
          if FTemperature <=-1 then
            FTemperature := DefaultTemperature;

          FIdentifier := ReadString('ChatGPTSourceIdentifier');
          if FIdentifier.Trim.IsEmpty then
            FIdentifier := DefaultIdentifier;
        end;
      end;
    except
      LoadDefaults;
    end;
  finally
    LvRegKey.Free;
  end;
end;

procedure TSingletonSettingObj.WriteToRegistry;
var
  LvRegKey: TRegistry;
begin
  LvRegKey := TRegistry.Create;
  try
    with LvRegKey do
    begin
      CloseKey;
      RootKey := HKEY_CURRENT_USER;
      if OpenKey('\SOFTWARE\ChatGPTWizard', True) then
      begin
        WriteString('ChatGPTApiKey', FApiKey);
        WriteString('ChatGPTURL', FURL);
        WriteString('ChatGPTModel', FModel);
        WriteInteger('ChatGPTMaxToken', FMaxToken);
        WriteInteger('ChatGPTTemperature', FTemperature);
        WriteString('ChatGPTSourceIdentifier', FIdentifier);
      end;
    end;
  finally
    LvRegKey.Free;
  end;
end;

procedure TFrm_Setting.Btn_DefaultClick(Sender: TObject);
begin
  Edt_ApiKey.Text := '';
  Edt_Url.Text := DefaultURL;
  cbbModel.ItemIndex := 0;
  Edt_MaxToken.Text := IntToStr(DefaultMaxToken);
  Edt_Temperature.Text := IntToStr(DefaultTemperature);
end;

procedure TFrm_Setting.Btn_SaveClick(Sender: TObject);
var
  LvSettingObj: TSingletonSettingObj;
begin
  LvSettingObj := TSingletonSettingObj.Instance;
  LvSettingObj.ApiKey := Trim(Edt_ApiKey.Text);
  LvSettingObj.URL := Trim(Edt_Url.Text);
  LvSettingObj.Model := Trim(cbbModel.Text);
  LvSettingObj.MaxToken := StrToInt(Edt_MaxToken.Text);
  LvSettingObj.Temperature := StrToInt(Edt_Temperature.Text);
  LvSettingObj.WriteToRegistry;
  Close;
end;

initialization
  Cs := TCriticalSection.Create;
finalization
  Cs.Free;
end.
