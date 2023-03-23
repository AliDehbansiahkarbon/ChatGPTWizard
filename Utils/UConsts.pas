unit UConsts;

interface
uses
  Winapi.Messages;

const
  WM_UPDATE_MESSAGE = WM_USER + 5874;
  WM_PROGRESS_MESSAGE = WM_USER + 5875;
  WM_WRITESONIC_UPDATE_MESSAGE = WM_USER + 5876;

  DefaultChatGPTURL = 'https://api.openai.com/v1/completions';
  DefaultModel = 'text-davinci-003';
  DefaultMaxToken = 2048;
  DefaultTemperature = 0;
  DefaultIdentifier = 'cpt';
  DefaultCodeFormatter = False;
  DefaultRTL = False;


  DefaultWriteSonicURL = 'https://api.writesonic.com/v2/business/content/chatsonic?engine=premium';
  CrLf = #10#13;

implementation
end.
