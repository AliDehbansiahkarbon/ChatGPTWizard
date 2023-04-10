unit UConsts;

interface
uses
  Winapi.Messages;

const
  WM_UPDATE_MESSAGE = WM_USER + 5874;
  WM_PROGRESS_MESSAGE = WM_USER + 5875;
  WM_WRITESONIC_UPDATE_MESSAGE = WM_USER + 5876;
  WM_YOUCHAT_UPDATE_MESSAGE = WM_USER + 5877;

  DefaultChatGPTURL = 'https://api.openai.com/v1/completions';
  DefaultChatGPT3_5TurboURL = 'https://api.openai.com/v1/chat/completions';
  DefaultModel = 'text-davinci-003';
  DefaultMaxToken = 2048;
  DefaultTemperature = 0;
  DefaultIdentifier = 'cpt';
  DefaultCodeFormatter = False;
  DefaultRTL = False;


  DefaultWriteSonicURL = 'https://api.writesonic.com/v2/business/content/chatsonic?engine=premium';
  DefaultYouChatURL = 'https://betterapi.net/youdotcom/chat';
  CrLf = #10#13;

implementation
end.
