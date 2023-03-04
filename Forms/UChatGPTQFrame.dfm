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
    TabOrder = 0
    OnChange = pgcMainChange
    object tsChatGPT: TTabSheet
      Caption = 'ChatGPT'
      object pnlMain: TPanel
        Left = 0
        Top = 0
        Width = 427
        Height = 371
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
            Left = 96
            Top = 6
            Width = 137
            Height = 28
            Caption = 'Copy to Clipboard'
            TabOrder = 1
            WordWrap = True
            OnClick = Btn_ClipboardClick
          end
          object Btn_Ask: TButton
            Left = 15
            Top = 6
            Width = 74
            Height = 28
            Hint = 'Ctrl + Enter'
            Caption = 'Ask'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = Btn_AskClick
          end
          object Btn_Clear: TButton
            Left = 246
            Top = 6
            Width = 74
            Height = 28
            Caption = 'Clear All'
            TabOrder = 2
            OnClick = Btn_ClearClick
          end
        end
        object pnlCenter: TPanel
          Left = 1
          Top = 45
          Width = 425
          Height = 325
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
            Height = 208
            Align = alClient
            TabOrder = 0
            object Lbl_Answer: TLabel
              Left = 7
              Top = 5
              Width = 45
              Height = 15
              Caption = 'Answer:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object mmoAnswer: TMemo
              AlignWithMargins = True
              Left = 4
              Top = 21
              Width = 417
              Height = 183
              Margins.Top = 20
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              PopupMenu = pmMemo
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
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
              Left = 11
              Top = 20
              Width = 402
              Height = 89
              Hint = 'Type a question and press Ctrl + Enter'
              Anchors = [akLeft, akTop, akRight, akBottom]
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              Lines.Strings = (
                'Create a class to make a Zip file in Delphi.')
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
        Height = 231
        Align = alClient
        TabOrder = 1
        object mmoPredefinedCmdAnswer: TMemo
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 419
          Height = 223
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
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
      end
      object pnlHistoryBottom: TPanel
        Left = 0
        Top = 188
        Width = 427
        Height = 183
        Align = alClient
        TabOrder = 1
        object mmoHistoryDetail: TMemo
          Left = 1
          Top = 1
          Width = 425
          Height = 181
          Align = alClient
          PopupMenu = pmMemo
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
    object CreateTestUnit1: TMenuItem
      Caption = 'Create Test Unit'
      OnClick = CreateTestUnit1Click
    end
    object ConverttoSingletone1: TMenuItem
      Caption = 'Convert to Singleton'
      OnClick = ConverttoSingletone1Click
    end
    object Findpossibleproblems1: TMenuItem
      Caption = 'Find possible problems'
      OnClick = Findpossibleproblems1Click
    end
    object ImproveNaming1: TMenuItem
      Caption = 'Improve Naming'
      OnClick = ImproveNaming1Click
    end
    object Rewriteinmoderncodingstyle1: TMenuItem
      Caption = 'Rewrite in modern coding style'
      OnClick = Rewriteinmoderncodingstyle1Click
    end
    object CrreateInterface1: TMenuItem
      Caption = 'Crreate Interface'
      OnClick = CrreateInterface1Click
    end
    object ConverttoGenericType1: TMenuItem
      Caption = 'Convert to Generic Type'
      OnClick = ConverttoGenericType1Click
    end
    object Convertto1: TMenuItem
      Caption = 'Convert to'
      object C1: TMenuItem
        Caption = 'C#'
        OnClick = C1Click
      end
      object Java1: TMenuItem
        Caption = 'Java'
        OnClick = Java1Click
      end
      object Python1: TMenuItem
        Caption = 'Python'
        OnClick = Python1Click
      end
      object Javascript1: TMenuItem
        Caption = 'Javascript'
        OnClick = Javascript1Click
      end
      object C3: TMenuItem
        Caption = 'C'
        OnClick = C3Click
      end
      object C2: TMenuItem
        Caption = 'C++'
        OnClick = C2Click
      end
      object Go1: TMenuItem
        Caption = 'Go'
        OnClick = Go1Click
      end
      object Rust1: TMenuItem
        Caption = 'Rust'
        OnClick = Rust1Click
      end
    end
    object WriteXMLdoc1: TMenuItem
      Caption = 'Write XML doc'
      OnClick = WriteXMLdoc1Click
    end
    object CustomCommand1: TMenuItem
      Caption = 'Custom Command'
      OnClick = CustomCommand1Click
    end
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
    object ReloadHistory1: TMenuItem
      Caption = 'Reload History'
      OnClick = ReloadHistory1Click
    end
  end
end
