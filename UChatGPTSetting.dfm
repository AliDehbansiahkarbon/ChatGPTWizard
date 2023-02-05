object Frm_Setting: TFrm_Setting
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Setting'
  ClientHeight = 248
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pnl1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 448
    Height = 242
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 446
    ExplicitHeight = 234
    object Label1: TLabel
      Left = 20
      Top = 24
      Width = 51
      Height = 15
      Caption = 'Base URL:'
    end
    object Label2: TLabel
      Left = 10
      Top = 52
      Width = 61
      Height = 15
      Caption = 'Access Key:'
    end
    object Label3: TLabel
      Left = 34
      Top = 81
      Width = 37
      Height = 15
      Caption = 'Model:'
    end
    object Label4: TLabel
      Left = 9
      Top = 110
      Width = 62
      Height = 15
      Caption = 'Max-Token:'
    end
    object Label5: TLabel
      Left = 2
      Top = 141
      Width = 69
      Height = 15
      Caption = 'Temperature:'
    end
    object Lbl_SourceIdentifier: TLabel
      Left = 21
      Top = 171
      Width = 50
      Height = 15
      Caption = 'Identifier:'
    end
    object Edt_Url: TEdit
      Left = 79
      Top = 18
      Width = 354
      Height = 23
      TabOrder = 0
      Text = 'https://api.openai.com/v1/completions'
    end
    object Edt_ApiKey: TEdit
      Left = 79
      Top = 48
      Width = 354
      Height = 23
      PasswordChar = '*'
      TabOrder = 1
    end
    object Edt_MaxToken: TEdit
      Left = 79
      Top = 107
      Width = 122
      Height = 23
      NumbersOnly = True
      TabOrder = 2
      Text = '2048'
    end
    object Edt_Temperature: TEdit
      Left = 79
      Top = 137
      Width = 122
      Height = 23
      NumbersOnly = True
      TabOrder = 3
      Text = '0'
    end
    object cbbModel: TComboBox
      Left = 79
      Top = 78
      Width = 122
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      Text = 'text-davinci-003'
      Items.Strings = (
        'text-davinci-003'
        'text-curie-001'
        'text-babbage-001'
        'text-ada-001')
    end
    object Btn_Save: TButton
      Left = 356
      Top = 191
      Width = 83
      Height = 28
      Caption = 'Save && Close'
      TabOrder = 5
      OnClick = Btn_SaveClick
    end
    object Btn_Default: TButton
      Left = 356
      Top = 160
      Width = 83
      Height = 28
      Caption = 'Load Defaults'
      TabOrder = 6
      OnClick = Btn_DefaultClick
    end
    object Edt_SourceIdentifier: TEdit
      Left = 79
      Top = 166
      Width = 38
      Height = 23
      Alignment = taCenter
      TabOrder = 7
      Text = 'cpt'
    end
    object chk_CodeFormatter: TCheckBox
      Left = 20
      Top = 202
      Width = 128
      Height = 17
      BiDiMode = bdRightToLeft
      Caption = 'Call Code Formatter'
      Checked = True
      ParentBiDiMode = False
      State = cbChecked
      TabOrder = 8
    end
    object chk_Rtl: TCheckBox
      Left = 224
      Top = 80
      Width = 97
      Height = 17
      Caption = 'Righ To Left'
      TabOrder = 9
    end
  end
end
