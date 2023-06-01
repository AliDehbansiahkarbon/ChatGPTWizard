{***************************************************}
{                                                   }
{   This unit is a simple source code parser        }
{   to fetch classes list, classes sources, etc.    }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UChatGPTLexer;

interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  System.StrUtils, UPascalLexer, UPascalLexerTypes,
  ToolsAPI, StructureViewAPI, Vcl.Dialogs, UChatGPTSetting;

type
  TClassList = TObjectDictionary<string, TStringList>;
  TcpLexer = class
  private
    FClassList: TClassList;
    function GetCurrentUnitPath: string;
    procedure StructureViewToSL(ASL: TStringList);

    //Method 1
    procedure AddClassSource(ALexer: TmwPasLex; AClassName: string; var AClassSource: string);
    function IsClassLine(ALexer: TmwPasLex): Boolean; overload;
    function IsClassLine(ALine: string): Boolean; overload;
    function ExtractSingleClassSource(AUnitContent: TStringList; AClassName: string): string;
    procedure ParseSourceCode(ACurrentUnitPath: string); //with Lexer
    procedure ParseSourceCode2(ACurrentUnitPath: string);//Method2 whitout actuall Lexer object.
    function GetSingleClassSource(AUnitContent: TStringList; AClassName: string): string;
  public
    constructor Create(AClassList: TClassList);
    procedure Reload;
  end;

implementation

{ TcpLexer }

constructor TcpLexer.Create(AClassList: TClassList);
begin
  FClassList := AClassList;
end;

procedure TcpLexer.AddClassSource(ALexer: TmwPasLex; AClassName: string; var AClassSource: string);
var
  LvPos: Integer;
  LvRemainingCodesStr: string;
  LvRemainingCodes: TStringList;
begin
  LvRemainingCodes := TStringList.Create;
  try
    LvPos := ALexer.TokenPos;
    LvRemainingCodesStr := '';
    while ALexer.TokenID <> ptNull do
    begin
      LvRemainingCodesStr := LvRemainingCodesStr + ALexer.Token;
      ALexer.Next;
    end;
    LvRemainingCodes.Text := LvRemainingCodesStr;
    AClassSource := AClassSource + #13 + ExtractSingleClassSource(LvRemainingCodes, AClassName);
  finally
    ALexer.RunPos := LvPos;
    LvRemainingCodes.Free;
  end;
end;

function TcpLexer.ExtractSingleClassSource(AUnitContent: TStringList; AClassName: string): string;
var
  StrResult: TStringList;
  I: Integer;
  AFlag: Boolean;
begin
  AFlag := False;
  AClassName := AClassName.ToLower.Trim;
  StrResult := TStringList.Create;
  try
    for I := 0 to Pred(AUnitContent.Count) do
    begin
      if (not AFlag) and (LeftStr(AUnitContent[I].TrimLeft.ToLower, 8) = 'function') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 14) = 'class function') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 9)  = 'procedure') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 15) = 'class procedure') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 11) = 'constructor') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 10) = 'destructor')
      then
      begin
        if AUnitContent[I].ToLower.Contains(AClassName) then
        begin
          AFlag := True;
          StrResult.Add('');
        end;
      end;

      if AFlag then
      begin
        StrResult.Add(AUnitContent[I]);
        if AUnitContent[I].Trim.ToLower = 'end;' then
          AFlag := False;
      end;
    end;
  finally
    Result := StrResult.Text;
    StrResult.Free;
  end;
end;

function TcpLexer.GetCurrentUnitPath: string;
var
  ModuleServices: IOTAModuleServices;
  CurrentModule: IOTAModule;
begin
  Result := '';
  try
    ModuleServices := BorlandIDEServices as IOTAModuleServices;
    CurrentModule := ModuleServices.CurrentModule;
    if Assigned(CurrentModule) then
      Result := CurrentModule.CurrentEditor.FileName;
  except
  end;
end;

function TcpLexer.GetSingleClassSource(AUnitContent: TStringList; AClassName: string): string;
var
  StrResult: TStringList;
  I: Integer;
  AFlag: Boolean;
