{***************************************************}
{                                                   }
{   This unit is the main unit of the package       }
{   including register function.                    }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UChatGptMain;

interface
uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.Menus, Vcl.Dialogs, Winapi.Windows,
  {$IFNDEF NEXTGEN}System.StrUtils{$ELSE}AnsiStrings{$ENDIF !NEXTGEN}, ToolsAPI, StructureViewAPI,
  DockForm, System.Generics.Collections, Vcl.Forms, System.IOUtils, UConsts, UAbout, Vcl.Imaging.pngimage,
  UChatGPTMenuHook, UChatGPTSetting, UChatGPTQFrame, UChatGPTQuestion, UEditorHelpers, Vcl.Graphics, Vcl.ImgList;

type

{$REGION 'Types and definitions'}
  TTStringListHelper = class helper for TStringList
    function TrimLineText: string;
  end;

  TChatGPTOnCliskType = procedure(Sender: TObject) of Object;
  TMsgType = (mtNone, mtNormalQuestion, mtAddTest, mtFindBugs, mtAddComment,
              mtOptimize, mtCompleteCode, mtExplain, mtRefactor, mtASM);

{*********************************************************}
{                                                         }
{           This menu item will be added                  }
{           into the main menu of the IDE.                }
{                                                         }
{*********************************************************}
  TChatGptMenuWizard = class(TInterfacedObject, IOTAWizard)
  private
    FRoot, FAskMenu,
    FSettingMenu, FAboutMenu: TMenuItem;
    FSetting: TSingletonSettingObj;

    FAskSubMenuH, FAddTestH, FFindBugsH, //These hidden menues usre used for better Ux expreince with shortcuts.
    FOptimizeH, FAddCommentsH, FCompleteCodeH, FAsmConvert: TMenuItem;

    procedure AskMenuClick(Sender: TObject);
    procedure ChatGPTDockableMenuClick(Sender: TObject);
    procedure ChatGPTSettingMenuClick(Sender: TObject);
    procedure ChatGPTAboutMenuClick(Sender: TObject);
    procedure AskSubmenuHiddenOnClick(Sender: TObject);
    class function CanUseDockableAssistant: Boolean; static;
    procedure OpenAssistantUI;
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
    procedure LoadSubMenuIcons(AMainMenu: TMainMenu);
  end;

{************************************************************************************************}
{                                                                                                }
{   The editor is not immediately available upon startup of the IDE,                             }
{   therefore we can’t get access to the editor in the plugin initialization code.               }
{   What we needed is to register a class that implements the INTAEditServicesNotifier interface.}
{   The IDE calls this interface when the editor is activated in the IDE.                        }
{                                                                                                }
{************************************************************************************************}
  {$IF CompilerVersion >= 32.0}
  TStylingNotifier = class(TNotifierObject, IOTANotifier, INTAIDEThemingServicesNotifier)
    procedure ChangingTheme();
    procedure ChangedTheme();
  end;
  {$ENDIF}
  TEditNotifierHelper = class(TNotifierObject, IOTANotifier, INTAEditServicesNotifier)
    procedure OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
    procedure OnChatGPTContextMenuFixedQuestionClick(Sender: TObject);
    procedure AfterEditorContextMenuPopup(Sender: TObject; Menu: TPopupMenu);
  private
    FMenuHook: TCpMenuHook;
    class function GetQuestion(AStr: string): string;
    class function CreateMsg(AType: TMsgType): string;
    class procedure FormatSource;
    function GetCurrentUnitPath: string;
    class function GetSelectedText: string;
    class procedure RunInlineQuestion(AQuestion: string; AMsgType: TMsgType);
    class procedure ShowAssistantMessage(const AMessage: string);
    class procedure ShowSettingsDialog;
    class procedure OpenAssistantWithDraft(const ASelectedText: string; AShowInlineHint: Boolean = False);
    class procedure DoAskSubMenu;
    class procedure DoAddTest;
    class procedure DoFindBugs;
    class procedure DoOptimize;
    class procedure DoAddComments;
    class procedure DoCompleteCode;
    class procedure DoExplain;
    class procedure DoRefactor;
    class procedure DoConvertToAssembly;
    class function RefineText(AInput: TStringList; AMsgType: TMsgType = mtNone): string;
    class procedure WriteIntoEditor(AText: string);
  public
    constructor Create;
    destructor Destroy; override;
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
    function AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string; ATag: NativeInt): TMenuItem;
    function AddSeparatorMenuItem(AParentMenu: TMenuItem; const AName: string): TMenuItem;
  end;

