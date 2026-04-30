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
  TCpLexer = class
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

function StripInlineComment(const ALine: string): string;
var
  I: Integer;
  LInSingleQuote: Boolean;
begin
  Result := '';
  LInSingleQuote := False;
  I := 1;
  while I <= Length(ALine) do
  begin
    if ALine[I] = '''' then
    begin
      Result := Result + ALine[I];
      if (I < Length(ALine)) and (ALine[I + 1] = '''') then
      begin
        Inc(I);
        Result := Result + ALine[I];
      end
      else
        LInSingleQuote := not LInSingleQuote;
    end
    else if (not LInSingleQuote) and (ALine[I] = '/') and (I < Length(ALine)) and (ALine[I + 1] = '/') then
      Break
    else
      Result := Result + ALine[I];
    Inc(I);
  end;
end;

function NormalizeTypeName(const AName: string): string;
var
  LValue: string;
  LPos: Integer;
begin
  LValue := Trim(AName);
  LPos := Pos('<', LValue);
  if LPos > 0 then
    LValue := Trim(Copy(LValue, 1, LPos - 1));
  Result := LValue;
end;

function IsSectionBoundary(const ALineLower: string): Boolean;
begin
  Result :=
    StartsText('const', ALineLower) or
    StartsText('var', ALineLower) or
    StartsText('threadvar', ALineLower) or
    StartsText('resourcestring', ALineLower) or
    StartsText('procedure', ALineLower) or
    StartsText('function', ALineLower) or
    StartsText('constructor', ALineLower) or
    StartsText('destructor', ALineLower) or
    StartsText('operator', ALineLower) or
    StartsText('implementation', ALineLower) or
    StartsText('initialization', ALineLower) or
    StartsText('finalization', ALineLower) or
    StartsText('exports', ALineLower);
end;

function IsSupportedTypeStarter(const ALineLower: string): Boolean;
begin
  Result :=
    (Pos('= class', ALineLower) > 0) or
    (Pos('= record', ALineLower) > 0) or
    (Pos('= packed record', ALineLower) > 0) or
    (Pos('= interface', ALineLower) > 0) or
    (Pos('= dispinterface', ALineLower) > 0) or
    (Pos('= object', ALineLower) > 0) or
    (Pos('class helper', ALineLower) > 0) or
    (Pos('record helper', ALineLower) > 0) or
    (Pos('helper for', ALineLower) > 0);
end;

function CountTypeStarts(const ALineLower: string): Integer;
begin
  Result := 0;
  if IsSupportedTypeStarter(ALineLower) then
    Inc(Result);
end;

function CountTypeEnds(const ALineLower: string): Integer;
var
  LTrim: string;
begin
  LTrim := Trim(ALineLower);
  Result := 0;
  if StartsText('end', LTrim) and (Pos(';', LTrim) > 0) then
    Inc(Result);
end;

function TryExtractTypeName(const ALine: string; out ATypeName: string): Boolean;
var
  LLine: string;
  LPos: Integer;
begin
  Result := False;
  ATypeName := '';
  LLine := Trim(ALine);
  if StartsText('type ', LowerCase(LLine)) then
    LLine := Trim(Copy(LLine, 5, MaxInt));

  if (LLine = '') or (LLine[1] = '[') then
    Exit;

  LPos := Pos('=', LLine);
  if LPos <= 1 then
    Exit;

  ATypeName := NormalizeTypeName(Trim(Copy(LLine, 1, LPos - 1)));
  Result := ATypeName <> '';
end;

function IsRoutineStart(const ALineLower, ATypeNameLower: string): Boolean;
begin
  Result :=
    (ATypeNameLower <> '') and
    (Pos(ATypeNameLower + '.', ALineLower) > 0) and
    (StartsText('function', ALineLower) or
     StartsText('class function', ALineLower) or
     StartsText('procedure', ALineLower) or
     StartsText('class procedure', ALineLower) or
     StartsText('constructor', ALineLower) or
     StartsText('destructor', ALineLower) or
     StartsText('operator', ALineLower) or
     StartsText('class operator', ALineLower));
end;

function CountKeywordOccurrence(const ALineLower, AKeyword: string): Integer;
var
  LSearchFrom: Integer;
  LPos: Integer;
begin
  Result := 0;
  LSearchFrom := 1;
  repeat
    LPos := PosEx(AKeyword, ALineLower, LSearchFrom);
    if LPos > 0 then
    begin
      Inc(Result);
      LSearchFrom := LPos + Length(AKeyword);
    end;
  until LPos = 0;
end;

function ExtractRoutineImplementations(AUnitContent: TStrings; const ATypeName: string): string;
var
  I: Integer;
  J: Integer;
  LTypeNameLower: string;
  LLineLower: string;
  LTrimLower: string;
  LDepth: Integer;
  LBodyStarted: Boolean;
  LOutput: TStringList;
