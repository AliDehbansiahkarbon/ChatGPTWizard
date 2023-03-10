{***************************************************}
{                                                   }
{   This unit is the main unit of the package       }
{   including register function.                    }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{                                                   }
{***************************************************}
unit UChatGptMain;

interface
uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.Menus, Vcl.Dialogs, Winapi.Windows,
  {$IFNDEF NEXTGEN}System.StrUtils{$ELSE}AnsiStrings{$ENDIF !NEXTGEN}, ToolsAPI, StructureViewAPI,
  DockForm, System.Generics.Collections, Vcl.Forms, System.IOUtils,
  UChatGPTMenuHook, UChatGPTSetting, UChatGPTQFrame, UChatGPTQuestion;

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
    FRoot, FAskMenu,
    FSettingMenu, FAskMenuDockable: TMenuItem;
    FAskSubmenuHidden: TMenuItem;
    FSetting: TSingletonSettingObj;
    
    procedure AskMenuClick(Sender: TObject);
    procedure ChatGPTDockableMenuClick(Sender: TObject);
    procedure ChatGPTSettingMenuClick(Sender: TObject);
    procedure AskSubmenuHiddenOnClick(Sender: TObject);
    procedure RenewUI(AForm: TCustomForm);
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
    class function GetQuestion(AStr: string): string;
    class function CreateMsg: string;
    class procedure FormatSource;
    function GetCurrentUnitPath: string;
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
    procedure AddEditorContextMenu;
    function AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string): TMenuItem;
  end;

{*******************************************************}
{                                                       }
{   This is a dockable form of the plugin.              }
{   It is a singleton class which means there will      }
{   be just one instance as long as the IDE is alive!   }
{   Could be activate/deactive in main menu.            }
{                                                       }
{*******************************************************}
  TChatGPTDockForm = class(TDockableForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
    FDockFormClassListObj: TClassList;
    Fram_Question: TFram_Question;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  end;

  const
    WizardFail = -1;

  var
    FMainMenuIndex: Integer = WizardFail;
    FNotifierIndex: Integer = WizardFail;
    FChatGPTSubMenu: TCpMenuItemDef;
    FChatGPTDockForm: TChatGPTDockForm;

    procedure RemoveAferUnInstall;
    procedure register;

implementation

uses
  UChatGPTProgress;

procedure register;
begin
  FMainMenuIndex := (BorlandIDEServices as IOTAWizardServices).AddWizard(TChatGptMenuWizard.Create);
  FNotifierIndex := (BorlandIDEServices as IOTAEditorServices).AddNotifier(TEditNotifierHelper.Create);
end;

procedure RemoveAferUnInstall;
var
  LvRootMenu: TMainMenu;
begin
  if Assigned(FChatGPTDockForm) then
  begin
    FChatGPTDockForm.Close;
    FreeAndNil(FChatGPTDockForm);
  end;

  LvRootMenu := (BorlandIDEServices as INTAServices).MainMenu;
  LvRootMenu.Items.Delete(TSingletonSettingObj.Instance.RootMenuIndex);

  if FMainMenuIndex <> WizardFail then
    (BorlandIDEServices as IOTAWizardServices).RemoveWizard(FMainMenuIndex);

  if FNotifierIndex <> WizardFail then
    (BorlandIDEServices as IOTAEditorServices).RemoveNotifier(FNotifierIndex);
end;

{ TChatGptMenuWizard }
procedure TChatGptMenuWizard.ChatGPTDockableMenuClick(Sender: TObject);
var
  LvSettingObj: TSingletonSettingObj;
begin
  LvSettingObj := TSingletonSettingObj.Instance;
  LvSettingObj.ReadRegistry;
  if LvSettingObj.ApiKey = '' then
  begin
    if LvSettingObj.GetSetting.Trim.IsEmpty then
      Exit;
  end;

  if not Assigned(FChatGPTDockForm) then
    FChatGPTDockForm := TChatGPTDockForm.Create(Application);

  TSingletonSettingObj.RegisterFormClassForTheming(TChatGPTDockForm, FChatGPTDockForm); //Apply Theme
  RenewUI(FChatGPTDockForm);
  FChatGPTDockForm.Show;
end;

procedure TChatGptMenuWizard.ChatGPTSettingMenuClick(Sender: TObject);
begin
  FSetting := TSingletonSettingObj.Instance;
  FSetting.ReadRegistry;
  Frm_Setting := TFrm_Setting.Create(nil);
  try
    TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Setting, Frm_Setting); //Apply Theme
    Frm_Setting.Edt_ApiKey.Text := FSetting.ApiKey;
    Frm_Setting.Edt_Url.Text := FSetting.URL;
    Frm_Setting.Edt_MaxToken.Text := FSetting.MaxToken.ToString;
    Frm_Setting.Edt_Temperature.Text := FSetting.Temperature.ToString;
    Frm_Setting.cbbModel.ItemIndex := Frm_Setting.cbbModel.Items.IndexOf(FSetting.Model);
    Frm_Setting.Edt_SourceIdentifier.Text := FSetting.Identifier;
    Frm_Setting.chk_CodeFormatter.Checked := FSetting.CodeFormatter;
    Frm_Setting.chk_Rtl.Checked := FSetting.RighToLeft;
    Frm_Setting.chk_History.Checked := FSetting.HistoryEnabled;
    Frm_Setting.lbEdt_History.Text := FSetting.HistoryPath;
    Frm_Setting.lbEdt_History.Enabled := FSetting.HistoryEnabled;
    Frm_Setting.Btn_HistoryPathBuilder.Enabled := FSetting.HistoryEnabled;
    Frm_Setting.ColorBox_Highlight.Selected := FSetting.HighlightColor;
    Frm_Setting.chk_AnimatedLetters.Checked := FSetting.AnimatedLetters;
    Frm_Setting.AddAllDefinedQuestions;

    Frm_Setting.ShowModal;
    if Frm_Setting.HasChanges then
      RenewUI(FChatGPTDockForm);
  finally
    Frm_Setting.Free;
    FSetting.ReadRegistry; // In case something changed in setting that must reload.
  end;
