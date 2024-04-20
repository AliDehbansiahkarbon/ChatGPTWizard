object FrmChatGPT: TFrmChatGPT
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  Caption = 'ChatGPT'
  ClientHeight = 485
  ClientWidth = 421
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
    Width = 421
    Height = 485
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 421
    ExplicitHeight = 485
    inherited pgcMain: TPageControl
      Width = 421
      Height = 451
      ExplicitWidth = 417
      ExplicitHeight = 450
      inherited tsChatGPT: TTabSheet
        ExplicitWidth = 413
        ExplicitHeight = 421
        inherited pnlMain: TPanel
          Width = 413
          Height = 421
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 409
          ExplicitHeight = 420
          inherited pnlTop: TPanel
            Width = 411
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 407
            inherited btnHelp: TSpeedButton
              Left = 386
              ExplicitLeft = 390
            end
          end
          inherited pnlCenter: TPanel
            Width = 411
            Height = 375
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 407
            ExplicitHeight = 374
            inherited splitter: TSplitter
              Width = 411
              ExplicitWidth = 419
            end
            inherited pnlAnswer: TPanel
              Width = 411
              Height = 258
              StyleElements = [seFont, seClient, seBorder]
              ExplicitWidth = 407
              ExplicitHeight = 257
              inherited pgcAnswers: TPageControl
                Width = 409
                Height = 256
                ExplicitWidth = 405
                ExplicitHeight = 255
                inherited tsChatGPTAnswer: TTabSheet
                  ExplicitWidth = 401
                  ExplicitHeight = 228
                  inherited mmoAnswer: TMemo
                    Width = 401
                    Height = 228
                    StyleElements = [seFont, seClient, seBorder]
                    ExplicitWidth = 397
                    ExplicitHeight = 227
                  end
                end
                inherited tsWriteSonicAnswer: TTabSheet
                  inherited mmoWriteSonicAnswer: TMemo
                    StyleElements = [seFont, seClient, seBorder]
                  end
                end
                inherited tsYouChat: TTabSheet
                  inherited mmoYouChatAnswer: TMemo
                    StyleElements = [seFont, seClient, seBorder]
                  end
                end
              end
            end
            inherited pnlQuestion: TPanel
              Width = 411
              StyleElements = [seFont, seClient, seBorder]
              ExplicitWidth = 407
              inherited Lbl_Question: TLabel
                StyleElements = [seFont, seClient, seBorder]
              end
              inherited mmoQuestion: TMemo
                Width = 411
                StyleElements = [seFont, seClient, seBorder]
                ExplicitWidth = 407
              end
            end
          end
        end
      end
      inherited tsClassView: TTabSheet
        inherited splClassView: TSplitter
          ExplicitWidth = 421
        end
        inherited pnlClasses: TPanel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited pnlPredefinedCmdAnswer: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited mmoClassViewDetail: TMemo
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited mmoClassViewResult: TMemo
            StyleElements = [seFont, seClient, seBorder]
          end
        end
      end
      inherited tsHistory: TTabSheet
        inherited splHistory: TSplitter
          ExplicitWidth = 421
        end
        inherited pnlHistoryTop: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited pnlSearchHistory: TPanel
            StyleElements = [seFont, seClient, seBorder]
            inherited Edt_Search: TEdit
              StyleElements = [seFont, seClient, seBorder]
            end
          end
        end
        inherited pnlHistoryBottom: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited mmoHistoryDetail: TMemo
            StyleElements = [seFont, seClient, seBorder]
          end
        end
      end
    end
    inherited pnlBottom: TPanel
      Top = 451
      Width = 421
      StyleElements = [seFont, seClient, seBorder]
      ExplicitTop = 451
      ExplicitWidth = 421
      inherited chk_AutoCopy: TCheckBox
        Left = 261
        ExplicitLeft = 257
      end
    end
  end
end
