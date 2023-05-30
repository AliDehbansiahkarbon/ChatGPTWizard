unit UAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Winapi.ShellAPI;

type
  TFrm_About = class(TForm)
    Img_Logo: TImage;
    lbl_Name: TLabel;
    lbl_Description: TLabel;
    lbl_Github: TLabel;
    LinkLabel_Github: TLinkLabel;
    lbl_ShortVideo: TLabel;
    LinkLabel_ShortVideo: TLinkLabel;
    lbl_LongVideo: TLabel;
    LinkLabel_LongVideo: TLinkLabel;
    procedure FormCreate(Sender: TObject);
    procedure LinkLabel_GithubLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
  private
    procedure LoadLogo;
  public
    { Public declarations }
  end;

var
  Frm_About: TFrm_About;

implementation

{$R *.dfm}

procedure TFrm_About.FormCreate(Sender: TObject);
begin
  LoadLogo;
end;

procedure TFrm_About.LinkLabel_GithubLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, 'Open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrm_About.LoadLogo;
var
  LvResStream: TResourceStream;
begin
  LvResStream := TResourceStream.Create(HInstance, 'LOGO', RT_RCDATA);
  try
    Img_Logo.Picture.LoadFromStream(LvResStream);
  finally
    LvResStream.Free;
  end;
end;

end.
