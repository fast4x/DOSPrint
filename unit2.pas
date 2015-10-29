unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm_progress }

  TForm_progress = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Labelmsg: TLabel;
    Labelmsg1: TLabel;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form_progress: TForm_progress;

implementation
uses unit1;

{ TForm_progress }

procedure TForm_progress.FormCreate(Sender: TObject);
begin
//  labelmsg.caption:='';
//  labelmsg1.caption:='';
end;

{$R *.lfm}

end.