{*******************************************************}
{                                                       }
{   This is the dockable form of the plugin.            }
{   It is a singleton class which means there will      }
{   be just one instance as long as the IDE is alive!   }
{   Could be activate/deactive in main menu.            }
{                                                       }
{*******************************************************}
  TChatGPTDockForm = class(TDockableForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
   private
    FDockFormClassListObj: TClassList;
  public
    Fram_Question: TFram_Question;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  end;

  const
    WizardFail = -1;

  var
    FMainMenuIndex: Integer = WizardFail;
    FNotifierIndex: Integer = WizardFail;
    FStylingNotifierIndex: Integer = WizardFail;
    FFusionAISubMenu: TCpMenuItemDef;
    FFusionAIDockForm: TChatGPTDockForm;
    FChatGptMenuWizard: TChatGptMenuWizard;
    FShouldApplyTheme: Boolean = False;

    procedure RemoveAferUnInstall;
    procedure RegisterAboutBox;
    procedure register;
{$ENDREGION}

implementation

uses
  UChatGPTProgress;

{$REGION 'public methods'}
procedure register;
begin
  FChatGptMenuWizard := TChatGptMenuWizard.Create;
  FMainMenuIndex := (BorlandIDEServices as IOTAWizardServices).AddWizard(FChatGptMenuWizard);
  FNotifierIndex := (BorlandIDEServices as IOTAEditorServices).AddNotifier(TEditNotifierHelper.Create);
  {$IF CompilerVersion >= 32.0}
  FStylingNotifierIndex := (BorlandIDEServices as IOTAIDEThemingServices).AddNotifier(TStylingNotifier.Create);
  {$ENDIF}
end;

procedure RemoveAferUnInstall;
var
  LvRootMenu: TMainMenu;
begin
  if Assigned(FFusionAIDockForm) then
  begin
    FFusionAIDockForm.Close;
    FreeAndNil(FFusionAIDockForm);
  end;

  LvRootMenu := (BorlandIDEServices as INTAServices).MainMenu;
  LvRootMenu.Items.Delete(TSingletonSettingObj.Instance.RootMenuIndex);

  if FMainMenuIndex <> WizardFail then
    (BorlandIDEServices as IOTAWizardServices).RemoveWizard(FMainMenuIndex);

  if FNotifierIndex <> WizardFail then
    (BorlandIDEServices as IOTAEditorServices).RemoveNotifier(FNotifierIndex);

  {$IF CompilerVersion >= 32.0}
  if FStylingNotifierIndex <> WizardFail then
     (BorlandIDEServices as IOTAIDEThemingServices).RemoveNotifier(FStylingNotifierIndex);
  {$ENDIF}
end;

procedure RegisterAboutBox;
var
  LvSplashService : IOTASplashScreenServices;
  LvResStream: TResourceStream;
  LvPngImage: TPngImage;
  LvBmp: TBitmap;
begin
  if Supports(SplashScreenServices, IOTASplashScreenServices, LvSplashService) then
  begin
    LvResStream := TResourceStream.Create(HInstance, 'GPT24', RT_RCDATA);
    try
      LvPngImage := TPngImage.Create;
      try
        LvPngImage.LoadFromStream(LvResStream);
        LvBmp := TBitmap.Create;
        try
          LvPngImage.Transparent := False;
          LvPngImage.AssignTo(LvBmp);
          LvSplashService.AddPluginBitmap(CVersionedName, LvBmp.Handle, False, 'MIT License');
        finally
          LvBmp.Free;
        end;
      finally
        LvPngImage.Free;
      end;
    finally
      LvResStream.Free;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'TChatGptMenuWizard'}
procedure TChatGptMenuWizard.ChatGPTAboutMenuClick(Sender: TObject);
var
  Frm_About: TFrm_About;
begin
  Frm_About := TFrm_About.Create(nil);
  TSingletonSettingObj.RegisterFormClassForTheming(TFrm_About, Frm_About); //Apply Theme
  try
    Frm_About.ShowModal;
  finally
    Frm_About.Free;
  end;
end;

procedure TChatGptMenuWizard.ChatGPTDockableMenuClick(Sender: TObject);
begin
  AskMenuClick(Sender);
end;
class function TChatGptMenuWizard.CanUseDockableAssistant: Boolean;
begin
  {$IF CompilerVersion >= 32.0}
  Result := True;
  {$ELSE}
  Result := False;
  {$IFEND}
end;
procedure TChatGptMenuWizard.OpenAssistantUI;
var
  FrmChatGPTMain: TFrmChatGPT;
begin
  if CanUseDockableAssistant then
  begin
    if not Assigned(FFusionAIDockForm) then
      FFusionAIDockForm := TChatGPTDockForm.Create(Application);
    TSingletonSettingObj.RegisterFormClassForTheming(TChatGPTDockForm, FFusionAIDockForm); //Apply Theme
    RenewUI(FFusionAIDockForm);
    FFusionAIDockForm.Show;
    Exit;
  end;
  FrmChatGPTMain := TFrmChatGPT.Create(Application);
  try
    TSingletonSettingObj.RegisterFormClassForTheming(TFrmChatGPT, FrmChatGPTMain);  //Apply Theme
    RenewUI(FrmChatGPTMain);
    FrmChatGPTMain.ShowModal;
  finally
    FreeAndNil(FrmChatGPTMain);
  end;
end;