end;

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

  if not Assigned(FSettingMenu) then
  begin
    FSettingMenu := TMenuItem.Create(nil);
    FSettingMenu.Name := 'Mnu_ChatGPTSetting';
    FSettingMenu.Caption := 'ChatGPT Setting';
    FSettingMenu.OnClick := ChatGPTSettingMenuClick;
    FSettingMenu.ImageIndex := 36;
  end;

  if not Assigned(FAskSubmenuHidden) then
  begin
    FAskSubmenuHidden := TMenuItem.Create(nil);
    FAskSubmenuHidden.ShortCut := TextToShortCut('Ctrl+Alt+Shift+A');
    FAskSubmenuHidden.OnClick := AskSubmenuHiddenOnClick;
    FAskSubmenuHidden.Visible := False;
  end;

  if not Assigned(FAskMenuDockable) then
  begin
    FAskMenuDockable := TMenuItem.Create(nil);
    FAskMenuDockable.Name := 'Mnu_ChatGPTDockable';
    FAskMenuDockable.Caption := 'ChatGPT Dockabale';
    FAskMenuDockable.OnClick := ChatGPTDockableMenuClick;
    FAskMenuDockable.ImageIndex := 1;
  end;

  if not Assigned(FRoot) then
  begin
    FRoot := TMenuItem.Create(nil);
    FRoot.Caption := 'ChatGPT';
    FRoot.Name := 'ChatGPTRootMenu';
    FRoot.Add(FAskMenu);
    FRoot.Add(FAskMenuDockable);
    FRoot.Add(FSettingMenu);
    FRoot.Add(FAskSubmenuHidden);
  end;

  if not Assigned((BorlandIDEServices as INTAServices).MainMenu.Items.Find('ChatGPTRootMenu')) then
  begin
    LvMainMenu := (BorlandIDEServices as INTAServices).MainMenu;
    LvMainMenu.Items.Insert(LvMainMenu.Items.Count - 1, FRoot);
  end;
  TSingletonSettingObj.Instance.RootMenuIndex := LvMainMenu.Items.IndexOf(FRoot);
  TSingletonSettingObj.Instance.ReadRegistry;
