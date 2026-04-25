{ ***************************************************}
{                                                    }
{   This is the setting form of the plugin.          }
{   Could be found in the main menu.                 }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com)  }
{   GitHub: https://github.com/AliDehbansiahkarbon   }
{                                                    }
{ ***************************************************}
unit UChatGPTSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.Win.Registry, System.SyncObjs,
  ToolsAPI, System.StrUtils, System.Generics.Collections, Vcl.Mask, System.Math,
  Vcl.ComCtrls, DockForm, UConsts, System.JSON, UAICommon, UEditorHelpers;

type
  TQuestionPair = class;
  TQuestionPairs = TObjectDictionary<Integer, TQuestionPair>;
  TControlAccess = class(TControl);

  TQuestionPair = class
  private
    FCaption: string;
    FQuestion: string;
  public
    constructor Create(ACaption, AQuestion: string);
    property Caption: string read FCaption write FCaption;
    property Question: string read FQuestion write FQuestion;
  end;

  // Note: This class is thread-safe, since accessing the class variable is done in a critical section!
  TSingletonSettingObj = class(TObject)
  private
    FApiKey: string;
    FURL: string;
    FModel: string;
    FMaxToken: Integer;
    FTemperature: Integer;
    FChatGPTTopP: Double;
    FIdentifier: string;
    FCodeFormatter: Boolean;
    FRightToLeft: Boolean;
    FRootMenuIndex: Integer;
    FProxySetting: TProxySetting;
    FCurrentActiveViewName: string;
    FHistoryEnabled: Boolean;
    FHistoryPath: string;
    FShouldReloadHistory: Boolean;
    FHighlightColor: TColor;
    FPredefinedQuestions: TQuestionPairs;
    FAnimatedLetters: Boolean;
    FTimeOut: Integer;
    FMainFormLastQuestion: string;
    FEnableChatGPT: Boolean;
    FEnableGemini: Boolean;
    FGeminiAPIKey: string;
    FGeminiBaseURL: string;
    FGeminiModel: string;
    FGeminiMaxTokens: Integer;
    FGeminiTemperature: Double;
    FGeminiTopP: Double;
    FGeminiTopK: Integer;
    FEnableClaude: Boolean;
    FClaudeAPIKey: string;
    FClaudeBaseURL: string;
    FClaudeModel: string;
    FClaudeMaxTokens: Integer;
    FClaudeTemperature: Double;
    FClaudeTopP: Double;
    FClaudeApiVersion: string;
    FEnableOllama: Boolean;
    FOllamaAPIKey: string;
    FOllamaBaseURL: string;
    FOllamaModel: string;
    FOllamaMaxTokens: Integer;
    FOllamaTemperature: Double;
    FOllamaTopP: Double;
    FOllamaTopK: Integer;
    FDefaultProviderId: string;
    FEnableFileLog: Boolean;
    FLogDirectory: string;

    FTaskList: TList<string>;
    FDockableFormPointer: TDockableForm;

    class var FInstance: TSingletonSettingObj;
    class function GetInstance: TSingletonSettingObj; static;
    constructor Create;

    function GetLeftIdentifier: string;
    function GetRightIdentifier: string;
    procedure LoadDefaults;
    procedure LoadDefaultQuestions;
    function IsMultiAI: Boolean;
    function GetProviderEnabledCount: Integer;

  public
    destructor Destroy; override;
    procedure ReadRegistry;
    procedure WriteToRegistry;
    function GetSetting: string;
    function GetHistoryFullPath: string;
    function GetProviderSetting(const AProviderId: string): TAIProviderSetting;
    function GetEnabledProviderIds: TArray<string>;
    function GetPrimaryProviderId: string;
    function GetEffectiveModel(const AProviderId: string): string;
    function TryFindQuestion(ACaption: string; var AQuestion: string): Integer;
    class Procedure RegisterFormClassForTheming(Const AFormClass: TCustomFormClass; Const Component: TComponent = Nil);
    class function IsValidJson(const AJsonString: string): Boolean;
    class property Instance: TSingletonSettingObj read GetInstance;

    property ApiKey: string read FApiKey write FApiKey;
    property URL: string read FURL write FURL;
    property Model: string read FModel write FModel;
    property MaxToken: Integer read FMaxToken write FMaxToken;
    property Temperature: Integer read FTemperature write FTemperature;
    property ChatGPTTopP: Double read FChatGPTTopP write FChatGPTTopP;
    property CodeFormatter: Boolean read FCodeFormatter write FCodeFormatter;
    property Identifier: string read FIdentifier write FIdentifier;
    property LeftIdentifier: string read GetLeftIdentifier;
    property RightIdentifier: string read GetRightIdentifier;
    property RighToLeft: Boolean read FRightToLeft write FRightToLeft;
    property RootMenuIndex: Integer read FRootMenuIndex write FRootMenuIndex;
    property ProxySetting: TProxySetting read FProxySetting write FProxySetting;
    property CurrentActiveViewName: string read FCurrentActiveViewName write FCurrentActiveViewName;
    property HistoryEnabled: Boolean read FHistoryEnabled write FHistoryEnabled;
    property HistoryPath: string read FHistoryPath write FHistoryPath;
    property ShouldReloadHistory: Boolean read FShouldReloadHistory write FShouldReloadHistory;
    property HighlightColor: TColor read FHighlightColor write FHighlightColor;
    property PredefinedQuestions: TQuestionPairs read FPredefinedQuestions write FPredefinedQuestions;
    property AnimatedLetters: Boolean read FAnimatedLetters write FAnimatedLetters;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property MainFormLastQuestion: string read FMainFormLastQuestion write FMainFormLastQuestion;
    property EnableChatGPT: Boolean read FEnableChatGPT write FEnableChatGPT;
    property EnableGemini: Boolean read FEnableGemini write FEnableGemini;
    property GeminiAPIKey: string read FGeminiAPIKey write FGeminiAPIKey;
    property GeminiBaseURL: string read FGeminiBaseURL write FGeminiBaseURL;
    property GeminiModel: string read FGeminiModel write FGeminiModel;
    property GeminiMaxTokens: Integer read FGeminiMaxTokens write FGeminiMaxTokens;
    property GeminiTemperature: Double read FGeminiTemperature write FGeminiTemperature;
    property GeminiTopP: Double read FGeminiTopP write FGeminiTopP;
    property GeminiTopK: Integer read FGeminiTopK write FGeminiTopK;
    property EnableClaude: Boolean read FEnableClaude write FEnableClaude;
    property ClaudeAPIKey: string read FClaudeAPIKey write FClaudeAPIKey;
    property ClaudeBaseURL: string read FClaudeBaseURL write FClaudeBaseURL;
    property ClaudeModel: string read FClaudeModel write FClaudeModel;
    property ClaudeMaxTokens: Integer read FClaudeMaxTokens write FClaudeMaxTokens;
    property ClaudeTemperature: Double read FClaudeTemperature write FClaudeTemperature;
    property ClaudeTopP: Double read FClaudeTopP write FClaudeTopP;
    property ClaudeApiVersion: string read FClaudeApiVersion write FClaudeApiVersion;
    property EnableOllama: Boolean read FEnableOllama write FEnableOllama;
    property OllamaAPIKey: string read FOllamaAPIKey write FOllamaAPIKey;
    property OllamaBaseURL: string read FOllamaBaseURL write FOllamaBaseURL;
    property OllamaModel: string read FOllamaModel write FOllamaModel;
    property OllamaMaxTokens: Integer read FOllamaMaxTokens write FOllamaMaxTokens;
    property OllamaTemperature: Double read FOllamaTemperature write FOllamaTemperature;
    property OllamaTopP: Double read FOllamaTopP write FOllamaTopP;
    property OllamaTopK: Integer read FOllamaTopK write FOllamaTopK;
    property DefaultProviderId: string read FDefaultProviderId write FDefaultProviderId;
    property EnableFileLog: Boolean read FEnableFileLog write FEnableFileLog;
    property LogDirectory: string read FLogDirectory write FLogDirectory;

    property MultiAI: Boolean read IsMultiAI;
    property TaskList: TList<string> read FTaskList write FTaskList;
    property DockableFormPointer: TDockableForm read FDockableFormPointer write FDockableFormPointer;
  end;

  TFrm_Setting = class(TForm)
    pnlMain: TPanel;
    grp_OpenAI: TGroupBox;
    pnlOpenAI: TPanel;
    lbl_1: TLabel;
    lbl_2: TLabel;
    lbl_3: TLabel;
    lbl_4: TLabel;
    lbl_5: TLabel;
    edt_Url: TEdit;
    edt_ApiKey: TEdit;
    edt_MaxToken: TEdit;
    edt_Temperature: TEdit;
    cbbModel: TComboBox;
    pnlOther: TPanel;
    pnlBottom: TPanel;
    Btn_Default: TButton;
    Btn_Save: TButton;
    grp_History: TGroupBox;
    pnlHistory: TPanel;
    chk_History: TCheckBox;
    lbEdt_History: TLabeledEdit;
    grp_Proxy: TGroupBox;
    pnlProxy: TPanel;
    lbEdt_ProxyHost: TLabeledEdit;
    lbEdt_ProxyPort: TLabeledEdit;
    chk_ProxyActive: TCheckBox;
    lbEdt_ProxyUserName: TLabeledEdit;
    lbEdt_ProxyPassword: TLabeledEdit;
    grp_Other: TGroupBox;
    pnlIDE: TPanel;
    lbl_6: TLabel;
    Edt_SourceIdentifier: TEdit;
    chk_CodeFormatter: TCheckBox;
    chk_Rtl: TCheckBox;
    Btn_HistoryPathBuilder: TButton;
    ColorBox_Highlight: TColorBox;
    lbl_ColorPicker: TLabel;
    pgcSetting: TPageControl;
    tsMainSetting: TTabSheet;
    tsPreDefinedQuestions: TTabSheet;
    Btn_AddQuestion: TButton;
    ScrollBox: TScrollBox;
    GridPanelPredefinedQs: TGridPanel;
    Btn_RemoveQuestion: TButton;
    lbEdt_Timeout: TLabeledEdit;
    tsOtherAiServices: TTabSheet;
    grp_Gemini: TGroupBox;
    chk_Gemini: TCheckBox;
    lbEdt_GeminiAPIKey: TLabeledEdit;
    lbEdt_GeminiBaseURL: TLabeledEdit;
    pnlGemini: TPanel;
    grp_Claude: TGroupBox;
    pnlClaude: TPanel;
    chk_Claude: TCheckBox;
    lbEdt_ClaudeAPIKey: TLabeledEdit;
    lbEdt_ClaudeBaseURL: TLabeledEdit;
    pnlPredefinedQ: TPanel;
    pnlOtherAIMain: TPanel;
    chk_AnimatedLetters: TCheckBox;
    chk_Offline: TCheckBox;
    edt_OfflineModel: TEdit;
    procedure Btn_SaveClick(Sender: TObject);
    procedure Btn_DefaultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_HistoryPathBuilderClick(Sender: TObject);
    procedure chk_HistoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_RemoveQuestionClick(Sender: TObject);
    procedure Btn_AddQuestionClick(Sender: TObject);
    procedure edt_UrlChange(Sender: TObject);
    procedure cbbModelChange(Sender: TObject);
    procedure chk_AnimatedLettersClick(Sender: TObject);
    procedure ColorBox_HighlightChange(Sender: TObject);
    procedure chk_ProxyActiveClick(Sender: TObject);
    procedure pgcSettingChange(Sender: TObject);
    procedure chk_GeminiClick(Sender: TObject);
    procedure chk_ClaudeClick(Sender: TObject);
    procedure chk_ChatGPTClick(Sender: TObject);
    procedure chk_OllamaClick(Sender: TObject);
    procedure chk_FileLogClick(Sender: TObject);
    procedure chk_OfflineClick(Sender: TObject);
    procedure PredefinedQuestionsMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    FChkChatGPTEnabled: TCheckBox;
    FBtnRefreshChatGPTModels: TButton;
    FTabChatGPT: TTabSheet;
    FOtherAIPageControl: TPageControl;
    FAIServiceHeaderPanel: TPanel;
    FTabClaude: TTabSheet;
    FTabGemini: TTabSheet;
    FTabOllama: TTabSheet;
    FEdtChatGPTTopP: TLabeledEdit;
    FCbbGeminiModel: TComboBox;
    FLblGeminiModel: TLabel;
    FBtnRefreshGeminiModels: TButton;
    FEdtGeminiMaxTokens: TLabeledEdit;
    FEdtGeminiTemperature: TLabeledEdit;
    FEdtGeminiTopP: TLabeledEdit;
    FEdtGeminiTopK: TLabeledEdit;
    FCbbClaudeModel: TComboBox;
    FLblClaudeModel: TLabel;
    FBtnRefreshClaudeModels: TButton;
    FEdtClaudeMaxTokens: TLabeledEdit;
    FEdtClaudeTemperature: TLabeledEdit;
    FEdtClaudeTopP: TLabeledEdit;
    FEdtClaudeApiVersion: TLabeledEdit;
    FGrpOllama: TGroupBox;
    FPnlOllama: TPanel;
    FChkOllamaEnabled: TCheckBox;
    FLbEdtOllamaAPIKey: TLabeledEdit;
    FLbEdtOllamaBaseURL: TLabeledEdit;
    FCbbOllamaModel: TComboBox;
    FLblOllamaModel: TLabel;
    FBtnRefreshOllamaModels: TButton;
    FEdtOllamaMaxTokens: TLabeledEdit;
    FEdtOllamaTemperature: TLabeledEdit;
    FEdtOllamaTopP: TLabeledEdit;
    FEdtOllamaTopK: TLabeledEdit;
    FLblDefaultProvider: TLabel;
    FCbbDefaultProvider: TComboBox;
    FChkFileLog: TCheckBox;
    FLbEdtLogDirectory: TLabeledEdit;
    FBtnLogPathBuilder: TButton;
    FGrpLogging: TGroupBox;
    procedure AddQuestion(AQuestionpair: TQuestionPair = nil);
    procedure RemoveLatestQuestion;
    procedure ClearGridPanel;
    function ValidateInputs: Boolean;
    procedure ConfigureProviderEditors;
    procedure ConfigureMainSettingsLayout;
    procedure ConfigureOtherProviderLayout;
    procedure ConfigureProviderPanel(AGroup: TGroupBox; APanel: TPanel; ACheckBox: TCheckBox;
                                    AApiKeyEdit, ABaseURLedIt: TLabeledEdit;
                                    AModelCombo: TComboBox; AModelLabel: TLabel; ARefreshButton: TButton);
    procedure ConfigureProviderAdvancedOptions;
    function CreateProviderOptionEdit(AParent: TWinControl; const ALabelCaption, AName: string): TLabeledEdit;
    procedure LayoutProviderOptionEdits(const APanel: TPanel; const AOptionEdits: array of TLabeledEdit);
    procedure LoadProviderModels;
    procedure ApplyProviderEditorState;
    procedure RefreshProviderModels(const AProviderId: string; ACombo: TComboBox);
    procedure RefreshModelClick(Sender: TObject);
    procedure RefreshDefaultProviderChoices;
    function ProviderIdToCaption(const AProviderId: string): string;
    function ProviderCaptionToId(const ACaption: string): string;
  public
    HasChanges: Boolean;
    procedure AddAllDefinedQuestions;
    procedure LoadFromSettings(const ASettings: TSingletonSettingObj);
  end;

var
  Frm_Setting: TFrm_Setting;
  Cs: TCriticalSection;

implementation
uses
  UChatGptMain, UAIProviders;

{$R *.dfm}

const
  CaptionChatGPT = 'ChatGPT';
  CaptionGemini = 'Gemini';
  CaptionClaude = 'Claude';
  CaptionOllama = 'Ollama';
  CaptionEnableChatGPT = 'Enable ChatGPT';
  CaptionEnableGemini = 'Enable Gemini';
  CaptionEnableClaude = 'Enable Claude';
  CaptionEnableOllama = 'Enable Ollama';
  CaptionAccessKey = 'Access Key:';
  CaptionBaseURL = 'Base URL:';
  CaptionModel = 'Model:';
  CaptionMaxTokens = 'Max Tokens';
  CaptionTemperature = 'Temperature';
  CaptionTopP = 'Top P';
  CaptionTopK = 'Top K';
  CaptionAnthropicVersion = 'Anthropic Version';
  CaptionRefresh = 'Refresh';
  CaptionRequestTimeout = 'Request Timeout (s)';
  CaptionDefaultProvider = 'Default AI Service:';
  CaptionOllamaAccessKey = 'Access Key (optional):';
  MsgHistoryPathRequired = 'Please indicate the history folder path.';
  MsgChatGPTSectionIncomplete = 'Please complete the ChatGPT section.';
  MsgGeminiSectionIncomplete = 'Please complete the Gemini section.';
  MsgClaudeSectionIncomplete = 'Please complete the Claude section.';
  MsgOllamaSectionIncomplete = 'Please complete the Ollama section.';
  MsgProviderRequired = 'Please enable at least one provider.';
  MsgLogDirectoryRequired = 'Please indicate the logging directory.';

{ TSingletonSettingObj }
constructor TSingletonSettingObj.Create;
begin
  inherited;
  FProxySetting := TProxySetting.Create;
  FPredefinedQuestions := TObjectDictionary<Integer, TQuestionPair>.Create;
  CurrentActiveViewName := '';
  FTaskList := TList<string>.Create;
  DockableFormPointer := nil;
  LoadDefaults;
end;

destructor TSingletonSettingObj.Destroy;
begin
  FProxySetting.Free;
  FPredefinedQuestions.Free;
  FTaskList.Free;
  inherited;
end;

function TSingletonSettingObj.GetHistoryFullPath: string;
begin
  Result := FHistoryPath + '\History.sdb';
end;

function TSingletonSettingObj.GetProviderSetting(const AProviderId: string): TAIProviderSetting;
begin
  Result := TAIProviderSetting.Create;
  Result.ProviderId := AProviderId;

  if SameText(AProviderId, ProviderGemini) then
  begin
    Result.DisplayName := CaptionGemini;
    Result.Enabled := FEnableGemini;
    Result.ApiKey := FGeminiAPIKey;
    Result.BaseURL := FGeminiBaseURL;
    Result.DefaultModel := FGeminiModel;
    Result.MaxTokens := FGeminiMaxTokens;
    Result.Temperature := FGeminiTemperature;
    Result.TopP := FGeminiTopP;
    Result.TopK := FGeminiTopK;
  end
  else if SameText(AProviderId, ProviderClaude) then
  begin
    Result.DisplayName := CaptionClaude;
    Result.Enabled := FEnableClaude;
    Result.ApiKey := FClaudeAPIKey;
    Result.BaseURL := FClaudeBaseURL;
    Result.DefaultModel := FClaudeModel;
    Result.MaxTokens := FClaudeMaxTokens;
    Result.Temperature := FClaudeTemperature;
    Result.TopP := FClaudeTopP;
    Result.ApiVersion := FClaudeApiVersion;
  end
  else if SameText(AProviderId, ProviderOllama) then
  begin
    Result.DisplayName := CaptionOllama;
    Result.Enabled := FEnableOllama;
    Result.ApiKey := FOllamaAPIKey;
    Result.BaseURL := FOllamaBaseURL;
    Result.DefaultModel := FOllamaModel;
    Result.MaxTokens := FOllamaMaxTokens;
    Result.Temperature := FOllamaTemperature;
    Result.TopP := FOllamaTopP;
    Result.TopK := FOllamaTopK;
  end
  else
  begin
    Result.DisplayName := CaptionChatGPT;
    Result.Enabled := FEnableChatGPT;
    Result.ApiKey := FApiKey;
    Result.BaseURL := FURL;
    Result.DefaultModel := FModel;
    Result.MaxTokens := FMaxToken;
    Result.Temperature := FTemperature;
    Result.TopP := FChatGPTTopP;
  end;
end;

function TSingletonSettingObj.GetEnabledProviderIds: TArray<string>;
var
  LIndex: Integer;
begin
  SetLength(Result, GetProviderEnabledCount);
  if Length(Result) = 0 then
    Exit;

  LIndex := 0;
  if FEnableGemini then
  begin
    Result[LIndex] := ProviderGemini;
    Inc(LIndex);
  end;

  if FEnableClaude then
  begin
    Result[LIndex] := ProviderClaude;
    Inc(LIndex);
  end;

  if FEnableOllama then
  begin
    Result[LIndex] := ProviderOllama;
    Inc(LIndex);
  end;

  if FEnableChatGPT then
    Result[LIndex] := ProviderChatGPT;
end;

function TSingletonSettingObj.GetPrimaryProviderId: string;
begin
  Result := ProviderChatGPT;

  if SameText(FDefaultProviderId, ProviderChatGPT) and FEnableChatGPT then
    Exit(ProviderChatGPT);
  if SameText(FDefaultProviderId, ProviderGemini) and FEnableGemini then
    Exit(ProviderGemini);
  if SameText(FDefaultProviderId, ProviderClaude) and FEnableClaude then
    Exit(ProviderClaude);
  if SameText(FDefaultProviderId, ProviderOllama) and FEnableOllama then
    Exit(ProviderOllama);

  if FEnableChatGPT then
    Exit(ProviderChatGPT);
  if FEnableGemini then
    Exit(ProviderGemini);
  if FEnableClaude then
    Exit(ProviderClaude);
  if FEnableOllama then
    Exit(ProviderOllama);
end;

function TSingletonSettingObj.GetEffectiveModel(const AProviderId: string): string;
var
  LModels: TModelDescriptorList;
  LSetting: TAIProviderSetting;
begin
  LSetting := GetProviderSetting(AProviderId);
  try
    Result := LSetting.DefaultModel;
    if Result <> '' then
      Exit;
  finally
    LSetting.Free;
  end;

  LModels := TModelCatalogService.Instance.GetCachedModels(AProviderId);
  try
    if LModels.Count > 0 then
      Result := LModels[0].ModelId;
  finally
    LModels.Free;
  end;
end;

class function TSingletonSettingObj.GetInstance: TSingletonSettingObj;
begin
  if not Assigned(FInstance) then
    FInstance := TSingletonSettingObj.Create;
  Result := FInstance;
end;

function TSingletonSettingObj.GetLeftIdentifier: string;
begin
  Result := FIdentifier + ':';
end;

function TSingletonSettingObj.IsMultiAI: Boolean;
begin
  Result := GetProviderEnabledCount > 1;
end;

function TSingletonSettingObj.GetProviderEnabledCount: Integer;
begin
  Result := 0;
  if FEnableGemini then
    Inc(Result);
  if FEnableClaude then
    Inc(Result);
  if FEnableOllama then
    Inc(Result);
  if FEnableChatGPT then
    Inc(Result);
end;

function TSingletonSettingObj.GetRightIdentifier: string;
begin
  Result := ':' + FIdentifier;
end;

function TSingletonSettingObj.GetSetting: string;
begin
  Result := EmptyStr;
  ShowMessage('Please configure at least one AI provider in the settings form.');
  Frm_Setting := TFrm_Setting.Create(nil);
  try
    TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Setting, Frm_Setting);
    // Apply Theme
    Frm_Setting.LoadFromSettings(Self);
    Frm_Setting.ShowModal;
  finally
    FreeAndNil(Frm_Setting);
  end;
  Result := GetPrimaryProviderId;
