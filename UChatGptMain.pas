unit UChatGptMain;

interface
uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.Menus, Vcl.Dialogs, System.Win.Registry,
  Winapi.Windows, {$IFNDEF NEXTGEN}System.StrUtils{$ELSE}AnsiStrings{$ENDIF !NEXTGEN}, ToolsAPI,
  DockForm, System.Generics.Collections, UMenuHook;

type
  TTStringListHelper = class helper for TStringList
    function TrimLineText: string;
  end;

  TChatGPTOnCliskType = procedure(Sender: TObject) of Object;
{*********************************************************}
{                                                         }
{           This menu item will be added                  }
{           into the main menu of the IDE.                }
{                                                         }
{*********************************************************}
  TChatGptMenuWizard = class(TInterfacedObject, IOTAWizard)
  private
    FRoot, FAskMenu: TMenuItem;
    class var FApiKey: string;
    procedure AskMenuClick(Sender: TObject);
    class procedure ReadRegistry;
    class procedure WriteToRegistry(AApiKey: string);
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

{************************************************************************************************}
{                                                                                                }
{   The editor is not immediately available upon startup of the IDE,                             }
{   therefore we can’t get access to the editor in the plugin initialization code.               }
{   What we needed is to register a class that implements the INTAEditServicesNotifier interface.}
{   The IDE calls this interface when the editor is activated in the IDE.                        }
{                                                                                                }
{************************************************************************************************}
  TEditNotifierHelper = class(TNotifierObject, IOTANotifier, INTAEditServicesNotifier)
    procedure OnChatGPTAskSubMenuClick(Sender: TObject);
    procedure OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
  private
    FMenuHook: TCpMenuHook;
    function GetQuestion(AStr: string): string;
  public
    constructor Create;
    destructor Destroy;override;
    procedure WindowShow(const EditWindow: INTAEditWindow; Show, LoadedFromDesktop: Boolean);
    procedure WindowNotification(const EditWindow: INTAEditWindow; Operation: TOperation);
    procedure WindowActivated(const EditWindow: INTAEditWindow);
    procedure WindowCommand(const EditWindow: INTAEditWindow; Command, Param: Integer; var Handled: Boolean);
    procedure EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
    procedure EditorViewModified(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
    procedure DockFormVisibleChanged(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure DockFormUpdated(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure DockFormRefresh(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure CnAddEditorContextMenu;
    function AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string): TMenuItem;
  end;

  const
    WizardFail = -1;
    LeftIdentifier = 'cpt:';
    RightIdentifier = ':cpt';

  var
    FMainMenuIndex: Integer = WizardFail;
    FNotifierIndex: Integer = WizardFail;
    FChatGPTSubMenu: TCpMenuItemDef;
    FkeyWords: TList<string>;

    procedure RemoveAferUnInstall;
    procedure FillFkeyWords;
    procedure register;

implementation

uses
  UQuestion, UProgress;

procedure register;
begin
  FMainMenuIndex := (BorlandIDEServices as IOTAWizardServices).AddWizard(TChatGptMenuWizard.Create);
  FNotifierIndex := (BorlandIDEServices as IOTAEditorServices).AddNotifier(TEditNotifierHelper.Create);
end;

procedure RemoveAferUnInstall;
begin
  if FMainMenuIndex <> WizardFail then
    (BorlandIDEServices as IOTAWizardServices).RemoveWizard(FMainMenuIndex);

  if FNotifierIndex <> WizardFail then
    (BorlandIDEServices as IOTAEditorServices).RemoveNotifier(FNotifierIndex);
end;

procedure FillFkeyWords;
begin
  FkeyWords := TList<string>.Create;
  FkeyWords.Add('unit');
  FkeyWords.Add('interface');
  FkeyWords.Add('uses');
  FkeyWords.Add('type');
  FkeyWords.Add('private');
  FkeyWords.Add('protected');
  FkeyWords.Add('public');
  FkeyWords.Add('published');
  FkeyWords.Add('implementation');
  FkeyWords.Add('var');
  FkeyWords.Add('begin');
  FkeyWords.Add('end;');
  FkeyWords.Add('initialization');
  FkeyWords.Add('finalization');
  FkeyWords.Add('end.');
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
    FAskMenu.ShortCut := TextToShortCut('Ctrl+Alt+Shift+C');
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

class procedure TChatGptMenuWizard.ReadRegistry;
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

class procedure TChatGptMenuWizard.WriteToRegistry(AApiKey: string);
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

{ TEditNotifierHelper }

function TEditNotifierHelper.AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string): TMenuItem;
var
  LvItem: TMenuItem;
begin
  LvItem := TMenuItem.Create(nil);
  LvItem.Name := AName;
  LvItem.Caption := ACaption;
  LvItem.OnClick := AOnClick;
  LvItem.ShortCut := TextToShortCut(AShortCut);
  AParentMenu.Add(LvItem);
  Result := LvItem;
end;

procedure TEditNotifierHelper.OnChatGPTAskSubMenuClick(Sender: TObject);
var
  LvEditView: IOTAEditView;
  LvEditBlock: IOTAEditBlock;
  LvSelectedText: string;
begin
  TChatGptMenuWizard.ReadRegistry; //Class method!
  if TChatGptMenuWizard.FApiKey = '' then
  begin
    TChatGptMenuWizard.FApiKey := Trim(InputBox('You need an API key', 'Your key', ''));
    if TChatGptMenuWizard.FApiKey <> '' then
      TChatGptMenuWizard.WriteToRegistry(TChatGptMenuWizard.FApiKey) // Class method!
    else
      Exit;
  end;

  LvEditView := (BorlandIDEServices as IOTAEditorServices).TopView;

  // Get the selected text in the edit view
  LvEditBlock := LvEditView.GetBlock;

  // If there is a selection of text, get it via editblock.Text
  if (LvEditBlock.StartingColumn <> LvEditBlock.EndingColumn) or (LvEditBlock.StartingRow <> LvEditBlock.EndingRow) then
  begin
    LvSelectedText := LvEditBlock.Text;

    //If it is a ChatGPT question
    if (SameStr(LeftStr(LvSelectedText, 4).ToLower, LeftIdentifier)) and (SameStr(RightStr(LvSelectedText, 4).ToLower, RightIdentifier)) then
    begin
      if TChatGptMenuWizard.FApiKey <> EmptyStr then
      begin
        Frm_Progress := TFrm_Progress.Create(nil);
        Frm_Progress.ApiKey := TChatGptMenuWizard.FApiKey;
        frm_Progress.SelectedText := GetQuestion(LvEditBlock.Text);
        try
          Frm_Progress.ShowModal;
          LvEditView.Buffer.EditPosition.InsertText(Frm_Progress.Answer.TrimLineText);
        finally
          FreeAndNil(Frm_Progress);
        end;
      end;
    end;
  end
  else
  begin
    ShowMessage('There is no selected text with the ChatGPT Plug-in''s desired format, check the below sample' + #13
                + #13 + LeftIdentifier + ' Any Question! ' + RightIdentifier);
  end;
end;

procedure TEditNotifierHelper.OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
begin
  if not Assigned(MenuItem.Find('Ask')) then
    AddMenuItem(MenuItem, 'ChatGPTAskSubMenu', 'Ask', OnChatGPTAskSubMenuClick, 'CTRL+ALT+SHIFT+A');
end;

procedure TEditNotifierHelper.CnAddEditorContextMenu;
var
  FEditorPopUpMenu: TPopupMenu;
begin
  FEditorPopUpMenu := TPopupMenu((BorlandIDEServices as IOTAEditorServices).TopView.GetEditWindow.Form.FindComponent('EditorLocalMenu'));
  FMenuHook.HookMenu(FEditorPopUpMenu);
  if FMenuHook.IsHooked(FEditorPopUpMenu) then
  begin
    FChatGPTSubMenu := TCpMenuItemDef.Create('ChatGPTSubMenu', 'ChatGPT SubMenu', nil, ipAfter, 'ChatGPTSubMenu');
    FChatGPTSubMenu.OnCreated := OnChatGPTSubMenuClick;
    FMenuHook.AddMenuItemDef(FChatGPTSubMenu);
  end;
end;

constructor TEditNotifierHelper.Create;
begin
  inherited Create;
  FMenuHook := TCpMenuHook.Create(nil);
end;

destructor TEditNotifierHelper.Destroy;
begin
  FMenuHook.Free;
  inherited;
end;

procedure TEditNotifierHelper.DockFormRefresh(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
begin
end;

procedure TEditNotifierHelper.DockFormUpdated(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
begin
end;

procedure TEditNotifierHelper.DockFormVisibleChanged(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
begin
end;

procedure TEditNotifierHelper.EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
begin
  if not Assigned(FChatGPTSubMenu) then
    //AddEditorContextMenu;
    CnAddEditorContextMenu;
end;

procedure TEditNotifierHelper.EditorViewModified(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
begin
end;

function TEditNotifierHelper.GetQuestion(AStr: string): string;
var
  LvTmpStr: string;
begin
  LvTmpStr := AStr.Trim;
  if LeftStr(AStr, 2) = '//' then
    LvTmpStr := RightStr(AStr.Trim, AStr.Length - 2);

  LvTmpStr := RightStr(AStr.Trim, AStr.Length - 4);
  Result := LeftStr(LvTmpStr, LvTmpStr.Length - 4);
end;

procedure TEditNotifierHelper.WindowActivated(const EditWindow: INTAEditWindow);
begin
end;

procedure TEditNotifierHelper.WindowCommand(const EditWindow: INTAEditWindow; Command, Param: Integer; var Handled: Boolean);
begin
end;

procedure TEditNotifierHelper.WindowNotification(const EditWindow: INTAEditWindow; Operation: TOperation);
begin
end;

procedure TEditNotifierHelper.WindowShow(const EditWindow: INTAEditWindow; Show, LoadedFromDesktop: Boolean);
begin
end;

{ TTStringListHelper }

function TTStringListHelper.TrimLineText: string;
var
  I: Integer;
begin
  for I := 0 to Pred(Self.Count) do
  begin
    Self[I] := Trim(Self[I]);
//
//    if not ((FkeyWords.Contains(Self[I])) or (LeftStr(Self[I], 9).ToLower = 'function ') or (LeftStr(Self[I], 10).ToLower = 'procedure ')) then
//      Self[I] := '  ' + Self[I];
  end;
  Result := Self.Text;
end;

initialization
  FChatGPTSubMenu := nil;
  FillFkeyWords;

finalization
  FkeyWords.Free;
  RemoveAferUnInstall;
end.