end;

procedure TChatGptMenuWizard.AfterSave;
begin
//Do noting yet, its created by interface force!
end;

procedure TChatGptMenuWizard.AskMenuClick(Sender: TObject);
var
  LvSettingObj: TSingletonSettingObj;
  FrmChatGPTMain: TFrmChatGPT;
begin
  LvSettingObj := TSingletonSettingObj.Instance;
  LvSettingObj.ReadRegistry;

  if LvSettingObj.ApiKey = '' then
  begin
    if LvSettingObj.GetSetting.Trim.IsEmpty then
      Exit;
  end;

  if LvSettingObj.ApiKey <> EmptyStr then
  begin
    FrmChatGPTMain := TFrmChatGPT.Create(Application);
    try
      LvSettingObj.RegisterFormClassForTheming(TFrmChatGPT, FrmChatGPTMain);  //Apply Theme
      RenewUI(FrmChatGPTMain);
      FrmChatGPTMain.ShowModal;
    finally
      FreeAndNil(FrmChatGPTMain);
    end;
  end;
end;

procedure TChatGptMenuWizard.AskSubmenuHiddenOnClick(Sender: TObject);
var
  LvEditView: IOTAEditView;
  LvEditBlock: IOTAEditBlock;
  LvSelectedText: string;
begin
  TSingletonSettingObj.Instance.ReadRegistry;
  if TSingletonSettingObj.Instance.ApiKey = '' then
  begin
    if TSingletonSettingObj.Instance.GetSetting.Trim.IsEmpty then
      Exit;
  end;

  LvEditView := (BorlandIDEServices as IOTAEditorServices).TopView;

  if not Assigned(LvEditView) then
    Exit;

  // Get the selected text in the edit view
  LvEditBlock := LvEditView.GetBlock;

  // If there is a selection of text, get it via editblock.Text
  if (LvEditBlock.StartingColumn <> LvEditBlock.EndingColumn) or (LvEditBlock.StartingRow <> LvEditBlock.EndingRow) then
  begin
    LvSelectedText := LvEditBlock.Text;

    //If it is a ChatGPT question
    if (SameStr(LeftStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.LeftIdentifier)) and (SameStr(RightStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.RightIdentifier)) then
    begin
      if not TSingletonSettingObj.Instance.ApiKey.Trim.IsEmpty then
      begin
        Frm_Progress := TFrm_Progress.Create(nil);
        try
          frm_Progress.SelectedText := TEditNotifierHelper.GetQuestion(LvEditBlock.Text);
          TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Progress, Frm_Progress); //Apply Theme
          Frm_Progress.ShowModal;
          LvEditView.Buffer.EditPosition.InsertText(Frm_Progress.Answer.TrimLineText);
          if not (Frm_Progress.HasError) and (TSingletonSettingObj.Instance.CodeFormatter) then
            TEditNotifierHelper.FormatSource;
        finally
          FreeAndNil(Frm_Progress);
        end;
      end;
    end
    else
      ShowMessage(TEditNotifierHelper.CreateMsg);
  end
  else
    ShowMessage(TEditNotifierHelper.CreateMsg);
end;

procedure TChatGptMenuWizard.BeforeSave;
begin
//Do noting yet, its created by interface force!
end;

procedure TChatGptMenuWizard.Destroyed;
begin
  if Assigned(FAskMenu) then
    FreeAndNil(FAskMenu);

  if Assigned(FAskMenuDockable) then
    FreeAndNil(FAskMenuDockable);

  if Assigned(FSettingMenu) then
    FreeAndNil(FSettingMenu);

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

