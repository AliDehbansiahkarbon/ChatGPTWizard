{********************************************************************************}
{    This unit is a refinemented version of the corresponding unit from          }
{     Castalia-Delphi-Parser. The Original Code is released in August 17, 1999.  }
{    The Initial Developer of the Original Code was                              }
{     Martin Waldenburg (Martin.Waldenburg@T-Online.de).                         }
{                                                                                }
{    You can find the original repo on GitHub for more info:                     }
{     https://github.com/jacobthurman/Castalia-Delphi-Parser                     }
{********************************************************************************}

unit UPascalLexerTypes;

interface

uses SysUtils, TypInfo;

{$INCLUDE ParserDefines.inc}

var
  CompTable: array [#0 .. #255] of byte;

type
  TMessageEventType = (meError, meNotSupported);
  TMessageEvent = procedure(Sender: TObject; const Typ: TMessageEventType;
    const Msg: string; X, Y: Integer) of object;
  TCommentState = (csAnsi, csBor, csNo);

  TTokenPoint = packed record
    X: Integer;
    Y: Integer;
  end;

  TptTokenKind = (ptAbort, ptAbsolute, ptAbstract, ptAdd, ptAddressOp,
    ptAmpersand, ptAnd, ptAnsiComment, ptAnsiString, ptArray, ptAs, ptAsciiChar,
    ptAsm, ptAssembler, ptAssign, ptAt, ptAutomated, ptBegin, ptBoolean,
    ptBorComment, ptBraceClose, ptBraceOpen, ptBreak, ptByte, ptByteBool,
    ptCardinal, ptCase, ptCdecl, ptChar, ptClass, ptClassForward,
    ptClassFunction, ptClassProcedure, ptColon, ptComma, ptComp, ptCompDirect,
    ptConst, ptConstructor, ptContains, ptContinue, ptCRLF, ptCRLFCo, ptCurrency,
    ptDefault, ptDefineDirect, ptDeprecated, ptDestructor, ptDispid, ptDispinterface,
    ptDiv, ptDo, ptDotDot, ptDouble, ptDoubleAddressOp, ptDownto, ptDWORD, ptDynamic,
    ptElse, ptElseDirect, ptEnd, ptEndIfDirect, ptEqual, ptError, ptExcept, ptExit,
    ptExport, ptExports, ptExtended, ptExternal, ptFar, ptFile,
{$IFDEF D8_NEWER}
    ptFinal,
{$ENDIF}
    ptFinalization, ptFinally, ptFloat, ptFor, ptForward, ptFunction, ptGoto,
    ptGreater, ptGreaterEqual, ptHalt,
{$IFDEF D8_NEWER}
    ptHelper,
{$ENDIF}
    ptIdentifier, ptIf, ptIfDirect, ptIfEndDirect, ptElseIfDirect,
    ptIfDefDirect, ptIfNDefDirect, ptIfOptDirect, ptImplementation,
    ptImplements, ptIn, ptIncludeDirect, ptIndex, ptInherited, ptInitialization,
    ptInline, ptInt64, ptInteger, ptIntegerConst, ptInterface, ptIs, ptLabel,
    ptLibrary, ptLocal, ptLongBool, ptLongint, ptLongword, ptLower,
    ptLowerEqual, ptMessage, ptMinus, ptMod, ptName, ptNear, ptNil, ptNodefault,
    ptNone, ptNot, ptNotEqual, ptNull, ptObject, ptOf, ptOleVariant, ptOn,
{$IFDEF D8_NEWER}
    ptOperator,
{$ENDIF}
    ptOr, ptOut, ptOverload, ptOverride, ptPackage, ptPacked, ptPascal, ptPChar,
    ptPlatform, ptPlus, ptPoint, ptPointerSymbol, ptPrivate, ptProcedure,
    ptProgram, ptProperty, ptProtected, ptPublic, ptPublished, ptRaise, ptRead,
    ptReadonly, ptReal, ptReal48, ptRecord,
{$IFDEF D12_NEWER}
    ptReference,
{$ENDIF}
    ptRegister, ptReintroduce, ptRemove, ptRepeat, ptRequires, ptResident,
    ptResourceDirect, ptResourcestring, ptRoundClose, ptRoundOpen, ptRunError,
    ptSafeCall,
{$IFDEF D8_NEWER}
    ptSealed,
{$ENDIF}
    ptSemiColon, ptSet, ptShl, ptShortint, ptShortString, ptShr, ptSingle,
    ptSlash, ptSlashesComment, ptSmallint, ptSpace, ptSquareClose,
    ptSquareOpen, ptStar,
{$IFDEF D8_NEWER}
    ptStatic,
{$ENDIF}
    ptStdcall, ptStored,
{$IFDEF D8_NEWER}
    ptStrict,
{$ENDIF}
    ptString, ptStringConst, ptStringDQConst, ptStringresource, ptSymbol,
    ptThen, ptThreadvar, ptTo, ptTry, ptType, ptUndefDirect, ptUnit, ptUnknown,
{$IFDEF D8_NEWER}
    ptUnsafe,
{$ENDIF}
    ptUntil, ptUses, ptVar, ptVarargs, ptVariant, ptVirtual, ptWhile,
    ptWideChar, ptWideString, ptWith, ptWord, ptWordBool, ptWrite,
    ptWriteonly, ptXor);

  TmwPasLexStatus = record
    CommentState: TCommentState;
    ExID: TptTokenKind;
    LineNumber: Integer;
    LinePos: Integer;
    Origin: PChar;
    RunPos: Integer;
    TokenPos: Integer;
    TokenID: TptTokenKind;
  end;

const
  ExTypes = [ptDWORD, ptUnknown];

  function TokenName(Value: TptTokenKind): string;
  function ptTokenName(Value: TptTokenKind): string;
  function IsTokenIDJunk(const aTokenID: TptTokenKind): Boolean;

implementation

function TokenName(Value: TptTokenKind): string;
begin
  Result := Copy(ptTokenName(Value), 3, MaxInt);
end;

function ptTokenName(Value: TptTokenKind): string;
begin
  Result := GetEnumName(TypeInfo(TptTokenKind), Integer(Value));
end;

function IsTokenIDJunk(const aTokenID: TptTokenKind): Boolean;
begin
  Result := aTokenID in [ptAnsiComment, ptBorComment, ptCRLF, ptCRLFCo,
    ptSlashesComment, ptSpace, ptIfDirect, ptIfEndDirect, ptElseIfDirect,
    ptIfDefDirect, ptIfNDefDirect, ptEndIfDirect, ptIfOptDirect, ptDefineDirect,
    ptUndefDirect];
end;

end.
