unit UChatGPTMenuHook;

{    This unit is a refinemented version of the CnMenuHook unit which is
     originally wrriten by Zhou Jinyu (zjy@cnpack.org) in Cnwizard project.
     More info: https://github.com/cnpack/cnwizards
}

{**************************************************************************************************}
{    Remarks:                                                                                      }
{    -This unit is used to realize the hooking operation of the PopupMenu inside the IDE,          }
{      by modifying the OnPopup event, delete the custom menu before popping up,                   }
{      execute the original OnPopup and then restart, add a new defined menu to                    }
{      realize the function of custom menu.                                                        }
{    -This method is adopted because directly modifying the PopupMenu may cause errors in the IDE. }
{    -Comments are translated, original comments are in Chinese.                                   }
{**************************************************************************************************}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.ActnList, Vcl.Menus, System.Contnrs;

type

{ TCpAbstractMenuItemDef }

  TCpMenuItemInsertPos = (ipFirst, ipLast, ipAfter, ipBefore);
  TCpMenuItemStatus = set of (msVisible, msEnabled, msChecked);

  TCpAbstractMenuItemDef = class(TObject)
  private
    FActive: Boolean;
  protected
    function GetName: string; virtual; abstract;
    function GetInsertPos: TCpMenuItemInsertPos; virtual; abstract;
    function GetRelItemName: string; virtual; abstract;
    function GetCaption: string; virtual; abstract;
    function GetHint: string; virtual; abstract;
    function GetStatus : TCpMenuItemStatus; virtual; abstract;
    function GetAction: TCustomAction; virtual; abstract;
    function GetImageIndex: Integer; virtual; abstract;
    function GetShortCut: TShortCut; virtual; abstract;

    procedure MenuItemCreated(MenuItem: TMenuItem); virtual; abstract;
    {This method is called when the user menu item is created}
  public
    procedure Execute(Sender: TObject); virtual; abstract;
    {menu item execution method}

    property Active: Boolean read FActive write FActive;
    {Whether the menu item definition is valid, if not, the menu will not be created automatically}
    property Name: string read GetName;
    {The component name of the menu item}
    property InsertPos: TCpMenuItemInsertPos read GetInsertPos;
    {The insertion position of the user menu item}
    property RelItemName: string read GetRelItemName;
    {When InsertPos is ipAfter, ipBefore, the relative original menu name}
    property Caption: string read GetCaption;
    {Title of the menu item}
    property Hint: string read GetHint;
    {Tooltips for menu items}
    property Status: TCpMenuItemStatus read GetStatus;
    {the state of the menu item}
    property Action: TCustomAction read GetAction;
    {The Action corresponding to the menu item}
    property ImageIndex: Integer read GetImageIndex;
    {The ImageIndex corresponding to the menu item}
    property ShortCut: TShortCut read GetShortCut;
    {The shortcut key corresponding to the menu item}
  end;

//==============================================================================
// Common user menu item class
//==============================================================================

{ TCpMenuItemDef }

  TMenuItemCreatedEvent = procedure (Sender: TObject; MenuItem: TMenuItem) of object;

  TCpMenuItemDef = class(TCpAbstractMenuItemDef)
  private
    FName: string;
    FInsertPos: TCpMenuItemInsertPos;
    FRelItemName: string;
    FCaption: string;
    FHint: string;
    FAction: TCustomAction;
    FImageIndex: Integer;
    FShortCut: TShortCut;
    FStatus: TCpMenuItemStatus;
    FOnClick: TNotifyEvent;
    FOnCreated: TMenuItemCreatedEvent;
  protected
    function GetName: string; override;
    function GetInsertPos: TCpMenuItemInsertPos; override;
    function GetRelItemName: string; override;
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetStatus: TCpMenuItemStatus; override;
    function GetAction: TCustomAction; override;
    function GetImageIndex: Integer; override;
    function GetShortCut: TShortCut; override;
    procedure MenuItemCreated(MenuItem: TMenuItem); override;
  public
    constructor Create(const AName, ACaption: string; AOnClick: TNotifyEvent;
      AInsertPos: TCpMenuItemInsertPos; const ARelItemName: string = '';
      const AHint: string = ''; AAction: TCustomAction = nil; ImgIndex: Integer = -1;
      AShortCut: TShortCut = 0);
    destructor Destroy; override;
    procedure Execute(Sender: TObject); override;

    procedure SetCaption(const Value: string);
    procedure SetHint(const Value: string);
    procedure SetImageIndex(Value: Integer);
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnCreated: TMenuItemCreatedEvent read FOnCreated write FOnCreated;
    {Called when the menu item is dynamically created, the user can modify the menu properties in this event}
  end;

//==============================================================================
// Separate menu item classes
//==============================================================================