procedure TChatGptMenuWizard.RenewUI(AForm: TCustomForm);
begin
  if not Assigned(AForm) then
    Exit;

  if TSingletonSettingObj.Instance.RighToLeft then
    AForm.BiDiMode := bdRightToLeft
  else
    AForm.BiDiMode := bdLeftToRight;

  Cs.Enter;
  if AForm.FindChildControl('Fram_Question') <> nil then
  with AForm.FindComponent('Fram_Question') as TFram_Question do
  begin
    Btn_Ask.Enabled := True;
    Align := alClient;
    pgcMain.ActivePageIndex := 0;
    if TSingletonSettingObj.Instance.RighToLeft then
    begin
      Btn_Ask.Left := pnlTop.Width - Btn_Ask.Width - 5;
      Btn_Clipboard.Left := Btn_Ask.Left - Btn_Clipboard.Width - 5;
      Btn_Clear.Left := Btn_Clipboard.Left - Btn_Clear.Width - 5;

      Btn_Ask.Anchors := [TAnchorKind.akTop, TAnchorKind.akRight];
      Btn_Clipboard.Anchors := [TAnchorKind.akTop, TAnchorKind.akRight];
      Btn_Clear.Anchors := [TAnchorKind.akTop, TAnchorKind.akRight];
    end
    else
    begin
      Btn_Ask.Left := 15;
      Btn_Clipboard.Left := Btn_Ask.Left + Btn_Ask.Width + 5;
      Btn_Clear.Left := Btn_Clipboard.Left + Btn_Clipboard.Width + 5;

      Btn_Ask.Anchors := [TAnchorKind.akTop, TAnchorKind.akLeft];
      Btn_Clipboard.Anchors := [TAnchorKind.akTop, TAnchorKind.akLeft];
      Btn_Clear.Anchors := [TAnchorKind.akTop, TAnchorKind.akLeft];
    end;
  end;
  Cs.Leave;
end;

{ TEditNotifierHelper }

function TEditNotifierHelper.AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string): TMenuItem;
var
  LvItem: TMenuItem;
begin
  LvItem := TMenuItem.Create(nil);
  LvItem.Name := AName;
  LvItem.Caption := ACaption + '  ' + AShortCut;
  LvItem.OnClick := AOnClick;
  //LvItem.ShortCut := TextToShortCut(AShortCut);
  AParentMenu.Add(LvItem);
  Result := LvItem;
end;

procedure TEditNotifierHelper.OnChatGPTAskSubMenuClick(Sender: TObject);
var
  LvEditView: IOTAEditView;
  LvEditBlock: IOTAEditBlock;
  LvSelectedText: string;
begin
  TSingletonSettingObj.Instance.ReadRegistry;
  if TSingletonSettingObj.Instance.ApiKey = '' then
  begin
    if TSingletonSettingObj.Instance.GetSetting.Trim.IsEmpty then
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
    if (SameStr(LeftStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.LeftIdentifier)) and (SameStr(RightStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.RightIdentifier)) then
    begin
      if not TSingletonSettingObj.Instance.ApiKey.Trim.IsEmpty then
      begin
        Frm_Progress := TFrm_Progress.Create(nil);
        try
          frm_Progress.SelectedText := GetQuestion(LvEditBlock.Text);
          TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Progress, Frm_Progress); //Apply Theme
          Frm_Progress.ShowModal;
          LvEditView.Buffer.EditPosition.InsertText(Frm_Progress.Answer.TrimLineText);
          if not (Frm_Progress.HasError) and (TSingletonSettingObj.Instance.CodeFormatter) then
            FormatSource;
        finally
          FreeAndNil(Frm_Progress);
        end;
      end;
    end
    else
      ShowMessage(CreateMsg);
  end
  else
    ShowMessage(CreateMsg);
end;

procedure TEditNotifierHelper.OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
begin
  if not Assigned(MenuItem.Find('Ask')) then
    AddMenuItem(MenuItem, 'ChatGPTAskSubMenu', 'Ask', OnChatGPTAskSubMenuClick, 'CTRL+ALT+SHIFT+A');
end;

procedure TEditNotifierHelper.AddEditorContextMenu;
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

