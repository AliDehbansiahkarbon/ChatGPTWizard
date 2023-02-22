object Fram_Question: TFram_Question
  Left = 0
  Top = 0
  Width = 483
  Height = 384
  TabOrder = 0
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 483
    Height = 350
    ActivePage = tsChatGPT
    Align = alClient
    TabOrder = 0
    object tsChatGPT: TTabSheet
      Caption = 'ChatGPT'
      object pnlMain: TPanel
        Left = 0
        Top = 0
        Width = 475
        Height = 320
        Align = alClient
        ParentColor = True
        TabOrder = 0
        object pnlTop: TPanel
          Left = 1
          Top = 1
          Width = 473
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
          Width = 473
          Height = 274
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object splitter: TSplitter
            Left = 0
            Top = 114
            Width = 473
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
            Width = 473
            Height = 157
            Align = alClient
            TabOrder = 0
            object Lbl_Answer: TLabel
              Left = 15
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
              Width = 465
              Height = 132
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
            Width = 473
            Height = 114
            Align = alTop
            TabOrder = 1
            DesignSize = (
              473
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
              Width = 450
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
        Width = 475
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 113
        ExplicitWidth = 241
      end
      object pnlClasses: TPanel
        Left = 0
        Top = 0
        Width = 475
        Height = 137
        Align = alTop
        TabOrder = 0
      end
      object pnlPredefinedCmdAnswer: TPanel
        Left = 0
        Top = 140
        Width = 475
        Height = 180
        Align = alClient
        TabOrder = 1
        object mmoPredefinedCmdAnswer: TMemo
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 467
          Height = 172
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
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 350
    Width = 483
    Height = 34
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      483
      34)
    object chk_AutoCopy: TCheckBox
      AlignWithMargins = True
      Left = 321
      Top = 6
      Width = 146
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
    Left = 248
    Top = 264
    object CopytoClipboard1: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = CopytoClipboard1Click
    end
  end
  object pmClassOperations: TPopupMenu
    OnPopup = pmClassOperationsPopup
    Left = 336
    Top = 264
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
    object CustomCommand1: TMenuItem
      Caption = 'Custom Command'
      OnClick = CustomCommand1Click
    end
  end
end
