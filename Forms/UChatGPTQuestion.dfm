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
  OnShow = FormShow
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
    inherited pgcMain: TPageControl
      Width = 429
      Height = 453
      ExplicitWidth = 429
      ExplicitHeight = 453
      inherited tsChatGPT: TTabSheet
        ExplicitWidth = 421
        ExplicitHeight = 423
        inherited pnlMain: TPanel
          Width = 421
          Height = 423
          ExplicitWidth = 421
          ExplicitHeight = 423
          inherited pnlTop: TPanel
            Width = 419
            ExplicitWidth = 419
          end
          inherited pnlCenter: TPanel
            Width = 419
            Height = 377
            ExplicitWidth = 419
            ExplicitHeight = 377
            inherited splitter: TSplitter
              Width = 419
              ExplicitWidth = 419
            end
            inherited pnlAnswer: TPanel
              Width = 419
              Height = 260
              ExplicitWidth = 419
              ExplicitHeight = 260
              inherited mmoAnswer: TMemo
                Width = 411
                Height = 235
                ExplicitWidth = 411
                ExplicitHeight = 235
              end
            end
            inherited pnlQuestion: TPanel
              Width = 419
              ExplicitWidth = 419
            end
          end
        end
      end
      inherited tsClassView: TTabSheet
        inherited splClassView: TSplitter
          Width = 421
          ExplicitWidth = 421
        end
        inherited pnlClasses: TPanel
          Width = 421
          ExplicitWidth = 421
        end
        inherited pnlPredefinedCmdAnswer: TPanel
          Width = 421
          Height = 283
          ExplicitWidth = 421
          ExplicitHeight = 283
          inherited mmoPredefinedCmdAnswer: TMemo
            Width = 413
            Height = 275
            ExplicitWidth = 413
            ExplicitHeight = 275
          end
        end
      end
    end
    inherited pnlBottom: TPanel
      Top = 453
      Width = 429
      ExplicitTop = 453
      ExplicitWidth = 429
      inherited chk_AutoCopy: TCheckBox
        Left = 281
        ExplicitLeft = 281
      end
    end
  end
end