class function TEditNotifierHelper.CreateMsg: string;
var
  LeftIdentifier: string;
  RightIdentifier: string;
begin
  Cs.Enter;
  LeftIdentifier := TSingletonSettingObj.Instance.LeftIdentifier;
  RightIdentifier := TSingletonSettingObj.Instance.RightIdentifier;
  Cs.Leave;

  Result := 'There is no selected text with the ChatGPT Plug-in''s desired format, follow the below sample, please.' +
               #13 + LeftIdentifier + ' Any Question... ' + RightIdentifier;
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

function TEditNotifierHelper.GetCurrentUnitPath: string;
var
  ModuleServices: IOTAModuleServices;
  CurrentModule: IOTAModule;
  SourceModule: IOTASourceEditor;
begin
  Result := '';
  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  CurrentModule := ModuleServices.CurrentModule;
  Result := ExtractFileName(CurrentModule.CurrentEditor.FileName);
end;

procedure TEditNotifierHelper.EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
var
  LvCurrentUnitName: string;
begin
  if not Assigned(FChatGPTSubMenu) then
    AddEditorContextMenu;

  LvCurrentUnitName := GetCurrentUnitPath;

  Cs.Enter;
  if Assigned(FChatGPTDockForm) and (FChatGPTDockForm.Showing) and (FChatGPTDockForm.Fram_Question.pgcMain.ActivePageIndex = 1) and
    (not LvCurrentUnitName.Equals(TSingletonSettingObj.Instance.CurrentActiveViewName)) then
  begin
    TSingletonSettingObj.Instance.CurrentActiveViewName := LvCurrentUnitName;
    Cs.Leave;
    FChatGPTDockForm.Fram_Question.ReloadClassList(FChatGPTDockForm.FDockFormClassListObj);
  end;
end;

procedure TEditNotifierHelper.EditorViewModified(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
begin
end;

class procedure TEditNotifierHelper.FormatSource;
var
  FEditorPopUpMenu: TPopupMenu;
begin
  FEditorPopUpMenu := TPopupMenu((BorlandIDEServices as IOTAEditorServices).TopView.GetEditWindow.Form.FindComponent('EditorLocalMenu'));
  FEditorPopUpMenu.Items.Find('Format Source').Click;
end;

class function TEditNotifierHelper.GetQuestion(AStr: string): string;
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
    Self[I] := Trim(Self[I]);

  Result := Self.Text;
end;

{ TChatGPTDockForm }

constructor TChatGPTDockForm.Create(AOwner: TComponent);
begin
  inherited;
  DeskSection := 'ChatGPTPlugin';
  AutoSave := True;
  SaveStateNecessary := True;
  FDockFormClassListObj := TClassList.Create;

  with Self do
  begin
    Caption := 'ChatGPT';
    ClientHeight := 557;
    ClientWidth := 420;
    Position := poMainFormCenter;
  end;

  Fram_Question := TFram_Question.Create(Self);
  with Fram_Question do
  begin
    Name := 'Fram_Question';
    Parent := Self;
    InitialFrame;
    InitialClassViewMenueItems(FDockFormClassListObj);
    Show;
    BringToFront;
  end;

  with TSingletonSettingObj.Instance do
  begin
    if (not HistoryEnabled) and (not ShouldReloadHistory) and (FileExists(GetHistoryFullPath)) then
      ShouldReloadHistory := True;
  end;

  Self.OnKeyDown := FormKeyDown;
  Self.OnClose := FormClose;
  Self.KeyPreview := True;
end;

destructor TChatGPTDockForm.Destroy;
begin
  SaveStateNecessary := True;
  FDockFormClassListObj.Free;
  inherited;
  FChatGPTDockForm := nil;
end;

procedure TChatGPTDockForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Fram_Question.Edt_Search.Clear;
  Fram_Question.TerminateThred;
end;

procedure TChatGPTDockForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
    Close;
end;

initialization
  FChatGPTSubMenu := nil;
  FChatGPTDockForm := nil;

finalization
  RemoveAferUnInstall;
end.
