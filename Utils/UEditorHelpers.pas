{***************************************************}
{                                                   }
{   This unit includes some helper functions to     }
{   work with Editor.                               }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UEditorHelpers;

interface
uses
  ToolsAPI, System.SysUtils, System.Classes, UConsts;

const
  EditControlClassName = 'TEditControl';
  EditControlName = 'Editor';

  function QuerySvcs(const AInstance: IUnknown; const AIntf: TGUID; out AInst): Boolean;
  function GetEditBuffer: IOTAEditBuffer;
  function GetFileEditorForModule(AModule: IOTAModule; AIndex: Integer): IOTAEditor;
  function GetSourceEditorFromModule(AModule: IOTAModule; const AFileName: string = ''): IOTASourceEditor;
  function GetCurrentModule: IOTAModule;
  function GetCurrentSourceEditor: IOTASourceEditor;
  function GetEditWriterForSourceEditor(ASourceEditor: IOTASourceEditor = nil): IOTAEditWriter;
  function ConvertTextToEditorTextW(const AText: string): AnsiString;
  function ConvertEditorTextToTextW(const Text: AnsiString): string;
  function GetCharPosFromPos(APosition: LongInt; AEditView: IOTAEditView): TOTACharPos;
  procedure InsertTextIntoEditorAtPos(const AText: string; APosition: Longint; ASourceEditor: IOTASourceEditor = nil);
  function GetTopMostEditView: IOTAEditView; overload;
  function LinePosToEditPos(ALinePos: Integer; AEditView: IOTAEditView = nil): TOTAEditPos;
  function IsEditControl(AControl: TComponent): Boolean;
  function EditPosToLinePos(AEditPos: TOTAEditPos; AEditView: IOTAEditView = nil): Integer;
  function OTAEditPos(ACol: SmallInt; ALine: Longint): TOTAEditPos;
  function GetCurrLineText(var AText: string; var ALineNo: Integer; var ACharIndex: Integer; AView: IOTAEditView = nil): Boolean;
  procedure PositionInsertText(AEditPosition: IOTAEditPosition; const AText: string);
  procedure InsertSingleLine(ALine: Integer; const AText: string; AEditView: IOTAEditView = nil);
  function GetCurrChar(OffsetX: Integer = 0; View: IOTAEditView = nil): Char;

implementation


function QuerySvcs(const AInstance: IUnknown; const AIntf: TGUID; out AInst): Boolean;
begin
  Result := (AInstance <> nil) and Supports(AInstance, AIntf, AInst);
end;

function GetEditBuffer: IOTAEditBuffer;
var
  LiEditorServices: IOTAEditorServices;
begin
  QuerySvcs(BorlandIDEServices, IOTAEditorServices, LiEditorServices);
  if LiEditorServices <> nil then
  begin
    Result := LiEditorServices.GetTopBuffer;
    Exit;
  end;
  Result := nil;
end;

function GetFileEditorForModule(AModule: IOTAModule; AIndex: Integer): IOTAEditor;
begin
  Result := nil;
  if not Assigned(AModule) then
    Exit;

  try
    Result := AModule.GetModuleFileEditor(AIndex);
  except
    Result := nil;
  end;
end;

function GetSourceEditorFromModule(AModule: IOTAModule; const AFileName: string): IOTASourceEditor;
var
  I: Integer;
  LiEditor: IOTAEditor;
  LiSourceEditor: IOTASourceEditor;
begin
  if not Assigned(AModule) then
  begin
    Result := nil;
    Exit;
  end;

  for I := 0 to AModule.GetModuleFileCount - 1 do
  begin
    LiEditor := GetFileEditorForModule(AModule, I);

    if Supports(LiEditor, IOTASourceEditor, LiSourceEditor) then
    begin
      if Assigned(LiSourceEditor) then
      begin
        if (AFileName = '') or SameFileName(LiSourceEditor.FileName, AFileName) then
        begin
          Result := LiSourceEditor;
          Exit;
        end;
      end;
    end;
  end;
  Result := nil;
end;

function GetCurrentModule: IOTAModule;
var
  LiModuleServices: IOTAModuleServices;
begin
  QuerySvcs(BorlandIDEServices, IOTAModuleServices, LiModuleServices);
  if LiModuleServices <> nil then
  begin
    Result := LiModuleServices.CurrentModule;
    Exit;
  end;
  Result := nil;
end;

function GetCurrentSourceEditor: IOTASourceEditor;
var
  LiEditBuffer: IOTAEditBuffer;
begin
  LiEditBuffer := GetEditBuffer;
  if Assigned(LiEditBuffer) and (LiEditBuffer.FileName <> '') then
    Result := GetSourceEditorFromModule(GetCurrentModule, LiEditBuffer.FileName);

  if Result = nil then
    Result := GetSourceEditorFromModule(GetCurrentModule);
end;

function GetEditWriterForSourceEditor(ASourceEditor: IOTASourceEditor = nil): IOTAEditWriter;
 resourcestring SEditWriterNotAvail = 'Edit writer not available';
begin
  if not Assigned(ASourceEditor) then
    ASourceEditor := GetCurrentSourceEditor;

  if Assigned(ASourceEditor) then
    Result := ASourceEditor.CreateUndoableWriter;

  Assert(Assigned(Result), SEditWriterNotAvail);
end;

function ConvertTextToEditorTextW(const AText: string): AnsiString;
begin
  Result := Utf8Encode(AText);
end;

procedure InsertTextIntoEditorAtPos(const AText: string; APosition: Longint; ASourceEditor: IOTASourceEditor);
var
  LvEditWriter: IOTAEditWriter;
