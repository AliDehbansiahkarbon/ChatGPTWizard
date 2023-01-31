object Fram_Question: TFram_Question
  Left = 0
  Top = 0
  Width = 435
  Height = 534
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 534
    Align = alClient
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      435
      534)
    object Label1: TLabel
      Left = 12
      Top = 44
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
    object Label2: TLabel
      Left = 18
      Top = 157
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
    object mmoQuestion: TMemo
      Left = 13
      Top = 63
      Width = 406
      Height = 89
      Hint = 'Type a question and press Ctrl + Enter'
      Anchors = [akLeft, akTop, akRight]
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
    object mmoAnswer: TMemo
      Left = 13
      Top = 175
      Width = 406
      Height = 323
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object ProgressBar1: TProgressBar
      Left = 12
      Top = 509
      Width = 126
      Height = 17
      Anchors = [akLeft, akBottom]
      Style = pbstMarquee
      TabOrder = 2
      Visible = False
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 433
      Height = 41
      Align = alTop
      TabOrder = 3
      object Btn_Clipboard: TButton
        Left = 96
        Top = 6
        Width = 116
        Height = 28
        Caption = 'Copy to Clipboard'
        TabOrder = 0
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
        TabOrder = 1
        OnClick = Btn_AskClick
      end
      object Btn_Clear: TButton
        Left = 219
        Top = 6
        Width = 74
        Height = 28
        Caption = 'Clear All'
        TabOrder = 2
        OnClick = Btn_ClearClick
      end
    end
    object chk_AutoCopy: TCheckBox
      AlignWithMargins = True
      Left = 271
      Top = 507
      Width = 146
      Height = 19
      Margins.Right = 4
      Anchors = [akRight, akBottom]
      Caption = 'Auto copy to clipboard'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 240
    Top = 192
    object CopytoClipboard1: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = CopytoClipboard1Click
    end
  end
end
