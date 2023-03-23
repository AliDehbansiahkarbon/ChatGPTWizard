unit UWriteSonicThread;

interface

uses
  System.Classes, System.SysUtils, Vcl.Dialogs, System.Generics.Collections,
  Winapi.Messages, Winapi.Windows, System.IOUtils, Rest.HttpClient,
  XSuperObject, UChatGPTSetting, UConsts;

type
  TRequestJson = class
  private
    FEnable_Google_Results: Boolean;
    FEnable_memory: Boolean;
    FInput_text: string;
  public
    property enable_google_results: Boolean read FEnable_Google_Results write FEnable_Google_Results;
    property enable_memory: Boolean read FEnable_memory write FEnable_memory;
    property input_text: string read FInput_text write FInput_text;
  end;

  TResponseJson = class
  private
    FMessage: string;
    FImage_urls: TArray<string>;
  public
    property &message: string read FMessage write FMessage;
    property image_urls: TArray<string> read FImage_urls write FImage_urls;
  end;

  TWriteSonicTrd = class(TThread)
  private
    FHandle: HWND;
    FAPIKey: string;
    FBaseURL: string;
    FTimeOut: Integer;
    FAnimated: Boolean;
    FProxySetting: TProxySetting;
    FPrompt: string;

    function Query: string;
    function LoadFromFileInTempFolder(const fileName: string): string;
    procedure SaveToFileInTempFolder(const fileName, content: string);
  protected
    procedure Execute; override;
  public
    constructor Create(AHandle: HWND; AAPIKey: string; ABaseURL: string; APrompt: string; AProxayIsActive: Boolean;
                       AProxyHost: string; AProxyPort: Integer; AProxyUsername: string; AProxyPassword: string;
                       AAnimated: Boolean; ATimeOut: Integer);
    destructor Destroy; override;
  end;

implementation

{ TWriteSonicTrd }

