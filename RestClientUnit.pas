unit RestClientUnit;

interface
uses
  System.Classes, System.SysUtils, IdHTTP, IdSSLOpenSSL, IdComponent, Vcl.Dialogs,
  XSuperObject, System.Generics.Collections;

type
  TRequestJSON = class
  private
    FModel: string;
    FPrompt: string;
    FMax_tokens: Integer;
    FTemperature: Integer;
  public
    property model: string read FModel write FModel;
    property prompt: string read FPrompt write FPrompt;
    property max_tokens: Integer read FMax_tokens write FMax_tokens;
    property temperature: Integer read FTemperature write FTemperature;
  end;

  TChoice = class
  private
    FText: string;
    FIndex: Integer;
    FLogProbs: string;
    FFinish_reason: string;
  published
    property text: string read FText write FText;
    property &index: Integer read FIndex write FIndex;
    property logprobs: string read FLogProbs write FLogProbs;
    property finish_reason: string read FFinish_reason write FFinish_reason;
  end;

  TUsage = class
  private
    FPrompt_Tokens: Integer;
    FCompletion_Tokens: Integer;
    FTotal_Tokens: Integer;
  published
    property prompt_tokens: Integer read FPrompt_Tokens write FPrompt_Tokens;
    property completion_tokens: Integer read FCompletion_Tokens write FCompletion_Tokens;
    property total_tokens: Integer read FTotal_Tokens write FTotal_Tokens;
  end;

  TChatGPTResponse = class
  private
    FId: string;
    FObject: string;
    FCreated: Integer;
    FModel: string;
    FChoices: TObjectList<TChoice>;
    FUsage: Tusage;
    constructor Create;
    destructor Destroy; override;
  published
    property id: string read FId write FId;
    property &object: string read FObject write FObject;
    property created: Integer read FCreated write FCreated;
    property model: string read FModel write FModel;
    property choices: TObjectList<TChoice> read FChoices write FChoices;
    property usage: Tusage read FUsage write FUsage;
  end;

  TOpenAIAPI = class
  private
    FAccessToken: string;
  public
    constructor Create(const AAccessToken: string);
    function Query(const AModel: string; const APrompt: string): string;
  end;

implementation

constructor TOpenAIAPI.Create(const AAccessToken: string);
begin
  inherited Create;
  FAccessToken := AAccessToken;
end;

function TOpenAIAPI.Query(const AModel: string; const APrompt: string): string;
var
  LvHttpClient: TIdHTTP;
  LvSslIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  LvParamStream: TStringStream;
  Response: string;

  LvRequestJSON: TRequestJSON;
  LvChatGPTResponse: TChatGPTResponse;
begin
  Response := '';
  LvHttpClient := TIdHTTP.Create(nil);
  LvSslIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  LvChatGPTResponse := TChatGPTResponse.Create;
  LvRequestJSON := TRequestJSON.Create;
  with LvRequestJSON do
  begin
    model := AModel;
    prompt := APrompt;
    max_tokens := 2048;
    temperature := 0;
  end;

  try
    LvHttpClient.IOHandler := LvSslIOHandler;
    LvSslIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    LvParamStream := TStringStream.Create(LvRequestJSON.AsJSON(True), TEncoding.UTF8);

    LvHttpClient.Request.CustomHeaders.AddValue('Authorization', 'Bearer '+ FAccessToken);
    LvHttpClient.Request.ContentType := 'application/json';
    try
      Response := LvHttpClient.Post('https://api.openai.com/v1/completions', LvParamStream);
      if not Response.IsEmpty then
        Result := LvChatGPTResponse.FromJSON(response).Choices[0].Text.Trim;
    except on E: Exception do
      Result := E.Message;
    end;
  finally
    LvRequestJSON.Free;
    LvParamStream.Free;
    LvChatGPTResponse.Free;
    LvHttpClient.Free;
  end;
end;
{ TChatGPTResponse }

constructor TChatGPTResponse.Create;
begin
  inherited Create;
  Choices := TObjectList<TChoice>.Create;
  Usage := Tusage.Create;
end;

destructor TChatGPTResponse.Destroy;
begin
  Choices.Free;
  Usage.Free;
  inherited;
end;

end.
