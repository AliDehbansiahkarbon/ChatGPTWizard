unit ULanguages;

interface
uses
  System.Generics.Collections;

type
  TLang = class
  private
    FAsk: string;
    FCopyToClipBoard: string;
    FClearAll: string;
    FAutoClipBoard: string;
    FQuestion: string;
    FAnswer: string;
    FAskMenu: string;
    FDockableMenu: string;
    FSettingMenu: string;
    FBaseUrl: string;
    FApiKey: string;
    FModel: string;
    FMaxToken: string;
    FTemperature: string;
    FIdentifier: string;
    FDirection: string;
    FCallCodeFormatter: string;
    FLoadDefaults: string;
    FSaveAndExit: string;
  public
    function Ask(AValue: string): TLang;
    function CopyToClipBoard(AValue: string): TLang;
    function ClearAll(AValue: string): TLang;
    function AutoClipBoard(AValue: string): TLang;
    function Question(AValue: string): TLang;
    function Answer(AValue: string): TLang;
    function AskMenu(AValue: string): TLang;
    function DockableMenu(AValue: string): TLang;
    function SettingMenu(AValue: string): TLang;
    function BaseUrl(AValue: string): TLang;
    function ApiKey(AValue: string): TLang;
    function Model(AValue: string): TLang;
    function MaxToken(AValue: string): TLang;
    function Temperature(AValue: string): TLang;
    function Identifier(AValue: string): TLang;
    function Direction(AValue: string): TLang;
    function CallCodeFormatter(AValue: string): TLang;
    function LoadDefaults(AValue: string): TLang;
    function SaveAndExit(AValue: string): TLang;

    property _Ask: string read FAsk write FAsk;
    property _CopyToClipBoard: string read FCopyToClipBoard write FCopyToClipBoard;
    property _ClearAll: string read FClearAll write FClearAll;
    property _AutoClipBoard: string read FAutoClipBoard write FAutoClipBoard;
    property _Question: string read FQuestion write FQuestion;
    property _Answer: string read FAnswer write FAnswer;
    property _AskMenu: string read FAskMenu write FAskMenu;
    property _DockableMenu: string read FDockableMenu write FDockableMenu;
    property _SettingMenu: string read FSettingMenu write FSettingMenu;
    property _BaseUrl: string read FBaseUrl write FBaseUrl;
    property _ApiKey: string read FApiKey write FApiKey;
    property _Model: string read FModel write FModel;
    property _MaxToken: string read FMaxToken write FMaxToken;
    property _Temperature: string read FTemperature write FTemperature;
    property _Identifier: string read FIdentifier write FIdentifier;
    property _Direction: string read FDirection write FDirection;
    property _CallCodeFormatter: string read FCallCodeFormatter write FCallCodeFormatter;
    property _LoadDefaults: string read FLoadDefaults write FLoadDefaults;
    property _SaveAndExit: string read FSaveAndExit write FSaveAndExit;
  end;

  procedure FillLanguageList(ALangList: TObjectDictionary<Integer,Tlang>);

implementation

{ TLang }

function TLang.Answer(AValue: string): TLang;
begin
  FAnswer := AValue;
  Result := Self;
end;

function TLang.ApiKey(AValue: string): TLang;
begin
  FApiKey := AValue;
  Result := Self;
end;

function TLang.AskMenu(AValue: string): TLang;
begin
  FAskMenu := AValue;
  Result := Self;
end;

function TLang.Ask(AValue: string): TLang;
begin
  FAsk := AValue;
  Result := Self;
end;

function TLang.AutoClipBoard(AValue: string): TLang;
begin
  FAutoClipBoard := AValue;
  Result := Self;
end;

function TLang.BaseUrl(AValue: string): TLang;
begin
  FBaseUrl := AValue;
  Result := Self;
end;

function TLang.CallCodeFormatter(AValue: string): TLang;
begin
  FCallCodeFormatter := AValue;
  Result := Self;
end;

function TLang.ClearAll(AValue: string): TLang;
begin
  FClearAll := AValue;
  Result := Self;
end;

function TLang.CopyToClipBoard(AValue: string): TLang;
begin
  FCopyToClipBoard := AValue;
  Result := Self;
end;

function TLang.Direction(AValue: string): TLang;
begin
  FDirection := AValue;
  Result := Self;
end;