begin
  if AText = '' then
    Exit;
  LvEditWriter := GetEditWriterForSourceEditor(ASourceEditor);
  try
    LvEditWriter.CopyTo(APosition);
    LvEditWriter.Insert(PAnsiChar(ConvertTextToEditorTextW((AText))));
  finally
    LvEditWriter := nil;
  end;
end;

function GetTopMostEditView: IOTAEditView;
var
  LiEditBuffer: IOTAEditBuffer;
begin
  LiEditBuffer := GetEditBuffer;
  if LiEditBuffer <> nil then
  begin
    Result := LiEditBuffer.GetTopView;
    Exit;
  end;
  Result := nil;
end;

function GetCharPosFromPos(APosition: LongInt; AEditView: IOTAEditView): TOTACharPos;
var
  LiEditWriter: IOTAEditWriter;
begin
  Assert(Assigned(AEditView));
  LiEditWriter := AEditView.Buffer.CreateUndoableWriter;
  try
    Assert(Assigned(LiEditWriter));
    LiEditWriter.CopyTo(APosition);
    Result := LiEditWriter.CurrentPos;
  finally
    LiEditWriter := nil;
  end;
end;

function LinePosToEditPos(ALinePos: Integer; AEditView: IOTAEditView = nil): TOTAEditPos;
var
  LvCharPos: TOTACharPos;
begin
  if AEditView = nil then
    AEditView := GetTopMostEditView;

  if Assigned(AEditView) then
  begin
    LvCharPos := GetCharPosFromPos(ALinePos, AEditView);
    AEditView.ConvertPos(False, Result, LvCharPos);
  end
  else
  begin
    Result.Col := 0;
    Result.Line := 0;
  end;
end;

function IsEditControl(AControl: TComponent): Boolean;
begin
  Result := (AControl <> nil) and AControl.ClassNameIs(EditControlClassName) and SameText(AControl.Name, EditControlName);
end;

function EditPosToLinePos(AEditPos: TOTAEditPos; AEditView: IOTAEditView = nil): Integer;
var
  LvCharPos: TOTACharPos;
begin
  if AEditView = nil then
    AEditView := GetTopMostEditView;

  if Assigned(AEditView) then
  begin
    AEditView.ConvertPos(True, AEditPos, LvCharPos);
    Result := AEditView.CharPosToPos(LvCharPos);
  end
  else
    Result := 0;
end;

function OTAEditPos(ACol: SmallInt; ALine: Longint): TOTAEditPos;
begin
  Result.Col := ACol;
  Result.Line := ALine;
end;

function ConvertEditorTextToTextW(const Text: AnsiString): string;
begin
  Result := UTF8ToUnicodeString(Text);
end;

function GetCurrLineText(var AText: string; var ALineNo: Integer; var ACharIndex: Integer; AView: IOTAEditView = nil): Boolean;
var
  L1, L2: Integer;
  LvReader: IOTAEditReader;
  LvEditBuffer: IOTAEditBuffer;
  LvEditPos: TOTAEditPos;
  LvCharPos: TOTACharPos;
  LvOutStr: AnsiString;
begin
  Result := False;
  if not Assigned(AView) then
    AView := GetTopMostEditView;

  if not Assigned(AView) then
    Exit;

  LvEditPos := AView.CursorPos;
  AView.ConvertPos(True, LvEditPos, LvCharPos);
  ALineNo := LvCharPos.Line;
  ACharIndex := LvCharPos.CharIndex;

  LvEditBuffer := AView.Buffer;
  L1 := EditPosToLinePos(OTAEditPos(1, ALineNo), LvEditBuffer.TopView);
  if (ALineNo >= AView.Buffer.GetLinesInBuffer) then
    L2 := EditPosToLinePos(OTAEditPos(High(SmallInt), ALineNo + 1), LvEditBuffer.TopView)
  else
    L2 := EditPosToLinePos(OTAEditPos(1, ALineNo + 1), LvEditBuffer.TopView) - 2;

  SetLength(LvOutStr, L2 - L1);
  LvReader := LvEditBuffer.CreateReader;
  try
    LvReader.GetText(L1, PAnsiChar(LvOutStr), L2 - L1);
  finally
    LvReader := nil;
  end;
  AText := TrimRight(ConvertEditorTextToTextW(LvOutStr));
  Result := True;
end;

procedure PositionInsertText(AEditPosition: IOTAEditPosition; const AText: string);
begin
  AEditPosition.InsertText(AText);
end;

procedure InsertSingleLine(ALine: Integer; const AText: string; AEditView: IOTAEditView = nil);
begin
  if not Assigned(AEditView) then
    AEditView := GetTopMostEditView;

  if Assigned(AEditView) then
  begin
    if ALine > 1 then
    begin
      AEditView.Position.Move(ALine - 1, 1);
      AEditView.Position.MoveEOL;
    end
    else
      AEditView.Position.Move(1, 1);

    PositionInsertText(AEditView.Position, CRLF);
    AEditView.Position.Move(ALine, 1);
    PositionInsertText(AEditView.Position, AText);
    AEditView.Paint;
  end;
end;

function GetCurrChar(OffsetX: Integer = 0; View: IOTAEditView = nil): Char;
var
  CharIndex: Integer;
  LineText: string;
  LineNo: Integer;
begin
  Result := #0;
  if (View = nil) or (View = GetTopMostEditView) then
  begin
    if GetCurrLineText(LineText, LineNo, CharIndex) then
    begin
      CharIndex := CharIndex + OffsetX + 1;
      if (CharIndex > 0) and (CharIndex <= Length(LineText)) then
        Result := LineText[CharIndex];
    end;
  end
  else if GetCurrLineText(LineText, LineNo, CharIndex, View) then
  begin
    CharIndex := CharIndex + OffsetX + 1;
    if (CharIndex > 0) and (CharIndex <= Length(LineText)) then
      Result := LineText[CharIndex];
  end;
end;

end.
