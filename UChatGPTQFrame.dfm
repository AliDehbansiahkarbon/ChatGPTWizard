object Fram_Question: TFram_Question
  Left = 0
  Top = 0
  Width = 544
  Height = 333
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 544
    Height = 333
    Align = alClient
    ParentColor = True
    TabOrder = 0
    object splitter: TSplitter
      Left = 1
      Top = 159
      Width = 542
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitLeft = 8
      ExplicitTop = 156
      ExplicitWidth = 433
    end
    object pnlTop: TPanel
      Left = 1
      Top = 1
      Width = 542
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
    object pnlQuestion: TPanel
      Left = 1
      Top = 45
      Width = 542
      Height = 114
      Align = alTop
      TabOrder = 1
      DesignSize = (
        542
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
        Width = 519
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
    object pnlAnswer: TPanel
      Left = 1
      Top = 162
      Width = 542
      Height = 136
      Align = alClient
      TabOrder = 2
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
        Width = 534
        Height = 111
        Margins.Top = 20
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitLeft = 11
        ExplicitTop = 22
        ExplicitWidth = 515
        ExplicitHeight = 105
      end
    end
    object pnlBottom: TPanel
      Left = 1
      Top = 298
      Width = 542
      Height = 34
      Align = alBottom
      TabOrder = 3
      DesignSize = (
        542
        34)
      object chk_AutoCopy: TCheckBox
        AlignWithMargins = True
        Left = 380
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
  end
  object PopupMenu: TPopupMenu
    Left = 344
    Top = 88
    object CopytoClipboard1: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = CopytoClipboard1Click
    end
  end
end