{ TCpSepMenuItemDef }

  TCpSepMenuItemDef = class(TCpMenuItemDef)
  public
    constructor Create(AInsertPos: TCpMenuItemInsertPos; const ARelItemName: string);
  end;

//==============================================================================
// Hooked TPopupMenu menu object data class
//==============================================================================

{ TMenuObj }

  TMenuObj = class(TObject)
  private
    FOldOnPopup: TNotifyEvent;
    FMenu: TPopupMenu;
  public
    constructor Create(AMenu: TPopupMenu; ANewOnPopup: TNotifyEvent);
    destructor Destroy; override;
    property Menu: TPopupMenu read FMenu;
    property OldOnPopup: TNotifyEvent read FOldOnPopup;
  end;

//==============================================================================
// Menu hook manager
//==============================================================================

{ TCpMenuHook }

  TMenuPopupEvent = procedure (Sender: TObject; Menu: TPopupMenu) of object;

  TCpMenuHook = class(TComponent)
  private
    FMenuList: TObjectList;
    FMenuItemDefList: TObjectList;
    FActive: Boolean;
    FOnAfterPopup: TMenuPopupEvent;
    FOnBeforePopup: TMenuPopupEvent;
    procedure SetActive(const Value: Boolean);
    function GetMenuItemDef(Index: Integer): TCpAbstractMenuItemDef;
    function GetMenuItemDefCount: Integer;
  protected
    function GetMenuObj(AMenu: TPopupMenu): TMenuObj;
    procedure OnMenuPopup(Sender: TObject); virtual;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;

    function FindMenuItem(AMenu: TPopupMenu; const AName: string): TMenuItem;
    procedure DoRemoveMenuItem(AMenu: TPopupMenu; const AName: string);
    procedure DoAddMenuItem(AMenu: TPopupMenu; AItem: TCpAbstractMenuItemDef);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure HookMenu(AMenu: TPopupMenu);
    {Hook a PopupMenu menu}
    procedure UnHookMenu(AMenu: TPopupMenu);
    {Unhook the PopupMenu menu}
    function IsHooked(AMenu: TPopupMenu): Boolean;
    {Determine whether the PopupMenu menu has been linked}

    function AddMenuItemDef(AItem: TCpAbstractMenuItemDef): Integer;
    {Add a user menu item definition, return list index number}
    procedure RemoveMenuItemDef(AItem: TCpAbstractMenuItemDef);
    {Remove a user menu item definition}
    function IndexOfMenuItemDef(const AName: string): Integer;
    {Find the index number of the specified menu in the list}

    property Active: Boolean read FActive write SetActive;
    {Menu hook active property}
    property MenuItemDefCount: Integer read GetMenuItemDefCount;
    {User menu item definition count}
    property MenuItemDefs[Index: Integer]: TCpAbstractMenuItemDef read GetMenuItemDef;
    {Array of user menu item definitions}
    property OnBeforePopup: TMenuPopupEvent read FOnBeforePopup write FOnBeforePopup;
    {The event before the hooked menu pops up. At this time, the user menu item has been released, and the user can perform special processing here}
    property OnAfterPopup: TMenuPopupEvent read FOnAfterPopup write FOnAfterPopup;
    {The event after the hooked menu pops up. At this time, the user menu item has been created, and the user can perform special processing here}
  end;

implementation

const
  csMenuItemTag = $8080;

//==============================================================================
// Common user menu item class
//==============================================================================

{ TCpMenuItemDef }

constructor TCpMenuItemDef.Create(const AName, ACaption: string;
  AOnClick: TNotifyEvent; AInsertPos: TCpMenuItemInsertPos; const ARelItemName,
  AHint: string; AAction: TCustomAction; ImgIndex: Integer; AShortCut: TShortCut);
begin
  inherited Create;
  FActive := True;
  FStatus := [msVisible, msEnabled];
  FName := AName;
  FCaption := ACaption;
  FOnClick := AOnClick;
  FInsertPos := AInsertPos;
  FRelItemName := ARelItemName;
  FHint := AHint;
  FAction := AAction;
  FImageIndex := ImgIndex;
  FShortCut := AShortCut;
  FOnCreated := nil;
end;

destructor TCpMenuItemDef.Destroy;
begin
  inherited;
end;

procedure TCpMenuItemDef.Execute(Sender: TObject);
begin
  if Assigned(FOnClick) then
    FOnClick(Sender);
end;

function TCpMenuItemDef.GetAction: TCustomAction;
begin
  Result := FAction;
end;

function TCpMenuItemDef.GetCaption: string;
begin
  Result := FCaption;
end;

function TCpMenuItemDef.GetHint: string;
begin
  Result := FHint;
end;