procedure TChatGptMenuWizard.ChatGPTSettingMenuClick(Sender: TObject);
begin
  FSetting := TSingletonSettingObj.Instance;
  FSetting.ReadRegistry;
  Frm_Setting := TFrm_Setting.Create(nil);
  try
    TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Setting, Frm_Setting); //Apply Theme
    Frm_Setting.LoadFromSettings(FSetting);
    Frm_Setting.ShowModal;
    if Frm_Setting.HasChanges then
      RenewUI(FFusionAIDockForm);
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
    FAskMenu.Name := CAskMenuName;
    FAskMenu.Caption := CAskMenuCaption;
    FAskMenu.OnClick := AskMenuClick;
    FAskMenu.ShortCut := TextToShortCut('Ctrl+Alt+Shift+C');
  end;

  if not Assigned(FSettingMenu) then
  begin
    FSettingMenu := TMenuItem.Create(nil);
    FSettingMenu.Name := CSettingsMenuName;
    FSettingMenu.Caption := CSettingsMenuCaption;
    FSettingMenu.OnClick := ChatGPTSettingMenuClick;
    FSettingMenu.ImageIndex := 36;
  end;
  {$REGION 'Hidden menus, to use shortcuts before creation of the real menu inside the Editor'}
  if not Assigned(FAskSubMenuH) then
  begin
    FAskSubMenuH := TMenuItem.Create(nil);
    FAskSubMenuH.Tag := 0;
    FAskSubMenuH.ShortCut := TextToShortCut('Ctrl+Alt+Shift+A');
    FAskSubMenuH.OnClick := AskSubmenuHiddenOnClick;
    FAskSubMenuH.Visible := False;
  end;

  if not Assigned(FAddTestH) then
  begin
    FAddTestH := TMenuItem.Create(nil);
    FAddTestH.Tag := 1;
    FAddTestH.ShortCut := TextToShortCut('Ctrl+Alt+Shift+T');
    FAddTestH.OnClick := AskSubmenuHiddenOnClick;
    FAddTestH.Visible := False;
  end;

  if not Assigned(FFindBugsH) then
  begin
    FFindBugsH := TMenuItem.Create(nil);
    FFindBugsH.Tag := 2;
    FFindBugsH.ShortCut := TextToShortCut('Ctrl+Alt+Shift+B');
    FFindBugsH.OnClick := AskSubmenuHiddenOnClick;
    FFindBugsH.Visible := False;
  end;

  if not Assigned(FOptimizeH) then
  begin
    FOptimizeH := TMenuItem.Create(nil);
    FOptimizeH.Tag := 3;
    FOptimizeH.ShortCut := TextToShortCut('Ctrl+Alt+Shift+O');
    FOptimizeH.OnClick := AskSubmenuHiddenOnClick;
    FOptimizeH.Visible := False;
  end;

  if not Assigned(FAddCommentsH) then
  begin
    FAddCommentsH := TMenuItem.Create(nil);
    FAddCommentsH.Tag := 4;
    FAddCommentsH.ShortCut := TextToShortCut('Ctrl+Alt+Shift+M');
    FAddCommentsH.OnClick := AskSubmenuHiddenOnClick;
    FAddCommentsH.Visible := False;
  end;

  if not Assigned(FCompleteCodeH) then
  begin
    FCompleteCodeH := TMenuItem.Create(nil);
    FCompleteCodeH.Tag := 5;
    FCompleteCodeH.ShortCut := TextToShortCut('Ctrl+Alt+Shift+K');
    FCompleteCodeH.OnClick := AskSubmenuHiddenOnClick;
    FCompleteCodeH.Visible := False;
  end;

  if not Assigned(FAsmConvert) then
  begin
    FCompleteCodeH := TMenuItem.Create(nil);
    FCompleteCodeH.Tag := 8;
    FCompleteCodeH.ShortCut := TextToShortCut('Ctrl+Alt+Shift+S');
    FCompleteCodeH.OnClick := AskSubmenuHiddenOnClick;
    FCompleteCodeH.Visible := False;
  end;
  {$ENDREGION}

  if not Assigned(FAboutMenu) then
  begin
    FAboutMenu := TMenuItem.Create(nil);
    FAboutMenu.Name := CAboutMenuName;
    FAboutMenu.Caption := CAboutMenuCaption;
    FAboutMenu.OnClick := ChatGPTAboutMenuClick;
    FAboutMenu.ImageIndex := 50;
  end;

  if not Assigned(FRoot) then
  begin
    FRoot := TMenuItem.Create(nil);
    FRoot.Caption := CPluginName;
    FRoot.Name := CRootMenuName;
    FRoot.Add(FAskMenu);
    FRoot.Add(FSettingMenu);
    FRoot.Add(FAskSubMenuH);
    FRoot.Add(FAddTestH);
    FRoot.Add(FFindBugsH);
    FRoot.Add(FOptimizeH);
    FRoot.Add(FAddCommentsH);
    FRoot.Add(FCompleteCodeH);
    FRoot.Add(FAboutMenu);
  end;

  if not Assigned((BorlandIDEServices as INTAServices).MainMenu.Items.Find(CRootMenuName)) then
  begin
    LvMainMenu := (BorlandIDEServices as INTAServices).MainMenu;
    LvMainMenu.Items.Insert(LvMainMenu.Items.Count - 1, FRoot);
    LoadSubMenuIcons(LvMainMenu);
  end;
  TSingletonSettingObj.Instance.RootMenuIndex := LvMainMenu.Items.IndexOf(FRoot);
  TSingletonSettingObj.Instance.ReadRegistry;
