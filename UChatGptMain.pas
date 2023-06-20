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
              mtOptimize, mtCompleteCode, mtExplain, mtRefactor);

{*********************************************************}
{                                                         }
{           This menu item will be added                  }
{           into the main menu of the IDE.                }
{                                                         }
{*********************************************************}
  TChatGptMenuWizard = class(TInterfacedObject, IOTAWizard)
  private
    FRoot, FAskMenu,
    FSettingMenu, FAskMenuDockable, FAboutMenu: TMenuItem;
    FSetting: TSingletonSettingObj;

    FAskSubMenuH, FAddTestH, FFindBugsH, //These hidden menues usre used for better Ux expreince with shortcuts.
    FOptimizeH, FAddCommentsH, FCompleteCodeH: TMenuItem;

    procedure AskMenuClick(Sender: TObject);
    procedure ChatGPTDockableMenuClick(Sender: TObject);
    procedure ChatGPTSettingMenuClick(Sender: TObject);
    procedure ChatGPTAboutMenuClick(Sender: TObject);
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
  private
    FMenuHook: TCpMenuHook;
    class function GetQuestion(AStr: string): string;
    class function CreateMsg(AType: TMsgType): string;
    class procedure FormatSource;
    function GetCurrentUnitPath: string;
    class function GetSelectedText: string;
    class procedure RunInlineQuestion(AQuestion: string; AMsgType: TMsgType);
    class procedure DoAskSubMenu;
    class procedure DoAddTest;
    class procedure DoFindBugs;
    class procedure DoOptimize;
    class procedure DoAddComments;
    class procedure DoCompleteCode;
    class procedure DoExplain;
    class procedure DoRefactor;
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
  end;