end;

class function TSingletonSettingObj.IsValidJson(const AJsonString: string): Boolean;
var
  LvJsonObj: TJSONObject;
begin
  Result := False;
  try
    LvJsonObj := TJSONObject.ParseJSONValue(AJsonString) as TJSONObject;
    Result := Assigned(LvJsonObj); // If parsing succeeds, JSON is valid
    LvJsonObj.Free;
  except
    Result := False;
  end;
end;

procedure TSingletonSettingObj.LoadDefaultQuestions;
begin
  with FPredefinedQuestions do
  begin
    Clear;
    Add(1, TQuestionPair.Create('Create Test Unit', 'Create a Test Unit for the following class in Delphi:'));
    Add(2, TQuestionPair.Create('Convert to Singleton', 'Convert this class to singleton in Delphi:'));
    Add(3, TQuestionPair.Create('Find possible problems', 'What is wrong with this class in Delphi?'));
    Add(4, TQuestionPair.Create('Improve Naming', 'Improve naming of the members of this class in Delphi:'));
    Add(5, TQuestionPair.Create('Rewrite in modern coding style', 'Rewrite this class with modern coding style in Delphi:'));
    Add(6, TQuestionPair.Create('Create Interface','Create necessary interfaces for this Class in Delphi:'));
    Add(7, TQuestionPair.Create('Convert to Generic Type', 'Convert this class to generic class in Delphi:'));
    Add(8, TQuestionPair.Create('Write XML doc', 'Write Documentation using inline XML based comments for this class in Delphi:'));
  end;
end;

