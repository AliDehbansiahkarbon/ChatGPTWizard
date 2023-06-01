{***************************************************}
{                                                   }
{   This unit contains a worker thread to do        }
{   API calls and some other stuff.                 }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon  }
{                                                   }
{***************************************************}
unit UYouChatThread;

interface

uses
  System.Classes, System.SysUtils, Vcl.Dialogs, System.Generics.Collections,
  Winapi.Messages, Winapi.Windows, System.IOUtils, Rest.HttpClient, XSuperObject,
  UChatGPTSetting, UConsts, System.Net.HttpClient, System.Net.URLClient;

type
  TYouChatTrd = class(TThread)
  private
    FHandle: HWND;
    FAPIKey: string;
    FBaseURL: string;
    FTimeOut: Integer;
    FAnimated: Boolean;
    FProxySetting: TProxySetting;
    FPrompt: string;

    function QueryRestHttp: string;
    function QueryTHTTPClient: string;
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

constructor TYouChatTrd.Create(AHandle: HWND; AAPIKey: string; ABaseURL: string; APrompt: string; AProxayIsActive: Boolean;
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

destructor TYouChatTrd.Destroy;
begin
  FProxySetting.Free;
  PostMessage(FHandle, WM_PROGRESS_MESSAGE, 0, 0);
  inherited;
end;

procedure TYouChatTrd.Execute;
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
    LvResult := QueryTHTTPClient;

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
              SendMessage(FHandle, WM_YOUCHAT_UPDATE_MESSAGE, Integer(LvResult[I]), 1); //Send next char.
          end;
        end;
        SendMessage(FHandle, WM_YOUCHAT_UPDATE_MESSAGE, 0, 2); // Finished.
      end
      else
      begin
        SendMessageW(FHandle, WM_YOUCHAT_UPDATE_MESSAGE, Integer(LvResult), 0); // Send whole string.
        SendMessage(FHandle, WM_YOUCHAT_UPDATE_MESSAGE, 0, 2); // Finished.
      end;
    end;
  except on E: Exception do
    begin
      Sleep(10);
      SendMessageW(FHandle, WM_YOUCHAT_UPDATE_MESSAGE, Integer(E.Message), 3); // Send exception.
      Terminate;
    end;
  end;
end;

function TYouChatTrd.QueryRestHttp: string;
var
  LvHttpClient: TRESTHTTP;
  LvResponse: ISuperObject;
  LvResponseStream: TStringStream;
  LvFullQuery: string;
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

  try
    try
      LvFullQuery := FBaseURL + '?message=' + FPrompt + '&key=' + FAPIKey;
      LvResponseStream := TStringStream.Create;
      LvHttpClient.Get(LvFullQuery, LvResponseStream);

      if not LvResponseStream.DataString.IsEmpty then
      begin
        LvResponse := SO(UTF8ToString(LvResponseStream.DataString));
        Result := AdjustLineBreaks(LvResponse['message'].AsString.Trim);
      end;
    except on E: Exception do
      Result := E.Message;
    end;
  finally
    LvResponseStream.Free;
    LvHttpClient.Free;
  end;
end;

function TYouChatTrd.QueryTHTTPClient: string;
var
  LvHttpClient: THTTPClient;
  LvResponse: ISuperObject;
  LvHTTPResponse: IHTTPResponse;
  LvFullQuery: string;
begin
  LvHttpClient := THTTPClient.Create;
  LvHttpClient.ConnectionTimeout := FTimeOut * 1000;
  LvHttpClient.ResponseTimeout := (FTimeOut * 1000) * 2;

  if (FProxySetting.Active) and (not FProxySetting.ProxyHost.IsEmpty) then
  begin
    with FProxySetting do
      LvHttpClient.ProxySettings := TProxySettings.Create(ProxyHost, ProxyPort, ProxyUsername, ProxyPassword);
  end;

  try
    try
      LvFullQuery := FBaseURL + '?message=' + FPrompt + '&key=' + FAPIKey;
      LvHTTPResponse := LvHttpClient.Get(LvFullQuery);

      if not LvHTTPResponse.ContentAsString.IsEmpty then
      begin
        if not TSingletonSettingObj.IsValidJson(LvHTTPResponse.ContentAsString(TEncoding.UTF8)) then
          Result := AdjustLineBreaks(QueryRestHttp, tlbsCRLF)
        else
        begin
          LvResponse := SO(LvHTTPResponse.ContentAsString(TEncoding.UTF8));
          Result := AdjustLineBreaks(LvResponse['message'].AsString.Trim, tlbsCRLF);
        end;
      end;
    except on E: Exception do
      Result := E.Message;
    end;
  finally
    LvHttpClient.Free;
  end;
end;

end.