{*******************************************************}
{                                                       }
{   This is the dockable form of the plugin.              }
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
    FChatGPTSubMenu: TCpMenuItemDef;
    FChatGPTDockForm: TChatGPTDockForm;
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
    with Frm_Setting do
    begin
      Edt_ApiKey.Text := FSetting.ApiKey;
      Edt_Url.Text := FSetting.URL;
      Edt_MaxToken.Text := FSetting.MaxToken.ToString;
      Edt_Temperature.Text := FSetting.Temperature.ToString;
      cbbModel.ItemIndex := Frm_Setting.cbbModel.Items.IndexOf(FSetting.Model);
      Edt_SourceIdentifier.Text := FSetting.Identifier;
      chk_CodeFormatter.Checked := FSetting.CodeFormatter;
      chk_Rtl.Checked := FSetting.RighToLeft;
      chk_History.Checked := FSetting.HistoryEnabled;
      lbEdt_History.Text := FSetting.HistoryPath;
      lbEdt_History.Enabled := FSetting.HistoryEnabled;
      Btn_HistoryPathBuilder.Enabled := FSetting.HistoryEnabled;
      ColorBox_Highlight.Selected := FSetting.HighlightColor;
      chk_AnimatedLetters.Checked := FSetting.AnimatedLetters;
      lbEdt_Timeout.Text := FSetting.TimeOut.ToString;
      AddAllDefinedQuestions;

      chk_WriteSonic.Checked := FSetting.EnableWriteSonic;
      lbEdt_WriteSonicAPIKey.Text := FSetting.WriteSonicAPIKey;
      lbEdt_WriteSonicBaseURL.Text := FSetting.WriteSonicBaseURL;
      lbEdt_WriteSonicAPIKey.Enabled := FSetting.EnableWriteSonic;
      lbEdt_WriteSonicBaseURL.Enabled := FSetting.EnableWriteSonic;

      chk_YouChat.Checked := FSetting.EnableYouChat;
      lbEdt_YouChatAPIKey.Text := FSetting.YouChatAPIKey;
      lbEdt_YouChatBaseURL.Text := FSetting.YouChatBaseURL;
      lbEdt_YouChatAPIKey.Enabled := FSetting.EnableYouChat;
      lbEdt_YouChatBaseURL.Enabled := FSetting.EnableYouChat;

      ShowModal;
    end;
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
  end;

  if not Assigned(FSettingMenu) then
  begin
    FSettingMenu := TMenuItem.Create(nil);
    FSettingMenu.Name := 'Mnu_ChatGPTSetting';
    FSettingMenu.Caption := 'ChatGPT Setting';
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
  {$ENDREGION}

  if not Assigned(FAskMenuDockable) then
  begin
    FAskMenuDockable := TMenuItem.Create(nil);
    FAskMenuDockable.Name := 'Mnu_ChatGPTDockable';
    FAskMenuDockable.Caption := 'ChatGPT Dockabale';
    FAskMenuDockable.OnClick := ChatGPTDockableMenuClick;
  end;

  if not Assigned(FAboutMenu) then
  begin
    FAboutMenu := TMenuItem.Create(nil);
    FAboutMenu.Name := 'Mnu_ChatGPTAbout';
    FAboutMenu.Caption := 'About';
    FAboutMenu.OnClick := ChatGPTAboutMenuClick;
    FAboutMenu.ImageIndex := 50;
  end;

  if not Assigned(FRoot) then
  begin
    FRoot := TMenuItem.Create(nil);
    FRoot.Caption := 'ChatGPT';
    FRoot.Name := 'ChatGPTRootMenu';
    FRoot.Add(FAskMenu);
    FRoot.Add(FAskMenuDockable);
    FRoot.Add(FSettingMenu);
    FRoot.Add(FAskSubMenuH);
    FRoot.Add(FAddTestH);
    FRoot.Add(FFindBugsH);
    FRoot.Add(FOptimizeH);
    FRoot.Add(FAddCommentsH);
    FRoot.Add(FCompleteCodeH);
    FRoot.Add(FAboutMenu);
  end;

  if not Assigned((BorlandIDEServices as INTAServices).MainMenu.Items.Find('ChatGPTRootMenu')) then
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
          if LvRootMenu.Name = 'ChatGPTRootMenu' then
          begin
            LvImgList := LvRootMenu.GetImageList;
            if Assigned(LvImgList) then
            begin
              try
                FAskMenu.ImageIndex := LvImgList.Add(LvBmp, nil);
                FAskMenuDockable.ImageIndex := FAskMenu.ImageIndex;
              except
                FAskMenu.ImageIndex := 1;
                FAskMenuDockable.ImageIndex := 1;
              end;
            end;
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
    tsWriteSonicAnswer.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableWriteSonic);
    tsYouChat.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableYouChat);

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
    end;
  end;
end;

