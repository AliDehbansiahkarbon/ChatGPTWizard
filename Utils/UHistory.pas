{****************************************************}
{                                                    }
{    This unit contains an inherited DbGrid          }
{    used in History page.                           }
{    Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{   GitHub: https://github.com/AliDehbansiahkarbon   }
{                                                    }
{****************************************************}
unit UHistory;

interface
Uses
  Vcl.Controls, Vcl.DBGrids, Winapi.Windows, Winapi.Messages, Data.DB;

type
  THistoryDBGrid = class(TDBGrid)
  Private
    FRowHeight: Integer;
  Protected
    Procedure SetRowHeight(Value:Integer);
  Public
    // The inherited method is declared as protected.
    // Used Reintroduce to hide compiler warnings.
    function CellRect(ACol,Arow : Longint): TRect; Reintroduce;

    //Fit columns.
    procedure FitGrid;

    // Expose Row and Col properties
    Property Row;
    Property Col;
  Published
    Property RowHeight : Integer Read FRowHeight Write SetRowHeight ;
  end;

implementation

{ TDBGridObj }

function THistoryDBGrid.CellRect(ACol, Arow: Longint): TRect;
begin
  Result := Inherited CellRect(ACol, ARow);
end;

procedure THistoryDBGrid.SetRowHeight(Value: Integer);
begin
  if FRowHeight <> Value Then
  begin
    FRowHeight := Value ;
    DefaultRowHeight := FRowHeight ;
    // Force the Grid to update the RowCount.
    // The method I need to call is
    // UpdateRowCount, but it's declared
    // as private in the parent.
    // This calls it by performing a mock resize event using a message!!
    if Self.DataLink.Active then
      Perform(WM_SIZE, 0, 0);
  end;
end;

procedure THistoryDBGrid.FitGrid;
begin
  Align := alClient;
  Columns[1].Width := 60;
  Columns[2].Width := 25;
  Columns[0].Width := Width - (Columns[1].Width + Columns[2].Width) - 30;
end;

end.
