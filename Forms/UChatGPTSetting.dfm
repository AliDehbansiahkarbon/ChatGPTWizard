object Frm_Setting: TFrm_Setting
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Setting'
  ClientHeight = 638
  ClientWidth = 461
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
    Left = 0
    Top = 0
    Width = 461
    Height = 638
    Align = alClient
    TabOrder = 0
    object grp_OpenAI: TGroupBox
      Left = 1
      Top = 1
      Width = 459
      Height = 203
      Align = alTop
      Caption = 'OpenAI preferences'
      TabOrder = 0
      object pnlOpenAI: TPanel
        Left = 2
        Top = 17
        Width = 455
        Height = 184
        Align = alClient
        TabOrder = 0
        object lbl_1: TLabel
          Left = 21
          Top = 29
          Width = 51
          Height = 15
          Caption = 'Base URL:'
        end
        object lbl_2: TLabel
          Left = 11
          Top = 57
          Width = 61
          Height = 15
          Caption = 'Access Key:'
        end
        object lbl_3: TLabel
          Left = 35
          Top = 86
          Width = 37
          Height = 15
          Caption = 'Model:'
        end
        object lbl_4: TLabel
          Left = 10
          Top = 115
          Width = 62
          Height = 15
          Caption = 'Max-Token:'
        end
        object lbl_5: TLabel
          Left = 3
          Top = 146
          Width = 69
          Height = 15
          Caption = 'Temperature:'
        end
        object edt_Url: TEdit
          Left = 80
          Top = 23
          Width = 318
          Height = 23
          TabOrder = 0
          Text = 'https://api.openai.com/v1/completions'
        end
        object edt_ApiKey: TEdit
          Left = 80
          Top = 53
          Width = 318
          Height = 23
          PasswordChar = '*'
          TabOrder = 1
        end
        object edt_MaxToken: TEdit
          Left = 80
          Top = 112
          Width = 122
          Height = 23
          NumbersOnly = True
          TabOrder = 2
          Text = '2048'
        end
        object edt_Temperature: TEdit
          Left = 80
          Top = 142
          Width = 122
          Height = 23
          NumbersOnly = True
          TabOrder = 3
          Text = '0'
        end
        object cbbModel: TComboBox
          Left = 80
          Top = 83
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
    end
    object pnlOther: TPanel
      Left = 1
      Top = 204
      Width = 459
      Height = 433
      Align = alClient
      TabOrder = 1
      object pnlBottom: TPanel
        Left = 1
        Top = 386
        Width = 457
        Height = 46
        Align = alBottom
        TabOrder = 0
        DesignSize = (
          457
          46)
        object Btn_Default: TButton
          Left = 271
          Top = 10
          Width = 89
          Height = 28
          Anchors = [akRight, akBottom]
          Caption = 'Load Defaults'
          TabOrder = 0
          OnClick = Btn_DefaultClick
        end
        object Btn_Save: TButton
          Left = 362
          Top = 10
          Width = 89
          Height = 28
          Anchors = [akRight, akBottom]
          Caption = 'Save && Close'
          TabOrder = 1
          OnClick = Btn_SaveClick
        end
      end
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 457
        Height = 96
        Align = alTop
        Caption = 'History'
        TabOrder = 1
        object pnlHistory: TPanel
          Left = 2
          Top = 17
          Width = 453
          Height = 77
          Align = alClient
          TabOrder = 0
          DesignSize = (
            453
            77)
          object chk_History: TCheckBox
            Left = 20
            Top = 16
            Width = 69
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            BiDiMode = bdLeftToRight
            Caption = 'Enable'
            ParentBiDiMode = False
            TabOrder = 0
            OnClick = chk_HistoryClick
          end
          object lbEdt_History: TLabeledEdit
            Left = 79
            Top = 39
            Width = 318
            Height = 23
            EditLabel.Width = 55
            EditLabel.Height = 15
            EditLabel.Caption = 'Location:  '
            EditLabel.Layout = tlCenter
            LabelPosition = lpLeft
            TabOrder = 1
            Text = ''
          end
          object Btn_HistoryPathBuilder: TButton
            Left = 398
            Top = 39
            Width = 27
            Height = 24
            Caption = '...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = Btn_HistoryPathBuilderClick
          end
        end
      end
      object grp_Proxy: TGroupBox
        Left = 1
        Top = 204
        Width = 457
        Height = 172
        Align = alTop
        Caption = 'Proxy Setting'
        TabOrder = 2
        object pnlProxy: TPanel
          Left = 2
          Top = 17
          Width = 453
          Height = 153
          Align = alClient
          TabOrder = 0
          object lbEdt_ProxyHost: TLabeledEdit
            Left = 79
            Top = 27
            Width = 318
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
            Left = 79
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
            Left = 233
            Top = 118
            Width = 62
            Height = 17
            Caption = 'Active'
            TabOrder = 2
          end
          object lbEdt_ProxyUserName: TLabeledEdit
            Left = 79
            Top = 85
            Width = 138
            Height = 23
            EditLabel.Width = 58
            EditLabel.Height = 15
            EditLabel.Caption = 'UserName:'
            EditLabel.Layout = tlCenter
            LabelPosition = lpLeft
            TabOrder = 3
            Text = ''
          end
          object lbEdt_ProxyPassword: TLabeledEdit
            Left = 79
            Top = 114
            Width = 138
            Height = 23
            EditLabel.Width = 53
            EditLabel.Height = 15
            EditLabel.Caption = 'Password:'
            EditLabel.Layout = tlCenter
            LabelPosition = lpLeft
            TabOrder = 4
            Text = ''
          end
        end
      end
      object grp_Other: TGroupBox
        Left = 1
        Top = 97
        Width = 457
        Height = 107
        Align = alTop
        Caption = 'IDE && Other'
        TabOrder = 3
        object pnlIDE: TPanel
          Left = 2
          Top = 17
          Width = 453
          Height = 88
          Align = alClient
          TabOrder = 0
          object lbl_6: TLabel
            Left = 258
            Top = 29
            Width = 50
            Height = 15
            Caption = 'Identifier:'
          end
          object Edt_SourceIdentifier: TEdit
            Left = 314
            Top = 26
            Width = 54
            Height = 23
            Alignment = taCenter
            TabOrder = 0
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
            TabOrder = 1
          end
          object chk_Rtl: TCheckBox
            Left = 155
            Top = 29
            Width = 97
            Height = 17
            Caption = 'Righ To Left'
            TabOrder = 2
          end
        end
      end
    end
  end
end
