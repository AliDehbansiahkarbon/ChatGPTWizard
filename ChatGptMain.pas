unit ChatGptMain;

interface
uses
  System.Classes, System.SysUtils, Vcl.Menus, Vcl.Dialogs, ToolsAPI,
  System.Win.Registry, Winapi.Windows;

type
  TChatGptMenuWizard = class(TInterfacedObject, IOTAWizard)
  private
    FRoot, FAskMenu: TMenuItem;
    FApiKey: string;
    procedure AskMenuClick(Sender: TObject);
    procedure ReadRegistry;
    procedure WriteToRegistry(AApiKey: string);
  protected
    { protected declarations }
  public
    constructor Create;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState; { Launch the AddIn }
    procedure Execute;
    procedure AfterSave; { This function is called immediately before the item is saved. This is not called for IOTAWizard }
    procedure BeforeSave;
    procedure Destroyed; { The associated item is being destroyed so all references should be dropped.Exceptions are ignored. }
    procedure Modified; { This associated item was modified in some way. This is not called for IOTAWizards }
  end;

  const
    WizardFail = -1;
  var
    FIndexWizard : Integer = WizardFail;

  procedure register;

implementation

uses
  QuestionUnit;

procedure register;
begin
  (BorlandIDEServices as IOTAWizardServices).AddWizard(TChatGptMenuWizard.Create)
end;

{ TChatGptMenuWizard }

constructor TChatGptMenuWizard.Create;
var
  LvMainMenu: TMainMenu;
begin
  if not Assigned(FAskMenu) then
  begin
    FAskMenu := TMenuItem.Create(nil);
    FAskMenu.Name := 'Mnu_ChatGPT';
    FAskMenu.Caption := 'Ask ChatGPT';
    FAskMenu.OnClick := AskMenuClick;
    FAskMenu.ImageIndex := 1;
  end;

  if not Assigned(FRoot) then
  begin
    FRoot := TMenuItem.Create(nil);
    FRoot.Caption := 'ChatGPT';
    FRoot.Name := 'ChatGPTRootMenu';
    FRoot.Add(FAskMenu);
  end;

  if not Assigned((BorlandIDEServices as INTAServices).MainMenu.Items.Find('ChatGPTRootMenu')) then
  begin
    LvMainMenu := (BorlandIDEServices as INTAServices).MainMenu;
    LvMainMenu.Items.Insert(LvMainMenu.Items.Count - 1, FRoot);
  end;
  ReadRegistry;
end;

procedure TChatGptMenuWizard.AfterSave;
begin
//Do noting yet, its created by interface force!
end;

procedure TChatGptMenuWizard.AskMenuClick(Sender: TObject);
begin
  ReadRegistry;
  if FApiKey = '' then
  begin
    FApiKey := Trim(InputBox('You need an API key', 'Your key', ''));
    if FApiKey <> '' then
      WriteToRegistry(FApiKey)
    else
      Exit;
  end;

  if FApiKey <> EmptyStr then
  begin
    FrmChatGPT := TFrmChatGPT.Create(nil);
    FrmChatGPT.ApiKey := FApiKey;
    try
      FrmChatGPT.ShowModal;
    finally
      FreeAndNil(FrmChatGPT);
    end;
  end;
end;

procedure TChatGptMenuWizard.BeforeSave;
begin
//Do noting yet, its created by interface force!
end;

procedure TChatGptMenuWizard.Destroyed;
begin
  if Assigned(FAskMenu) then
    FreeAndNil(FAskMenu);

  if Assigned(FRoot) then
    FreeAndNil(FRoot);
end;

procedure TChatGptMenuWizard.Execute;
begin
//Do noting yet, its created by interface force!
end;

function TChatGptMenuWizard.GetIDString: string;
begin
  Result := 'ChatGptIDString';
end;

function TChatGptMenuWizard.GetName: string;
begin
  Result := 'ChatGptName';
end;

function TChatGptMenuWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure TChatGptMenuWizard.Modified;
begin
//Do noting yet, its created by interface force!
end;

procedure TChatGptMenuWizard.ReadRegistry;
var
  LvRegKey: TRegistry;
begin
  FApiKey := '';

  LvRegKey := TRegistry.Create;
  try
    with LvRegKey do
    begin
      CloseKey;
      RootKey := HKEY_CURRENT_USER;

      if OpenKey('\SOFTWARE\ChatGPTWizard', False) then
        FApiKey := ReadString('ChatGPTApiKey');
    end;
  finally
    LvRegKey.Free;
  end;
end;

procedure TChatGptMenuWizard.WriteToRegistry(AApiKey: string);
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
        WriteString('ChatGPTApiKey', AApiKey);
    end;
  finally
    LvRegKey.Free;
  end;
end;

initialization

finalization
  if FIndexWizard <> WizardFail then
    (BorlandIDEServices as IOTAWizardServices).RemoveWizard(FIndexWizard);

end.
