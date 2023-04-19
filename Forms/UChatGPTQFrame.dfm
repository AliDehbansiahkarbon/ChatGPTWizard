object Fram_Question: TFram_Question
  Left = 0
  Top = 0
  Width = 435
  Height = 433
  TabOrder = 0
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 435
    Height = 399
    ActivePage = tsChatGPT
    Align = alClient
    MultiLine = True
    TabOrder = 0
    OnChange = pgcMainChange
    OnChanging = pgcMainChanging
    object tsChatGPT: TTabSheet
      Caption = 'ChatGPT'
      object pnlMain: TPanel
        Left = 0
        Top = 0
        Width = 427
        Height = 369
        Align = alClient
        ParentColor = True
        TabOrder = 0
        object pnlTop: TPanel
          Left = 1
          Top = 1
          Width = 425
          Height = 44
          Align = alTop
          TabOrder = 0
          object Btn_Clipboard: TButton
            Left = 121
            Top = 8
            Width = 137
            Height = 27
            Caption = 'Copy to Clipboard'
            TabOrder = 1
            WordWrap = True
            OnClick = Btn_ClipboardClick
          end
          object Btn_Ask: TButton
            Left = 40
            Top = 8
            Width = 74
            Height = 27
            Hint = 'Ctrl + Enter'
            Caption = 'Ask'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = Btn_AskClick
          end
          object Btn_Clear: TButton
            Left = 271
            Top = 8
            Width = 74
            Height = 27
            Caption = 'Clear All'
            TabOrder = 2
            OnClick = Btn_ClearClick
          end
        end
        object pnlCenter: TPanel
          Left = 1
          Top = 45
          Width = 425
          Height = 323
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object splitter: TSplitter
            Left = 0
            Top = 114
            Width = 425
            Height = 3
            Cursor = crVSplit
            Align = alTop
            ExplicitLeft = 8
            ExplicitTop = 156
            ExplicitWidth = 433
          end
          object pnlAnswer: TPanel
            Left = 0
            Top = 117
            Width = 425
            Height = 206
            Align = alClient
            TabOrder = 0
            object pgcAnswers: TPageControl
              Left = 1
              Top = 1
              Width = 423
              Height = 204
              ActivePage = tsChatGPTAnswer
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindow
              Font.Height = -11
              Font.Name = 'Segoe UI'
              Font.Style = []
              HotTrack = True
              ParentFont = False
              TabOrder = 0
              OnChange = pgcAnswersChange
              object tsChatGPTAnswer: TTabSheet
                Caption = 'ChatGPT'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -8
                Font.Name = 'Segoe UI'
                Font.Style = []
                ParentFont = False
                object mmoAnswer: TMemo
                  Left = 0
                  Top = 0
                  Width = 415
                  Height = 176
                  Align = alClient
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -12
                  Font.Name = 'Consolas'
                  Font.Style = []
                  ParentFont = False
                  ReadOnly = True
                  ScrollBars = ssVertical
                  TabOrder = 0
                end
              end
              object tsWriteSonicAnswer: TTabSheet
                Caption = 'WriteSonic'
                ImageIndex = 1
                object mmoWriteSonicAnswer: TMemo
                  Left = 0
                  Top = 0
                  Width = 415
                  Height = 176
                  Align = alClient
                  ReadOnly = True
                  ScrollBars = ssVertical
                  TabOrder = 0
                end
              end
              object tsYouChat: TTabSheet
                Caption = 'YouChat'
                ImageIndex = 2
                object mmoYouChatAnswer: TMemo
                  Left = 0
                  Top = 0
                  Width = 415
                  Height = 176
                  Align = alClient
                  ReadOnly = True
                  ScrollBars = ssVertical
                  TabOrder = 0
                end
              end
            end
          end
          object pnlQuestion: TPanel
            Left = 0
            Top = 0
            Width = 425
            Height = 114
            Align = alTop
            TabOrder = 1
            DesignSize = (
              425
              114)
            object Lbl_Question: TLabel
              Left = 7
              Top = 3
              Width = 53
              Height = 15
              Caption = 'Question:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object mmoQuestion: TMemo
              Left = 5
              Top = 20
              Width = 415
              Height = 89
              Hint = 'Type a question and press Ctrl + Enter'
              Anchors = [akLeft, akTop, akRight, akBottom]
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              Lines.Strings = (
                '')
              ParentFont = False
              ParentShowHint = False
              ScrollBars = ssVertical
              ShowHint = True
              TabOrder = 0
              OnKeyDown = mmoQuestionKeyDown
            end
          end
        end
      end
    end
    object tsClassView: TTabSheet
      Caption = 'Class View'
      ImageIndex = 1
      object splClassView: TSplitter
        Left = 0
        Top = 137
        Width = 427
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 113
        ExplicitWidth = 241
      end
      object pnlClasses: TPanel
        Left = 0
        Top = 0
        Width = 427
        Height = 137
        Align = alTop
        TabOrder = 0
      end
      object pnlPredefinedCmdAnswer: TPanel
        Left = 0
        Top = 140
        Width = 427
        Height = 229
        Align = alClient
        TabOrder = 1
        object splClassViewResult: TSplitter
          Left = 238
          Top = 1
          Height = 227
          Align = alRight
          Visible = False
          ExplicitLeft = 216
          ExplicitTop = 64
          ExplicitHeight = 100
        end
        object mmoClassViewDetail: TMemo
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 231
          Height = 221
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          OnDblClick = mmoClassViewDetailDblClick
        end
        object mmoClassViewResult: TMemo
          Left = 241
          Top = 1
          Width = 185
          Height = 227
          Align = alRight
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
          Visible = False
          OnDblClick = mmoClassViewResultDblClick
        end
      end
    end
    object tsHistory: TTabSheet
      Caption = 'History'
      ImageIndex = 2
      object splHistory: TSplitter
        Left = 0
        Top = 185
        Width = 427
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 184
      end
      object pnlHistoryTop: TPanel
        Left = 0
        Top = 0
        Width = 427
        Height = 185
        Align = alTop
        PopupMenu = pmGrdHistory
        TabOrder = 0
        object pnlSearchHistory: TPanel
          Left = 1
          Top = 1
          Width = 425
          Height = 40
          Align = alTop
          TabOrder = 0
          Visible = False
          DesignSize = (
            425
            40)
          object Chk_CaseSensitive: TCheckBox
            Left = 330
            Top = 1
            Width = 94
            Height = 38
            Align = alRight
            Anchors = [akTop, akRight]
            Caption = 'Case Sensitive'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = Chk_CaseSensitiveClick
          end
          object Edt_Search: TEdit
            AlignWithMargins = True
            Left = 7
            Top = 8
            Width = 202
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            OnChange = Edt_SearchChange
          end
          object Chk_FuzzyMatch: TCheckBox
            Left = 245
            Top = 1
            Width = 85
            Height = 38
            Align = alRight
            Anchors = [akTop, akRight]
            Caption = 'Fuzzy Match'
            Color = clLime
            Ctl3D = True
            DoubleBuffered = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentCtl3D = False
            ParentDoubleBuffered = False
            ParentFont = False
            TabOrder = 2
            OnClick = Chk_CaseSensitiveClick
          end
        end
      end
      object pnlHistoryBottom: TPanel
        Left = 0
        Top = 188
        Width = 427
        Height = 181
        Align = alClient
        TabOrder = 1
        object mmoHistoryDetail: TMemo
          Left = 1
          Top = 1
          Width = 425
          Height = 179
          Align = alClient
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 399
    Width = 435
    Height = 34
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      435
      34)
    object chk_AutoCopy: TCheckBox
      AlignWithMargins = True
      Left = 294
      Top = 6
      Width = 132
      Height = 20
      Margins.Right = 4
      Anchors = [akRight, akBottom]
      Caption = 'Auto copy to clipboard'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object ActivityIndicator1: TActivityIndicator
      Left = 6
      Top = 5
      Animate = True
      IndicatorColor = aicWhite
      IndicatorSize = aisSmall
      IndicatorType = aitSectorRing
    end
  end
  object pmMemo: TPopupMenu
    Left = 56
    Top = 232
    object CopytoClipboard1: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = CopytoClipboard1Click
    end
  end
  object pmClassOperations: TPopupMenu
    OnPopup = pmClassOperationsPopup
    Left = 56
    Top = 304
  end
  object FDConnection: TFDConnection
    LoginPrompt = False
    Left = 152
    Top = 232
  end
  object DSHistory: TDataSource
    DataSet = FDQryHistory
    Left = 240
    Top = 304
  end
  object FDQryHistory: TFDQuery
    AfterScroll = FDQryHistoryAfterScroll
    OnFilterRecord = FDQryHistoryFilterRecord
    Connection = FDConnection
    SQL.Strings = (
      'Select * from TbHistory')
    Left = 239
    Top = 231
    object FDQryHistoryHID: TFDAutoIncField
      FieldName = 'HID'
      Origin = 'HID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQryHistoryQuestion: TWideMemoField
      Alignment = taCenter
      FieldName = 'Question'
      Origin = 'Question'
      OnGetText = FDQryHistoryQuestionGetText
      BlobType = ftWideMemo
    end
    object FDQryHistoryAnswer: TWideMemoField
      FieldName = 'Answer'
      Origin = 'Answer'
      OnGetText = FDQryHistoryQuestionGetText
      BlobType = ftWideMemo
    end
    object FDQryHistoryDate: TLargeintField
      FieldName = 'Date'
      OnGetText = FDQryHistoryDateGetText
    end
  end
  object pmGrdHistory: TPopupMenu
    Left = 160
    Top = 304
    object GetQuestion: TMenuItem
      Caption = 'Use the Question'
      OnClick = GetQuestionClick
    end
    object ReloadHistory: TMenuItem
      Caption = 'Reload History'
      OnClick = ReloadHistoryClick
    end
    object SearchMnu: TMenuItem
      AutoCheck = True
      Caption = 'Search'
      OnClick = SearchMnuClick
    end
  end
end