begin
  AFlag := False;
  AClassName := AClassName.ToLower.Trim;
  StrResult := TStringList.Create;
  try
    for I := 0 to Pred(AUnitContent.Count) do
    begin
      if LeftStr(AUnitContent[I].TrimLeft.ToUpper, 1) = 'T' then
      begin
        if (not AFlag) and
          ((RightStr(AUnitContent[I].Trim, 5).ToLower = 'class') and (AUnitContent[I].TrimLeft.Contains('='))) then
        begin
          if AClassName = StringReplace(LeftStr(AUnitContent[I].TrimLeft, Pos('=', AUnitContent[I]) - 2).Trim, '=', '', [rfReplaceAll]).Trim.ToLower then
          begin
            AFlag := True;
            StrResult.Add(AUnitContent[I].Trim); //Just add Class line and continue.
            Continue;
          end;
        end;
      end;

      if (not AFlag) and (LeftStr(AUnitContent[I].TrimLeft.ToLower, 8) = 'function') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 14) = 'class function') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 9)  = 'procedure') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 15) = 'class procedure') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 11) = 'constructor') or
         (LeftStr(AUnitContent[I].TrimLeft.ToLower, 10) = 'destructor')
      then
      begin
        if AUnitContent[I].ToLower.Contains(AClassName) then
        begin
          AFlag := True;
          StrResult.Add('');
        end;
      end;

      if AFlag then
      begin
        StrResult.Add(AUnitContent[I]);
        if AUnitContent[I].Trim.ToLower = 'end;' then
          AFlag := False;
      end;
    end;
  finally
    Result := StrResult.Text;
    StrResult.Free;
  end;
end;

function TcpLexer.IsClassLine(ALine: string): Boolean;
begin
  Result := (ALine.ToLower.Contains('class')) and (ALine.ToLower.Contains('=')) and ((RightStr(ALine.Trim, 5).ToLower = 'class') or (RightStr(ALine.Trim, 1).ToLower = ')'));
end;

function TcpLexer.IsClassLine(ALexer: TmwPasLex): Boolean;
var
  LvPos: Integer;
  LvLine: string;
  lvHasClassToken, LvHasEqualToken: Boolean;
begin
  LvPos := ALexer.TokenPos;

  try
    while ALexer.TokenID <> ptCRLF do
    begin
      LvLine := LvLine + ALexer.Token;
      if ALexer.TokenID = ptClass then
        lvHasClassToken := True;

      if ALexer.TokenID = ptEqual then
        LvHasEqualToken := True;

      ALexer.Next;
    end;
    Result := IsClassLine(LvLine) and (lvHasClassToken) and (LvHasEqualToken);
  finally
    ALexer.RunPos := LvPos;
  end;
end;

procedure TcpLexer.ParseSourceCode(ACurrentUnitPath: string);
var
  LvLexer: TmwPasLex;
  LvStartPos: Integer;
  PassedTypeIdentifier: Boolean;
  LvTempContent, LvTempClassName: string;
  LvSourceLoader: TStringList;
  LvFileStream: TFileStream;
