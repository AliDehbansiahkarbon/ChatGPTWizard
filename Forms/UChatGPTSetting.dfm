object Frm_Setting: TFrm_Setting
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Setting'
  ClientHeight = 584
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pgcSetting: TPageControl
    Left = 0
    Top = 0
    Width = 461
    Height = 538
    ActivePage = tsMainSetting
    Align = alClient
    TabOrder = 0
    OnChange = pgcSettingChange
    object tsMainSetting: TTabSheet
      Caption = 'Main Setting'
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 453
        Height = 508
        Align = alClient
        TabOrder = 0
        object grp_OpenAI: TGroupBox
          Left = 1
          Top = 1
          Width = 451
          Height = 184
          Align = alTop
          Caption = 'OpenAI preferences'
          TabOrder = 0
          object pnlOpenAI: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 20
            Width = 441
            Height = 159
            Align = alClient
            BevelOuter = bvLowered
            TabOrder = 0
            object lbl_1: TLabel
              Left = 30
              Top = 18
              Width = 51
              Height = 15
              Caption = 'Base URL:'
            end
            object lbl_2: TLabel
              Left = 20
              Top = 46
              Width = 61
              Height = 15
              Caption = 'Access Key:'
            end
            object lbl_3: TLabel
              Left = 44
              Top = 75
              Width = 37
              Height = 15
              Caption = 'Model:'
            end
            object lbl_4: TLabel
              Left = 19
              Top = 104
              Width = 62
              Height = 15
              Caption = 'Max-Token:'
            end
            object lbl_5: TLabel
              Left = 12
              Top = 135
              Width = 69
              Height = 15
              Caption = 'Temperature:'
            end
            object edt_Url: TEdit
              Left = 89
              Top = 12
              Width = 318
              Height = 23
              TabOrder = 0
              Text = 'https://api.openai.com/v1/completions'
              OnChange = edt_UrlChange
            end
            object edt_ApiKey: TEdit
              Left = 89
              Top = 42
              Width = 318
              Height = 23
              PasswordChar = '*'
              TabOrder = 1
              OnChange = edt_UrlChange
            end
            object edt_MaxToken: TEdit
              Left = 89
              Top = 101
              Width = 122
              Height = 23
              NumbersOnly = True
              TabOrder = 2
              Text = '2048'
              OnChange = edt_UrlChange
            end
            object edt_Temperature: TEdit
              Left = 89
              Top = 131
              Width = 122
              Height = 23
              NumbersOnly = True
              TabOrder = 3
              Text = '0'
              OnChange = edt_UrlChange
            end
            object cbbModel: TComboBox
              Left = 89
              Top = 72
              Width = 122
              Height = 23
              Style = csDropDownList
              TabOrder = 4
              OnChange = cbbModelChange
              Items.Strings = (
                'text-davinci-003'
                'text-curie-001'
                'text-babbage-001'
                'text-ada-001'
                'gpt-3.5-turbo'
                'gpt-3.5-turbo-0301'
                'code-davinci-002'
                'text-davinci-002'
                'gpt-4'
                'gpt-4-32k'
                'gpt-4-0314')
            end
            object chk_AnimatedLetters: TCheckBox
              Left = 234
              Top = 76
              Width = 113
              Height = 17
              Caption = 'Animated Letters'
              TabOrder = 5
              OnClick = chk_AnimatedLettersClick
            end
            object lbEdt_Timeout: TLabeledEdit
              Left = 297
              Top = 99
              Width = 28
              Height = 23
              Alignment = taCenter
              EditLabel.Width = 57
              EditLabel.Height = 15
              EditLabel.Caption = 'Timeout(s)'
              LabelPosition = lpLeft
              LabelSpacing = 5
              NumbersOnly = True
              TabOrder = 6
              Text = '20'
            end
          end
        end
        object pnlOther: TPanel
          Left = 1
          Top = 185
          Width = 451
          Height = 322
          Align = alClient
          TabOrder = 1
          object GroupBox1: TGroupBox
            Left = 1
            Top = 1
            Width = 449
            Height = 96
            Align = alTop
            Caption = 'History'
            TabOrder = 0
            object pnlHistory: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 20
              Width = 439
              Height = 71
              Align = alClient
              BevelOuter = bvLowered
              TabOrder = 0
              DesignSize = (
                439
                71)
              object lbl_ColorPicker: TLabel
                Left = 197
                Top = 16
                Width = 82
                Height = 15
                Caption = 'Highlight Color'
              end
              object chk_History: TCheckBox
                Left = 20
                Top = 16
                Width = 55
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
                OnChange = edt_UrlChange
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
              object ColorBox_Highlight: TColorBox
                Left = 284
                Top = 13
                Width = 113
                Height = 22
                DefaultColorColor = clRed
                TabOrder = 3
                OnChange = ColorBox_HighlightChange
              end
            end
          end
          object grp_Proxy: TGroupBox
            Left = 1
            Top = 164
            Width = 449
            Height = 157
            Align = alTop
            Caption = 'Proxy Setting'
            TabOrder = 1
            object pnlProxy: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 20
              Width = 439
              Height = 132
              Align = alClient
              BevelOuter = bvLowered
              TabOrder = 0
              object lbEdt_ProxyHost: TLabeledEdit
                Left = 71
                Top = 11
                Width = 318
                Height = 23
                EditLabel.Width = 28
                EditLabel.Height = 15
                EditLabel.Caption = 'Host:'
                EditLabel.Layout = tlCenter
                LabelPosition = lpLeft
                TabOrder = 0
                Text = ''
                OnChange = edt_UrlChange
              end
              object lbEdt_ProxyPort: TLabeledEdit
                Left = 71
                Top = 40
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
                OnChange = edt_UrlChange
              end
              object chk_ProxyActive: TCheckBox
                Left = 225
                Top = 102
                Width = 62
                Height = 17
                Caption = 'Active'
                TabOrder = 2
                OnClick = chk_ProxyActiveClick
              end
              object lbEdt_ProxyUserName: TLabeledEdit
                Left = 71
                Top = 69
                Width = 138
                Height = 23
                EditLabel.Width = 58
                EditLabel.Height = 15
                EditLabel.Caption = 'UserName:'
                EditLabel.Layout = tlCenter
                LabelPosition = lpLeft
                TabOrder = 3
                Text = ''
                OnChange = edt_UrlChange
              end
              object lbEdt_ProxyPassword: TLabeledEdit
                Left = 71
                Top = 98
                Width = 138
                Height = 23
                EditLabel.Width = 53
                EditLabel.Height = 15
                EditLabel.Caption = 'Password:'
                EditLabel.Layout = tlCenter
                LabelPosition = lpLeft
                TabOrder = 4
                Text = ''
                OnChange = edt_UrlChange
              end
            end
          end
          object grp_Other: TGroupBox
            Left = 1
            Top = 97
            Width = 449
            Height = 67
            Align = alTop
            Caption = 'IDE && Other'
            TabOrder = 2
            object pnlIDE: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 20
              Width = 439
              Height = 42
              Align = alClient
              BevelOuter = bvLowered
              TabOrder = 0
              object lbl_6: TLabel
                Left = 271
                Top = 17
                Width = 50
                Height = 15
                Caption = 'Identifier:'
              end
              object Edt_SourceIdentifier: TEdit
                Left = 327
                Top = 14
                Width = 54
                Height = 23
                Alignment = taCenter
                TabOrder = 0
                Text = 'cpt'
              end
              object chk_CodeFormatter: TCheckBox
                Left = 24
                Top = 17
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
                Left = 168
                Top = 17
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
    object tsPreDefinedQuestions: TTabSheet
      Caption = 'PreDefined Questions'
      ImageIndex = 1
      object Btn_AddQuestion: TButton
        Left = 5
        Top = 11
        Width = 78
        Height = 27
        Caption = 'Add'
        TabOrder = 0
        OnClick = Btn_AddQuestionClick
      end
      object ScrollBox: TScrollBox
        AlignWithMargins = True
        Left = 3
        Top = 50
        Width = 447
        Height = 455
        Margins.Top = 50
        Align = alClient
        TabOrder = 1
        object GridPanelPredefinedQs: TGridPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 0
          Align = alTop
          ColumnCollection = <
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <>
          RowCollection = <
            item
              Value = 50.000000000000000000
            end
            item
              Value = 50.000000000000000000
            end>
          TabOrder = 0
        end
      end
      object Btn_RemoveQuestion: TButton
        Left = 86
        Top = 11
        Width = 90
        Height = 27
        Caption = 'Remove latest'
        TabOrder = 2
        OnClick = Btn_RemoveQuestionClick
      end
    end
    object tsOtherAiServices: TTabSheet
      Caption = 'Other AI Services'
      ImageIndex = 2
      object grp_WriteSonic: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 447
        Height = 126
        Align = alTop
        Caption = 'Writesonic'
        TabOrder = 0
        object pnlWriteSonic: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 20
          Width = 437
          Height = 101
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 0
          object chk_WriteSonic: TCheckBox
            Left = 8
            Top = 4
            Width = 121
            Height = 17
            Caption = 'Enable WriteSonic'
            TabOrder = 0
            OnClick = chk_WriteSonicClick
          end
          object lbEdt_WriteSonicAPIKey: TLabeledEdit
            Left = 74
            Top = 31
            Width = 330
            Height = 23
            EditLabel.Width = 43
            EditLabel.Height = 15
            EditLabel.Caption = 'API Key:'
            LabelPosition = lpLeft
            LabelSpacing = 5
            PasswordChar = '*'
            TabOrder = 1
            Text = ''
          end
          object lbEdt_WriteSonicBaseURL: TLabeledEdit
            Left = 74
            Top = 60
            Width = 330
            Height = 23
            EditLabel.Width = 51
            EditLabel.Height = 15
            EditLabel.Caption = 'Base URL:'
            LabelPosition = lpLeft
            LabelSpacing = 5
            TabOrder = 2
            Text = ''
          end
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 538
    Width = 461
    Height = 46
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      461
      46)
    object Btn_Default: TButton
      Left = 275
      Top = 10
      Width = 89
      Height = 28
      Anchors = [akRight, akBottom]
      Caption = 'Load Defaults'
      TabOrder = 0
      OnClick = Btn_DefaultClick
    end
    object Btn_Save: TButton
      Left = 366
      Top = 10
      Width = 89
      Height = 28
      Anchors = [akRight, akBottom]
      Caption = 'Save && Close'
      TabOrder = 1
      OnClick = Btn_SaveClick
    end
  end
end
