object FrmChatGPT: TFrmChatGPT
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  Caption = 'ChatGPT'
  ClientHeight = 487
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  ParentBiDiMode = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  TextHeight = 15
  inline Fram_Question1: TFram_Question
    Left = 0
    Top = 0
    Width = 429
    Height = 487
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 429
    ExplicitHeight = 487
    inherited pnlMain: TPanel
      Width = 429
      Height = 487
      ExplicitWidth = 429
      ExplicitHeight = 487
      inherited splitter: TSplitter
        Width = 427
        ExplicitWidth = 427
      end
      inherited pnlTop: TPanel
        Width = 427
        ExplicitWidth = 427
      end
      inherited pnlQuestion: TPanel
        Width = 427
        ExplicitWidth = 427
        inherited mmoQuestion: TMemo
          Width = 404
          ExplicitWidth = 404
        end
      end
      inherited pnlAnswer: TPanel
        Width = 427
        Height = 290
        ExplicitWidth = 427
        ExplicitHeight = 290
        inherited mmoAnswer: TMemo
          Width = 400
          Height = 262
          ExplicitWidth = 400
          ExplicitHeight = 262
        end
      end
      inherited pnlBottom: TPanel
        Top = 452
        Width = 427
        ExplicitTop = 452
        ExplicitWidth = 427
        inherited chk_AutoCopy: TCheckBox
          Left = 265
          ExplicitLeft = 265
        end
      end
    end
  end
end
