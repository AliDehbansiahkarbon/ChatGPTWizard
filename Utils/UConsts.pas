unit UConsts;

interface
uses
  Winapi.Messages;

const
  WM_UPDATE_MESSAGE = WM_USER + 5874;
  WM_PROGRESS_MESSAGE = WM_USER + 5875;
  WM_WRITESONIC_UPDATE_MESSAGE = WM_USER + 5876;
  WM_YOUCHAT_UPDATE_MESSAGE = WM_USER + 5877;

  DefaultChatGPTURL = 'https://api.openai.com/v1/chat/completions';
  DefaultChatGPTURL_Offline = 'http://localhost:11434/api/generate';
  DefaultModel = 'gpt-3.5-turbo';
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
  ContextMenuConvertToAsm = 'Convert the following code to Assembly code';

  CPluginName = 'ChatGPTWizard';
  CVersion = 'v3.1';
  CVersionedName = CPluginName + ' - ' + CVersion;

implementation
end.
