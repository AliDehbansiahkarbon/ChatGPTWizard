object FrmChatGPT: TFrmChatGPT
  Left = 0
  Top = 0
  Caption = 'ChatGPT'
  ClientHeight = 527
  ClientWidth = 561
  Color = clBtnFace
  Constraints.MinHeight = 550
  Constraints.MinWidth = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 561
    Height = 527
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 559
    ExplicitHeight = 519
    DesignSize = (
      561
      527)
    object Label1: TLabel
      Left = 11
      Top = 19
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
      Left = 19
      Top = 127
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
    object Btn_Ask: TButton
      Left = 474
      Top = 14
      Width = 75
      Height = 91
      Anchors = [akTop, akRight]
      Caption = 'Ask'
      TabOrder = 0
      OnClick = Btn_AskClick
      ExplicitLeft = 472
    end
    object mmoQuestion: TMemo
      Left = 68
      Top = 16
      Width = 400
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
      TabOrder = 1
      OnKeyDown = mmoQuestionKeyDown
    end
    object mmoAnswer: TMemo
      Left = 68
      Top = 124
      Width = 400
      Height = 371
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
      TabOrder = 2
      ExplicitWidth = 398
      ExplicitHeight = 363
    end
    object ProgressBar1: TProgressBar
      Left = 4
      Top = 508
      Width = 150
      Height = 17
      Anchors = [akLeft, akBottom]
      Style = pbstMarquee
      TabOrder = 3
      Visible = False
      ExplicitTop = 500
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 384
    Top = 160
    object CopytoClipboard1: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = CopytoClipboard1Click
    end
  end
end