procedure TSingletonSettingObj.LoadDefaults;
begin
  FApiKey := '';
  FURL := DefaultChatGPTBaseURL;
  FModel := DefaultChatGPTModel;
  FMaxToken := DefaultMaxToken;
  FTemperature := DefaultTemperature;
  FChatGPTTopP := -1;
  FIdentifier := DefaultIdentifier;
  FCodeFormatter := DefaultCodeFormatter;
  FRightToLeft := DefaultRTL;
  FProxySetting.ProxyHost := '';
  FProxySetting.ProxyPort := 0;
  FProxySetting.ProxyUsername := '';
  FProxySetting.ProxyPassword := '';
  FProxySetting.Active := False;
  FHistoryEnabled := False;
  FShouldReloadHistory := False;
  FHistoryPath := '';
  FHighlightColor := clRed;
  FAnimatedLetters := True;
  FTimeOut := 20;
  FMainFormLastQuestion := 'Create a class to make a Zip file in Delphi.';
  FEnableChatGPT := True;
  FEnableGemini := False;
  FGeminiAPIKey := '';
  FGeminiBaseURL := DefaultGeminiBaseURL;
  FGeminiModel := DefaultGeminiModel;
  FGeminiMaxTokens := 0;
  FGeminiTemperature := -1;
  FGeminiTopP := -1;
  FGeminiTopK := 0;
  FEnableClaude := False;
  FClaudeAPIKey := '';
  FClaudeBaseURL := DefaultClaudeBaseURL;
  FClaudeModel := DefaultClaudeModel;
  FClaudeMaxTokens := 0;
  FClaudeTemperature := -1;
  FClaudeTopP := -1;
  FClaudeApiVersion := AnthropicVersionHeader;
  FEnableOllama := False;
  FOllamaAPIKey := '';
  FOllamaBaseURL := DefaultOllamaBaseURL;
  FOllamaModel := DefaultOllamaModel;
  FOllamaMaxTokens := 0;
  FOllamaTemperature := -1;
  FOllamaTopP := -1;
  FOllamaTopK := 0;
  FDefaultProviderId := ProviderChatGPT;
  FEnableFileLog := False;
  FLogDirectory := '';

  LoadDefaultQuestions;
end;

procedure TSingletonSettingObj.ReadRegistry;
var
  LvRegKey: TRegistry;
  I: Integer;
begin
  LoadDefaults;

  LvRegKey := TRegistry.Create;
  try
    try
      with LvRegKey do
      begin
        CloseKey;
        RootKey := HKEY_CURRENT_USER;

        if OpenKey(CRegistryRoot, False) or OpenKey(CLegacyRegistryRoot, False) then
        begin
          if ValueExists('ChatGPTApiKey') then
            FApiKey := ReadString('ChatGPTApiKey');

          if ValueExists('ChatGPTURL') then
            FURL := IfThen(ReadString('ChatGPTURL').IsEmpty, DefaultChatGPTBaseURL, ReadString('ChatGPTURL'))
          else
            FURL := DefaultChatGPTBaseURL;

          if ValueExists('ChatGPTModel') then
            FModel := IfThen(ReadString('ChatGPTModel').IsEmpty, DefaultModel, ReadString('ChatGPTModel'))
          else
            FModel := DefaultModel;

          if ValueExists('ChatGPTMaxToken') then
          begin
            FMaxToken := ReadInteger('ChatGPTMaxToken');
            if FMaxToken <= 0 then
              FMaxToken := DefaultMaxToken;
          end
          else
            FMaxToken := DefaultMaxToken;

          if ValueExists('ChatGPTTemperature') then
          begin
            FTemperature := ReadInteger('ChatGPTTemperature');
            if FTemperature <= -1 then
              FTemperature := DefaultTemperature;
          end
          else
            FTemperature := DefaultTemperature;

          if ValueExists('ChatGPTTopP') then
            FChatGPTTopP := StrToFloatDef(ReadString('ChatGPTTopP'), -1)
          else
            FChatGPTTopP := -1;

          if ValueExists('ChatGPTSourceIdentifier') then
            FIdentifier := IfThen(ReadString('ChatGPTSourceIdentifier').IsEmpty, DefaultIdentifier, ReadString('ChatGPTSourceIdentifier'))
          else
            FIdentifier := DefaultIdentifier;

          if ValueExists('ChatGPTCodeFormatter') then
            FCodeFormatter := ReadBool('ChatGPTCodeFormatter')
          else
            FCodeFormatter := DefaultCodeFormatter;

          if ValueExists('ChatGPTRTL') then
            FRightToLeft := ReadBool('ChatGPTRTL')
          else
            FRightToLeft := DefaultRTL;

          if ValueExists('ChatGPTProxyActive') then
            FProxySetting.Active := ReadBool('ChatGPTProxyActive')
          else
            FProxySetting.Active := False;

          if ValueExists('ChatGPTProxyHost') then
            FProxySetting.ProxyHost := ReadString('ChatGPTProxyHost')
          else
            FProxySetting.ProxyHost := '';

          if ValueExists('ChatGPTProxyPort') then
            FProxySetting.ProxyPort := ReadInteger('ChatGPTProxyPort')
          else
            FProxySetting.ProxyPort := 0;

          if ValueExists('ChatGPTProxyUsername') then
            FProxySetting.ProxyUsername := ReadString('ChatGPTProxyUsername')
          else
            FProxySetting.ProxyUsername := '';

          if ValueExists('ChatGPTProxyPassword') then
            FProxySetting.ProxyPassword := ReadString('ChatGPTProxyPassword')
          else
            FProxySetting.ProxyPassword := '';

          if ValueExists('ChatGPTHistoryEnabled') then
          begin
            FHistoryEnabled := ReadBool('ChatGPTHistoryEnabled');
            FShouldReloadHistory := FHistoryEnabled;
          end;

          if ValueExists('ChatGPTHistoryPath') then
            FHistoryPath := ReadString('ChatGPTHistoryPath')
          else
            FHistoryPath := '';

          if ValueExists('ChatGPTHighlightColor') then
            FHighlightColor := ReadInteger('ChatGPTHighlightColor')
          else
            FHighlightColor := clRed;

          if ValueExists('ChatGPTAnimatedLetters') then
            FAnimatedLetters := ReadBool('ChatGPTAnimatedLetters')
          else
            FAnimatedLetters := True;

          if ValueExists('ChatGPTTimeOut') then
            FTimeOut := ReadInteger('ChatGPTTimeOut')
          else
            FTimeOut := 20;

          if ValueExists(CMainFormLastQuestionValueName) then
            FMainFormLastQuestion := ReadString(CMainFormLastQuestionValueName).Trim
          else if ValueExists(CLegacyMainFormLastQuestionValueName) then
            FMainFormLastQuestion := ReadString(CLegacyMainFormLastQuestionValueName).Trim
          else
            FMainFormLastQuestion := 'Create a class to make a Zip file in Delphi.';
          if ValueExists('ChatGPTEnabled') then
            FEnableChatGPT := ReadBool('ChatGPTEnabled')
          else
            FEnableChatGPT := True;

          if ValueExists('DefaultProviderId') then
            FDefaultProviderId := ReadString('DefaultProviderId');

          if ValueExists('EnableFileLog') then
            FEnableFileLog := ReadBool('EnableFileLog')
          else if ValueExists('EnableIDEMessagesLog') then
            FEnableFileLog := ReadBool('EnableIDEMessagesLog');

          if ValueExists('LogDirectory') then
            FLogDirectory := ReadString('LogDirectory');
        end;

        if OpenKey(CProvidersRegistryRoot + '\Gemini', False) or OpenKey(CLegacyProvidersRegistryRoot + '\Gemini', False) then
        begin
          FEnableGemini := ReadBool('Enabled');
          FGeminiAPIKey := ReadString('ApiKey');
          FGeminiBaseURL := IfThen(ReadString('BaseURL').IsEmpty, DefaultGeminiBaseURL, ReadString('BaseURL'));
          FGeminiModel := IfThen(ReadString('DefaultModel').IsEmpty, DefaultGeminiModel, ReadString('DefaultModel'));
          FGeminiMaxTokens := StrToIntDef(ReadString('MaxTokens'), 0);
          FGeminiTemperature := StrToFloatDef(ReadString('Temperature'), -1);
          FGeminiTopP := StrToFloatDef(ReadString('TopP'), -1);
          FGeminiTopK := StrToIntDef(ReadString('TopK'), 0);
        end;

        if OpenKey(CProvidersRegistryRoot + '\Claude', False) or OpenKey(CLegacyProvidersRegistryRoot + '\Claude', False) then
        begin
          FEnableClaude := ReadBool('Enabled');
          FClaudeAPIKey := ReadString('ApiKey');
          FClaudeBaseURL := IfThen(ReadString('BaseURL').IsEmpty, DefaultClaudeBaseURL, ReadString('BaseURL'));
          FClaudeModel := IfThen(ReadString('DefaultModel').IsEmpty, DefaultClaudeModel, ReadString('DefaultModel'));
          FClaudeMaxTokens := StrToIntDef(ReadString('MaxTokens'), 0);
          FClaudeTemperature := StrToFloatDef(ReadString('Temperature'), -1);
          FClaudeTopP := StrToFloatDef(ReadString('TopP'), -1);
          FClaudeApiVersion := IfThen(ReadString('ApiVersion').IsEmpty, AnthropicVersionHeader, ReadString('ApiVersion'));
        end;

        if OpenKey(CProvidersRegistryRoot + '\Ollama', False) or OpenKey(CLegacyProvidersRegistryRoot + '\Ollama', False) then
        begin
          FEnableOllama := ReadBool('Enabled');
          FOllamaAPIKey := ReadString('ApiKey');
          FOllamaBaseURL := IfThen(ReadString('BaseURL').IsEmpty, DefaultOllamaBaseURL, ReadString('BaseURL'));
          FOllamaModel := IfThen(ReadString('DefaultModel').IsEmpty, DefaultOllamaModel, ReadString('DefaultModel'));
          FOllamaMaxTokens := StrToIntDef(ReadString('MaxTokens'), 0);
          FOllamaTemperature := StrToFloatDef(ReadString('Temperature'), -1);
          FOllamaTopP := StrToFloatDef(ReadString('TopP'), -1);
          FOllamaTopK := StrToIntDef(ReadString('TopK'), 0);
        end
        else if OpenKey(CRegistryRoot, False) or OpenKey(CLegacyRegistryRoot, False) then
        begin
          if ValueExists('ChatGPTIsOffline') then
            FEnableOllama := ReadBool('ChatGPTIsOffline');
          FOllamaBaseURL := DefaultOllamaBaseURL;
          if ValueExists('ChatGPTModel') then
            FOllamaModel := ReadString('ChatGPTModel');
        end;

        if OpenKey(CQuestionsRegistryRoot, False) or OpenKey(CLegacyQuestionsRegistryRoot, False) then
        begin
          FPredefinedQuestions.Clear;
          for I := 1 to 100 do
          begin
            if (ValueExists('Caption' + I.ToString)) and (ValueExists('Question' + I.ToString)) then
              FPredefinedQuestions.Add(I, TQuestionPair.Create(ReadString('Caption' + I.ToString), ReadString('Question' + I.ToString)));
          end;

          if FPredefinedQuestions.Count = 0 then
            LoadDefaultQuestions;
        end
        else
          LoadDefaultQuestions;
      end;
    except
      LoadDefaults;
    end;
  finally
    LvRegKey.Free;
  end;
end;

class procedure TSingletonSettingObj.RegisterFormClassForTheming(const AFormClass: TCustomFormClass; const Component: TComponent);
{$IF CompilerVersion >= 32.0}
Var
{$IF CompilerVersion > 33.0} // Breaking change to the Open Tools API - They fixed the wrongly defined interface
  ITS: IOTAIDEThemingServices;
{$ELSE}
  ITS: IOTAIDEThemingServices250;
{$IFEND}
{$IFEND}
begin
{$IF CompilerVersion >= 32.0}
{$IF CompilerVersion > 33.0}
  If Supports(BorlandIDEServices, IOTAIDEThemingServices, ITS) Then
{$ELSE}
  If Supports(BorlandIDEServices, IOTAIDEThemingServices250, ITS) Then
{$IFEND}
    If ITS.IDEThemingEnabled Then
    begin
      ITS.RegisterFormClass(AFormClass);
      If Assigned(Component) Then
        ITS.ApplyTheme(Component);
    end;
{$IFEND}
end;

function TSingletonSettingObj.TryFindQuestion(ACaption: string; var AQuestion: string): Integer;
var
  LvKey: Integer;
begin
  AQuestion := '';
  Result := -1;

  for LvKey in FPredefinedQuestions.Keys do
  begin
    if FPredefinedQuestions.Items[LvKey].Caption.ToLower.Trim = ACaption.ToLower.Trim then
    begin
      AQuestion := FPredefinedQuestions.Items[LvKey].Question;
      Result := LvKey;
      Break;
    end;
  end;