end;

procedure TChatGptMenuWizard.AskMenuClick(Sender: TObject);
var
  LvSettingObj: TSingletonSettingObj;
begin
  LvSettingObj := TSingletonSettingObj.Instance;
  LvSettingObj.ReadRegistry;
  if Length(LvSettingObj.GetEnabledProviderIds) = 0 then
  begin
    LvSettingObj.GetSetting;
    LvSettingObj.ReadRegistry;
    if Length(LvSettingObj.GetEnabledProviderIds) = 0 then
      Exit;
  end;
  if Length(LvSettingObj.GetEnabledProviderIds) > 0 then
    OpenAssistantUI;
end;

procedure TChatGptMenuWizard.AskSubmenuHiddenOnClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    with TEditNotifierHelper do
    begin
      case TMenuItem(Sender).Tag of
        0: DoAskSubMenu;
        1: DoAddTest;
        2: DoFindBugs;
        3: DoOptimize;
        4: DoAddComments;
        5: DoCompleteCode;
        6: DoExplain;
        7: DoRefactor;
        8: DoConvertToAssembly;
      end;
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
  Result := CWizardIDString;
end;

function TChatGptMenuWizard.GetName: string;
begin
  Result := CWizardName;
end;

function TChatGptMenuWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure TChatGptMenuWizard.LoadSubMenuIcons(AMainMenu: TMainMenu);
var
  LvResStream: TResourceStream;
  LvImgList: TCustomImageList;
  LvPngImage: TPngImage;
  LvRootMenu: TMenuItem;
  LvBmp: TBitmap;
  I: Integer;
begin
  LvResStream := TResourceStream.Create(HInstance, 'GPT24', RT_RCDATA);
  try
    LvPngImage := TPngImage.Create;
    try
      LvPngImage.LoadFromStream(LvResStream);
      LvBmp := TBitmap.Create;
      try
        LvPngImage.Transparent := False;
        LvPngImage.AssignTo(LvBmp);
        LvBmp.SetSize(16, 16);
        LvBmp.Canvas.Draw((16 - LvPngImage.Width) div 2, (16 - LvPngImage.Height) div 2, LvPngImage);

        for I := AMainMenu.Items.Count - 1 downto 0 do
        begin
          LvRootMenu := AMainMenu.Items[I];
          if LvRootMenu.Name = CRootMenuName then
          begin
            LvImgList := LvRootMenu.GetImageList;
            if Assigned(LvImgList) then
            begin
              try
                FAskMenu.ImageIndex := LvImgList.Add(LvBmp, nil);
              except
                FAskMenu.ImageIndex := 1;
              end;
            end;
            FAskMenu.Bitmap.Assign(LvBmp);
            Break;
          end;
        end;
      finally
        LvBmp.Free;
      end;
    finally
      LvPngImage.Free;
    end;
  finally
    LvResStream.Free;
  end;
  try
    RegisterAboutBox;
  except
  end;
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
    ConfigureProviderPages;
    UpdateTopButtonLayout;
  end;
  Cs.Leave;
end;
{$ENDREGION}

{$REGION 'TEditNotifierHelper'}
function TEditNotifierHelper.AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string; ATag: NativeInt): TMenuItem;
var
  LvItem: TMenuItem;
begin
  LvItem := TMenuItem.Create(nil);
  LvItem.Name := AName;
  LvItem.Tag := ATag;
  LvItem.Caption := ACaption + IfThen(AShortCut.IsEmpty, '', '  (' + AShortCut + ')');
  LvItem.OnClick := AOnClick;
  AParentMenu.Add(LvItem);
  Result := LvItem;
end;
function TEditNotifierHelper.AddSeparatorMenuItem(AParentMenu: TMenuItem; const AName: string): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.Name := AName;
  Result.Caption := '-';
  AParentMenu.Add(Result);
end;

procedure TEditNotifierHelper.OnChatGPTContextMenuFixedQuestionClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    case TMenuItem(Sender).Tag of
      0: DoAskSubMenu;
      1: DoAddTest;
      2: DoFindBugs;
      3: DoOptimize;
      4: DoAddComments;
      5: DoCompleteCode;
      6: DoExplain;
      7: DoRefactor;
      8: DoConvertToAssembly;
      100: ShowSettingsDialog;
    end;
  end;
end;