begin
  LOutput := TStringList.Create;
  try
    LTypeNameLower := LowerCase(ATypeName);
    I := 0;
    while I < AUnitContent.Count do
    begin
      LLineLower := LowerCase(Trim(StripInlineComment(AUnitContent[I])));
      if IsRoutineStart(LLineLower, LTypeNameLower) then
      begin
        LDepth := 0;
        LBodyStarted := False;
        J := I;
        while J < AUnitContent.Count do
        begin
          LOutput.Add(AUnitContent[J]);
          LTrimLower := LowerCase(Trim(StripInlineComment(AUnitContent[J])));

          if Pos('begin', LTrimLower) > 0 then
          begin
            Inc(LDepth, CountKeywordOccurrence(LTrimLower, 'begin'));
            LBodyStarted := True;
          end;
          if Pos('case', LTrimLower) > 0 then
            Inc(LDepth, CountKeywordOccurrence(LTrimLower, 'case'));
          if Pos('try', LTrimLower) > 0 then
            Inc(LDepth, CountKeywordOccurrence(LTrimLower, 'try'));
          if Pos('asm', LTrimLower) > 0 then
            Inc(LDepth, CountKeywordOccurrence(LTrimLower, 'asm'));
          if Pos('repeat', LTrimLower) > 0 then
            Inc(LDepth, CountKeywordOccurrence(LTrimLower, 'repeat'));

          if StartsText('until', LTrimLower) and LBodyStarted then
            Dec(LDepth);

          if StartsText('end', LTrimLower) and (Pos(';', LTrimLower) > 0) and LBodyStarted then
          begin
            Dec(LDepth);
            if LDepth <= 0 then
              Break;
          end;

          Inc(J);
        end;
        if (LOutput.Count > 0) and (Trim(LOutput[LOutput.Count - 1]) <> '') then
          LOutput.Add('');
        I := J;
      end;
      Inc(I);
    end;

    Result := Trim(LOutput.Text);
  finally
    LOutput.Free;
  end;
end;

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
  LvTypeName: string;
  LvTempStr: TStringList;
  LvFileStream: TFileStream;
  LCurrentTypeName: string;
  LTypeSource: TStringList;
  LInsideTypeSection: Boolean;
  LBodyDetected: Boolean;
  LTypeDepth: Integer;
  LLine: string;
  LLineLower: string;
  LTypeText: string;
  LRoutineText: string;
  LStoredLines: TStringList;

  procedure ResetCurrentType;
  begin
    LCurrentTypeName := '';
    FreeAndNil(LTypeSource);
    LBodyDetected := False;
    LTypeDepth := 0;
  end;

  procedure StoreCurrentType;
  begin
    if (LCurrentTypeName = '') or (not Assigned(LTypeSource)) then
      Exit;

    if not FClassList.TryGetValue(LCurrentTypeName, LStoredLines) then
    begin
      LStoredLines := TStringList.Create;
      FClassList.Add(LCurrentTypeName, LStoredLines);
    end
    else
      LStoredLines.Clear;

    LTypeText := Trim(LTypeSource.Text);
    LRoutineText := ExtractRoutineImplementations(LvTempStr, LCurrentTypeName);
    if LRoutineText <> '' then
      LStoredLines.Text := Trim(LTypeText + sLineBreak + sLineBreak + LRoutineText)
    else
      LStoredLines.Text := LTypeText;

    ResetCurrentType;
  end;
begin
  FClassList.Clear;
  if not FileExists(ACurrentUnitPath) then
    Exit;

  LvTempStr := TStringList.Create;
  LTypeSource := nil;
  LvFileStream := TFileStream.Create(ACurrentUnitPath, fmOpenRead or fmShareDenyNone);
  try
    LvTempStr.LoadFromStream(LvFileStream);
  finally
    LvFileStream.Free;
  end;

  try
    LInsideTypeSection := False;
    LCurrentTypeName := '';
    LBodyDetected := False;
    LTypeDepth := 0;

    for I := 0 to Pred(LvTempStr.Count) do
    begin
      LLine := Trim(StripInlineComment(LvTempStr[I]));
      LLineLower := LowerCase(LLine);

      if LCurrentTypeName <> '' then
      begin
        LTypeSource.Add(LvTempStr[I]);
        if not LBodyDetected then
        begin
          if IsSupportedTypeStarter(LLineLower) then
          begin
            LBodyDetected := True;
            Inc(LTypeDepth, CountTypeStarts(LLineLower));
            Dec(LTypeDepth, CountTypeEnds(LLineLower));
            if LTypeDepth <= 0 then
              StoreCurrentType;
          end
          else if IsSectionBoundary(LLineLower) then
            ResetCurrentType;
        end
        else
        begin
          Inc(LTypeDepth, CountTypeStarts(LLineLower));
          Dec(LTypeDepth, CountTypeEnds(LLineLower));
          if LTypeDepth <= 0 then
            StoreCurrentType;
        end;
        Continue;
      end;

      if not LInsideTypeSection then
      begin
        if SameText(LLineLower, 'type') or StartsText('type ', LLineLower) then
        begin
          LInsideTypeSection := True;
          if StartsText('type ', LLineLower) then
          begin
            LLine := Trim(Copy(LLine, 5, MaxInt));
            LLineLower := LowerCase(LLine);
          end
          else
            Continue;
        end;
      end;

      if not LInsideTypeSection then
        Continue;

      if IsSectionBoundary(LLineLower) then
      begin
        LInsideTypeSection := False;
        Continue;
      end;

      if TryExtractTypeName(LLine, LvTypeName) then
      begin
        LCurrentTypeName := LvTypeName;
        LTypeSource := TStringList.Create;
        LTypeSource.Add(LvTempStr[I]);
        LBodyDetected := IsSupportedTypeStarter(LLineLower);
        if LBodyDetected then
        begin
          LTypeDepth := CountTypeStarts(LLineLower) - CountTypeEnds(LLineLower);
          if LTypeDepth <= 0 then
            StoreCurrentType;
        end
        else
          LTypeDepth := 0;
      end;
    end;

    StoreCurrentType;
  finally
    FreeAndNil(LTypeSource);
    LvTempStr.Free;
  end;
end;

procedure TcpLexer.Reload;
begin
  ParseSourceCode2(GetCurrentUnitPath); // parse code using a text-based parser that tolerates newer Delphi syntax better.
  if FClassList.Count = 0 then
    ParseSourceCode(GetCurrentUnitPath); // fallback to the legacy lexer path.
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
