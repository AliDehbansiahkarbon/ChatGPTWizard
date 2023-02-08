object Frm_Setting: TFrm_Setting
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Setting'
  ClientHeight = 436
  ClientWidth = 399
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
    Width = 393
    Height = 430
    Align = alClient
    TabOrder = 0
    object grp_OpenAI: TGroupBox
      Left = 1
      Top = 1
      Width = 391
      Height = 168
      Align = alTop
      Caption = 'OenAI preferences'
      TabOrder = 0
      object lbl_1: TLabel
        Left = 20
        Top = 24
        Width = 51
        Height = 15
        Caption = 'Base URL:'
      end
      object lbl_2: TLabel
        Left = 10
        Top = 52
        Width = 61
        Height = 15
        Caption = 'Access Key:'
      end
      object lbl_3: TLabel
        Left = 34
        Top = 81
        Width = 37
        Height = 15
        Caption = 'Model:'
      end
      object lbl_4: TLabel
        Left = 9
        Top = 110
        Width = 62
        Height = 15
        Caption = 'Max-Token:'
      end
      object lbl_5: TLabel
        Left = 2
        Top = 141
        Width = 69
        Height = 15
        Caption = 'Temperature:'
      end
      object edt_Url: TEdit
        Left = 77
        Top = 18
        Width = 291
        Height = 23
        TabOrder = 0
        Text = 'https://api.openai.com/v1/completions'
      end
      object edt_ApiKey: TEdit
        Left = 77
        Top = 48
        Width = 291
        Height = 23
        PasswordChar = '*'
        TabOrder = 1
      end
      object edt_MaxToken: TEdit
        Left = 79
        Top = 107
        Width = 122
        Height = 23
        NumbersOnly = True
        TabOrder = 2
        Text = '2048'
      end
      object edt_Temperature: TEdit
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
    end
    object grp_Other: TGroupBox
      Left = 1
      Top = 169
      Width = 391
      Height = 260
      Align = alClient
      Caption = 'IDE && Other'
      TabOrder = 1
      DesignSize = (
        391
        260)
      object lbl_6: TLabel
        Left = 258
        Top = 29
        Width = 50
        Height = 15
        Caption = 'Identifier:'
      end
      object Btn_Default: TButton
        Left = 291
        Top = 225
        Width = 89
        Height = 28
        Anchors = [akRight, akBottom]
        Caption = 'Load Defaults'
        TabOrder = 0
        OnClick = Btn_DefaultClick
      end
      object Btn_Save: TButton
        Left = 196
        Top = 225
        Width = 89
        Height = 28
        Anchors = [akRight, akBottom]
        Caption = 'Save && Close'
        TabOrder = 1
        OnClick = Btn_SaveClick
      end
      object Edt_SourceIdentifier: TEdit
        Left = 314
        Top = 26
        Width = 54
        Height = 23
        Alignment = taCenter
        TabOrder = 2
        Text = 'cpt'
      end
      object chk_CodeFormatter: TCheckBox
        Left = 11
        Top = 29
        Width = 128
        Height = 17
        BiDiMode = bdLeftToRight
        Caption = 'Call Code Formatter'
        Checked = True
        ParentBiDiMode = False
        State = cbChecked
        TabOrder = 3
      end
      object chk_Rtl: TCheckBox
        Left = 155
        Top = 29
        Width = 97
        Height = 17
        Caption = 'Righ To Left'
        TabOrder = 4
      end
      object grp_Proxy: TGroupBox
        Left = 11
        Top = 71
        Width = 357
        Height = 148
        Caption = 'Proxy Setting'
        TabOrder = 5
        object lbEdt_ProxyHost: TLabeledEdit
          Left = 68
          Top = 27
          Width = 262
          Height = 23
          EditLabel.Width = 28
          EditLabel.Height = 15
          EditLabel.Caption = 'Host:'
          EditLabel.Layout = tlCenter
          LabelPosition = lpLeft
          TabOrder = 0
          Text = ''
        end
        object lbEdt_ProxyPort: TLabeledEdit
          Left = 68
          Top = 56
          Width = 66
          Height = 23
          EditLabel.Width = 25
          EditLabel.Height = 15
          EditLabel.Caption = 'Port:'
          EditLabel.Layout = tlCenter
          LabelPosition = lpLeft
          NumbersOnly = True
          TabOrder = 1
          Text = ''
        end
        object chk_ProxyActive: TCheckBox
          Left = 223
          Top = 120
          Width = 51
          Height = 17
          Caption = 'Active'
          TabOrder = 2
        end
        object lbEdt_ProxyUserName: TLabeledEdit
          Left = 68
          Top = 85
          Width = 138
          Height = 23
          EditLabel.Width = 58
          EditLabel.Height = 15
          EditLabel.Caption = 'UserName:'
          EditLabel.Layout = tlCenter
          LabelPosition = lpLeft
          NumbersOnly = True
          TabOrder = 3
          Text = ''
        end
        object lbEdt_ProxyPassword: TLabeledEdit
          Left = 68
          Top = 114
          Width = 138
          Height = 23
          EditLabel.Width = 53
          EditLabel.Height = 15
          EditLabel.Caption = 'Password:'
          EditLabel.Layout = tlCenter
          LabelPosition = lpLeft
          NumbersOnly = True
          TabOrder = 4
          Text = ''
        end
      end
    end
  end
end