procedure TEditNotifierHelper.OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
begin
  TSingletonSettingObj.Instance.ReadRegistry;
  if not Assigned(MenuItem.Find(CEditorSubMenuAskName)) then
  begin
    AddMenuItem(MenuItem, CEditorSubMenuAskName, CEditorAskCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+A', 0);
    AddMenuItem(MenuItem, CEditorSubMenuAddTestName, CEditorAddTestCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+T', 1);
    AddMenuItem(MenuItem, CEditorSubMenuFindBugsName, CEditorFindBugsCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+B', 2);
    AddMenuItem(MenuItem, CEditorSubMenuOptimizeName, CEditorOptimizeCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+O', 3);
    AddMenuItem(MenuItem, CEditorSubMenuAddCommentsName, CEditorAddCommentsCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+M', 4);
    AddMenuItem(MenuItem, CEditorSubMenuCompleteCodeName, CEditorCompleteCodeCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+K', 5);
    AddMenuItem(MenuItem, CEditorSubMenuExplainName, CEditorExplainCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+E', 6);
    AddMenuItem(MenuItem, CEditorSubMenuRefactorName, CEditorRefactorCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+R', 7);
    AddMenuItem(MenuItem, CEditorSubMenuAsmName, CEditorAsmCaption, OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+S', 8);
    AddSeparatorMenuItem(MenuItem, CEditorSubMenuSeparatorName);
    AddMenuItem(MenuItem, CEditorSubMenuSettingsName, CSettingsMenuCaption, OnChatGPTContextMenuFixedQuestionClick, '', 100);
  end;
end;

class function TEditNotifierHelper.RefineText(AInput: TStringList; AMsgType: TMsgType): string;
  const LcLeftComment = '//************ '; LcRightComment = ' ***************';
var
  LvComment: string;
begin
  case AMsgType of
    mtNone:
      LvComment := '';
    mtNormalQuestion:
      LvComment := '';
    mtAddTest:
      LvComment := 'Add Test';
    mtFindBugs:
      LvComment := 'Find Bugs';
    mtAddComment:
      LvComment := 'Add Comment';
    mtOptimize:
      LvComment := 'Optimize Code';
    mtCompleteCode:
      LvComment := 'Complete Code';
    mtExplain:
      LvComment := 'Explanation';
    mtRefactor:
      LvComment := 'Refactor';
    mtASM:
      LvComment := 'Convert to Assembly'
  end;

  Result := CRLF + '{' + LcLeftComment + LvComment + LcRightComment + CRLF +
    AInput.Text + '}';
end;

class procedure TEditNotifierHelper.RunInlineQuestion(AQuestion: string; AMsgType: TMsgType);
begin
  if Length(TSingletonSettingObj.Instance.GetEnabledProviderIds) > 0 then
  begin
    Frm_Progress := TFrm_Progress.Create(nil);
    try
      Frm_Progress.SelectedText := AQuestion;
      if TSingletonSettingObj.Instance.EnableFileLog then
        AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
          'RunInlineQuestion: showing modal progress dialog.');
      TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Progress, Frm_Progress); //Apply Theme
      Frm_Progress.ShowModal;
      if TSingletonSettingObj.Instance.EnableFileLog then
        AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
          'RunInlineQuestion: modal dialog closed. HasError=' +
          BoolToStr(Frm_Progress.HasError, True) + ', AnswerLength=' +
          IntToStr(Length(Frm_Progress.Answer.Text)));
      if (not Frm_Progress.HasError) and (not Frm_Progress.Answer.Text.Trim.IsEmpty) then
      begin
        if TSingletonSettingObj.Instance.EnableFileLog then
          AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
            'RunInlineQuestion: writing response into editor.');
        WriteIntoEditor(RefineText(Frm_Progress.Answer, AMsgType));
        if TSingletonSettingObj.Instance.EnableFileLog then
          AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
            'RunInlineQuestion: editor write completed.');
        if TSingletonSettingObj.Instance.CodeFormatter then
          TEditNotifierHelper.FormatSource;
      end;
      if Frm_Progress.HasError and (not Frm_Progress.Answer.Text.Trim.IsEmpty) then
        ShowAssistantMessage(Frm_Progress.Answer.Text.Trim);
    finally
      FreeAndNil(Frm_Progress);
    end;
  end;
end;

procedure TEditNotifierHelper.AddEditorContextMenu;
var
  LvEditorPopUpMenu: TPopupMenu;
begin
  LvEditorPopUpMenu := TPopupMenu((BorlandIDEServices as IOTAEditorServices).TopView.GetEditWindow.Form.FindComponent('EditorLocalMenu'));
  FMenuHook.HookMenu(LvEditorPopUpMenu);
  if FMenuHook.IsHooked(LvEditorPopUpMenu) then
  begin
    FFusionAISubMenu := TCpMenuItemDef.Create(CEditorSubMenuName, CEditorMenuCaption, nil, ipFirst, '');
    FFusionAISubMenu.OnCreated := OnChatGPTSubMenuClick;
    FMenuHook.AddMenuItemDef(FFusionAISubMenu);
  end;
end;

constructor TEditNotifierHelper.Create;
begin
  inherited Create;
  FMenuHook := TCpMenuHook.Create(nil);
  FMenuHook.OnAfterPopup := AfterEditorContextMenuPopup;
end;

class function TEditNotifierHelper.CreateMsg(AType: TMsgType): string;
var
  LeftIdentifier: string;
  RightIdentifier: string;
begin
  Result := CNoSelectionMsg;
  case AType of
    mtNormalQuestion:
    begin
      Cs.Enter;
      LeftIdentifier := TSingletonSettingObj.Instance.LeftIdentifier;
      RightIdentifier := TSingletonSettingObj.Instance.RightIdentifier;
      Cs.Leave;
      Result := Format(CAskSelectionRequiredMsgFmt, [LeftIdentifier, RightIdentifier]);
    end;
    mtAddTest,
    mtFindBugs,
    mtAddComment,
    mtOptimize,
    mtCompleteCode,
    mtExplain,
    mtRefactor,
    mtASM:
      Result := CNoSelectionMsg;
  end;
end;

destructor TEditNotifierHelper.Destroy;
begin
  FMenuHook.Free;
  inherited;
end;

class procedure TEditNotifierHelper.DoAskSubMenu;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
  begin
    if (SameStr(LeftStr(LvSelectedText, Length(TSingletonSettingObj.Instance.LeftIdentifier)).ToLower, TSingletonSettingObj.Instance.LeftIdentifier)) and
       (SameStr(RightStr(LvSelectedText, Length(TSingletonSettingObj.Instance.RightIdentifier)).ToLower, TSingletonSettingObj.Instance.RightIdentifier)) then
      RunInlineQuestion(GetQuestion(LvSelectedText), mtNormalQuestion)
    else
      OpenAssistantWithDraft(LvSelectedText, True);
  end
  else
    OpenAssistantWithDraft('', True);
end;

class procedure TEditNotifierHelper.DoAddTest;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuAddTest + #13 + LvSelectedText, mtAddTest)
  else
    ShowAssistantMessage(CreateMsg(mtAddTest));
end;

class procedure TEditNotifierHelper.DoFindBugs;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuFindBugs + #13 + LvSelectedText, mtFindBugs)
  else
    ShowAssistantMessage(CreateMsg(mtFindBugs));
end;

class procedure TEditNotifierHelper.DoOptimize;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuOptimize + #13 + LvSelectedText, mtOptimize)
  else
    ShowAssistantMessage(CreateMsg(mtOptimize));
end;

class procedure TEditNotifierHelper.DoAddComments;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuAddComments + #13 + LvSelectedText, mtAddComment)
  else
    ShowAssistantMessage(CreateMsg(mtAddComment));
end;

class procedure TEditNotifierHelper.DoCompleteCode;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuCompleteCode + #13 + LvSelectedText, mtCompleteCode)
  else
    ShowAssistantMessage(CreateMsg(mtCompleteCode));
end;

class procedure TEditNotifierHelper.DoConvertToAssembly;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuConvertToAsm + #13 + LvSelectedText, mtASM)
  else
    ShowAssistantMessage(CreateMsg(mtASM));
end;

class procedure TEditNotifierHelper.DoExplain;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuExplain + #13 + LvSelectedText, mtExplain)
  else
    ShowAssistantMessage(CreateMsg(mtExplain));
end;

class procedure TEditNotifierHelper.DoRefactor;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuRefactor + #13 + LvSelectedText, mtRefactor)
  else
    ShowAssistantMessage(CreateMsg(mtRefactor));
end;
procedure TEditNotifierHelper.AfterEditorContextMenuPopup(Sender: TObject; Menu: TPopupMenu);
var
  LMenuItem: TMenuItem;
begin
  if not Assigned(Menu) then
    Exit;
  LMenuItem := Menu.Items.Find(CEditorSubMenuName);
  if Assigned(LMenuItem) and (LMenuItem.MenuIndex <> 0) then
  begin
    Menu.Items.Remove(LMenuItem);
    Menu.Items.Insert(0, LMenuItem);
  end;
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

procedure TChatGptMenuWizard.AfterSave;
begin
//Do noting yet, its created by interface force!
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

procedure TEditNotifierHelper.EditorViewModified(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
begin
end;

function TEditNotifierHelper.GetCurrentUnitPath: string;
var
  ModuleServices: IOTAModuleServices;
  CurrentModule: IOTAModule;
begin
  Result := '';
  if Supports(BorlandIDEServices, IOTAModuleServices) then
  begin
    try
      ModuleServices := BorlandIDEServices as IOTAModuleServices;
      CurrentModule := ModuleServices.CurrentModule;
      Result := ExtractFileName(CurrentModule.CurrentEditor.FileName);
    except
      Result := '';
    end;
  end;
end;

procedure TEditNotifierHelper.EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
var
  LvCurrentUnitName: string;
begin
  if not Assigned(FFusionAISubMenu) then
    AddEditorContextMenu;

  LvCurrentUnitName := GetCurrentUnitPath;

  Cs.Enter;
  if Assigned(FFusionAIDockForm) and (FFusionAIDockForm.Showing) and (FFusionAIDockForm.Fram_Question.pgcMain.ActivePageIndex = 1) and
    (not LvCurrentUnitName.Equals(TSingletonSettingObj.Instance.CurrentActiveViewName)) then
  begin
    TSingletonSettingObj.Instance.CurrentActiveViewName := LvCurrentUnitName;
    Cs.Leave;

    if Assigned(FFusionAIDockForm) then
    begin
      with FFusionAIDockForm.Fram_Question do
      begin
        if (pgcMain.ActivePage = tsClassView) and (not ClassViewIsBusy) then
          ReloadClassList(FFusionAIDockForm.FDockFormClassListObj);
      end;
    end;
  end;
end;

class procedure TEditNotifierHelper.FormatSource;
var
  LvEditorPopUpMenu: TPopupMenu;
  LvFormatSource: TMenuItem;
begin
  LvEditorPopUpMenu := TPopupMenu((BorlandIDEServices as IOTAEditorServices).TopView.GetEditWindow.Form.FindComponent('EditorLocalMenu'));
  if LvEditorPopUpMenu <> nil then
  begin
    LvFormatSource := LvEditorPopUpMenu.Items.Find('Format Source');
    if Assigned(LvFormatSource) then
      LvFormatSource.Click;
  end;
end;

class function TEditNotifierHelper.GetQuestion(AStr: string): string;
var
  LvTmpStr: string;
begin
  LvTmpStr := AStr.Trim;
  if LeftStr(AStr, 2) = '//' then
    LvTmpStr := RightStr(AStr.Trim, AStr.Length - 2);
  LvTmpStr := RightStr(LvTmpStr, LvTmpStr.Length - Length(TSingletonSettingObj.Instance.LeftIdentifier));
  Result := LeftStr(LvTmpStr, LvTmpStr.Length - Length(TSingletonSettingObj.Instance.RightIdentifier));
end;

class function TEditNotifierHelper.GetSelectedText: string;
var
  LvEditView: IOTAEditView;
  LvEditBlock: IOTAEditBlock;
  LvReader: IOTAEditReader;
  LvStartPos: Integer;
  LvEndPos: Integer;
  LvOutStr: AnsiString;
begin
  Result := '';
  LvEditView := GetTopMostEditView;
  if Assigned(LvEditView) then
  begin
    LvEditBlock := LvEditView.GetBlock;
    if Assigned(LvEditBlock) and LvEditView.Block.IsValid and (LvEditView.Block.Size > 0) then
    begin
      Result := TrimRight(LvEditBlock.Text);
      if Result = '' then
      begin
        LvStartPos := EditPosToLinePos(OTAEditPos(LvEditBlock.StartingColumn, LvEditBlock.StartingRow), LvEditView);
        LvEndPos := EditPosToLinePos(OTAEditPos(LvEditBlock.EndingColumn, LvEditBlock.EndingRow), LvEditView);
        if LvEndPos > LvStartPos then
        begin
          SetLength(LvOutStr, LvEndPos - LvStartPos);
          LvReader := LvEditView.Buffer.CreateReader;
          try
            LvReader.GetText(LvStartPos, PAnsiChar(LvOutStr), LvEndPos - LvStartPos);
          finally
            LvReader := nil;
          end;
          Result := TrimRight(ConvertEditorTextToTextW(LvOutStr));
        end;
      end;
    end;
  end;
end;
class procedure TEditNotifierHelper.ShowAssistantMessage(const AMessage: string);
begin
  ShowIDEMessage(AMessage, True, CPluginName);
end;
class procedure TEditNotifierHelper.ShowSettingsDialog;
var
  LSetting: TSingletonSettingObj;
begin
  LSetting := TSingletonSettingObj.Instance;
  LSetting.ReadRegistry;
  Frm_Setting := TFrm_Setting.Create(nil);
  try
    TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Setting, Frm_Setting);
    Frm_Setting.LoadFromSettings(LSetting);
    Frm_Setting.ShowModal;
  finally
    Frm_Setting.Free;
    LSetting.ReadRegistry;
  end;
end;
class procedure TEditNotifierHelper.OpenAssistantWithDraft(const ASelectedText: string; AShowInlineHint: Boolean);
var
  FrmChatGPTMain: TFrmChatGPT;
begin
  {$IF CompilerVersion >= 32.0}
  if TChatGptMenuWizard.CanUseDockableAssistant then
  begin
    if not Assigned(FFusionAIDockForm) then
      FFusionAIDockForm := TChatGPTDockForm.Create(Application);
    TSingletonSettingObj.RegisterFormClassForTheming(TChatGPTDockForm, FFusionAIDockForm);
    FFusionAIDockForm.Show;
    FFusionAIDockForm.BringToFront;
    FFusionAIDockForm.Fram_Question.ConfigureProviderPages;
    FFusionAIDockForm.Fram_Question.UpdateTopButtonLayout;
    FFusionAIDockForm.Fram_Question.PrepareQuestionDraft(ASelectedText, AShowInlineHint);
    Exit;
  end;
  {$IFEND}
  FrmChatGPTMain := TFrmChatGPT.Create(Application);
  try
    FrmChatGPTMain.InitialQuestionDraft := ASelectedText;
    FrmChatGPTMain.ShowInlineQuestionTip := AShowInlineHint;
    TSingletonSettingObj.RegisterFormClassForTheming(TFrmChatGPT, FrmChatGPTMain);
    FrmChatGPTMain.ShowModal;
  finally
    FreeAndNil(FrmChatGPTMain);
  end;
end;
class procedure TEditNotifierHelper.WriteIntoEditor(AText: string);
var
  LvEditView: IOTAEditView;
  LvTextLen: Integer;
  LvStartPos: Integer;
  LvEndPos: Integer;
  LvLineNo: Integer;
  LvCharIndex: Integer;
  LvLineText: String;
begin
  if TSingletonSettingObj.Instance.EnableFileLog then
    AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
      'WriteIntoEditor: entered with text length=' + IntToStr(Length(AText)) + '.');
  LvEditView := GetTopMostEditView;
  if IsEditControl(Screen.ActiveControl) and Assigned(LvEditView) then
  begin
    if LvEditView.Block.IsValid then
    begin
      LvStartPos := EditPosToLinePos(OTAEditPos(LvEditView.Block.StartingColumn, LvEditView.Block.StartingRow), LvEditView);
      LvEndPos := EditPosToLinePos(OTAEditPos(LvEditView.Block.EndingColumn, LvEditView.Block.EndingRow), LvEditView);
      LvTextLen := LvEditView.Block.Size;

      InsertTextIntoEditorAtPos(AText , LvEndPos, LvEditView.Buffer);
      LvEditView.CursorPos := LinePosToEditPos(LvStartPos + LvTextLen);
      LvEditView.Block.BeginBlock;
      LvEditView.CursorPos := LinePosToEditPos(LvEndPos + LvTextLen);
      LvEditView.Block.EndBlock;

      LvEditView.Paint;
    end
    else
    begin
      GetCurrLineText(LvLineText, LvLineNo, LvCharIndex);
      Inc(LvLineNo);
      InsertSingleLine(LvLineNo, LvLineText, LvEditView);
    end;
  end;
  if TSingletonSettingObj.Instance.EnableFileLog then
    AppendLogMessage(TSingletonSettingObj.Instance.LogDirectory,
      'WriteIntoEditor: completed.');
end;
{$ENDREGION}

{$REGION 'TTStringListHelper'}
function TTStringListHelper.TrimLineText: string;
var
  I: Integer;
begin
  for I := 0 to Pred(Self.Count) do
    Self[I] := Trim(Self[I]);

  Result := Self.Text;
end;
{$ENDREGION}

{$REGION 'TChatGPTDockForm'}
constructor TChatGPTDockForm.Create(AOwner: TComponent);
begin
  inherited;
  DeskSection := CAssistantDeskSection;
  AutoSave := True;
  SaveStateNecessary := True;
  FDockFormClassListObj := TClassList.Create;

  with Self do
  begin
    Caption := CAssistantWindowCaption;
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

    DockableFormPointer := Self;
  end;

  Self.OnKeyDown := FormKeyDown;
  Self.OnClose := FormClose;
  Self.OnShow := FormShow;
  Self.KeyPreview := True;
end;

destructor TChatGPTDockForm.Destroy;
begin
  SaveStateNecessary := True;
  FDockFormClassListObj.Free;
  inherited;
  FFusionAIDockForm := nil;
end;

procedure TChatGPTDockForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Fram_Question.Edt_Search.Clear;
  Fram_Question.TerminateAll;
end;

procedure TChatGPTDockForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
    Close;
end;

procedure TChatGPTDockForm.FormShow(Sender: TObject);
begin
  Fram_Question.ConfigureProviderPages;
end;

{$ENDREGION}

{$REGION 'TStylingNotifier'}
{$IF CompilerVersion >= 32.0}
procedure TStylingNotifier.ChangedTheme;
begin
  if FShouldApplyTheme then
  begin
    FShouldApplyTheme := False;

    // Styling does not work properly in Rio after changing the style, the following lines will make it better.
    if CompilerVersion = 33{Rio} then
    begin
      with FFusionAIDockForm.Fram_Question do
      begin
        HistoryGrid.ParentColor := False;
        if (BorlandIDEServices as IOTAIDEThemingServices).ActiveTheme = 'Dark' then
          HistoryGrid.Color := $006B5E4F
        else
          HistoryGrid.Color := $00EBDDCD;
        tsChatGPT.StyleElements := [seFont, seBorder];
        pnlTop.StyleElements := [seFont, seBorder];
        pnlTop.ParentColor := False;
        pnlTop.Color := FFusionAIDockForm.Color;
        pnlQuestion.ParentColor := False;
        pnlQuestion.Color := FFusionAIDockForm.Color;
      end;
    end;
    FChatGptMenuWizard.FAskMenu.Click;
  end;
end;

procedure TStylingNotifier.ChangingTheme;
begin
  if (Assigned(FFusionAIDockForm)) and (FFusionAIDockForm.Showing) then
  begin
    TSingletonSettingObj.RegisterFormClassForTheming(TDockableForm, FFusionAIDockForm);
    FFusionAIDockForm.Close;
    FShouldApplyTheme := True;
  end;
end;
{$ENDIF}
{$ENDREGION}

initialization
  FFusionAISubMenu := nil;
  FFusionAIDockForm := nil;

finalization
  RemoveAferUnInstall;
end.
