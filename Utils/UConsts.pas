unit UConsts;

interface
uses
  Winapi.Messages;

const
  WM_UPDATE_MESSAGE = WM_USER + 5874;
  WM_PROGRESS_MESSAGE = WM_USER + 5875;
  WM_PROVIDER_MESSAGE = WM_USER + 5876;

  ProviderGemini = 'gemini';
  ProviderClaude = 'claude';
  ProviderOllama = 'ollama';
  ProviderChatGPT = 'chatgpt';

  DefaultChatGPTBaseURL = 'https://api.openai.com/v1';
  DefaultGeminiBaseURL = 'https://generativelanguage.googleapis.com/v1beta';
  DefaultClaudeBaseURL = 'https://api.anthropic.com';
  DefaultOllamaBaseURL = 'http://localhost:11434/api';

  DefaultChatGPTModel = 'gpt-4o-mini';
  DefaultGeminiModel = 'gemini-2.0-flash';
  DefaultClaudeModel = 'claude-3-5-sonnet-latest';
  DefaultOllamaModel = 'llama3.2';

  AnthropicVersionHeader = '2023-06-01';
  DefaultModel = DefaultChatGPTModel;
  DefaultMaxToken = 2048;
  DefaultTemperature = 0;
  DefaultIdentifier = 'cpt';
  DefaultCodeFormatter = False;
  DefaultRTL = False;
  CRLF = #13#10;

  ContextMenuAddTest = 'Create unit test for the following Delphi code';
  ContextMenuFindBugs = 'Find possible bugs in the following Delphi code';
  ContextMenuOptimize = 'Optimize the following Delphi code';
  ContextMenuAddComments = 'Add descriptive comments for the following Delphi code';
  ContextMenuCompleteCode = 'Try to complete the following Delphi code and return the completed code';
  ContextMenuExplain = 'Explain what does the following code';
  ContextMenuRefactor = 'Refactor the following code';
  ContextMenuConvertToAsm = 'Convert the following code to Assembly code';

  CPluginName = 'FusionAI';
  CLegacyPluginName = 'ChatGPTWizard';
  CVersion = 'v3.1';
  CVersionedName = CPluginName + ' - ' + CVersion;
  CPluginRepositoryUrl = 'https://github.com/AliDehbansiahkarbon/ChatGPTWizard';
  CRegistryRoot = '\SOFTWARE\' + CPluginName;
  CLegacyRegistryRoot = '\SOFTWARE\' + CLegacyPluginName;
  CProvidersRegistryRoot = CRegistryRoot + '\Providers';
  CLegacyProvidersRegistryRoot = CLegacyRegistryRoot + '\Providers';
  CQuestionsRegistryRoot = CRegistryRoot + '\PredefinedQuestions';
  CLegacyQuestionsRegistryRoot = CLegacyRegistryRoot + '\PredefinedQuestions';
  CRootMenuName = 'FusionAIRootMenu';
  CAskMenuName = 'Mnu_FusionAI';
  CSettingsMenuName = 'Mnu_FusionAISetting';
  CAboutMenuName = 'Mnu_FusionAIAbout';
  CEditorSubMenuName = 'FusionAISubMenu';
  CEditorSubMenuAskName = 'FusionAIAskSubMenu';
  CEditorSubMenuAddTestName = 'FusionAIAddTest';
  CEditorSubMenuFindBugsName = 'FusionAIFindBugs';
  CEditorSubMenuOptimizeName = 'FusionAIOptimize';
  CEditorSubMenuAddCommentsName = 'FusionAIAddComments';
  CEditorSubMenuCompleteCodeName = 'FusionAICompleteCode';
  CEditorSubMenuExplainName = 'FusionAIExplain';
  CEditorSubMenuRefactorName = 'FusionAIRefactor';
  CEditorSubMenuAsmName = 'FusionAIAsm';
  CEditorSubMenuSeparatorName = 'FusionAISeparator';
  CEditorSubMenuSettingsName = 'FusionAISettings';
  CWizardIDString = 'FusionAI.ID';
  CWizardName = 'FusionAI';
  CAssistantWindowCaption = 'FusionAI';
  CAskMenuCaption = 'Open FusionAI';
  CSettingsMenuCaption = 'FusionAI Settings';
  CAboutMenuCaption = 'About FusionAI';
  CEditorMenuCaption = 'FusionAI Assistant';
  CEditorAskCaption = 'Ask';
  CEditorAddTestCaption = 'Add Test';
  CEditorFindBugsCaption = 'Find Bugs';
  CEditorOptimizeCaption = 'Optimize';
  CEditorAddCommentsCaption = 'Add Comments';
  CEditorCompleteCodeCaption = 'Complete Code';
  CEditorExplainCaption = 'Explain Code';
  CEditorRefactorCaption = 'Refactor Code';
  CEditorAsmCaption = 'Convert to Assembly';
  CAboutDescription = 'An IDE plug-in for ChatGPT, Gemini, Claude, and Ollama by Ali Dehbansiahkarbon.';
  CAskSelectionRequiredMsgFmt = 'Please select some text, or wrap a direct inline question like "%s Any question... %s".';
  CNoSelectionMsg = 'Please select some text first.';
  CAssistantDeskSection = 'FusionAIPlugin';
  CMainFormLastQuestionValueName = 'FusionAIMainFormLastQuestion';
  CLegacyMainFormLastQuestionValueName = 'ChatGPTMainFormLastQuestion';
  CProgressPleaseWait = 'Please wait...';
  CProgressStartingFmt = 'Starting %s request...';
  CProgressRunningFmt = 'Working with %s... %d s elapsed';
  CProgressCompletedFmt = '%s request completed.';
  CProgressTimeoutFmt = 'The request timed out after %d seconds.';
  CProgressCancelled = 'The request was cancelled.';
  CProgressFailed = 'The request did not complete successfully.';
  CProviderUnavailableMessage = 'The selected provider is not available.';
  CInlineQuestionLabel = 'INLINE';
  CMinRequestTimeoutSeconds = 5;
  CDefaultRequestTimeoutSeconds = 30;
  CQuestionPromptLabel = 'Question:';
  CQuestionDraftPlaceholder = '[Type your question here]';
  CSelectedCodeLabel = 'Selected Delphi code:';
  CInlineEditorHintFmt = 'Tip: ask directly in the editor with "%s Any question... %s".';
  CNoProviderConfiguredMsg = 'Please enable and configure at least one AI provider in Settings.';
  CReviewProviderSettingsMsg = 'Please review the provider settings before starting the request.';
  CQuestionRequiredMsg = 'You need to type a question first.';

implementation
end.