end;

procedure TSingletonSettingObj.WriteToRegistry;
var
  LvRegKey: TRegistry;
  LvKey: Integer;
  I: Integer;
begin
  LvRegKey := TRegistry.Create;
  try
    with LvRegKey do
    begin
      CloseKey;
      RootKey := HKEY_CURRENT_USER;
      if OpenKey(CRegistryRoot, True) then
      begin
        WriteString('ChatGPTApiKey', FApiKey);
        WriteString('ChatGPTURL', FURL);
        WriteString('ChatGPTModel', FModel);
        WriteInteger('ChatGPTMaxToken', FMaxToken);
        WriteInteger('ChatGPTTemperature', FTemperature);
        WriteString('ChatGPTTopP', FloatToStr(FChatGPTTopP));
        WriteString('ChatGPTSourceIdentifier', FIdentifier);
        WriteBool('ChatGPTCodeFormatter', FCodeFormatter);
        WriteBool('ChatGPTRTL', FRightToLeft);
        WriteBool('ChatGPTProxyActive', FProxySetting.Active);
        WriteString('ChatGPTProxyHost', FProxySetting.ProxyHost);
        WriteInteger('ChatGPTProxyPort', FProxySetting.ProxyPort);
        WriteString('ChatGPTProxyUsername', FProxySetting.ProxyUsername);
        WriteString('ChatGPTProxyPassword', FProxySetting.ProxyPassword);
        WriteBool('ChatGPTHistoryEnabled', FHistoryEnabled);
        WriteString('ChatGPTHistoryPath', FHistoryPath);
        WriteInteger('ChatGPTHighlightColor', FHighlightColor);
        WriteBool('ChatGPTAnimatedLetters', FAnimatedLetters);
        WriteInteger('ChatGPTTimeOut', FTimeOut);
        WriteString(CMainFormLastQuestionValueName, FMainFormLastQuestion.Trim);
        WriteBool('ChatGPTEnabled', FEnableChatGPT);
        WriteString('DefaultProviderId', FDefaultProviderId);
        WriteBool('EnableFileLog', FEnableFileLog);
        WriteString('LogDirectory', FLogDirectory);

        if OpenKey(CProvidersRegistryRoot + '\Gemini', True) then
        begin
          WriteBool('Enabled', FEnableGemini);
          WriteString('ApiKey', FGeminiAPIKey);
          WriteString('BaseURL', FGeminiBaseURL);
          WriteString('DefaultModel', FGeminiModel);
          WriteString('MaxTokens', FGeminiMaxTokens.ToString);
          WriteString('Temperature', FloatToStr(FGeminiTemperature));
          WriteString('TopP', FloatToStr(FGeminiTopP));
          WriteString('TopK', FGeminiTopK.ToString);
        end;

        if OpenKey(CProvidersRegistryRoot + '\Claude', True) then
        begin
          WriteBool('Enabled', FEnableClaude);
          WriteString('ApiKey', FClaudeAPIKey);
          WriteString('BaseURL', FClaudeBaseURL);
          WriteString('DefaultModel', FClaudeModel);
          WriteString('MaxTokens', FClaudeMaxTokens.ToString);
          WriteString('Temperature', FloatToStr(FClaudeTemperature));
          WriteString('TopP', FloatToStr(FClaudeTopP));
          WriteString('ApiVersion', FClaudeApiVersion);
        end;

        if OpenKey(CProvidersRegistryRoot + '\Ollama', True) then
        begin
          WriteBool('Enabled', FEnableOllama);
          WriteString('ApiKey', FOllamaAPIKey);
          WriteString('BaseURL', FOllamaBaseURL);
          WriteString('DefaultModel', FOllamaModel);
          WriteString('MaxTokens', FOllamaMaxTokens.ToString);
          WriteString('Temperature', FloatToStr(FOllamaTemperature));
          WriteString('TopP', FloatToStr(FOllamaTopP));
          WriteString('TopK', FOllamaTopK.ToString);
        end;

        if OpenKey(CQuestionsRegistryRoot, True) then
        begin
          for I:= 0  to 100 do // Limited to maximum 100 menuitems.
          begin
            if ValueExists('Caption' + I.ToString) then
              DeleteValue('Caption' + I.ToString);

            if ValueExists('Question' + I.ToString) then
              DeleteValue('Question' + I.ToString);
          end;

          for LvKey in FPredefinedQuestions.Keys do
          begin
            WriteString('Caption' + LvKey.ToString, FPredefinedQuestions.Items[LvKey].Caption);
            WriteString('Question' + LvKey.ToString, FPredefinedQuestions.Items[LvKey].Question);
          end;
        end;
      end;
    end;
  finally
    LvRegKey.Free;
  end;
end;

{TFrm_Setting}

procedure TFrm_Setting.Btn_AddQuestionClick(Sender: TObject);
begin
  HasChanges := True;
  AddQuestion;
end;

procedure TFrm_Setting.Btn_DefaultClick(Sender: TObject);
begin
  edt_ApiKey.Text := '';
  edt_Url.Text := DefaultChatGPTBaseURL;
  cbbModel.Text := DefaultChatGPTModel;
  edt_MaxToken.Text := IntToStr(DefaultMaxToken);
  edt_Temperature.Text := IntToStr(DefaultTemperature);
  chk_CodeFormatter.Checked := DefaultCodeFormatter;
  chk_Rtl.Checked := DefaultRTL;
  lbEdt_ProxyHost.Text := '';
  lbEdt_ProxyPort.Text := '';
  lbEdt_ProxyUserName.Text := '';
  lbEdt_ProxyPassword.Text := '';
  chk_History.Checked := False;
  lbEdt_History.Text := '';
  ColorBox_Highlight.Selected := clRed;
  chk_AnimatedLetters.Checked := True;
  if Assigned(FChkChatGPTEnabled) then
    FChkChatGPTEnabled.Checked := True;
  chk_Gemini.Checked := False;
  chk_Claude.Checked := False;
  if Assigned(FChkOllamaEnabled) then
    FChkOllamaEnabled.Checked := False;
  lbEdt_GeminiBaseURL.Text := DefaultGeminiBaseURL;
  lbEdt_ClaudeBaseURL.Text := DefaultClaudeBaseURL;
  if Assigned(FCbbGeminiModel) then
    FCbbGeminiModel.Text := DefaultGeminiModel;
  if Assigned(FCbbClaudeModel) then
    FCbbClaudeModel.Text := DefaultClaudeModel;
  if Assigned(FLbEdtOllamaBaseURL) then
    FLbEdtOllamaBaseURL.Text := DefaultOllamaBaseURL;
  if Assigned(FCbbOllamaModel) then
    FCbbOllamaModel.Text := DefaultOllamaModel;
  chk_Offline.Checked := False;
  edt_OfflineModel.Visible := False;
  chk_Offline.Visible := False;
  ApplyProviderEditorState;
end;

procedure TFrm_Setting.Btn_HistoryPathBuilderClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  begin
    try
      Options := [fdoPickFolders];
      if Execute then
      begin
        if Assigned(Sender) and Assigned(FBtnLogPathBuilder) and (Sender = FBtnLogPathBuilder) then
          FLbEdtLogDirectory.Text := FileName
        else
          lbEdt_History.Text := FileName;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TFrm_Setting.Btn_SaveClick(Sender: TObject);
var
  I: Integer;
  LvSettingObj: TSingletonSettingObj;
  LvCaption, LvQuestion: string;
  LvLabeledEdit: TControl;
  Lvpanel: TControl;
begin
  if not ValidateInputs then
    Exit;

  LvSettingObj := TSingletonSettingObj.Instance;
  LvSettingObj.ApiKey := Trim(edt_ApiKey.Text);
  LvSettingObj.URL := Trim(edt_Url.Text);
  LvSettingObj.Model := Trim(cbbModel.Text);

  LvSettingObj.MaxToken := StrToInt(edt_MaxToken.Text);
  LvSettingObj.Temperature := StrToInt(edt_Temperature.Text);
  if Assigned(FEdtChatGPTTopP) then
    if Trim(FEdtChatGPTTopP.Text) = '' then
      LvSettingObj.ChatGPTTopP := -1
    else
      LvSettingObj.ChatGPTTopP := StrToFloatDef(FEdtChatGPTTopP.Text, -1);
  LvSettingObj.RighToLeft := chk_Rtl.Checked;
  LvSettingObj.CodeFormatter := chk_CodeFormatter.Checked;
  LvSettingObj.Identifier := Edt_SourceIdentifier.Text;
  LvSettingObj.ProxySetting.ProxyHost := lbEdt_ProxyHost.Text;
  LvSettingObj.ProxySetting.ProxyPort := StrToIntDef(lbEdt_ProxyPort.Text, 0);
  LvSettingObj.ProxySetting.Active := chk_ProxyActive.Checked;
  LvSettingObj.ProxySetting.ProxyUsername := lbEdt_ProxyUserName.Text;
  LvSettingObj.ProxySetting.ProxyPassword := lbEdt_ProxyPassword.Text;
  if (chk_History.Checked) and (not LvSettingObj.HistoryEnabled) then
    LvSettingObj.ShouldReloadHistory := True;

  LvSettingObj.HistoryEnabled := chk_History.Checked;
  LvSettingObj.HistoryPath := lbEdt_History.Text;
  LvSettingObj.HighlightColor := ColorBox_Highlight.Selected;
  LvSettingObj.AnimatedLetters := chk_AnimatedLetters.Checked;
  if Assigned(FChkFileLog) then
    LvSettingObj.EnableFileLog := FChkFileLog.Checked;
  if Assigned(FLbEdtLogDirectory) then
    LvSettingObj.LogDirectory := Trim(FLbEdtLogDirectory.Text);
  LvSettingObj.TimeOut := StrToInt(Frm_Setting.lbEdt_Timeout.Text);
  LvSettingObj.EnableChatGPT := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
  LvSettingObj.EnableGemini := chk_Gemini.Checked;
  LvSettingObj.GeminiAPIKey := lbEdt_GeminiAPIKey.Text;
  LvSettingObj.GeminiBaseURL := lbEdt_GeminiBaseURL.Text;
  if Assigned(FCbbGeminiModel) then
    LvSettingObj.GeminiModel := FCbbGeminiModel.Text;
  if Assigned(FEdtGeminiMaxTokens) then
    LvSettingObj.GeminiMaxTokens := StrToIntDef(FEdtGeminiMaxTokens.Text, 0);
  if Assigned(FEdtGeminiTemperature) then
    LvSettingObj.GeminiTemperature := StrToFloatDef(FEdtGeminiTemperature.Text, -1);
  if Assigned(FEdtGeminiTopP) then
    LvSettingObj.GeminiTopP := StrToFloatDef(FEdtGeminiTopP.Text, -1);
  if Assigned(FEdtGeminiTopK) then
    LvSettingObj.GeminiTopK := StrToIntDef(FEdtGeminiTopK.Text, 0);

  LvSettingObj.EnableClaude := chk_Claude.Checked;
  LvSettingObj.ClaudeAPIKey := lbEdt_ClaudeAPIKey.Text;
  LvSettingObj.ClaudeBaseURL := lbEdt_ClaudeBaseURL.Text;
  if Assigned(FCbbClaudeModel) then
    LvSettingObj.ClaudeModel := FCbbClaudeModel.Text;
  if Assigned(FEdtClaudeMaxTokens) then
    LvSettingObj.ClaudeMaxTokens := StrToIntDef(FEdtClaudeMaxTokens.Text, 0);
  if Assigned(FEdtClaudeTemperature) then
    LvSettingObj.ClaudeTemperature := StrToFloatDef(FEdtClaudeTemperature.Text, -1);
  if Assigned(FEdtClaudeTopP) then
    LvSettingObj.ClaudeTopP := StrToFloatDef(FEdtClaudeTopP.Text, -1);
  if Assigned(FEdtClaudeApiVersion) then
    LvSettingObj.ClaudeApiVersion := Trim(FEdtClaudeApiVersion.Text);

  LvSettingObj.EnableOllama := Assigned(FChkOllamaEnabled) and FChkOllamaEnabled.Checked;
  if Assigned(FLbEdtOllamaAPIKey) then
    LvSettingObj.OllamaAPIKey := FLbEdtOllamaAPIKey.Text;
  if Assigned(FLbEdtOllamaBaseURL) then
    LvSettingObj.OllamaBaseURL := FLbEdtOllamaBaseURL.Text;
  if Assigned(FCbbOllamaModel) then
    LvSettingObj.OllamaModel := FCbbOllamaModel.Text;
  if Assigned(FEdtOllamaMaxTokens) then
    LvSettingObj.OllamaMaxTokens := StrToIntDef(FEdtOllamaMaxTokens.Text, 0);
  if Assigned(FEdtOllamaTemperature) then
    LvSettingObj.OllamaTemperature := StrToFloatDef(FEdtOllamaTemperature.Text, -1);
  if Assigned(FEdtOllamaTopP) then
    LvSettingObj.OllamaTopP := StrToFloatDef(FEdtOllamaTopP.Text, -1);
  if Assigned(FEdtOllamaTopK) then
    LvSettingObj.OllamaTopK := StrToIntDef(FEdtOllamaTopK.Text, 0);
  if Assigned(FCbbDefaultProvider) then
    LvSettingObj.DefaultProviderId := ProviderCaptionToId(FCbbDefaultProvider.Text);

  lbEdt_History.Enabled := chk_History.Checked;
  Btn_HistoryPathBuilder.Enabled := chk_History.Checked;

  LvSettingObj.PredefinedQuestions.Clear;
  for I := 1 to 100 do
  begin
    LvLabeledEdit := nil;
    Lvpanel := nil;

    Lvpanel := GridPanelPredefinedQs.FindChildControl('panel' + I.ToString);
    if Lvpanel <> nil then
    begin  
      LvLabeledEdit := TPanel(Lvpanel).FindChildControl('CustomLbl' + I.ToString);
      if LvLabeledEdit <> nil then
      begin
        LvCaption := TLabeledEdit(LvLabeledEdit).Text;
        LvQuestion := TMemo(TPanel(Lvpanel).FindChildControl('CustomLblQ' + I.ToString)).Lines.Text;
        if (not LvCaption.IsEmpty) and (not LvQuestion.IsEmpty) then
          LvSettingObj.PredefinedQuestions.Add(I, TQuestionPair.Create(LvCaption, LvQuestion));
      end;
    end;      
  end;
  LvSettingObj.WriteToRegistry;
  if Assigned(LvSettingObj.DockableFormPointer) then
    TChatGPTDockForm(LvSettingObj.DockableFormPointer).Fram_Question.ConfigureProviderPages;
  Close;
