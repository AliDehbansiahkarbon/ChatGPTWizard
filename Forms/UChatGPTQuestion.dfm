object FrmChatGPT: TFrmChatGPT
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  Caption = 'ChatGPT'
  ClientHeight = 486
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  ParentBiDiMode = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  inline Fram_Question: TFram_Question
    Left = 0
    Top = 0
    Width = 425
    Height = 486
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 429
    ExplicitHeight = 487
    inherited pgcMain: TPageControl
      Width = 425
      Height = 452
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
              inherited pgcAnswers: TPageControl
                Width = 417
                Height = 258
                ExplicitWidth = 417
                ExplicitHeight = 258
                inherited tsChatGPTAnswer: TTabSheet
                  ExplicitWidth = 409
                  ExplicitHeight = 230
                  inherited mmoAnswer: TMemo
                    Width = 409
                    Height = 230
                    ExplicitWidth = 409
                    ExplicitHeight = 230
                  end
                end
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
          ExplicitWidth = 421
        end
      end
      inherited tsHistory: TTabSheet
        inherited splHistory: TSplitter
          Width = 421
          ExplicitWidth = 421
        end
        inherited pnlHistoryTop: TPanel
          Width = 421
          ExplicitWidth = 421
        end
        inherited pnlHistoryBottom: TPanel
          Width = 421
          Height = 235
          ExplicitWidth = 421
          ExplicitHeight = 235
          inherited mmoHistoryDetail: TMemo
            Width = 419
            Height = 233
            ExplicitWidth = 419
            ExplicitHeight = 233
          end
        end
      end
    end
    inherited pnlBottom: TPanel
      Top = 452
      Width = 425
      ExplicitTop = 452
      ExplicitWidth = 425
      inherited chk_AutoCopy: TCheckBox
        Left = 273
        ExplicitLeft = 281
      end
      inherited ActivityIndicator1: TActivityIndicator
        ExplicitWidth = 24
        ExplicitHeight = 24
      end
    end
  end
end