constructor TWriteSonicTrd.Create(AHandle: HWND; AAPIKey: string; ABaseURL: string; APrompt: string; AProxayIsActive: Boolean;
                                  AProxyHost: string; AProxyPort: Integer; AProxyUsername: string; AProxyPassword: string;
                                  AAnimated: Boolean; ATimeOut: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FApiKey := AApiKey;
  FHandle := AHandle;
  FBaseURL := ABaseURL;
  FAnimated := AAnimated;
  FTimeOut := ATimeOut;
  FPrompt := APrompt;
  FProxySetting := TProxySetting.Create;
  with FProxySetting do
  begin
    Active := AProxayIsActive;
    ProxyHost := AProxyHost;
    ProxyPort := AProxyPort;
    ProxyUsername := AProxyUsername;
    ProxyPassword := AProxyPassword;
  end;
  PostMessage(FHandle, WM_PROGRESS_MESSAGE, 1, 0);
end;

destructor TWriteSonicTrd.Destroy;
begin
  FProxySetting.Free;
  PostMessage(FHandle, WM_PROGRESS_MESSAGE, 0, 0);
  inherited;
end;

procedure TWriteSonicTrd.Execute;
{=================================================}
{  Lparams meaning:                               }
{  0 = sending whole string in one message        }
{  1 = sending character by character(animated)   }
{  2 = Finished the task.                         }
{  3 = Exceptions.                                }
{=================================================}
var
  I: Integer;
  LvResult: string;
begin
  inherited;
  try
    LvResult := Query;

    if (not Terminated) and (not LvResult.IsEmpty) then
    begin
      if FAnimated then
      begin
        for I := 0 to Pred(LvResult.Length) do
        begin
          if not Terminated then
          begin
            Sleep(1);
            if not Terminated then
              SendMessage(FHandle, WM_WRITESONIC_UPDATE_MESSAGE, Integer(LvResult[I]), 1); //Send next char.
          end;
        end;
        SendMessage(FHandle, WM_WRITESONIC_UPDATE_MESSAGE, 0, 2); // Finished.
      end
      else
      begin
        SendMessageW(FHandle, WM_WRITESONIC_UPDATE_MESSAGE, Integer(LvResult), 0); // Send whole string.
        SendMessage(FHandle, WM_WRITESONIC_UPDATE_MESSAGE, 0, 2); // Finished.
      end;
    end;
  except on E: Exception do
    begin
      Sleep(10);
      SendMessageW(FHandle, WM_WRITESONIC_UPDATE_MESSAGE, Integer(E.Message), 3); // Send exception.
      Terminate;
    end;
  end;
end;

function TWriteSonicTrd.Query: string;
var
  LvHttpClient: TRESTHTTP;
  LvParamStream: TStringStream;
  LvResponseStream: TStringStream;
  LvRequest: TRequestJson;
  LvResponse: TResponseJson;
begin
  LvHttpClient := TRESTHTTP.Create;
  LvHttpClient.ConnectTimeout := FTimeOut * 1000;
  LvHttpClient.ReadTimeout := (FTimeOut * 1000) * 2;

  if (FProxySetting.Active) and (not FProxySetting.ProxyHost.IsEmpty) then
  begin
    LvHttpClient.ProxyParams.ProxyServer := FProxySetting.ProxyHost;
    LvHttpClient.ProxyParams.ProxyPort := FProxySetting.ProxyPort;
    LvHttpClient.ProxyParams.ProxyUsername := FProxySetting.ProxyUsername;
    LvHttpClient.ProxyParams.ProxyPassword := FProxySetting.ProxyPassword;
  end;

  LvResponse := TResponseJson.Create;
  LvRequest := TRequestJson.Create;

  with LvRequest do
  begin
    FEnable_Google_Results := False;
    FEnable_memory := False;
    FInput_text := FPrompt;
  end;

  try
    LvParamStream := TStringStream.Create(LvRequest.AsJSON(True), TEncoding.UTF8);

    LvHttpClient.Request.CustomHeaders.Values['X-API-KEY'] := FAPIKey;
    LvHttpClient.Request.CustomHeaders.Values['Content-Type'] := 'application/json';

    try
      LvResponseStream := TStringStream.Create;
      LvHttpClient.Post(FBaseURL , LvParamStream, LvResponseStream);

      if not LvResponseStream.DataString.IsEmpty then
        Result :=  UTF8ToString(LvResponse.FromJSON(LvResponseStream.DataString).&message.Trim);
    except on E: Exception do
      Result := E.Message;
    end;
  finally
    LvResponseStream.Free;
    LvRequest.Free;
    LvParamStream.Free;
    LvResponse.Free;
    LvHttpClient.Free;
  end;
end;

procedure TWriteSonicTrd.SaveToFileInTempFolder(const fileName, content: string);
var
  LvPath: string;
  LvFileStream: TFileStream;
begin
  LvPath := IncludeTrailingPathDelimiter(TPath.GetTempPath) + fileName;
  LvFileStream := TFileStream.Create(LvPath, fmCreate);
  try
    LvFileStream.WriteBuffer(Pointer(content)^, Length(content) * SizeOf(Char));
  finally
    LvFileStream.Free;
  end;
end;

function TWriteSonicTrd.LoadFromFileInTempFolder(const fileName: string): string;
var
  LvPath: string;
  LvStream: TFileStream;
  LvSize: Integer;
begin
  LvPath := IncludeTrailingPathDelimiter(TPath.GetTempPath) + fileName;

  if not FileExists(LvPath) then
    raise Exception.Create('File not found: ' + LvPath);

  LvStream := TFileStream.Create(LvPath, fmOpenRead);
  try
    LvSize := LvStream.Size;
    SetLength(Result, LvSize div SizeOf(Char));
    LvStream.ReadBuffer(Pointer(Result)^, LvSize);
  finally
    LvStream.Free;
  end;
end;

end.
