unit ToolsAPIWrapper;

interface
uses
  ToolsAPI, System.SysUtils;

type
  TCreator = class(TInterfacedObject, IOTAModuleCreator)
  public
  constructor Create(const CreatorType: string);
    { IOTAModuleCreator }
    function GetAncestorName: string;
    function GetImplFileName: string;
    function GetIntfFileName: string;
    function GetFormName: string;
    function GetMainForm: Boolean;
    function GetShowForm: Boolean;
    function GetShowSource: Boolean;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    procedure FormCreated(const FormEditor: IOTAFormEditor);
    { IOTACreator }
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
  private
    FCreatorType: string;
  end;

  TFile = class(TInterfacedObject, IOTAFile)
  public
    constructor Create(const Source: string);
    function GetSource: string;
    function GetAge: TDateTime;
  private
    FSource: string;
end;

implementation

function TCreator.GetOwner: IOTAModule;
var
  I: Integer;
  Svc: IOTAModuleServices;
  Module: IOTAModule;
  Project: IOTAProject;
  Group: IOTAProjectGroup;
begin
  { Return the current project. }
  Supports(BorlandIDEServices, IOTAModuleServices, Svc);
  Result := nil;
  for I := 0 to Svc.ModuleCount - 1 do
  begin
    Module := Svc.Modules[I];
    if Supports(Module, IOTAProject, Project) then
    begin
      { Remember the first project module}
      if Result = nil then
        Result := Project;
    end
    else if Supports(Module, IOTAProjectGroup, Group) then
    begin
      { Found the project group, so return its active project}
      Result := Group.ActiveProject;
      Exit;
    end;
  end;
end;

function TCreator.NewImplSource(
                    const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
var
  FormSource: string;
begin
  FormSource :=
  '{ ----------------------------------------------------------------- ' +   #13#10 +
  '%s - description'+   #13#10 +
  'Copyright ©  %y Your company, inc.'+   #13#10 +
  'Created on %d'+   #13#10 +
  'By %u'+   #13#10 +
  ' ----------------------------------------------------------------- }' +   #13#10 +   #13#10;
  Result := TFile.Create(Format(FormSource, ModuleIdent, FormIdent, AncestorIdent));
end;


constructor TFile.Create(const Source: string);
begin
  FSource := Source;
end;
  function TFile.GetSource: string;
begin
  Result := FSource;
end;
  function TFile.GetAge: TDateTime;
begin
  Result := TDateTime(-1);
end;

end.
