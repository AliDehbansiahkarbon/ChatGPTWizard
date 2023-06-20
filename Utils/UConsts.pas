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
  CRLF = #13#10;

  ContextMenuAddTest = 'Create unit test for the following Delphi code';
  ContextMenuFindBugs = 'Find possible bugs in the following Delphi code';
  ContextMenuOptimize = 'Optimize the following Delphi code';
  ContextMenuAddComments = 'Add descriptive comments for the following Delphi code';
  ContextMenuCompleteCode = 'Try to complete the following Delphi code and return the completed code';
  ContextMenuExplain = 'Explain what does the following code';
  ContextMenuRefactor = 'Refactor the following code';

  CPluginName = 'ChatGPTWizard';
  CVersion = 'v2.2.0.6';
  CVersionedName = CPluginName + ' - ' + CVersion;

implementation
end.