end;

procedure TFrm_Setting.Btn_RemoveQuestionClick(Sender: TObject);
begin
  HasChanges := True;
  RemoveLatestQuestion;
end;

procedure TFrm_Setting.cbbModelChange(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_Setting.chk_AnimatedLettersClick(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_Setting.chk_HistoryClick(Sender: TObject);
begin
  lbEdt_History.Enabled := chk_History.Checked;
  Btn_HistoryPathBuilder.Enabled := chk_History.Checked;
  HasChanges := True;
end;

procedure TFrm_Setting.chk_OfflineClick(Sender: TObject);
begin
  // Offline mode is now configured through the dedicated Ollama provider section.
end;

procedure TFrm_Setting.chk_ProxyActiveClick(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_Setting.chk_GeminiClick(Sender: TObject);
begin
  HasChanges := True;
  lbEdt_GeminiAPIKey.Enabled := chk_Gemini.Checked;
  lbEdt_GeminiBaseURL.Enabled := chk_Gemini.Checked;
  if Assigned(FCbbGeminiModel) then
    FCbbGeminiModel.Enabled := chk_Gemini.Checked;
  if Assigned(FBtnRefreshGeminiModels) then
    FBtnRefreshGeminiModels.Enabled := chk_Gemini.Checked;
  if Assigned(FEdtGeminiMaxTokens) then
    FEdtGeminiMaxTokens.Enabled := chk_Gemini.Checked;
  if Assigned(FEdtGeminiTemperature) then
    FEdtGeminiTemperature.Enabled := chk_Gemini.Checked;
  if Assigned(FEdtGeminiTopP) then
    FEdtGeminiTopP.Enabled := chk_Gemini.Checked;
  if Assigned(FEdtGeminiTopK) then
    FEdtGeminiTopK.Enabled := chk_Gemini.Checked;
  RefreshDefaultProviderChoices;
end;

procedure TFrm_Setting.chk_ChatGPTClick(Sender: TObject);
begin
  HasChanges := True;
  ApplyProviderEditorState;
end;

procedure TFrm_Setting.chk_ClaudeClick(Sender: TObject);
begin
  HasChanges := True;
  lbEdt_ClaudeAPIKey.Enabled := chk_Claude.Checked;
  lbEdt_ClaudeBaseURL.Enabled := chk_Claude.Checked;
  if Assigned(FCbbClaudeModel) then
    FCbbClaudeModel.Enabled := chk_Claude.Checked;
  if Assigned(FBtnRefreshClaudeModels) then
    FBtnRefreshClaudeModels.Enabled := chk_Claude.Checked;
  if Assigned(FEdtClaudeMaxTokens) then
    FEdtClaudeMaxTokens.Enabled := chk_Claude.Checked;
  if Assigned(FEdtClaudeTemperature) then
    FEdtClaudeTemperature.Enabled := chk_Claude.Checked;
  if Assigned(FEdtClaudeTopP) then
    FEdtClaudeTopP.Enabled := chk_Claude.Checked;
  if Assigned(FEdtClaudeApiVersion) then
    FEdtClaudeApiVersion.Enabled := chk_Claude.Checked;
  RefreshDefaultProviderChoices;
end;

procedure TFrm_Setting.chk_OllamaClick(Sender: TObject);
begin
  HasChanges := True;
  ApplyProviderEditorState;
end;

procedure TFrm_Setting.chk_FileLogClick(Sender: TObject);
begin
  HasChanges := True;
  if Assigned(FLbEdtLogDirectory) then
    FLbEdtLogDirectory.Enabled := Assigned(FChkFileLog) and FChkFileLog.Checked;
  if Assigned(FBtnLogPathBuilder) then
    FBtnLogPathBuilder.Enabled := Assigned(FChkFileLog) and FChkFileLog.Checked;
end;

procedure TFrm_Setting.ApplyProviderEditorState;
begin
  edt_ApiKey.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
  edt_Url.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
  cbbModel.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
  edt_MaxToken.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
  edt_Temperature.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
  if Assigned(FEdtChatGPTTopP) then
    FEdtChatGPTTopP.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
  if Assigned(FBtnRefreshChatGPTModels) then
    FBtnRefreshChatGPTModels.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;

  chk_GeminiClick(chk_Gemini);
  chk_ClaudeClick(chk_Claude);

  if Assigned(FChkOllamaEnabled) then
  begin
    FLbEdtOllamaAPIKey.Enabled := FChkOllamaEnabled.Checked;
    FLbEdtOllamaBaseURL.Enabled := FChkOllamaEnabled.Checked;
    FCbbOllamaModel.Enabled := FChkOllamaEnabled.Checked;
    FBtnRefreshOllamaModels.Enabled := FChkOllamaEnabled.Checked;
    if Assigned(FEdtOllamaMaxTokens) then
      FEdtOllamaMaxTokens.Enabled := FChkOllamaEnabled.Checked;
    if Assigned(FEdtOllamaTemperature) then
      FEdtOllamaTemperature.Enabled := FChkOllamaEnabled.Checked;
    if Assigned(FEdtOllamaTopP) then
      FEdtOllamaTopP.Enabled := FChkOllamaEnabled.Checked;
    if Assigned(FEdtOllamaTopK) then
      FEdtOllamaTopK.Enabled := FChkOllamaEnabled.Checked;
  end;

  RefreshDefaultProviderChoices;
  chk_FileLogClick(FChkFileLog);
end;

procedure TFrm_Setting.ConfigureMainSettingsLayout;
begin
  grp_OpenAI.Caption := CaptionChatGPT;
  grp_OpenAI.Height := 320;
  pnlOpenAI.BevelOuter := bvLowered;

  lbl_4.Visible := True;
  lbl_5.Visible := True;
  lbl_4.Caption := CaptionMaxTokens + ':';
  lbl_5.Caption := CaptionTemperature + ':';
  edt_MaxToken.Visible := True;
  edt_Temperature.Visible := True;

  if not Assigned(FEdtChatGPTTopP) then
  begin
    FEdtChatGPTTopP := TLabeledEdit.Create(Self);
    FEdtChatGPTTopP.Parent := pnlOpenAI;
    FEdtChatGPTTopP.EditLabel.Caption := CaptionTopP;
    FEdtChatGPTTopP.LabelPosition := lpAbove;
    FEdtChatGPTTopP.OnChange := edt_UrlChange;
  end;

  if Assigned(FChkChatGPTEnabled) then
    FChkChatGPTEnabled.SetBounds(18, 12, 150, 19);

  lbl_1.Left := 18;
  lbl_1.Top := 44;
  lbl_2.Left := 18;
  lbl_2.Top := 100;
  lbl_3.Left := 18;
  lbl_3.Top := 156;
  lbl_4.Left := 18;
  lbl_4.Top := 214;
  lbl_5.Left := 211;
  lbl_5.Top := 214;

  edt_Url.SetBounds(18, 60, 389, 23);
  edt_ApiKey.SetBounds(18, 116, 389, 23);
  cbbModel.SetBounds(18, 172, 301, 23);
  cbbModel.Style := csDropDown;
  edt_MaxToken.SetBounds(18, 230, 175, 23);
  edt_Temperature.SetBounds(211, 230, 196, 23);
  FEdtChatGPTTopP.SetBounds(18, 286, 175, 23);

  if Assigned(FBtnRefreshChatGPTModels) then
    FBtnRefreshChatGPTModels.SetBounds(325, 170, 82, 25);

  lbEdt_Timeout.LabelPosition := lpAbove;
  lbEdt_Timeout.SetBounds(211, 286, 196, 23);
  lbEdt_Timeout.EditLabel.Caption := CaptionRequestTimeout;
  lbEdt_Timeout.EditLabel.Left := 211;
  lbEdt_Timeout.EditLabel.Top := 270;
end;

procedure TFrm_Setting.ConfigureOtherProviderLayout;
begin
  if not Assigned(FAIServiceHeaderPanel) then
  begin
    FAIServiceHeaderPanel := TPanel.Create(Self);
    FAIServiceHeaderPanel.Parent := pnlMain;
    FAIServiceHeaderPanel.Align := alTop;
    FAIServiceHeaderPanel.BevelOuter := bvNone;
    FAIServiceHeaderPanel.Height := 42;

    FLblDefaultProvider := TLabel.Create(Self);
    FLblDefaultProvider.Parent := FAIServiceHeaderPanel;
    FLblDefaultProvider.Caption := CaptionDefaultProvider;
    FLblDefaultProvider.Transparent := True;
    FLblDefaultProvider.SetBounds(12, 14, 110, 15);

    FCbbDefaultProvider := TComboBox.Create(Self);
    FCbbDefaultProvider.Parent := FAIServiceHeaderPanel;
    FCbbDefaultProvider.Style := csDropDownList;
    FCbbDefaultProvider.OnChange := cbbModelChange;
    FCbbDefaultProvider.SetBounds(128, 10, 170, 23);
  end;

  if not Assigned(FOtherAIPageControl) then
  begin
    FOtherAIPageControl := TPageControl.Create(Self);
    FOtherAIPageControl.Parent := pnlOtherAIMain;
    FOtherAIPageControl.Align := alClient;

    FTabChatGPT := TTabSheet.Create(Self);
    FTabChatGPT.PageControl := FOtherAIPageControl;
    FTabChatGPT.Caption := CaptionChatGPT;

    FTabGemini := TTabSheet.Create(Self);
    FTabGemini.PageControl := FOtherAIPageControl;
    FTabGemini.Caption := CaptionGemini;

    FTabClaude := TTabSheet.Create(Self);
    FTabClaude.PageControl := FOtherAIPageControl;
    FTabClaude.Caption := CaptionClaude;

    FTabOllama := TTabSheet.Create(Self);
    FTabOllama.PageControl := FOtherAIPageControl;
    FTabOllama.Caption := CaptionOllama;

    FOtherAIPageControl.ActivePageIndex := 0;
  end;

  grp_OpenAI.Parent := FTabChatGPT;
  grp_OpenAI.Align := alClient;
  grp_Gemini.Parent := FTabGemini;
  grp_Gemini.Align := alClient;
  grp_Claude.Parent := FTabClaude;
  grp_Claude.Align := alClient;
  ConfigureMainSettingsLayout;
  ConfigureProviderPanel(grp_Gemini, pnlGemini, chk_Gemini,
    lbEdt_GeminiAPIKey, lbEdt_GeminiBaseURL, FCbbGeminiModel, FLblGeminiModel, FBtnRefreshGeminiModels);
  ConfigureProviderPanel(grp_Claude, pnlClaude, chk_Claude,
    lbEdt_ClaudeAPIKey, lbEdt_ClaudeBaseURL, FCbbClaudeModel, FLblClaudeModel, FBtnRefreshClaudeModels);
  if Assigned(FGrpOllama) then
  begin
    FGrpOllama.Parent := FTabOllama;
    FGrpOllama.Align := alClient;
  end;
  ConfigureProviderPanel(FGrpOllama, FPnlOllama, FChkOllamaEnabled,
    FLbEdtOllamaAPIKey, FLbEdtOllamaBaseURL, FCbbOllamaModel, FLblOllamaModel, FBtnRefreshOllamaModels);
  ConfigureProviderAdvancedOptions;
end;

procedure TFrm_Setting.ConfigureProviderPanel(AGroup: TGroupBox; APanel: TPanel; ACheckBox: TCheckBox;
  AApiKeyEdit, ABaseURLedIt: TLabeledEdit; AModelCombo: TComboBox; AModelLabel: TLabel; ARefreshButton: TButton);
begin
  if not Assigned(AGroup) or not Assigned(APanel) then
    Exit;

  AGroup.Height := 320;
  APanel.BevelOuter := bvLowered;

  if Assigned(ACheckBox) then
    ACheckBox.SetBounds(18, 12, 160, 19);

  if Assigned(AApiKeyEdit) then
  begin
    AApiKeyEdit.LabelPosition := lpAbove;
    AApiKeyEdit.SetBounds(18, 48, 385, 23);
  end;

  if Assigned(ABaseURLedIt) then
  begin
    ABaseURLedIt.LabelPosition := lpAbove;
    ABaseURLedIt.SetBounds(18, 104, 385, 23);
  end;

  if Assigned(AModelLabel) then
  begin
    AModelLabel.Left := 18;
    AModelLabel.Top := 146;
  end;

  if Assigned(AModelCombo) then
  begin
    AModelCombo.SetBounds(18, 162, 301, 23);
    AModelCombo.Style := csDropDown;
  end;

  if Assigned(ARefreshButton) then
    ARefreshButton.SetBounds(325, 160, 78, 25);
end;

function TFrm_Setting.CreateProviderOptionEdit(AParent: TWinControl; const ALabelCaption, AName: string): TLabeledEdit;
begin
  Result := TLabeledEdit.Create(Self);
  Result.Parent := AParent;
  Result.Name := AName;
  Result.EditLabel.Caption := ALabelCaption;
  Result.LabelPosition := lpAbove;
  Result.Text := '';
  Result.OnChange := edt_UrlChange;
end;

procedure TFrm_Setting.LayoutProviderOptionEdits(const APanel: TPanel; const AOptionEdits: array of TLabeledEdit);
const
  LeftCol = 18;
  RightCol = 211;
  WidthCol = 175;
  FirstRowTop = 218;
  RowSpacing = 56;
var
  I: Integer;
  LEdit: TLabeledEdit;
begin
  for I := Low(AOptionEdits) to High(AOptionEdits) do
  begin
    LEdit := AOptionEdits[I];
    if not Assigned(LEdit) then
      Continue;

    LEdit.LabelPosition := lpAbove;
    if Odd(I) then
      LEdit.SetBounds(RightCol, FirstRowTop + (I div 2) * RowSpacing, WidthCol, 23)
    else
      LEdit.SetBounds(LeftCol, FirstRowTop + (I div 2) * RowSpacing, WidthCol, 23);
  end;
end;

procedure TFrm_Setting.ConfigureProviderAdvancedOptions;
begin
  LayoutProviderOptionEdits(pnlGemini, [FEdtGeminiMaxTokens, FEdtGeminiTemperature, FEdtGeminiTopP, FEdtGeminiTopK]);
  LayoutProviderOptionEdits(pnlClaude, [FEdtClaudeMaxTokens, FEdtClaudeTemperature, FEdtClaudeTopP, FEdtClaudeApiVersion]);
  LayoutProviderOptionEdits(FPnlOllama, [FEdtOllamaMaxTokens, FEdtOllamaTemperature, FEdtOllamaTopP, FEdtOllamaTopK]);
end;

function TFrm_Setting.ProviderIdToCaption(const AProviderId: string): string;
begin
  if SameText(AProviderId, ProviderGemini) then
    Exit(CaptionGemini);
  if SameText(AProviderId, ProviderClaude) then
    Exit(CaptionClaude);
  if SameText(AProviderId, ProviderOllama) then
    Exit(CaptionOllama);
  Result := CaptionChatGPT;
end;

function TFrm_Setting.ProviderCaptionToId(const ACaption: string): string;
begin
  if SameText(ACaption, CaptionGemini) then
    Exit(ProviderGemini);
  if SameText(ACaption, CaptionClaude) then
    Exit(ProviderClaude);
  if SameText(ACaption, CaptionOllama) then
    Exit(ProviderOllama);
  Result := ProviderChatGPT;
end;

procedure TFrm_Setting.RefreshDefaultProviderChoices;
var
  LCurrentProviderId: string;

  procedure AddProviderChoice(const AProviderId: string; AEnabled: Boolean);
  begin
    if AEnabled and Assigned(FCbbDefaultProvider) then
      FCbbDefaultProvider.Items.Add(ProviderIdToCaption(AProviderId));
  end;

begin
  if not Assigned(FCbbDefaultProvider) then
    Exit;

  LCurrentProviderId := ProviderCaptionToId(FCbbDefaultProvider.Text);
  FCbbDefaultProvider.Items.BeginUpdate;
  try
    FCbbDefaultProvider.Items.Clear;
    AddProviderChoice(ProviderChatGPT, Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked);
    AddProviderChoice(ProviderGemini, chk_Gemini.Checked);
    AddProviderChoice(ProviderClaude, chk_Claude.Checked);
    AddProviderChoice(ProviderOllama, Assigned(FChkOllamaEnabled) and FChkOllamaEnabled.Checked);

    if FCbbDefaultProvider.Items.Count = 0 then
      FCbbDefaultProvider.Text := ''
    else if FCbbDefaultProvider.Items.IndexOf(ProviderIdToCaption(LCurrentProviderId)) >= 0 then
      FCbbDefaultProvider.ItemIndex := FCbbDefaultProvider.Items.IndexOf(ProviderIdToCaption(LCurrentProviderId))
    else if FCbbDefaultProvider.Items.IndexOf(ProviderIdToCaption(TSingletonSettingObj.Instance.DefaultProviderId)) >= 0 then
      FCbbDefaultProvider.ItemIndex := FCbbDefaultProvider.Items.IndexOf(ProviderIdToCaption(TSingletonSettingObj.Instance.DefaultProviderId))
    else
      FCbbDefaultProvider.ItemIndex := 0;
  finally
    FCbbDefaultProvider.Items.EndUpdate;
  end;

  FCbbDefaultProvider.Enabled := FCbbDefaultProvider.Items.Count > 0;
end;

procedure TFrm_Setting.ConfigureProviderEditors;

  function CreateRefreshButton(AParent: TWinControl; ALeft, ATop: Integer; const AProviderId: string): TButton;
  begin
    Result := TButton.Create(Self);
    Result.Parent := AParent;
    Result.Left := ALeft;
    Result.Top := ATop;
    Result.Width := 68;
    Result.Height := 25;
    Result.Caption := CaptionRefresh;
    Result.Hint := AProviderId;
    Result.OnClick := RefreshModelClick;
  end;

begin
  grp_OpenAI.Caption := CaptionChatGPT;
  lbl_1.Caption := CaptionBaseURL;
  lbl_2.Caption := CaptionAccessKey;
  lbl_3.Caption := CaptionModel;

  if not Assigned(FChkChatGPTEnabled) then
  begin
    FChkChatGPTEnabled := TCheckBox.Create(Self);
    FChkChatGPTEnabled.Parent := pnlOpenAI;
    FChkChatGPTEnabled.Caption := CaptionEnableChatGPT;
    FChkChatGPTEnabled.OnClick := chk_ChatGPTClick;

    FBtnRefreshChatGPTModels := CreateRefreshButton(pnlOpenAI, 337, 71, ProviderChatGPT);
  end;

  grp_Gemini.Caption := CaptionGemini;
  chk_Gemini.Caption := CaptionEnableGemini;
  lbEdt_GeminiAPIKey.EditLabel.Caption := CaptionAccessKey;
  lbEdt_GeminiBaseURL.EditLabel.Caption := CaptionBaseURL;

  if not Assigned(FCbbGeminiModel) then
  begin
    FCbbGeminiModel := TComboBox.Create(Self);
    FCbbGeminiModel.Parent := pnlGemini;
    FCbbGeminiModel.Style := csDropDown;
    FCbbGeminiModel.OnChange := cbbModelChange;
    FLblGeminiModel := TLabel.Create(Self);
    FLblGeminiModel.Parent := pnlGemini;
    FLblGeminiModel.Caption := CaptionModel;
    FBtnRefreshGeminiModels := CreateRefreshButton(pnlGemini, 333, 106, ProviderGemini);
    FEdtGeminiMaxTokens := CreateProviderOptionEdit(pnlGemini, CaptionMaxTokens, 'GeminiMaxTokens');
    FEdtGeminiTemperature := CreateProviderOptionEdit(pnlGemini, CaptionTemperature, 'GeminiTemperature');
    FEdtGeminiTopP := CreateProviderOptionEdit(pnlGemini, CaptionTopP, 'GeminiTopP');
    FEdtGeminiTopK := CreateProviderOptionEdit(pnlGemini, CaptionTopK, 'GeminiTopK');
  end;

  grp_Claude.Caption := CaptionClaude;
  chk_Claude.Caption := CaptionEnableClaude;
  lbEdt_ClaudeAPIKey.EditLabel.Caption := CaptionAccessKey;
  lbEdt_ClaudeBaseURL.EditLabel.Caption := CaptionBaseURL;

  if not Assigned(FCbbClaudeModel) then
  begin
    FCbbClaudeModel := TComboBox.Create(Self);
    FCbbClaudeModel.Parent := pnlClaude;
    FCbbClaudeModel.Style := csDropDown;
    FCbbClaudeModel.OnChange := cbbModelChange;
    FLblClaudeModel := TLabel.Create(Self);
    FLblClaudeModel.Parent := pnlClaude;
    FLblClaudeModel.Caption := CaptionModel;
    FBtnRefreshClaudeModels := CreateRefreshButton(pnlClaude, 333, 106, ProviderClaude);
    FEdtClaudeMaxTokens := CreateProviderOptionEdit(pnlClaude, CaptionMaxTokens, 'ClaudeMaxTokens');
    FEdtClaudeTemperature := CreateProviderOptionEdit(pnlClaude, CaptionTemperature, 'ClaudeTemperature');
    FEdtClaudeTopP := CreateProviderOptionEdit(pnlClaude, CaptionTopP, 'ClaudeTopP');
    FEdtClaudeApiVersion := CreateProviderOptionEdit(pnlClaude, CaptionAnthropicVersion, 'ClaudeApiVersion');
  end;

  if not Assigned(FGrpOllama) then
  begin
    FGrpOllama := TGroupBox.Create(Self);
    FGrpOllama.Parent := pnlOtherAIMain;
    FGrpOllama.AlignWithMargins := True;
    FGrpOllama.Align := alTop;
    FGrpOllama.Height := 156;
    FGrpOllama.Caption := CaptionOllama;
    FGrpOllama.BringToFront;

    FPnlOllama := TPanel.Create(Self);
    FPnlOllama.Parent := FGrpOllama;
    FPnlOllama.AlignWithMargins := True;
    FPnlOllama.Align := alClient;
    FPnlOllama.BevelOuter := bvLowered;

    FChkOllamaEnabled := TCheckBox.Create(Self);
    FChkOllamaEnabled.Parent := FPnlOllama;
    FChkOllamaEnabled.Caption := CaptionEnableOllama;
    FChkOllamaEnabled.OnClick := chk_OllamaClick;

    FLbEdtOllamaAPIKey := TLabeledEdit.Create(Self);
    FLbEdtOllamaAPIKey.Parent := FPnlOllama;
    FLbEdtOllamaAPIKey.EditLabel.Caption := CaptionOllamaAccessKey;

    FLbEdtOllamaBaseURL := TLabeledEdit.Create(Self);
    FLbEdtOllamaBaseURL.Parent := FPnlOllama;
    FLbEdtOllamaBaseURL.EditLabel.Caption := CaptionBaseURL;

    FCbbOllamaModel := TComboBox.Create(Self);
    FCbbOllamaModel.Parent := FPnlOllama;
    FCbbOllamaModel.Style := csDropDown;
    FLblOllamaModel := TLabel.Create(Self);
    FLblOllamaModel.Parent := FPnlOllama;
    FLblOllamaModel.Caption := CaptionModel;
    FBtnRefreshOllamaModels := CreateRefreshButton(FPnlOllama, 333, 106, ProviderOllama);
    FEdtOllamaMaxTokens := CreateProviderOptionEdit(FPnlOllama, CaptionMaxTokens, 'OllamaMaxTokens');
    FEdtOllamaTemperature := CreateProviderOptionEdit(FPnlOllama, CaptionTemperature, 'OllamaTemperature');
    FEdtOllamaTopP := CreateProviderOptionEdit(FPnlOllama, CaptionTopP, 'OllamaTopP');
    FEdtOllamaTopK := CreateProviderOptionEdit(FPnlOllama, CaptionTopK, 'OllamaTopK');
  end;

  ConfigureMainSettingsLayout;
  ConfigureOtherProviderLayout;
  LoadProviderModels;
  ApplyProviderEditorState;
end;

procedure TFrm_Setting.LoadProviderModels;
var
  LModels: TModelDescriptorList;

  procedure LoadIntoCombo(const AProviderId, ADefaultValue: string; ACombo: TComboBox);
  var
    LIndex: Integer;
  begin
    if not Assigned(ACombo) then
      Exit;

    ACombo.Items.BeginUpdate;
    try
      ACombo.Items.Clear;
      LModels := TModelCatalogService.Instance.GetCachedModels(AProviderId);
      try
        for LIndex := 0 to LModels.Count - 1 do
          ACombo.Items.Add(LModels[LIndex].ModelId);
      finally
        LModels.Free;
      end;

      if (ACombo.Items.IndexOf(ADefaultValue) = -1) and (ADefaultValue <> '') then
        ACombo.Items.Insert(0, ADefaultValue);
      ACombo.Text := ADefaultValue;
    finally
      ACombo.Items.EndUpdate;
    end;
  end;

begin
  LoadIntoCombo(ProviderChatGPT, cbbModel.Text, cbbModel);
  LoadIntoCombo(ProviderGemini, FCbbGeminiModel.Text, FCbbGeminiModel);
  LoadIntoCombo(ProviderClaude, FCbbClaudeModel.Text, FCbbClaudeModel);
  LoadIntoCombo(ProviderOllama, FCbbOllamaModel.Text, FCbbOllamaModel);
end;

procedure TFrm_Setting.RefreshModelClick(Sender: TObject);
var
  LProviderId: string;
begin
  LProviderId := TButton(Sender).Hint;
  if SameText(LProviderId, ProviderChatGPT) then
    RefreshProviderModels(LProviderId, cbbModel)
  else if SameText(LProviderId, ProviderGemini) then
    RefreshProviderModels(LProviderId, FCbbGeminiModel)
  else if SameText(LProviderId, ProviderClaude) then
    RefreshProviderModels(LProviderId, FCbbClaudeModel)
  else if SameText(LProviderId, ProviderOllama) then
    RefreshProviderModels(LProviderId, FCbbOllamaModel);
end;

procedure TFrm_Setting.RefreshProviderModels(const AProviderId: string; ACombo: TComboBox);
var
  LSettings: TAIProviderSetting;
  LModels: TModelDescriptorList;
  LError: string;
  LProvider: IAIProvider;
  LItem: TModelDescriptor;
begin
  LSettings := TSingletonSettingObj.Instance.GetProviderSetting(AProviderId);
  try
    if SameText(AProviderId, ProviderChatGPT) then
    begin
      LSettings.Enabled := Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked;
      LSettings.ApiKey := edt_ApiKey.Text;
      LSettings.BaseURL := edt_Url.Text;
      LSettings.DefaultModel := cbbModel.Text;
    end
    else if SameText(AProviderId, ProviderGemini) then
    begin
      LSettings.Enabled := chk_Gemini.Checked;
      LSettings.ApiKey := lbEdt_GeminiAPIKey.Text;
      LSettings.BaseURL := lbEdt_GeminiBaseURL.Text;
      LSettings.DefaultModel := FCbbGeminiModel.Text;
      if Assigned(FEdtGeminiMaxTokens) then
        LSettings.MaxTokens := StrToIntDef(FEdtGeminiMaxTokens.Text, 0);
      if Assigned(FEdtGeminiTemperature) then
        LSettings.Temperature := StrToFloatDef(FEdtGeminiTemperature.Text, -1);
      if Assigned(FEdtGeminiTopP) then
        LSettings.TopP := StrToFloatDef(FEdtGeminiTopP.Text, -1);
      if Assigned(FEdtGeminiTopK) then
        LSettings.TopK := StrToIntDef(FEdtGeminiTopK.Text, 0);
    end
    else if SameText(AProviderId, ProviderClaude) then
    begin
      LSettings.Enabled := chk_Claude.Checked;
      LSettings.ApiKey := lbEdt_ClaudeAPIKey.Text;
      LSettings.BaseURL := lbEdt_ClaudeBaseURL.Text;
      LSettings.DefaultModel := FCbbClaudeModel.Text;
      if Assigned(FEdtClaudeMaxTokens) then
        LSettings.MaxTokens := StrToIntDef(FEdtClaudeMaxTokens.Text, 0);
      if Assigned(FEdtClaudeTemperature) then
        LSettings.Temperature := StrToFloatDef(FEdtClaudeTemperature.Text, -1);
      if Assigned(FEdtClaudeTopP) then
        LSettings.TopP := StrToFloatDef(FEdtClaudeTopP.Text, -1);
      if Assigned(FEdtClaudeApiVersion) then
        LSettings.ApiVersion := Trim(FEdtClaudeApiVersion.Text);
    end
    else
    begin
      LSettings.Enabled := Assigned(FChkOllamaEnabled) and FChkOllamaEnabled.Checked;
      LSettings.ApiKey := FLbEdtOllamaAPIKey.Text;
      LSettings.BaseURL := FLbEdtOllamaBaseURL.Text;
      LSettings.DefaultModel := FCbbOllamaModel.Text;
      if Assigned(FEdtOllamaMaxTokens) then
        LSettings.MaxTokens := StrToIntDef(FEdtOllamaMaxTokens.Text, 0);
      if Assigned(FEdtOllamaTemperature) then
        LSettings.Temperature := StrToFloatDef(FEdtOllamaTemperature.Text, -1);
      if Assigned(FEdtOllamaTopP) then
        LSettings.TopP := StrToFloatDef(FEdtOllamaTopP.Text, -1);
      if Assigned(FEdtOllamaTopK) then
        LSettings.TopK := StrToIntDef(FEdtOllamaTopK.Text, 0);
    end;

    LProvider := TAIProviderRegistry.Instance.GetProvider(AProviderId);
    if not Assigned(LProvider) then
    begin
      ShowIDEMessage('Provider "' + AProviderId + '" is not available.');
      Exit;
    end;

    LModels := TModelCatalogService.Instance.RefreshModels(LProvider, LSettings, LError);
    try
      if not Assigned(LModels) then
      begin
        ShowIDEMessage('Unable to refresh models.' + sLineBreak + LError);
        Exit;
      end;

      ACombo.Items.BeginUpdate;
      try
        ACombo.Items.Clear;
        for LItem in LModels do
          ACombo.Items.Add(LItem.ModelId);
        if ACombo.Items.Count > 0 then
          ACombo.ItemIndex := 0;
      finally
        ACombo.Items.EndUpdate;
      end;
    finally
      LModels.Free;
    end;
  finally
    LSettings.Free;
  end;
end;

procedure TFrm_Setting.ClearGridPanel;
var
  I: Integer;
begin
  for I:= GridPanelPredefinedQs.RowCollection.Count downto 1 do
    RemoveLatestQuestion;
end;

procedure TFrm_Setting.ColorBox_HighlightChange(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_Setting.edt_UrlChange(Sender: TObject);
begin
  HasChanges := True;
  ApplyProviderEditorState;
end;

procedure TFrm_Setting.FormCreate(Sender: TObject);
begin
  HasChanges := False;
  GridPanelPredefinedQs.RowCollection.Clear;
  ScrollBox.OnMouseWheel := PredefinedQuestionsMouseWheel;
  TControlAccess(GridPanelPredefinedQs).OnMouseWheel := PredefinedQuestionsMouseWheel;
  pgcSetting.ActivePageIndex := 0;
  tsMainSetting.Caption := 'AI Services';
  tsPreDefinedQuestions.Caption := 'Predefined Questions';
  tsOtherAiServices.Caption := 'Other';
  tsOtherAiServices.TabVisible := True;
  chk_Offline.Visible := False;
  edt_OfflineModel.Visible := False;
  ConfigureProviderEditors;

  if not Assigned(FGrpLogging) then
  begin
    grp_Other.Height := 182;
    pnlIDE.Height := 157;

    FGrpLogging := TGroupBox.Create(Self);
    FGrpLogging.Parent := pnlIDE;
    FGrpLogging.Caption := 'Logging';
    FGrpLogging.SetBounds(12, 64, 399, 84);

    FChkFileLog := TCheckBox.Create(Self);
    FChkFileLog.Parent := FGrpLogging;
    FChkFileLog.Caption := 'Enable file logging';
    FChkFileLog.SetBounds(14, 22, 130, 17);
    FChkFileLog.OnClick := chk_FileLogClick;

    FLbEdtLogDirectory := TLabeledEdit.Create(Self);
    FLbEdtLogDirectory.Parent := FGrpLogging;
    FLbEdtLogDirectory.EditLabel.Caption := 'Directory:';
    FLbEdtLogDirectory.LabelPosition := lpAbove;
    FLbEdtLogDirectory.SetBounds(14, 48, 340, 23);
    FLbEdtLogDirectory.OnChange := edt_UrlChange;

    FBtnLogPathBuilder := TButton.Create(Self);
    FBtnLogPathBuilder.Parent := FGrpLogging;
    FBtnLogPathBuilder.Caption := '...';
    FBtnLogPathBuilder.SetBounds(360, 47, 27, 24);
    FBtnLogPathBuilder.OnClick := Btn_HistoryPathBuilderClick;

    chk_FileLogClick(FChkFileLog);
  end;

  pnlOther.Parent := tsOtherAiServices;
  pnlOther.Align := alClient;
  pnlOtherAIMain.Parent := pnlMain;
  pnlOtherAIMain.Align := alClient;

  // Styling does not work properly in Tokyo and Rio the following lines will make it better.
  if (CompilerVersion = 32{Tokyo}) or (CompilerVersion = 33{Rio}) then
  begin
    pgcSetting.StyleElements := [seFont, seBorder, seClient];

    pnlMain.StyleElements := [seFont, seBorder];
    pnlOpenAI.StyleElements := [seFont, seBorder];
    pnlClaude.StyleElements := [seFont, seBorder];
    pnlGemini.StyleElements := [seFont, seBorder];
    pnlOther.StyleElements := [seFont, seBorder];
    pnlHistory.StyleElements := [seFont, seBorder];

    chk_History.StyleElements := [seFont, seBorder];
    chk_ProxyActive.StyleElements := [seFont, seBorder];
    chk_CodeFormatter.StyleElements := [seFont, seBorder];
    chk_Rtl.StyleElements := [seFont, seBorder];
    chk_Gemini.StyleElements := [seFont, seBorder];
    chk_Claude.StyleElements := [seFont, seBorder];
    chk_AnimatedLetters.StyleElements := [seFont, seBorder];
    if Assigned(FChkFileLog) then
      FChkFileLog.StyleElements := [seFont, seBorder];
    if Assigned(FGrpLogging) then
      FGrpLogging.StyleElements := [seFont, seBorder];

    tsPreDefinedQuestions.StyleElements := [seFont, seBorder, seClient];
    pnlPredefinedQ.StyleElements := [seFont, seBorder];
    pnlOtherAIMain.StyleElements := [seFont, seBorder];
  end;
end;

procedure TFrm_Setting.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
    Close;
end;

procedure TFrm_Setting.LoadFromSettings(const ASettings: TSingletonSettingObj);
begin
  if not Assigned(ASettings) then
    Exit;

  Edt_ApiKey.Text := ASettings.ApiKey;
  Edt_Url.Text := ASettings.URL;
  Edt_MaxToken.Text := ASettings.MaxToken.ToString;
  Edt_Temperature.Text := ASettings.Temperature.ToString;
  if Assigned(FEdtChatGPTTopP) then
    FEdtChatGPTTopP.Text := IfThen(ASettings.ChatGPTTopP > 0, FloatToStr(ASettings.ChatGPTTopP), '');
  cbbModel.Text := ASettings.Model;
  Edt_SourceIdentifier.Text := ASettings.Identifier;
  chk_CodeFormatter.Checked := ASettings.CodeFormatter;
  chk_Rtl.Checked := ASettings.RighToLeft;
  chk_History.Checked := ASettings.HistoryEnabled;
  lbEdt_History.Text := ASettings.HistoryPath;
  lbEdt_History.Enabled := ASettings.HistoryEnabled;
  Btn_HistoryPathBuilder.Enabled := ASettings.HistoryEnabled;
  ColorBox_Highlight.Selected := ASettings.HighlightColor;
  chk_AnimatedLetters.Checked := ASettings.AnimatedLetters;
  if Assigned(FChkFileLog) then
    FChkFileLog.Checked := ASettings.EnableFileLog;
  if Assigned(FLbEdtLogDirectory) then
    FLbEdtLogDirectory.Text := ASettings.LogDirectory;
  chk_FileLogClick(FChkFileLog);
  lbEdt_Timeout.Text := ASettings.TimeOut.ToString;

  if Assigned(FChkChatGPTEnabled) then
    FChkChatGPTEnabled.Checked := ASettings.EnableChatGPT;
  chk_Gemini.Checked := ASettings.EnableGemini;
  lbEdt_GeminiAPIKey.Text := ASettings.GeminiAPIKey;
  lbEdt_GeminiBaseURL.Text := ASettings.GeminiBaseURL;
  if Assigned(FCbbGeminiModel) then
    FCbbGeminiModel.Text := ASettings.GeminiModel;
  if Assigned(FEdtGeminiMaxTokens) then
    FEdtGeminiMaxTokens.Text := IfThen(ASettings.GeminiMaxTokens > 0, ASettings.GeminiMaxTokens.ToString, '');
  if Assigned(FEdtGeminiTemperature) then
    FEdtGeminiTemperature.Text := IfThen(ASettings.GeminiTemperature >= 0, FloatToStr(ASettings.GeminiTemperature), '');
  if Assigned(FEdtGeminiTopP) then
    FEdtGeminiTopP.Text := IfThen(ASettings.GeminiTopP >= 0, FloatToStr(ASettings.GeminiTopP), '');
  if Assigned(FEdtGeminiTopK) then
    FEdtGeminiTopK.Text := IfThen(ASettings.GeminiTopK > 0, ASettings.GeminiTopK.ToString, '');

  chk_Claude.Checked := ASettings.EnableClaude;
  lbEdt_ClaudeAPIKey.Text := ASettings.ClaudeAPIKey;
  lbEdt_ClaudeBaseURL.Text := ASettings.ClaudeBaseURL;
  if Assigned(FCbbClaudeModel) then
    FCbbClaudeModel.Text := ASettings.ClaudeModel;
  if Assigned(FEdtClaudeMaxTokens) then
    FEdtClaudeMaxTokens.Text := IfThen(ASettings.ClaudeMaxTokens > 0, ASettings.ClaudeMaxTokens.ToString, '');
  if Assigned(FEdtClaudeTemperature) then
    FEdtClaudeTemperature.Text := IfThen(ASettings.ClaudeTemperature >= 0, FloatToStr(ASettings.ClaudeTemperature), '');
  if Assigned(FEdtClaudeTopP) then
    FEdtClaudeTopP.Text := IfThen(ASettings.ClaudeTopP >= 0, FloatToStr(ASettings.ClaudeTopP), '');
  if Assigned(FEdtClaudeApiVersion) then
    FEdtClaudeApiVersion.Text := ASettings.ClaudeApiVersion;

  if Assigned(FChkOllamaEnabled) then
    FChkOllamaEnabled.Checked := ASettings.EnableOllama;
  if Assigned(FLbEdtOllamaAPIKey) then
    FLbEdtOllamaAPIKey.Text := ASettings.OllamaAPIKey;
  if Assigned(FLbEdtOllamaBaseURL) then
    FLbEdtOllamaBaseURL.Text := ASettings.OllamaBaseURL;
  if Assigned(FCbbOllamaModel) then
    FCbbOllamaModel.Text := ASettings.OllamaModel;
  if Assigned(FEdtOllamaMaxTokens) then
    FEdtOllamaMaxTokens.Text := IfThen(ASettings.OllamaMaxTokens > 0, ASettings.OllamaMaxTokens.ToString, '');
  if Assigned(FEdtOllamaTemperature) then
    FEdtOllamaTemperature.Text := IfThen(ASettings.OllamaTemperature >= 0, FloatToStr(ASettings.OllamaTemperature), '');
  if Assigned(FEdtOllamaTopP) then
    FEdtOllamaTopP.Text := IfThen(ASettings.OllamaTopP >= 0, FloatToStr(ASettings.OllamaTopP), '');
  if Assigned(FEdtOllamaTopK) then
    FEdtOllamaTopK.Text := IfThen(ASettings.OllamaTopK > 0, ASettings.OllamaTopK.ToString, '');
  if Assigned(FCbbDefaultProvider) then
    FCbbDefaultProvider.Text := ProviderIdToCaption(ASettings.DefaultProviderId);

  AddAllDefinedQuestions;
  LoadProviderModels;
  ApplyProviderEditorState;
  HasChanges := False;
end;

procedure TFrm_Setting.pgcSettingChange(Sender: TObject);
begin
  Btn_Default.Visible := pgcSetting.ActivePage = tsMainSetting;
end;

procedure TFrm_Setting.AddAllDefinedQuestions;
var
  LvKey: Integer;
  LvTempSortingArray : TArray<Integer>;
begin
  ClearGridPanel;

  LvTempSortingArray := TSingletonSettingObj.Instance.PredefinedQuestions.Keys.ToArray; // TObjectDictionary is not sorted!
  TArray.Sort<Integer>(LvTempSortingArray);

  for LvKey in LvTempSortingArray do
    AddQuestion(TSingletonSettingObj.Instance.PredefinedQuestions.Items[LvKey]);
end;

procedure TFrm_Setting.AddQuestion(AQuestionpair: TQuestionPair);
var
  LvPanel: Tpanel;
  LvLabeledEditCaption: TLabeledEdit;
  LvMemo: TMemo;
  LvQuestionLabel: TLabel;
  I, LvCounter: Integer;
  LvH: Integer;
begin
  LvH := 0;
  LvCounter := 0;
  with GridPanelPredefinedQs do
  begin
    for I := 0 to Pred(RowCollection.Count + 1) do
      LvH := LvH + 80;

    Height := LvH;
    with RowCollection.Add do
    begin
      SizeStyle := ssAbsolute;
      Value := 80;
    end;
  end;

  LvCounter := GridPanelPredefinedQs.RowCollection.Count;
  LvPanel := TPanel.Create(Self);
  LvPanel.Caption := '';
  LvPanel.Parent := GridPanelPredefinedQs;
  LvPanel.Align := alClient;
  TControlAccess(LvPanel).OnMouseWheel := PredefinedQuestionsMouseWheel;

  with LvPanel do
  begin
    Name := 'panel' + LvCounter.ToString;
    LvLabeledEditCaption := TLabeledEdit.Create(LvPanel);
    with LvLabeledEditCaption do
    begin
      Name := 'CustomLbl' + LvCounter.ToString;
      Parent := LvPanel;
      AlignWithMargins := True;
      Margins.Left := 55;
      Align := alTop;
      EditLabel.Caption := 'Caption';
      EditLabel.Transparent := True;
      LabelPosition := lpLeft;
      LabelSpacing := 4;
      if Assigned(AQuestionpair) then
        Text := AQuestionpair.Caption
      else
        Text := '';
      TControlAccess(LvLabeledEditCaption).OnMouseWheel := PredefinedQuestionsMouseWheel;
    end;

    LvMemo := TMemo.Create(LvPanel);
    LvMemo.Name := 'CustomLblQ' + LvCounter.ToString;
    LvMemo.Parent := LvPanel;
    LvMemo.AlignWithMargins := True;
    LvMemo.Margins.Left := 55;
    LvMemo.Align := alClient;
    LvMemo.WordWrap := True;
    if Assigned(AQuestionpair) then
      LvMemo.Lines.Text := AQuestionpair.Question
    else
      LvMemo.Lines.Text := '';
    LvMemo.ScrollBars := ssVertical;
    TControlAccess(LvMemo).OnMouseWheel := PredefinedQuestionsMouseWheel;

    LvQuestionLabel := TLabel.Create(LvPanel);
    LvQuestionLabel.Parent := LvPanel;
    LvQuestionLabel.Caption := 'Question';
    LvQuestionLabel.Left := 5;
    LvQuestionLabel.Top := 57;
    TControlAccess(LvQuestionLabel).OnMouseWheel := PredefinedQuestionsMouseWheel;
  end;
end;

procedure TFrm_Setting.PredefinedQuestionsMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const
  ScrollStep = 40;
begin
  ScrollBox.VertScrollBar.Position := Max(0, ScrollBox.VertScrollBar.Position - Sign(WheelDelta) * ScrollStep);
  Handled := True;
end;

procedure TFrm_Setting.RemoveLatestQuestion;
begin
  if GridPanelPredefinedQs.RowCollection.Count > 0 then
  begin
    with GridPanelPredefinedQs do
    begin
      FindChildControl('panel' + GridPanelPredefinedQs.RowCollection.Count.ToString).Free;
      RowCollection.Items[Pred(GridPanelPredefinedQs.RowCollection.Count)].Free;
    end;
  end;
end;

function TFrm_Setting.ValidateInputs: Boolean;
var
  LTopP: Double;
begin
  Result := False;
  if chk_History.Checked then
  begin
    if Trim(lbEdt_History.Text).IsEmpty then
    begin
      ShowMessage(MsgHistoryPathRequired);
      Exit;
    end;
  end;

  if Assigned(FChkFileLog) and FChkFileLog.Checked and
     (not Assigned(FLbEdtLogDirectory) or Trim(FLbEdtLogDirectory.Text).IsEmpty) then
  begin
    ShowMessage(MsgLogDirectoryRequired);
    Exit;
  end;

  if Assigned(FChkChatGPTEnabled) and FChkChatGPTEnabled.Checked then
  begin
    if (Trim(edt_ApiKey.Text).IsEmpty) or (Trim(edt_Url.Text).IsEmpty) or (Trim(cbbModel.Text).IsEmpty) then
    begin
      ShowMessage(MsgChatGPTSectionIncomplete);
      Exit;
    end;
    if Assigned(FEdtChatGPTTopP) and (Trim(FEdtChatGPTTopP.Text) <> '') then
    begin
      LTopP := StrToFloatDef(FEdtChatGPTTopP.Text, -1);
      if (LTopP <= 0) or (LTopP > 1) then
      begin
        ShowMessage('ChatGPT Top P must be greater than 0 and less than or equal to 1.');
        Exit;
      end;
    end;
  end;

  if chk_Gemini.Checked then
  begin
    if (Trim(lbEdt_GeminiAPIKey.Text).IsEmpty) or (Trim(lbEdt_GeminiBaseURL.Text).IsEmpty) or
       (not Assigned(FCbbGeminiModel)) or Trim(FCbbGeminiModel.Text).IsEmpty then
    begin
      ShowMessage(MsgGeminiSectionIncomplete);
      Exit;
    end;
  end;

  if chk_Claude.Checked then
  begin
    if (Trim(lbEdt_ClaudeAPIKey.Text).IsEmpty) or (Trim(lbEdt_ClaudeBaseURL.Text).IsEmpty) or
       (not Assigned(FCbbClaudeModel)) or Trim(FCbbClaudeModel.Text).IsEmpty then
    begin
      ShowMessage(MsgClaudeSectionIncomplete);
      Exit;
    end;
  end;

  if Assigned(FChkOllamaEnabled) and FChkOllamaEnabled.Checked then
  begin
    if (Trim(FLbEdtOllamaBaseURL.Text).IsEmpty) or (not Assigned(FCbbOllamaModel)) or Trim(FCbbOllamaModel.Text).IsEmpty then
    begin
      ShowMessage(MsgOllamaSectionIncomplete);
      Exit;
    end;
  end;

  if (not Assigned(FChkChatGPTEnabled) or not FChkChatGPTEnabled.Checked) and
     (not chk_Gemini.Checked) and
     (not chk_Claude.Checked) and
     (not Assigned(FChkOllamaEnabled) or not FChkOllamaEnabled.Checked) then
  begin
    ShowMessage(MsgProviderRequired);
    Exit;
  end;

  Result := True;
end;

{ TQuestionPair }

constructor TQuestionPair.Create(ACaption, AQuestion: string);
begin
  FCaption := ACaption;
  FQuestion := AQuestion;
end;

initialization
  Cs := TCriticalSection.Create;

finalization
  Cs.Free;

end.
