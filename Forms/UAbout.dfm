object Frm_About: TFrm_About
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'About'
  ClientHeight = 166
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object Img_Logo: TImage
    Left = 13
    Top = 5
    Width = 72
    Height = 60
    Proportional = True
    Stretch = True
  end
  object lbl_Name: TLabel
    Left = 91
    Top = 24
    Width = 129
    Height = 23
    Caption = 'ChatGPTWizard'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_Description: TLabel
    Left = 12
    Top = 70
    Width = 259
    Height = 30
    AutoSize = False
    Caption = 
      'An IDE plug-in for ChatGPT, Writesonic, and Youchat by Ali Dehba' +
      'nsiahkarbon.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object lbl_Github: TLabel
    Left = 30
    Top = 107
    Width = 43
    Height = 15
    Caption = 'GitHub:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_ShortVideo: TLabel
    Left = 5
    Top = 124
    Width = 68
    Height = 15
    Caption = 'Short video:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_LongVideo: TLabel
    Left = 9
    Top = 140
    Width = 64
    Height = 15
    Caption = 'Long video:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_Free: TLabel
    Left = 210
    Top = 46
    Width = 41
    Height = 15
    Caption = 'It'#39's free!'
    Color = 5592575
    ParentColor = False
    Transparent = False
  end
  object lbl_Version: TLabel
    Left = 224
    Top = 29
    Width = 56
    Height = 15
    Caption = 'lbl_Version'
  end
  object LinkLabel_Github: TLinkLabel
    Left = 79
    Top = 105
    Width = 206
    Height = 21
    Caption = 
      '<a href="https://github.com/AliDehbansiahkarbon/ChatGPTWizard">h' +
      'ttps://github.com/ChatGPTWizard</a>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnLinkClick = LinkLabel_GithubLinkClick
  end
  object LinkLabel_ShortVideo: TLinkLabel
    Left = 79
    Top = 122
    Width = 186
    Height = 21
    Caption = 
      '<a href="https://www.youtube.com/watch?v=jHFmmmrk3BU">https://yo' +
      'utu.be/jHFmmmrk3BU</a>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnLinkClick = LinkLabel_GithubLinkClick
  end
  object LinkLabel_LongVideo: TLinkLabel
    Left = 79
    Top = 138
    Width = 182
    Height = 21
    Caption = 
      '<a href="https://youtu.be/qHqEGfxAhIM">https://youtu.be/qHqEGfxA' +
      'hIM</a>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnLinkClick = LinkLabel_GithubLinkClick
  end
end