begin
  if ACurrentUnitPath.IsEmpty then
    Exit;

  LvTempContent := '';
  PassedTypeIdentifier := False;
  FClassList.Clear;

  LvLexer := TMwPasLex.Create;
  try
    LvFileStream := TFileStream.Create(ACurrentUnitPath, fmOpenRead or fmShareDenyNone);
    try
      LvSourceLoader := TStringList.Create;
      try
        LvSourceLoader.LoadFromStream(LvFileStream);
        LvLexer.Origin := PChar(LvSourceLoader.Text);
        LvLexer.Init;
        LvLexer.Next;
      finally
        LvSourceLoader.Free;
      end;
    finally
      LvFileStream.Free;
    end;

    while (LvLexer.TokenID <> ptNull) do
    begin
      if (LvLexer.TokenID = ptType) or (PassedTypeIdentifier) then
      begin
        LvLexer.NextNoJunk;

        if (LvLexer.TokenID = ptIdentifier) and (IsClassLine(LvLexer)) then
        begin
          LvTempClassName := LvLexer.Token.Trim;
          if not FClassList.ContainsKey(LvTempClassName) then
            FClassList.Add(LvTempClassName, TStringList.Create);

          while LvLexer.TokenID <> ptEnd do
          begin
            LvTempContent := LvTempContent + LvLexer.Token;
            LvLexer.Next;

            if LvLexer.TokenID = ptEnd then
            begin
              LvTempContent := LvTempContent + LvLexer.Token;
              LvStartPos := LvLexer.TokenPos + LvLexer.TokenLen;
            end;
          end;

          LvLexer.NextNoJunk;
          if LvLexer.TokenID = ptSemiColon then
            LvTempContent := LvTempContent + LvLexer.Token;

          AddClassSource(LvLexer, LvTempClassName, LvTempContent);
          FClassList.Items[LvTempClassName].Add(LvTempContent);
          LvLexer.RunPos := LvStartPos;
        end;

        LvTempContent := '';
        PassedTypeIdentifier := True;
      end;
      LvLexer.Next;
    end;
  finally
    LvLexer.Free;
  end;
end;

procedure TcpLexer.ParseSourceCode2(ACurrentUnitPath: string);
var
  I: Integer;
  LvClassName: string;
  LvTempStr: TStringList;
  LvFileStream: TFileStream;
begin
  FClassList.Clear;
  if not FileExists(ACurrentUnitPath) then
    Exit;

  LvTempStr := TStringList.Create;
  // Open the file in read-only mode and create a file stream safely
  LvFileStream := TFileStream.Create(ACurrentUnitPath, fmOpenRead or fmShareDenyNone);
  try
    LvTempStr.LoadFromStream(LvFileStream);
  finally
    LvFileStream.Free;
  end;

  try
    //LvTempStr.LoadFromFile(ACurrentUnitPath);
    for I := 0 to Pred(LvTempStr.Count) do
    begin
      if LeftStr(LvTempStr[I].TrimLeft.ToUpper, 1) = 'T' then
      begin
        if IsClassLine(LvTempStr[I]) then
        begin
          LvClassName := StringReplace(LeftStr(LvTempStr[I].TrimLeft, Pos('=', LvTempStr[I]) - 2).Trim, '=', '', [rfReplaceAll]).TrimLeft;
          if not FClassList.ContainsKey(LvClassName) then
            FClassList.Add(LvClassName, TStringList.Create);
        end;
      end;
    end;

    for LvClassName in FClassList.Keys do
    begin
      FClassList[LvClassName].Clear;
      FClassList[LvClassName].Add(GetSingleClassSource(LvTempStr, LvClassName));
    end;
  finally
    LvTempStr.Free;
  end;
end;

procedure TcpLexer.Reload;
begin
  ParseSourceCode(GetCurrentUnitPath); //parse code using Lexer.

//  if FClassList.Count = 0 then
//    ParseSourceCode(LvUnitName); //Parse code without Lexer.
end;

procedure TcpLexer.StructureViewToSL(ASL: TStringList);
  procedure TreeToSL(ANode: IOTAStructureNode; ASL: TStringList; const APrefix: string);
  var
    I: Integer;
  begin
    ASL.Add(APrefix + ANode.Caption);
    for I := 0 to ANode.ChildCount - 1 do
      TreeToSL(ANode.Child[I], ASL, APrefix + '  ');
  end;

var
  StructureView: IOTAStructureView;
  StructureContext: IOTAStructureContext;
  Node: IOTAStructureNode;
  I: Integer;
begin
  StructureView := BorlandIDEServices as IOTAStructureView;
  StructureContext := StructureView.GetStructureContext;
  for I := 0 to Pred(StructureContext.RootNodeCount) do
  begin
    Node := StructureContext.GetRootStructureNode(I);
    if Node.Selected then
      TreeToSL(Node, ASL, '');
  end;
end;
end.