function TCpMenuItemDef.GetInsertPos: TCpMenuItemInsertPos;
begin
  Result := FInsertPos;
end;

function TCpMenuItemDef.GetName: string;
begin
  Result := FName;
end;

function TCpMenuItemDef.GetRelItemName: string;
begin
  Result := FRelItemName;
end;

function TCpMenuItemDef.GetStatus: TCpMenuItemStatus;
begin
  Result := FStatus;
end;

procedure TCpMenuItemDef.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TCpMenuItemDef.SetHint(const Value: string);
begin
  FHint := Value;
end;

procedure TCpMenuItemDef.MenuItemCreated(MenuItem: TMenuItem);
begin
  if Assigned(FOnCreated) then
    FOnCreated(Self, MenuItem);
end;

function TCpMenuItemDef.GetImageIndex: Integer;
begin
  Result := FImageIndex;
end;

procedure TCpMenuItemDef.SetImageIndex(Value: Integer);
begin
  FImageIndex := Value;
end;

//==============================================================================
// Separate menu item classes
//==============================================================================

function TCpMenuItemDef.GetShortCut: TShortCut;
begin
  Result := FShortCut;
end;

{ TCpSepMenuItemDef }

constructor TCpSepMenuItemDef.Create(AInsertPos: TCpMenuItemInsertPos; const ARelItemName: string);
begin
  inherited Create('', '-', nil, AInsertPos, ARelItemName, '', nil);
end;

//==============================================================================
// Hooked TPopupMenu menu object data class
//==============================================================================

{ TMenuObj }

constructor TMenuObj.Create(AMenu: TPopupMenu; ANewOnPopup: TNotifyEvent);
begin
  inherited Create;
  FMenu := AMenu;
  FOldOnPopup := FMenu.OnPopup;
  FMenu.OnPopup := ANewOnPopup;
end;

destructor TMenuObj.Destroy;
begin
  FMenu.OnPopup := FOldOnPopup;
  inherited;
end;

//==============================================================================
// Menu hook manager
//==============================================================================

{ TCpMenuHook }

constructor TCpMenuHook.Create(AOwner: TComponent);
begin
  inherited;
  FMenuList := TObjectList.Create;
  FMenuItemDefList := TObjectList.Create;
  FActive := True;
  FOnAfterPopup := nil;
  FOnBeforePopup := nil;
end;

destructor TCpMenuHook.Destroy;
begin
  FMenuItemDefList.Free;
  FMenuList.Free;
  inherited;
end;

//------------------------------------------------------------------------------
// Menu item handling
//------------------------------------------------------------------------------

function TCpMenuHook.FindMenuItem(AMenu: TPopupMenu; const AName: string): TMenuItem;
var
  I: Integer;
begin
  Result := nil;
  if (AMenu = nil) or (AName = '') then
    Exit;

  for I := 0 to AMenu.Items.Count - 1 do
  begin
    if SameText(AMenu.Items[I].Name, AName) then
    begin
      Result := AMenu.Items[I];
      Exit;
    end;
  end;
end;

procedure TCpMenuHook.DoAddMenuItem(AMenu: TPopupMenu; AItem: TCpAbstractMenuItemDef);
var
  LvMenuItem, LvRelItem: TMenuItem;
  Idx: Integer;
begin
  Assert(Assigned(AMenu));
  Assert(Assigned(AItem));

  if FActive and AItem.Active then
  begin
    LvMenuItem := FindMenuItem(AMenu, AItem.Name);
    if not Assigned(LvMenuItem) then
    begin
      LvMenuItem := TMenuItem.Create(AMenu);
      LvMenuItem.Name := AItem.Name;

      LvRelItem := FindMenuItem(AMenu, AItem.RelItemName);
      Idx := 0;
      case AItem.InsertPos of
        ipFirst: Idx := 0;
        ipLast: Idx := AMenu.Items.Count;
        ipAfter:
          if Assigned(LvRelItem) then
            Idx := LvRelItem.MenuIndex + 1
          else
            Idx := AMenu.Items.Count;
        ipBefore:
          if Assigned(LvRelItem) then
            Idx := LvRelItem.MenuIndex
          else
            Idx := 0;
      end;

      AMenu.Items.Insert(Idx, LvMenuItem);
    end;

    // Define a Tag to mark the custom menu without Name
    LvMenuItem.Tag := csMenuItemTag;
    LvMenuItem.Caption := AItem.Caption;
    LvMenuItem.Hint := AItem.Hint;
    LvMenuItem.Enabled := msEnabled in AItem.Status;
    LvMenuItem.Visible := msVisible in AItem.Status;
    LvMenuItem.Checked := msChecked in AItem.Status;
    LvMenuItem.ImageIndex := AItem.ImageIndex;
    LvMenuItem.ShortCut := AItem.ShortCut;
    LvMenuItem.OnClick := AItem.Execute;
    LvMenuItem.Action := AItem.Action;

    AItem.MenuItemCreated(LvMenuItem);
  end