procedure TEditNotifierHelper.OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
begin
  TSingletonSettingObj.Instance.ReadRegistry;
  if not Assigned(MenuItem.Find('Ask')) then
  begin
    AddMenuItem(MenuItem, 'ChatGPTAskSubMenu', 'Ask', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+A', 0);
    AddMenuItem(MenuItem, 'ChatGPTAddTest', 'Add Test', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+T', 1);
    AddMenuItem(MenuItem, 'ChatGPTFindBugs', 'Find Bugs', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+B', 2);
    AddMenuItem(MenuItem, 'ChatGPTOptimize', 'Optimize', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+O', 3);
    AddMenuItem(MenuItem, 'ChatGPTAddComments', 'Add Comments', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+M', 4);
    AddMenuItem(MenuItem, 'ChatGPTCompleteCode', 'Complete Code', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+k', 5);
    AddMenuItem(MenuItem, 'ChatGPTExplain', 'Explain Code', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+E', 6);
    AddMenuItem(MenuItem, 'ChatGPTRefactor', 'Refactor Code', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+R', 7);
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
  end;

  Result := CRLF + '{' + LcLeftComment + LvComment + LcRightComment + CRLF +
    AInput.Text + '}';
end;

class procedure TEditNotifierHelper.RunInlineQuestion(AQuestion: string; AMsgType: TMsgType);
begin
  if not TSingletonSettingObj.Instance.ApiKey.Trim.IsEmpty then
  begin
    Frm_Progress := TFrm_Progress.Create(nil);
    try
      Frm_Progress.SelectedText := AQuestion;
      TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Progress, Frm_Progress); //Apply Theme
      Frm_Progress.ShowModal;
      if not Frm_Progress.Answer.Text.Trim.IsEmpty then
      begin
        WriteIntoEditor(RefineText(Frm_Progress.Answer, AMsgType));

        if not (Frm_Progress.HasError) and (TSingletonSettingObj.Instance.CodeFormatter) then
          TEditNotifierHelper.FormatSource;
      end;
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
    FChatGPTSubMenu := TCpMenuItemDef.Create('ChatGPTSubMenu', 'ChatGPT', nil, ipAfter, 'ChatGPTSubMenu');
    FChatGPTSubMenu.OnCreated := OnChatGPTSubMenuClick;
    FMenuHook.AddMenuItemDef(FChatGPTSubMenu);
  end;
end;

constructor TEditNotifierHelper.Create;
begin
  inherited Create;
  FMenuHook := TCpMenuHook.Create(nil);
end;

class function TEditNotifierHelper.CreateMsg(AType: TMsgType): string;
var
  LeftIdentifier: string;
  RightIdentifier: string;
begin
  case AType of
    mtNormalQuestion:
    begin
      Cs.Enter;
      LeftIdentifier := TSingletonSettingObj.Instance.LeftIdentifier;
      RightIdentifier := TSingletonSettingObj.Instance.RightIdentifier;
      Cs.Leave;

      Result := 'There is no selected text with the ChatGPT Plug-in''s desired format, follow the below sample, please.' +
                   #13 + LeftIdentifier + ' Any Question... ' + RightIdentifier;
    end;

    mtAddTest,
    mtFindBugs,
    mtOptimize,
    mtCompleteCode,
    mtExplain: Result := 'There is no selected text.';
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
    //If it is a ChatGPT question
    if (SameStr(LeftStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.LeftIdentifier)) and (SameStr(RightStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.RightIdentifier)) then
      RunInlineQuestion(GetQuestion(LvSelectedText), mtNormalQuestion)
    else
      ShowMessage(CreateMsg(mtNormalQuestion));
  end
  else
    ShowMessage(CreateMsg(mtNormalQuestion));
end;

class procedure TEditNotifierHelper.DoAddTest;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuAddTest + #13 + LvSelectedText, mtAddTest)
  else
    ShowMessage(CreateMsg(mtAddTest));
end;

class procedure TEditNotifierHelper.DoFindBugs;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuFindBugs + #13 + LvSelectedText, mtFindBugs)
  else
    ShowMessage(CreateMsg(mtFindBugs));
end;

class procedure TEditNotifierHelper.DoOptimize;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuOptimize + #13 + LvSelectedText, mtOptimize)
  else
    ShowMessage(CreateMsg(mtOptimize));
end;

class procedure TEditNotifierHelper.DoAddComments;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuAddComments + #13 + LvSelectedText, mtAddComment)
  else
    ShowMessage(CreateMsg(mtAddTest));
end;

class procedure TEditNotifierHelper.DoCompleteCode;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuCompleteCode + #13 + LvSelectedText, mtCompleteCode)
  else
    ShowMessage(CreateMsg(mtCompleteCode));
end;

class procedure TEditNotifierHelper.DoExplain;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuExplain + #13 + LvSelectedText, mtExplain)
  else
    ShowMessage(CreateMsg(mtExplain));
end;

class procedure TEditNotifierHelper.DoRefactor;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(ContextMenuRefactor + #13 + LvSelectedText, mtRefactor)
  else
    ShowMessage(CreateMsg(mtOptimize));
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
  if not Assigned(FChatGPTSubMenu) then
    AddEditorContextMenu;

  LvCurrentUnitName := GetCurrentUnitPath;

  Cs.Enter;
  if Assigned(FChatGPTDockForm) and (FChatGPTDockForm.Showing) and (FChatGPTDockForm.Fram_Question.pgcMain.ActivePageIndex = 1) and
    (not LvCurrentUnitName.Equals(TSingletonSettingObj.Instance.CurrentActiveViewName)) then
  begin
    TSingletonSettingObj.Instance.CurrentActiveViewName := LvCurrentUnitName;
    Cs.Leave;

    if Assigned(FChatGPTDockForm) then
    begin
      with FChatGPTDockForm.Fram_Question do
      begin
        if (pgcMain.ActivePage = tsClassView) and (not ClassViewIsBusy) then
          ReloadClassList(FChatGPTDockForm.FDockFormClassListObj);
      end;
    end;
  end;
end;

class procedure TEditNotifierHelper.FormatSource;
var
  LvEditorPopUpMenu: TPopupMenu;
begin
  LvEditorPopUpMenu := TPopupMenu((BorlandIDEServices as IOTAEditorServices).TopView.GetEditWindow.Form.FindComponent('EditorLocalMenu'));
  if LvEditorPopUpMenu <> nil then
    LvEditorPopUpMenu.Items.Find('Format Source').Click;
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

class function TEditNotifierHelper.GetSelectedText: string;
var
  LvEditView: IOTAEditView;
  LvEditBlock: IOTAEditBlock;
begin
  Result := '';
  if TSingletonSettingObj.Instance.ApiKey = '' then
  begin
    if TSingletonSettingObj.Instance.GetSetting.Trim.IsEmpty then
      Exit;
  end;

  if Supports(BorlandIDEServices, IOTAEditorServices) then
  begin
    LvEditView := (BorlandIDEServices as IOTAEditorServices).TopView;

    // Get the selected text in the edit view
    LvEditBlock := LvEditView.GetBlock;

    if (LvEditBlock.StartingColumn <> LvEditBlock.EndingColumn) or (LvEditBlock.StartingRow <> LvEditBlock.EndingRow) then
      Result := LvEditBlock.Text;
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
  FChatGPTDockForm := nil;
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
  Cs.Enter;
  Fram_Question.tsWriteSonicAnswer.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableWriteSonic);
  Fram_Question.tsYouChat.TabVisible := (CompilerVersion >= 32) and (TSingletonSettingObj.Instance.EnableYouChat);
  Cs.Leave;
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
      with FChatGPTDockForm.Fram_Question do
      begin
        HistoryGrid.ParentColor := False;
        if (BorlandIDEServices as IOTAIDEThemingServices).ActiveTheme = 'Dark' then
          HistoryGrid.Color := $006B5E4F
        else
          HistoryGrid.Color := $00EBDDCD;
        tsChatGPT.StyleElements := [seFont, seBorder];
        pnlTop.StyleElements := [seFont, seBorder];
        pnlTop.ParentColor := False;
        pnlTop.Color := FChatGPTDockForm.Color;
        pnlQuestion.ParentColor := False;
        pnlQuestion.Color := FChatGPTDockForm.Color;
      end;
    end;
    FChatGptMenuWizard.FAskMenuDockable.Click;
  end;
end;

procedure TStylingNotifier.ChangingTheme;
begin
  if (Assigned(FChatGPTDockForm)) and (FChatGPTDockForm.Showing) then
  begin
    TSingletonSettingObj.RegisterFormClassForTheming(TDockableForm, FChatGPTDockForm);
    FChatGPTDockForm.Close;
    FShouldApplyTheme := True;
  end;
end;
{$ENDIF}
{$ENDREGION}

initialization
  FChatGPTSubMenu := nil;
  FChatGPTDockForm := nil;

finalization
  RemoveAferUnInstall;
end.
