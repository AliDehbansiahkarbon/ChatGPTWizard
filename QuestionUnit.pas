unit QuestionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, RestClientUnit,
  Vcl.Menus, ToolsAPI;

const
  WM_UPDATE_MESSAGE = WM_USER + 5874;
  WM_PROGRESS_MESSAGE = WM_USER + 5875;

type
  TExecutorTrd = class(TThread)
  private
    FHandle: HWND;
    FPrompt: string;
    FModel: string;
    FApiKey: string;
    FFormattedResponse: TStringList;
  protected
    procedure Execute; override;
  public
    constructor Create(AHandle: HWND; AApiKey, AModel, APrompt: string);
    destructor Destroy; override;
  end;

  TFrmChatGPT = class(TForm)
    pnlMain: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Btn_Ask: TButton;
    mmoQuestion: TMemo;
    mmoAnswer: TMemo;
    ProgressBar1: TProgressBar;
    PopupMenu1: TPopupMenu;
    CopytoClipboard1: TMenuItem;
    procedure mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_AskClick(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
  public
    ApiKey: string;
    procedure OnUpdateMessage(var Msg: TMessage); message WM_UPDATE_MESSAGE;
    procedure OnProgressMessage(var Msg: TMessage); message WM_PROGRESS_MESSAGE;
  end;

var
  FrmChatGPT: TFrmChatGPT;

implementation

{$R *.dfm}

procedure TFrmChatGPT.Btn_AskClick(Sender: TObject);
var
  LvTrd: TExecutorTrd;
begin
  mmoAnswer.Clear;
  LvTrd := TExecutorTrd.Create(Self.Handle, ApiKey, 'text-davinci-003', mmoQuestion.Lines.Text);
  LvTrd.Start;
end;

procedure TFrmChatGPT.CopytoClipboard1Click(Sender: TObject);
begin
  mmoAnswer.CopyToClipboard;
end;

procedure TFrmChatGPT.mmoQuestionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Ord(Key) = 13) then
    Btn_Ask.Click;
end;

procedure TFrmChatGPT.OnProgressMessage(var Msg: TMessage);
begin
  ProgressBar1.Visible := Msg.WParam <> 0;
  Btn_Ask.Enabled := Msg.WParam = 0;
end;

procedure TFrmChatGPT.OnUpdateMessage(var Msg: TMessage);
begin
  mmoAnswer.Lines.Clear;
  mmoAnswer.Lines.Add(string(Msg.WParam));
end;

{ TExecutorTrd }

constructor TExecutorTrd.Create(AHandle: HWND; AApiKey, AModel, APrompt: string);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FFormattedResponse := TStringList.Create;
  FApiKey := AApiKey;
  FModel := AModel;
  FPrompt := APrompt;
  FHandle := AHandle;
  SendMessage(FHandle, WM_PROGRESS_MESSAGE, 1, 0);
end;

destructor TExecutorTrd.Destroy;
begin
  FFormattedResponse.Free;
  SendMessage(FHandle, WM_PROGRESS_MESSAGE, 0, 0);
  inherited;
end;

procedure TExecutorTrd.Execute;
var
  LvAPI: TOpenAIAPI;
  LvResult: string;
begin
  inherited;
  LvAPI := TOpenAIAPI.Create(FApiKey);
  try
    try
      LvResult := LvAPI.Query(FModel, FPrompt).Trim;

      if not LvResult.IsEmpty then
        SendMessage(FHandle, WM_UPDATE_MESSAGE, Integer(LvResult), 0);
    except on E: Exception do
      ShowMessage(E.Message);
    end;
  finally
    LvAPI.Free;
  end;
end;

end.