end;

procedure TCpMenuHook.DoRemoveMenuItem(AMenu: TPopupMenu; const AName: string);
var
  LvItem: TMenuItem;
begin
  LvItem := FindMenuItem(AMenu, AName);
  if Assigned(LvItem) then
    LvItem.Free;
end;

//------------------------------------------------------------------------------
// Menu hook handling
//------------------------------------------------------------------------------

function TCpMenuHook.GetMenuObj(AMenu: TPopupMenu): TMenuObj;
var
  I: Integer;
begin
  for I := 0 to FMenuList.Count - 1 do
  begin
    if TMenuObj(FMenuList[I]).Menu = AMenu then
    begin
      Result := TMenuObj(FMenuList[I]);
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TCpMenuHook.HookMenu(AMenu: TPopupMenu);
begin
  if not IsHooked(AMenu) then
  begin
    FMenuList.Add(TMenuObj.Create(AMenu, OnMenuPopup));
    AMenu.FreeNotification(Self);
  end;
end;

procedure TCpMenuHook.UnHookMenu(AMenu: TPopupMenu);
var
  LvObj: TMenuObj;
begin
  LvObj := GetMenuObj(AMenu);
  if Assigned(LvObj) then
  begin
    LvObj.Menu.RemoveFreeNotification(Self);
    FMenuList.Remove(LvObj);
  end;
end;

function TCpMenuHook.IsHooked(AMenu: TPopupMenu): Boolean;
begin
  Result := Assigned(GetMenuObj(AMenu));
end;

procedure TCpMenuHook.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited;
  if (AOperation = opRemove) and (AComponent is TPopupMenu) then
    UnHookMenu(AComponent as TPopupMenu)
end;

//------------------------------------------------------------------------------
// Added menu hook item processing
//------------------------------------------------------------------------------

function TCpMenuHook.AddMenuItemDef(AItem: TCpAbstractMenuItemDef): Integer;
begin
  Result := FMenuItemDefList.IndexOf(AItem);
  if Result < 0 then
    Result := FMenuItemDefList.Add(AItem);
end;

procedure TCpMenuHook.RemoveMenuItemDef(AItem: TCpAbstractMenuItemDef);
begin
  FMenuItemDefList.Remove(AItem);
end;

function TCpMenuHook.IndexOfMenuItemDef(const AName: string): Integer;
var
  I: Integer;
begin
  for I := 0 to MenuItemDefCount - 1 do
  begin
    if SameText(MenuItemDefs[I].Name, AName) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function TCpMenuHook.GetMenuItemDefCount: Integer;
begin
  Result := FMenuItemDefList.Count;
end;

function TCpMenuHook.GetMenuItemDef(Index: Integer): TCpAbstractMenuItemDef;
begin
  Result := TCpAbstractMenuItemDef(FMenuItemDefList[Index]);
end;

procedure TCpMenuHook.OnMenuPopup(Sender: TObject);
var
  LvMenu: TPopupMenu;
  LvMenuObj: TMenuObj;
  I: Integer;
begin
  if not (Sender is TPopupMenu) then
    Exit;

  LvMenu := Sender as TPopupMenu;

  // The previously registered menu must be cleared first, otherwise an error will occur
  for I := 0 to MenuItemDefCount - 1 do
    DoRemoveMenuItem(LvMenu, MenuItemDefs[I].Name);

  // Remove unnamed menu items based on Tag
  for I := LvMenu.Items.Count - 1 downto 0 do
    if LvMenu.Items[I].Tag = csMenuItemTag then
      LvMenu.Items[I].Free;

  if Assigned(FOnBeforePopup) then
    FOnBeforePopup(Self, LvMenu);

  // call the original event
  LvMenuObj := GetMenuObj(LvMenu);
  if Assigned(LvMenuObj) then
    if Assigned(LvMenuObj.OldOnPopup) then
      LvMenuObj.OldOnPopup(Sender);

  // If the menu item itself has no content, the description will not pop up, and no content will be added here to avoid forced pop-up
  if LvMenu.Items.Count = 0 then
    Exit;

  if Active then
  begin
    // Re-update custom menu items
    for I := 0 to MenuItemDefCount - 1 do
      if MenuItemDefs[I].Active then
        DoAddMenuItem(LvMenu, MenuItemDefs[I]);

    if Assigned(FOnAfterPopup) then
      FOnAfterPopup(Self, LvMenu);
  end;
end;

procedure TCpMenuHook.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

end.