function TLang.DockableMenu(AValue: string): TLang;
begin
  FDockableMenu := AValue;
  Result := Self;
end;

function TLang.Identifier(AValue: string): TLang;
begin
  FIdentifier := AValue;
  Result := Self;
end;

function TLang.LoadDefaults(AValue: string): TLang;
begin
  FLoadDefaults := AValue;
  Result := Self;
end;

function TLang.MaxToken(AValue: string): TLang;
begin
  FMaxToken := AValue;
  Result := Self;
end;

function TLang.Model(AValue: string): TLang;
begin
  FModel := AValue;
  Result := Self;
end;

function TLang.Question(AValue: string): TLang;
begin
  FQuestion := AValue;
  Result := Self;
end;

function TLang.SaveAndExit(AValue: string): TLang;
begin
  FSaveAndExit := AValue;
  Result := Self;
end;

function TLang.SettingMenu(AValue: string): TLang;
begin
  FSettingMenu := AValue;
  Result := Self;
end;

function TLang.Temperature(AValue: string): TLang;
begin
  FTemperature := AValue;
  Result := Self;
end;

procedure FillLanguageList(ALangList: TObjectDictionary<Integer,Tlang>);
begin
//Arabic
  ALangList.Add(0, TLang.Create.Ask('اِسأل').CopyToClipBoard('نسخ إلى الحافظة').ClearAll('مسح الکل').AutoClipBoard('نسخ تلقائي إلى الحافظة').Question('سؤال').
  Answer('إجابة').AskMenu('اسأل ChatGPT').DockableMenu('قابل للإرساء ChatGPT').SettingMenu('إعدادات ChatGPT').BaseUrl('عنوان URL الأساسي').ApiKey('مفتاح الوصول').
  Model('نموذج').MaxToken('ماكس توكن').Temperature('درجة حرارة').Identifier('المعرف').Direction('اتجاه').CallCodeFormatter('اجراء المنسق بعد الإدراج').
  LoadDefaults('حمل الافتراضيات').SaveAndExit('حفظ && إغلاق'));

//Chinese
  ALangList.Add(1, TLang.Create.Ask('问').CopyToClipBoard('复制到剪贴板').ClearAll('全部清除').AutoClipBoard('自动复制到剪贴板').Question('问题').Answer('回答').
  AskMenu('询问聊天GPT').DockableMenu('可停靠聊天GPT').SettingMenu('聊天GPT设置').BaseUrl('基本网址').ApiKey('访问密钥').Model('模型').MaxToken('最大令牌').
  Temperature('温度').Identifier('标识符').Direction('方向').CallCodeFormatter('插入后调用代码格式化程序').LoadDefaults('加载默认').SaveAndExit('保存 && 关闭'));

//English
  ALangList.Add(2, TLang.Create.Ask('Ask').CopyToClipBoard('Copy To ClipBoard').ClearAll('Clear All').AutoClipBoard('Auto Copy to Clipboard').
  Question('Question').Answer('Answer').AskMenu('Ask ChatGPT').DockableMenu('Dockable ChatGPT').SettingMenu('ChatGPT Setting').BaseUrl('Base URL:').
  ApiKey('Access Key:').Model('Model:').MaxToken('Max-Token:').Temperature('Temperature').Identifier('Identifier').Direction('Direction').
  CallCodeFormatter('Call Code Formatter After Insert').LoadDefaults('Load Defaults').SaveAndExit('Save && Close'));

//French
  ALangList.Add(3, TLang.Create.Ask('Demander').CopyToClipBoard('Copier dans le presse-papier').ClearAll('Tout effacer').
  AutoClipBoard('Copie automatique dans le presse-papiers').Question('Question').Answer('Répondre').AskMenu('Demander à ChatGPT').DockableMenu('ChatGPT ancrable').
  SettingMenu('Paramètre ChatGPT').BaseUrl('URL de base').ApiKey('Clef d''accès').Model('Modèle').MaxToken('Max-Token').Temperature('Température').
  Identifier('Identifiant').Direction('Direction').CallCodeFormatter('Formateur de code d''appel après insertion').LoadDefaults('Charger les paramètres par défaut').
  SaveAndExit('Sauvegarder et fermer'));

