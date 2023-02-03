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
  TextHeight = 15
  inline Fram_Question1: TFram_Question
    Left = 0
    Top = 0
    Width = 429
    Height = 487
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -6
    ExplicitTop = -47
    inherited pnlMain: TPanel
      Width = 429
      Height = 487
      inherited splitter: TSplitter
        Width = 427
      end
      inherited pnlTop: TPanel
        Width = 427
      end
      inherited pnlQuestion: TPanel
        Width = 427
        inherited mmoQuestion: TMemo
          Width = 404
        end
      end
      inherited pnlAnswer: TPanel
        Width = 427
        Height = 293
        inherited mmoAnswer: TMemo
          Width = 400
          Height = 262
        end
      end
      inherited pnlBottom: TPanel
        Top = 452
        Width = 427
        inherited chk_AutoCopy: TCheckBox
          Left = 265
        end
      end
    end
  end
end
