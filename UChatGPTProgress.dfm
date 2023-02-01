object Frm_Progress: TFrm_Progress
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Frm_Progress'
  ClientHeight = 56
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object pnlContainer: TPanel
    Left = 0
    Top = 0
    Width = 301
    Height = 56
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    object Lbl_Top: TLabel
      Left = 1
      Top = 1
      Width = 295
      Height = 15
      Align = alTop
      Caption = 'Please wait...'
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      ExplicitWidth = 71
    end
    object ProgressBar: TProgressBar
      Left = 15
      Top = 24
      Width = 269
      Height = 18
      Style = pbstMarquee
      TabOrder = 0
    end
    object btnClose: TBitBtn
      Left = 274
      Top = 0
      Width = 22
      Height = 16
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000C0000000C0000000100
        04000000000060000000330B0000330B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        0000FFFFFFFFFFFF0000F707FFFF707F0000F7007FF7007F0000FF70077007FF
        0000FFF700007FFF0000FFFF7007FFFF0000FFF700007FFF0000FF70077007FF
        0000F7007FF7007F0000F707FFFF707F0000FFFFFFFFFFFF0000}
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
end