//Germany
  ALangList.Add(4, TLang.Create.Ask('Fragen').CopyToClipBoard('In die Zwischenablage kopieren').ClearAll('Alles löschen').
  AutoClipBoard('Automatisches Kopieren in die Zwischenablage').Question('Frage').Answer('Antworten').AskMenu('Fragen Sie ChatGPT').DockableMenu('Andockbares ChatGPT').
  SettingMenu('ChatGPT-Einstellung').BaseUrl('Basis-URL').ApiKey('Zugangsschlüssel').Model('Modell').MaxToken('Max Token').Temperature('Temperatur').
  Identifier('Kennung').Direction('Richtung').CallCodeFormatter('Rufen Sie den Codeformatierer nach dem Einfügen auf').LoadDefaults('Standardwerte laden').
  SaveAndExit('Speichern && Schließen'));

//Hindi
  ALangList.Add(5, TLang.Create.Ask('पूछना').CopyToClipBoard('क्लिपबोर्ड पर कॉपी करें').ClearAll('सभी साफ करें').AutoClipBoard('क्लिपबोर्ड पर ऑटो कॉपी').
  Question('सवाल').Answer('उत्तर').AskMenu('चैटजीपीटी से पूछें').DockableMenu('डॉक करने योग्य चैटजीपीटी').SettingMenu('चैटजीपीटी सेटिंग').BaseUrl('बेस यूआरएल').
  ApiKey('प्रवेश की चाबी').Model('नमूना').MaxToken('मैक्स-टोकन').Temperature('तापमान').Identifier('पहचानकर्ता').Direction('दिशा').
  CallCodeFormatter('सम्मिलित करने के बाद कॉल कोड फ़ॉर्मेटर').LoadDefaults('डीफॉल्ट लोड करें').SaveAndExit('सहेजे बंद करें'));

//Italian
  ALangList.Add(6, TLang.Create.Ask('Chiedere').CopyToClipBoard('Copia negli appunti').ClearAll('Cancella tutto').AutoClipBoard('Copia automatica negli Appunti').
  Question('Domanda').Answer('Risposta').AskMenu('Chiedi a ChatGPT').DockableMenu('ChatGPT agganciabile').SettingMenu('Impostazioni ChatGPT').BaseUrl('URL di base').
  ApiKey('Chiave di accesso').Model('Modello').MaxToken('Max-Token').Temperature('Temperatura').Identifier('Identificatore').Direction('Direzione').
  CallCodeFormatter('Chiama il formattatore del codice dopo l''inserimento').LoadDefaults('Caricare impostazioni di default').SaveAndExit('Salva e chiudi'));

//Japanese
  ALangList.Add(7, TLang.Create.Ask('聞く').CopyToClipBoard('クリップボードにコピー').ClearAll('すべてクリア').AutoClipBoard('クリップボードに自動コピー').
  Question('質問').Answer('答え').AskMenu('ChatGPTに質問する').DockableMenu('ドッキング可能 ChatGPT').SettingMenu('ChatGPT設定').BaseUrl('ベース URL').
  ApiKey('アクセスキー').Model('モデル').MaxToken('最大トークン').Temperature('温度').Identifier('識別子').Direction('方向').
  CallCodeFormatter('挿入後にコード フォーマッタを呼び出す').LoadDefaults('デフォルトをロード').SaveAndExit('保存して閉じる'));

//Kurdish(Kurmanci)
  ALangList.Add(8, TLang.Create.Ask('Sormak').CopyToClipBoard('Panoya kopyala').ClearAll('Hepsini temizle').AutoClipBoard('Panoya Otomatik Kopyala').
  Question('Soru').Answer('Cevap').AskMenu('ChatGPT''ye Sor').DockableMenu('Takılabilir ChatGPT').SettingMenu('ChatGPT Ayarı').BaseUrl('Temel URL').
  ApiKey('Erişim anahtarı').Model('Modeli').MaxToken('Maksimum Jeton').Temperature('Hava sıcaklığı').Identifier('tanımlayıcı').Direction('Yön').
  CallCodeFormatter('Ekledikten Sonra Arama Kodu Formatlayıcı').LoadDefaults('Varsayılanları Yükle').SaveAndExit('Kaydet kapat'));

