{********************************************}
{                                            }
{   This is the setting form of the plugin.  }
{   Could be found in the main menu.         }
{                                            }
{********************************************}
unit UChatGPTSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Win.Registry, System.SyncObjs,
  ToolsAPI, System.StrUtils, System.Generics.Collections;

const
  DefaultURL = 'https://api.openai.com/v1/completions';
  DefaultModel = 'text-davinci-003';
  DefaultMaxToken = 2048;
  DefaultTemperature = 0;
  DefaultIdentifier = 'cpt';
  DefaultCodeFormatter = False;
  DefaultRTL = False;

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
    FCodeFormatter: Boolean;
    FRightToLeft: Boolean;

    class var FInstance: TSingletonSettingObj;
    class function GetInstance: TSingletonSettingObj; static;
    procedure LoadDefaults;
    constructor Create;
    function GetLeftIdentifier: string;
    function GetRightIdentifier: string;
  public
    procedure ReadRegistry;
    procedure WriteToRegistry;
    function GetSetting: string;
    Class Procedure RegisterFormClassForTheming(Const AFormClass : TCustomFormClass; Const Component : TComponent = Nil);

    class property Instance: TSingletonSettingObj read GetInstance;
    property ApiKey: string read FApiKey write FApiKey;
    property URL: string read FURL write FURL;
    property Model: string read FModel write FModel;
    property MaxToken: Integer read FMaxToken write FMaxToken;
    property Temperature: Integer read FTemperature write FTemperature;
    property CodeFormatter: Boolean read FCodeFormatter write FCodeFormatter;
    property Identifier: string read FIdentifier write FIdentifier;
    property LeftIdentifier: string read GetLeftIdentifier;
    property RightIdentifier: string read GetRightIdentifier;
    property RighToLeft: Boolean read FRightToLeft write FRightToLeft;
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
    chk_CodeFormatter: TCheckBox;
    chk_Rtl: TCheckBox;
    procedure Btn_SaveClick(Sender: TObject);
    procedure Btn_DefaultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
  LoadDefaults;
end;

class function TSingletonSettingObj.GetInstance: TSingletonSettingObj;
begin
  if not Assigned(FInstance) then
    FInstance := TSingletonSettingObj.Create;
  Result := FInstance;
end;

function TSingletonSettingObj.GetLeftIdentifier: string;
begin
  Result := FIdentifier + ':';
end;

function TSingletonSettingObj.GetRightIdentifier: string;
begin
  Result := ':' + FIdentifier;
end;

function TSingletonSettingObj.GetSetting: string;
begin
  Result := EmptyStr;
  ShowMessage('You need an API key, please fill the setting parameters in setting form.');
  Frm_Setting := TFrm_Setting.Create(nil);
  try
    TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Setting, Frm_Setting); //Apply Theme
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
  FIdentifier := DefaultIdentifier;
  FCodeFormatter := DefaultCodeFormatter;
  FRightToLeft := DefaultRTL;
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
          if ValueExists('ChatGPTApiKey') then
            FApiKey := ReadString('ChatGPTApiKey');
            
          if ValueExists('ChatGPTURL') then
            FURL := IfThen(ReadString('ChatGPTURL').IsEmpty, DefaultURL, ReadString('ChatGPTURL'))
          else
            FURL := DefaultURL;           

          if ValueExists('ChatGPTModel') then
            FModel := IfThen(ReadString('ChatGPTModel').IsEmpty, DefaultModel, ReadString('ChatGPTModel'))
          else
            FModel := DefaultModel;

          if ValueExists('ChatGPTMaxToken') then
          begin
            FMaxToken := ReadInteger('ChatGPTMaxToken');
            if FMaxToken <= 0 then
              FMaxToken := DefaultMaxToken;
          end
          else
            FMaxToken := DefaultMaxToken;          

          if ValueExists('ChatGPTTemperature') then
          begin
            FTemperature := ReadInteger('ChatGPTTemperature');
            if FTemperature <=-1 then
              FTemperature := DefaultTemperature;
          end
          else
            FTemperature := DefaultTemperature;

          if ValueExists('ChatGPTSourceIdentifier') then
            FIdentifier := IfThen(ReadString('ChatGPTSourceIdentifier').IsEmpty, DefaultIdentifier, ReadString('ChatGPTSourceIdentifier'))
          else
            FIdentifier := DefaultIdentifier;              

          if ValueExists('ChatGPTCodeFormatter') then
            FCodeFormatter := ReadBool('ChatGPTCodeFormatter')
          else
            FCodeFormatter := DefaultCodeFormatter;

          if ValueExists('ChatGPTRTL') then
            FRightToLeft := ReadBool('ChatGPTRTL')
          else
            FRightToLeft := DefaultRTL;
        end;
      end;
    except
      LoadDefaults;
    end;
  finally
    LvRegKey.Free;
  end;
end;

class procedure TSingletonSettingObj.RegisterFormClassForTheming(const AFormClass: TCustomFormClass; const Component: TComponent);
{$IF CompilerVersion >= 32.0}
Var
  {$IF CompilerVersion > 32.0} // Breaking change to the Open Tools API - They fixed the wrongly defined interface
    ITS : IOTAIDEThemingServices;
  {$ELSE}
    ITS : IOTAIDEThemingServices250;
  {$IFEND}
{$IFEND}
begin
  {$IF CompilerVersion >= 32.0}
  {$IF CompilerVersion > 32.0}
    If Supports(BorlandIDEServices, IOTAIDEThemingServices, ITS) Then
  {$ELSE}
    If Supports(BorlandIDEServices, IOTAIDEThemingServices250, ITS) Then
  {$IFEND}
    If ITS.IDEThemingEnabled Then
    begin
      ITS.RegisterFormClass(AFormClass);
      If Assigned(Component) Then
        ITS.ApplyTheme(Component);
    end;
  {$IFEND}
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
        WriteBool('ChatGPTCodeFormatter', FCodeFormatter);
        WriteBool('ChatGPTRTL', FRightToLeft);
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
  chk_CodeFormatter.Checked := DefaultCodeFormatter;
  chk_Rtl.Checked := DefaultRTL;
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
  LvSettingObj.RighToLeft := chk_Rtl.Checked;
  LvSettingObj.CodeFormatter := chk_CodeFormatter.Checked;
  LvSettingObj.Identifier := Edt_SourceIdentifier.Text;

  LvSettingObj.WriteToRegistry;
  Close;
end;

procedure TFrm_Setting.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(key) = 27 then
    Close;
end;

initialization
  Cs := TCriticalSection.Create;
finalization
  Cs.Free;
end.
