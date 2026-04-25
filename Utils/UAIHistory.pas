unit UAIHistory;

interface

uses
  System.SysUtils,
  System.DateUtils,
  FireDAC.Comp.Client,
  UAICommon;

type
  THistoryService = class
  public
    class procedure EnsureSchema(AConnection: TFDConnection);
    class procedure InsertEntry(AConnection: TFDConnection; const AQuestionText: string; const AResponse: TProviderResponse);
  end;

implementation

class procedure THistoryService.EnsureSchema(AConnection: TFDConnection);
  procedure Exec(const ASQL: string);
  begin
    AConnection.ExecSQL(ASQL);
  end;
  function ColumnExists(const AColumnName: string): Boolean;
  var
    LQry: TFDQuery;
  begin
    Result := False;
    LQry := TFDQuery.Create(nil);
    try
      LQry.Connection := AConnection;
      LQry.SQL.Text := 'PRAGMA table_info(TbHistory)';
      LQry.Open;
      while not LQry.Eof do
      begin
        if SameText(LQry.FieldByName('name').AsString, AColumnName) then
          Exit(True);
        LQry.Next;
      end;
    finally
      LQry.Free;
    end;
  end;
begin
  Exec('CREATE TABLE IF NOT EXISTS TbHistory (' +
       'HID INTEGER PRIMARY KEY AUTOINCREMENT,' +
       'Question TEXT,' +
       'Answer TEXT,' +
       'Date INTEGER' +
       ')');

  Exec('CREATE TABLE IF NOT EXISTS TbHistoryMeta (' +
       'MetaKey TEXT PRIMARY KEY,' +
       'MetaValue TEXT' +
       ')');

  Exec('INSERT OR REPLACE INTO TbHistoryMeta (MetaKey, MetaValue) VALUES (''schema_version'', ''2'')');

  if not ColumnExists('batch_id') then Exec('ALTER TABLE TbHistory ADD COLUMN batch_id TEXT');
  if not ColumnExists('request_id') then Exec('ALTER TABLE TbHistory ADD COLUMN request_id TEXT');
  if not ColumnExists('provider_id') then Exec('ALTER TABLE TbHistory ADD COLUMN provider_id TEXT');
  if not ColumnExists('provider_display_name') then Exec('ALTER TABLE TbHistory ADD COLUMN provider_display_name TEXT');
  if not ColumnExists('model_id') then Exec('ALTER TABLE TbHistory ADD COLUMN model_id TEXT');
  if not ColumnExists('question_text') then Exec('ALTER TABLE TbHistory ADD COLUMN question_text TEXT');
  if not ColumnExists('answer_text') then Exec('ALTER TABLE TbHistory ADD COLUMN answer_text TEXT');
  if not ColumnExists('status') then Exec('ALTER TABLE TbHistory ADD COLUMN status TEXT');
  if not ColumnExists('error_text') then Exec('ALTER TABLE TbHistory ADD COLUMN error_text TEXT');
  if not ColumnExists('created_at') then Exec('ALTER TABLE TbHistory ADD COLUMN created_at INTEGER');
  if not ColumnExists('completed_at') then Exec('ALTER TABLE TbHistory ADD COLUMN completed_at INTEGER');
  if not ColumnExists('duration_ms') then Exec('ALTER TABLE TbHistory ADD COLUMN duration_ms INTEGER');

  Exec('UPDATE TbHistory ' +
       'SET provider_id = COALESCE(provider_id, ''chatgpt-legacy''), ' +
       'provider_display_name = COALESCE(provider_display_name, ''ChatGPT (Legacy)''), ' +
       'question_text = COALESCE(question_text, Question), ' +
       'answer_text = COALESCE(answer_text, Answer), ' +
       'status = COALESCE(status, ''succeeded''), ' +
       'created_at = COALESCE(created_at, Date), ' +
       'completed_at = COALESCE(completed_at, Date), ' +
       'duration_ms = COALESCE(duration_ms, 0)');
end;

class procedure THistoryService.InsertEntry(AConnection: TFDConnection; const AQuestionText: string; const AResponse: TProviderResponse);
begin
  AConnection.ExecSQL(
    'INSERT INTO TbHistory ' +
    '(Question, Answer, Date, batch_id, request_id, provider_id, provider_display_name, model_id, question_text, answer_text, status, error_text, created_at, completed_at, duration_ms) ' +
    'VALUES (:Question, :Answer, :Date, :batch_id, :request_id, :provider_id, :provider_display_name, :model_id, :question_text, :answer_text, :status, :error_text, :created_at, :completed_at, :duration_ms)',
    [
      AQuestionText,
      AResponse.ResponseText,
      DateTimeToUnix(AResponse.CreatedAt),
      AResponse.BatchId,
      AResponse.RequestId,
      AResponse.ProviderId,
      AResponse.ProviderDisplayName,
      AResponse.ModelId,
      AQuestionText,
      AResponse.ResponseText,
      ProviderStatusToString(AResponse.Status),
      AResponse.ErrorText,
      DateTimeToUnix(AResponse.CreatedAt),
      DateTimeToUnix(AResponse.FinishedAt),
      AResponse.DurationMs
    ]
  );
end;

end.