//Persian
  ALangList.Add(9, TLang.Create.Ask('بپرس').CopyToClipBoard('کپی به کلیپ بورد').ClearAll('حذف همه').AutoClipBoard('کپی خودکار در کلیپ بورد').
  Question('سوال').Answer('پاسخ').AskMenu('از ChatGPT بپرسید').DockableMenu('ChatGPT قابل اتصال').
   SettingMenu('تنظیمات ChatGPT').BaseUrl('URL پایه').ApiKey('کلید دسترسی').Model('مدل').MaxToken('حداکثر توکن').Temperature('درجه حرارت').Identifier('شاخص').
   Direction('جهت').CallCodeFormatter('اجرای فرمت کننده پس از درج').LoadDefaults('بارگذاری پیش فرض ها').SaveAndExit('ذخیره && بستن'));

//Portuguese
  ALangList.Add(10, TLang.Create.Ask('Perguntar').CopyToClipBoard('Copiar para área de transferência').ClearAll('Limpar tudo').
  AutoClipBoard('Cópia automática para a área de transferência').Question('Pergunta').Answer('Responder').AskMenu('Pergunte ao ChatGPT').DockableMenu('Bate-papo acoplávelGPT').
   SettingMenu('Configuração do ChatGPT').BaseUrl('URL base').ApiKey('Chave de acesso').Model('Modelo').MaxToken('Max-Token').Temperature('Temperatura').
   Identifier('identificador').Direction('Direção').CallCodeFormatter('Formatador de código de chamada após a inserção').
   LoadDefaults('Carregar padrões').SaveAndExit('Salvar fechar'));

//Russian
  ALangList.Add(11, TLang.Create.Ask('Просить').CopyToClipBoard('Скопировать в буфер обмена').ClearAll('Очистить все').AutoClipBoard('Автоматическое копирование в буфер обмена').
  Question('Вопрос').Answer('Отвечать').AskMenu('Спросите ChatGPT').DockableMenu('Закрепляемый чатGPT').SettingMenu('Настройка ChatGPT').BaseUrl('Базовый URL').
  ApiKey('Ключ доступа').Model('Модель').MaxToken('Макс-токен').Temperature('Температура').Identifier('Идентификатор').Direction('Направление').
  CallCodeFormatter('Средство форматирования кода вызова после вставки').LoadDefaults('Загрузка значений по умолчанию').SaveAndExit('Сохранить && Закрыть'));

//Spanish
  ALangList.Add(12, TLang.Create.Ask('Preguntar').CopyToClipBoard('Copiar al portapapeles').ClearAll('Limpiar todo').AutoClipBoard('Copia automática al portapapeles').
  Question('Pregunta').Answer('Respuesta').AskMenu('Pregunte ChatGPT').DockableMenu('Acoplable ChatGPT').SettingMenu('Configuración de ChatGPT').
  BaseUrl('URL base').ApiKey('Llave de acceso').Model('Modelo').MaxToken('Max-token').Temperature('Temperatura').Identifier('identificador').Direction('Dirección').
  CallCodeFormatter('Formateador de código de llamada después de insertar').LoadDefaults('Cargar opciones por defecto').SaveAndExit('Guardar cerrar'));

//Turkish
  ALangList.Add(13, TLang.Create.Ask('').CopyToClipBoard('').ClearAll('').AutoClipBoard('').Question('').Answer('').AskMenu('').DockableMenu('').
   SettingMenu('').BaseUrl('').ApiKey('').Model('').MaxToken('').Temperature('').Identifier('').Direction('').CallCodeFormatter('').LoadDefaults('').SaveAndExit(''));

//Urdu
  ALangList.Add(14, TLang.Create.Ask('پوچھو').CopyToClipBoard('کلپ بورڈ پر کاپی کریں۔').ClearAll('تمام کو صاف کریں').AutoClipBoard('کلپ بورڈ پر آٹو کاپی کریں۔').
  Question('سوال').Answer('جواب دیں۔').AskMenu('ChatGPT سے پوچھیں۔').DockableMenu('ڈاک کے قابل چیٹ جی پی ٹی').SettingMenu('چیٹ جی پی ٹی سیٹنگ').
  BaseUrl('بنیادی URL').ApiKey('رسائی کلید').Model('ماڈل').MaxToken('میکس ٹوکن').Temperature('درجہ حرارت').Identifier('شناخت کنندہ').Direction('سمت').
  CallCodeFormatter('داخل کرنے کے بعد کوڈ فارمیٹر کو کال کریں۔').LoadDefaults('ڈیفالٹس لوڈ کریں۔').SaveAndExit('محفوظ کریں اور بند کریں۔'));
end;

end.
