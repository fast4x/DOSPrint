unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs,  TplTimerUnit,
  LSControls, JLabeledFloatEdit, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Printers, ExtCtrls, ComCtrls, MaskEdit, Spin, EditBtn, ShellCtrls, FileCtrl,
  ImgList, XMLPropStorage, LResources, Menus, Registry;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    FileListBox1: TFileListBox;
    FileListBoxProc: TFileListBox;
    floatSpinEdit1: TSpinEdit;
    floatSpinEdit4: TSpinEdit;
    floatSpinEdit2: TSpinEdit;
    floatSpinEdit5: TSpinEdit;
    floatSpinEdit6: TSpinEdit;
    FontDialog1: TFontDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBoxList: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBoxMain: TGroupBox;
    ImageList1: TImageList;
    ImageListload: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Labelfont: TLabel;
    Labelpri: TLabel;
    ListView1: TListView;
    LSImageAnimator1: TLSImageAnimator;
    lstampanti: TComboBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PageControl1: TPageControl;
    pageorient: TRadioGroup;
    PageSetupDialog1: TPageSetupDialog;
    PopupMenu1: TPopupMenu;
    PrinterSetupDialog1: TPrinterSetupDialog;
    AUTOSTARTRadioGroup: TRadioGroup;
    SpinEdit1: TSpinEdit;
    floatSpinEdit3: TSpinEdit;
    SpinEdit2: TSpinEdit;
    TabGen: TTabSheet;
    TabPref: TTabSheet;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    TrayIcon1: TTrayIcon;
    XMLPropStorage: TXMLPropStorage;
    XMLPropStorageApp: TXMLPropStorage;
    XMLPropStorage_default: TXMLPropStorage;
    procedure AUTOSTARTRadioGroupChangeBounds(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure LSImageAnimator1Animation(ASender: TObject;
      var AImageIndex: TImageIndex);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
    procedure LoadProp(Sender: TObject);
    procedure SaveProp(Sender: TObject);
    procedure OnTimer(Sender: TObject);
    procedure PrintFile(fcontent: tstringlist; confname: string);
    procedure PrintLines(Lines: TStringList);
    procedure PrintTStrings(Lst : TStrings) ;
    procedure PrintLines1(Lines: TStringlist; confname: string);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  filenameprop: string;
  modincorso: boolean;
  proclist: array of array of string;
  (*
  Timers: array of TTimer;
  ChkFiles: array of TFileListBox;
  *)

implementation
uses Unit2; // PrintStringsUnit;
{$R *.lfm}

{ TForm1 }

{Converts a TDateTime variable to Int64 milliseconds from 0001-01-01.}
function DateTimeToMilliseconds(aDateTime: TDateTime): Int64;
var
  TimeStamp: TTimeStamp;
begin
  {Call DateTimeToTimeStamp to convert DateTime to TimeStamp:}
  TimeStamp := DateTimeToTimeStamp (aDateTime);
  {Multiply and add to complete the conversion:}
  Result := Int64 (TimeStamp.Date) * MSecsPerDay + TimeStamp.Time;
end;

{Uses DateTimeToTimeStamp, TimeStampToMilliseconds, and DateTimeToMilliseconds. }
function MillisecondsBetween (const anow, athen: TDateTime): Int64;
begin
  if anow > athen then
    Result := DateTimeToMilliseconds(anow) - DateTimeToMilliseconds(athen)
  else
    Result := DateTimeToMilliseconds(athen) - DateTimeToMilliseconds(anow);
end;




procedure Tform1.PrintLines1(Lines: TStringlist; confname: string);
var
I: Integer;
MarginLeft,
MarginTop, MarginBottom: Integer; // Margins' from printable area
Y: Integer; // Y-Position in Pixel
Max: Integer; // Vertical resolution in Pixel
car:string;
begin

  xmlpropstorage.FileName:=confname;


with Printer do begin
      SetPrinter(xmlpropstorage.ReadString('REDIRTOPRINTER',''));
      Title:='Documento DOSPrint';
      Canvas.Font.PixelsPerInch := XDPI;
      if lowercase(xmlpropstorage.ReadString('PAGETYPE','Vertical'))='vertical' then
      Orientation:=poPortrait else Orientation:=poLandscape;

      Canvas.Font.Name := xmlpropstorage.ReadString('FONTNAME','Courier New'); //'Courier New';
      Canvas.Font.Size := xmlpropstorage.ReadInteger('FONTSIZE',10); //10;
      if xmlpropstorage.ReadInteger('FONTBOLD',0) = 1 then
      Canvas.Font.Style:=[fsBold];

      Canvas.Font.Quality:=fqDraft;
      Canvas.Font.Pitch:=fpFixed;

      MarginLeft := xmlpropstorage.ReadInteger('PAGEMARGINLEFT',10);  //10;
      MarginTop := xmlpropstorage.ReadInteger('PAGEMARGINTOP',10); //10;
      MarginBottom := xmlpropstorage.ReadInteger('PAGEMARGINBOTTOM',10); //10;

      //Max := PageHeight - MarginTop;

      Max := PageHeight - MarginTop - MarginBottom;

      BeginDoc;
      try
         Y := MarginTop;
         for I := 0 to Lines.Count - 1 do begin
             //car:=copy(Lines[I],0,1);
             //if length(car) = 1 then  showmessage(Lines[I]+'-'+chr(12));
             //showmessage(car);
             if (lines[i] <> chr(12))  then begin // non stampa il salto pagina, e carattere escape
                Canvas.TextOut(MarginLeft, Y, AnsiToUTF8(Lines[I]));
                //Y := Y + Canvas.TextHeight(Lines[I]);
                Y := Y + Canvas.TextHeight('H');
                Y := Y + xmlpropstorage.ReadInteger('PAGEROWOFFSET',0); // aggiunge l'offset verticale impostato per regolare l'altezza della riga
             end;
           //  If Y >= Max Then Begin
             If Y >= (Max - MarginBottom) Then Begin
                If (i < (Lines.Count-1))  Then
                   NewPage;
                   Y:= MarginTop;
                end;
             If (lines[i]=chr(12)) and (i<lines.Count-1) Then begin
                   NewPage;
                   Y:= MarginTop;
                end;

                Application.ProcessMessages; // for Printer.Abort();
         end;
      finally
         EndDoc;
      end;
end;

end;


procedure TForm1.PrintTStrings(Lst : TStrings) ;
var
  I,
  Line : Integer;
begin
  I := 0;
  Line := 0 ;

    Printer.Title:='Documento DOSPrint';
    Printer.Orientation:=poLandscape;
    Printer.Canvas.Font.PixelsPerInch := Printer.XDPI;
    Printer.Canvas.Font.Name := 'Courier New';
    Printer.Canvas.Font.Size := 10;

  Printer.BeginDoc ;
  for I := 0 to Lst.Count - 1 do begin
    Printer.Canvas.TextOut(0, Line, AnsiToUTF8(Lst[I]));

    {Font.Height is calculated as -Font.Size * 72 / Font.PixelsPerInch which returns
     a negative number. So Abs() is applied to the Height to make it a non-negative
     value}
    Line := Line + Abs(Printer.Canvas.Font.Height);
    if (Line >= Printer.PageHeight) then
      Printer.NewPage;
      Line := 0 ;
  end;
  Printer.EndDoc;
end;


procedure Tform1.PrintLines(Lines: TStringList);
var
  I, Line: Integer;
  H: Integer; // TextHeight
  MarginLeft,
  MarginTop,MarginBottom: Integer; // Margins' from printable area
  Y: Integer; // Y-Position in Pixel
  VR: Integer; // Vertical resolution in Pixel
begin
 // showmessage(inttostr(printer.XDPI));

  with Printer do begin
    Title:='Documento DOSPrint';
    Orientation:=poLandscape;
    Canvas.Font.PixelsPerInch := XDPI;
    Canvas.Font.Name := 'Courier New';
    Canvas.Font.Size := 10;

    MarginLeft := 0;
    MarginTop  := 0;
    MarginBottom := 0;


    //VR := PageHeight;
    VR := PageHeight;
    BeginDoc;
    try
       Line := 0;
       for I := 0 to Lines.Count - 1 do begin
          H := Canvas.TextHeight(Lines[I]);
          if ((MarginTop + (Line * H)) >= (VR - MarginTop)) then begin
             NewPage;
             Line := 0;
          end;
          Inc(Line);
          Y := MarginTop + (Line * H);
          Canvas.TextOut(PaperSize.PaperRect.WorkRect.Left+MarginLeft, PaperSize.PaperRect.WorkRect.Top+Y, AnsiToUTF8(Lines[I]));
          Application.ProcessMessages; // for Printer.Abort();
       end;
    finally
       EndDoc;
    end;
  end;
end;


procedure TForm1.PrintFile(fcontent: tstringlist; confname: string);
var LineHeight,VerticalMargin,YPos: word;
    flines,ftotlines: longint;
    pfont:tfont;
begin
  pfont:=tfont.Create;
  pfont.Name:='Courier New';
  pfont.Size:=10;

  try
    Printer.SetPrinter('Bullzip PDF Printer');



 (*
  PrintStrings('FAST DOSPrint - Test',
                       fcontent,
                       cMILTOINCH*0,        //marginleft
                       cMILTOINCH*0,       //marginright
                       cMILTOINCH*0,         //margintop
                       cMILTOINCH*0,      //marginbottom
                       printer.Orientation,                  //orientation
                       6,                                           //linesperinch
                       0,                 //linesperpage
                       pfont,                                    //font
                       false,                                       //measureonly
                       nil,nil);
*)
(*
    Printer.BeginDoc;


    Printer.Canvas.Font.Name := 'Courier New';
    Printer.Canvas.Font.Size := 10;
    Printer.Canvas.Font.Color := clBlack;
    //LineHeight := Round(1.2 * Abs(Canvas.TextHeight('I')));

    //VerticalMargin := 4 * LineHeight;
    // There we go
    //YPos := VerticalMargin;
    //SuccessString := HEADLINE + DateTimeToStr(Now);
    //Printer.Canvas.TextOut(50, YPos, confname);
    YPos:=0;
    ftotlines:=fcontent.Count;
    for flines:=0 to ftotlines-1 do begin
        Printer.Canvas.TextOut(0, YPos, fcontent[flines]);
        LineHeight := Canvas.TextHeight(fcontent[flines]);
        YPos:=YPos+LineHeight;
    end;
*)


  finally
    Printer.EndDoc;
  end;
end;

procedure TForm1.LoadProp(Sender: TObject);
begin
     if fileexists(filenameprop) then begin
        XMLPropStorage.FileName:=filenameprop;
        xmlpropstorage.Restore;
        checkbox1.Checked:=xmlpropstorage.ReadBoolean('STATUS',false);
        trackbar1.Position:=xmlpropstorage.ReadInteger('PRIORITY',0);
        labelfont.Font.Name:=xmlpropstorage.ReadString('FONTNAME','Courier New');
        labelfont.Font.Size:=xmlpropstorage.ReadInteger('FONTSIZE',10);
        labelfont.Caption:=labelfont.Font.Name+', '+inttostr(labelfont.Font.Size);
        fontdialog1.Font.Name:=labelfont.Font.Name;
        fontdialog1.Font.Size:=labelfont.Font.Size;
        if lowercase(xmlpropstorage.ReadString('PAGETYPE','Vertical'))='vertical' then pageorient.ItemIndex:=0 else pageorient.ItemIndex:=1;
        spinedit1.Value:=xmlpropstorage.ReadInteger('PAGEMAXLINES',0);
        floatspinedit1.Value:=xmlpropstorage.ReadInteger('PAGEMARGINLEFT',0);
        floatspinedit2.Value:=xmlpropstorage.ReadInteger('PAGEMARGINRIGHT',0);
        floatspinedit3.Value:=xmlpropstorage.ReadInteger('PAGEMARGINTOP',0);
        floatspinedit4.Value:=xmlpropstorage.ReadInteger('PAGEMARGINBOTTOM',0);
        floatspinedit5.Value:=xmlpropstorage.ReadInteger('PAGEROWOFFSET',0);
        directoryedit1.Directory:=xmlpropstorage.ReadString('LOADFILESFROM','');
        edit1.Text:=xmlpropstorage.ReadString('FILESEXT','');
        spinedit2.Value:=xmlpropstorage.ReadInteger('CHECKFILESINTERVAL',500);
        lstampanti.Text:=xmlpropstorage.ReadString('REDIRTOPRINTER','');
     end;
end;

procedure TForm1.SaveProp(Sender: TObject);
begin
        if modincorso = true then begin
        modincorso:=false;
        XMLPropStorage.FileName:=filenameprop;
//        showmessage(filenameprop);
        xmlpropstorage.WriteBoolean('STATUS',checkbox1.Checked);
        xmlpropstorage.WriteInteger('PRIORITY',trackbar1.Position);
        xmlpropstorage.WriteString('FONTNAME',labelfont.Font.Name);
        xmlpropstorage.WriteInteger('FONTSIZE',labelfont.Font.Size);
        if fsBold in labelfont.Font.Style then
        xmlpropstorage.WriteInteger('FONTBOLD',1) else
        xmlpropstorage.WriteInteger('FONTBOLD',0);
        if pageorient.ItemIndex=0 then xmlpropstorage.WriteString('PAGETYPE','Vertical') else xmlpropstorage.WriteString('PAGETYPE','Horizontal');
        xmlpropstorage.WriteString('PAGEMAXLINES',inttostr(spinedit1.Value));
        xmlpropstorage.WriteString('PAGEMARGINLEFT',floattostr(floatspinedit1.Value));
        xmlpropstorage.WriteString('PAGEMARGINRIGHT',floattostr(floatspinedit2.Value));
        xmlpropstorage.WriteString('PAGEMARGINTOP',floattostr(floatspinedit3.Value));
        xmlpropstorage.WriteString('PAGEMARGINBOTTOM',floattostr(floatspinedit4.Value));
        xmlpropstorage.WriteString('PAGEROWOFFSET',floattostr(floatspinedit5.Value));
        xmlpropstorage.WriteString('LOADFILESFROM',directoryedit1.Directory);
        xmlpropstorage.WriteString('FILESEXT',edit1.Text);
        xmlpropstorage.WriteString('CHECKFILESINTERVAL',inttostr(spinedit2.Value));
        xmlpropstorage.WriteString('REDIRTOPRINTER',lstampanti.Text);
      //  xmlpropstorage.Save;

        if checkbox1.Checked then listview1.Items[listview1.ItemIndex].ImageIndex:=0 else listview1.Items[listview1.ItemIndex].ImageIndex:=1;



        end;
end;

procedure TForm1.Button1Click(Sender: TObject);
const
  LEFTMARGIN = 100;
  HEADLINE = 'DOSPrint 2 - Pagina di test stampata il ';
var
  YPos, LineHeight, VerticalMargin: Integer;
  SuccessString: String;
begin
  //printersetupdialog1.Execute;
  //   pagesetupdialog1.Execute;
  //  showmessage(inttostr(pagesetupdialog1.Margins.Left));

  //  exit;
//    printer.Canvas.;

  with Printer do
  try

    Title:='DOSPrint2';
    BeginDoc;

    Canvas.Font.Name := 'Courier New';
    Canvas.Font.Size := 10;
    Canvas.Font.Color := clBlack;
    LineHeight := Round(1.2 * Abs(Canvas.TextHeight('I')));
    VerticalMargin := 4 * LineHeight;
    // There we go
    YPos := VerticalMargin;
    SuccessString := HEADLINE + DateTimeToStr(Now);
    Canvas.TextOut(LEFTMARGIN, YPos, SuccessString);
  finally
    EndDoc;
  end;

end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  groupboxmain.Enabled:=false;
  groupboxlist.Enabled:=true;
  modincorso:=false;
end;

procedure TForm1.AUTOSTARTRadioGroupChangeBounds(Sender: TObject);
var reg: tregistry;
begin
  reg:=tregistry.Create;
  if AUTOSTARTRadioGroup.ItemIndex=0 then BEGIN
       XMLPropStorageApp.WriteBoolean('AUTOSTARTFORALL',true);
       XMLPropStorageApp.WriteBoolean('AUTOSTARTFORME',false);
       Reg.RootKey:=HKEY_LOCAL_MACHINE;
       try
       if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true) then
       if CheckBox2.Checked then Reg.WriteString('FASTDOSPrint',Application.ExeName) else Reg.WriteString('FASTDOSPrint','');
       finally
          Reg.CloseKey;
          reg.Free;
       end;
  end;
  if AUTOSTARTRadioGroup.ItemIndex=1 then BEGIN
       XMLPropStorageApp.WriteBoolean('AUTOSTARTFORALL',false);
       XMLPropStorageApp.WriteBoolean('AUTOSTARTFORME',true);
       Reg.RootKey:=HKEY_CURRENT_USER;
       try
       if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true) then
       if CheckBox2.Checked then Reg.WriteString('FASTDOSPrint',Application.ExeName) else Reg.WriteString('FASTDOSPrint','');
       finally
          Reg.CloseKey;
          reg.Free;
       end;
  end;



end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if fontdialog1.Execute then begin
       labelfont.Font.Name:=fontdialog1.Font.Name;
       labelfont.Font.Size:=fontdialog1.Font.Size;
       labelfont.Font.Style:=fontdialog1.Font.Style;
       labelfont.Caption:=fontdialog1.Font.Name+', '+inttostr(fontdialog1.Font.Size);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   lstampanti.Items.Assign(Printer.Printers);

   trayicon1.ShowBalloonHint;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  //form_progress.Show;
  XMLPropStorageApp.Save;
end;

procedure TForm1.Button5Click(Sender: TObject);
var newitem: tlistitem;
    userstring: string;

begin
  if InputQuery('Nuovo processo', 'Nome da assegnare al processo', false, UserString)
  then begin
 {$IFDEF UNIX}
  filenameprop:='./config/'+lowercase(userstring)+'.xml';
 {$ENDIF}
 {$IFDEF WIN32}
  filenameprop:='.\config\'+lowercase(userstring)+'.xml';
 {$ENDIF}

  end;

  if fileexists(filenameprop) then showmessage('Processo già presente!') else
  begin
  XMLPropStorage.FileName:=filenameprop;
  xmlpropstorage.StoredValues:=xmlpropstorage_default.StoredValues;
  XMLPropStorage.Save;
  newitem:=Tlistitem.Create(ListView1.Items);
  newitem.Caption:=lowercase(userstring);
  newitem.ImageIndex:=0;
  listview1.Items.AddItem(newitem);
        labelfont.Font.Name:=xmlpropstorage.ReadString('FONTNAME','Courier New');
        labelfont.Font.Size:=xmlpropstorage.ReadInteger('FONTSIZE',10);
        labelfont.Caption:=labelfont.Font.Name+', '+inttostr(labelfont.Font.Size);
        fontdialog1.Font.Name:=labelfont.Font.Name;
        fontdialog1.Font.Size:=labelfont.Font.Size;
  end;
//  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if MessageDlg('Elimina processo', 'Vuoi eliminare '+filenameprop+' ?', mtConfirmation,
   [mbYes, mbNo],0) = mrYes
  then begin
      // showmessage('eliminato');
       if listview1.ItemIndex <= listview1.Items.Count-1 then begin
            if deletefile(filenameprop) then listview1.Items[listview1.ItemIndex].Delete;
            filelistbox1.UpdateFileList;
       end;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  timer1.Enabled:=true;
  button7.Enabled:=false;
  button8.Enabled:=true;
  if checkbox4.Checked = false then begin
    trayicon1.BalloonHint:='Processi avviati...';
      trayicon1.ShowBalloonHint;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
    timer1.Enabled:=false;
    button7.Enabled:=true;
    button8.Enabled:=false;
    if checkbox4.Checked = false then begin
       trayicon1.BalloonHint:='Processi fermati...';
       trayicon1.ShowBalloonHint;
    end;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  //CheckBox1Change(Sender);
  groupboxmain.Enabled:=false;
  groupboxlist.Enabled:=true;
  SaveProp(sender);
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
   //showmessage('modificato '+filenameprop);
  // modincorso:=true;
  // SaveProp(sender);
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
 var reg: tregistry;
begin

   XMLPropStorageApp.WriteBoolean('AUTOSTART',checkbox2.Checked);
  reg:=tregistry.Create;

  Reg.RootKey:=HKEY_LOCAL_MACHINE;
    try
      if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true) then
      if CheckBox2.Checked then Reg.WriteString('FASTDOSPrint',Application.ExeName) else Reg.WriteString('FASTDOSPrint','');
    finally
      Reg.CloseKey;
      reg.Free;
    end;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
    XMLPropStorageApp.WriteBoolean('AUTOSTARTPROCESS',checkbox3.Checked);
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  XMLPropStorageApp.WriteBoolean('TRAYPOPUP',checkbox4.Checked);
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
 var reg: tregistry;
begin

   XMLPropStorageApp.WriteBoolean('AUTOSTART',checkbox2.Checked);
  reg:=tregistry.Create;

  Reg.RootKey:=HKEY_CURRENT_USER;
    try
      if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true) then
      if CheckBox2.Checked then Reg.WriteString('FASTDOSPrint',Application.ExeName) else Reg.WriteString('FASTDOSPrint','');
    finally
      Reg.CloseKey;
      reg.Free;
    end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  canclose:=false;
  hide;
  trayicon1.Visible:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
var k:word;
    newitem:tlistitem;

begin


    lstampanti.Items.Assign(Printer.Printers);
    if filelistbox1.Items.Count > 0 then begin
         (*
         setlength(Timers,filelistbox1.Items.Count);
         setlength(ChkFiles,filelistbox1.Items.Count);
         *)
         setlength(proclist,filelistbox1.Items.Count,4);
    for k:=0 to filelistbox1.Items.Count-1 do begin
         newitem:=Tlistitem.Create(ListView1.Items);
         newitem.Caption:=copy(lowercase(filelistbox1.Items[k]),0,length(filelistbox1.Items[k])-4);
         {$IFDEF UNIX}
         xmlpropstorage.FileName:='./config/'+filelistbox1.Items[k];
         {$ENDIF}
         {$IFDEF WIN32}
         xmlpropstorage.FileName:='.\config\'+filelistbox1.Items[k];
         {$ENDIF}

         //showmessage(filelistbox1.Items[k]);
         if xmlpropstorage.ReadBoolean('STATUS',false)=true then newitem.ImageIndex:=0 else newitem.ImageIndex:=1;
         listview1.Items.AddItem(newitem);
         proclist[k][0]:=xmlpropstorage.ReadString('PRIORITY','0');
         proclist[k][1]:=filelistbox1.Items[k];
         proclist[k][2]:=xmlpropstorage.ReadString('LOADFILESFROM','');
         proclist[k][3]:=xmlpropstorage.ReadString('REDIRTOPRINTER','');
         (*
         Timers[k]:=TTimer.Create(nil);
         Timers[k].Name:=newitem.Caption;     //'T'+inttostr(k);
         Timers[k].Interval:=4000;
         Timers[k].OnTimer:=@OnTimer;
         Timers[k].Tag:=k;
         Timers[k].Enabled:=true;

         ChkFiles[k]:=TFileListBox.Create(nil);
         ChkFiles[k].Name:='Chk'+inttostr(k);
         *)
    end;
       listview1.Items[0].Selected:=true;
       ListView1Click(sender);
    end;

    XMLPropStorageApp.Restore;
     checkbox2.Checked:=XMLPropStorageApp.ReadBoolean('AUTOSTART',false);
     checkbox3.Checked:=XMLPropStorageApp.ReadBoolean('AUTOSTARTPROCESS',false);
     checkbox4.Checked:=XMLPropStorageApp.ReadBoolean('TRAYPOPUP',false);
     spinedit2.value:=XMLPropStorageApp.ReadInteger('CHKPROCESSINTERVAL',1000);
     timer1.Interval:=spinedit2.value;
    if checkbox3.Checked = true then  Button7Click(Sender); // avvia i processi se abilitato

end;

procedure TForm1.GroupBox2Click(Sender: TObject);
begin

end;

procedure Tform1.OnTimer(Sender: TObject);
begin
   TTimer(Sender).Enabled:=false;
//   memo1.Lines.Add(timetostr(time)+' - '+inttostr(TTimer(Sender).Tag)+' - '+TTimer(Sender).Name);

   TTimer(Sender).Enabled:=true;
end;

procedure TForm1.ListView1Click(Sender: TObject);
var clickitem:word;
begin
  clickitem:=listview1.ItemIndex;
  if clickitem <= listview1.Items.Count-1 then begin
       //PANEL1.Caption:='Impostazioni processo: '+listview1.Items[clickitem].Caption;
       groupboxmain.Caption:='Processo: '+listview1.Items[clickitem].Caption;
       {$IFDEF UNIX}
            filenameprop:='./config/'+lowercase(listview1.Items[clickitem].Caption)+'.xml';
       {$ENDIF}
       {$IFDEF WIN32}
            filenameprop:='.\config\'+lowercase(listview1.Items[clickitem].Caption)+'.xml';
       {$ENDIF}


       LoadProp(sender);

  end;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
begin
  modincorso:=true;
  ListView1Click(sender);
  groupboxmain.Enabled:=true;
  groupboxlist.Enabled:=false;
end;

procedure TForm1.LSImageAnimator1Animation(ASender: TObject;
  var AImageIndex: TImageIndex);
begin
    imagelistload.GetBitmap(AImageIndex, form_progress.Image1.Picture.Bitmap);
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
     form1.Caption:='DOSPrint - Configura processi DOSPrint';
     form1.TabGen.Tabvisible:=true;
     form1.TabPref.Tabvisible:=false;
     form1.Show;
     //trayicon1.Visible:=false;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  button8click(sender);

  if checkbox4.Checked = false then begin
    sleep(2000);
    trayicon1.BalloonHint:='Chiusura DOSPrint...';
    trayicon1.ShowBalloonHint;
    sleep(2000);
  end;
  application.Terminate;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
     form1.Caption:='DOSPrint - Preferenze';
     form1.TabGen.tabvisible:=false;
     form1.TabPref.tabvisible:=true;
     form1.Show;
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  XMLPropStorageApp.Writeinteger('CHKPROCESSINTERVAL',spinedit2.Value);
  button8click(sender);
  sleep(2000);
  button7click(sender);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var k:word;
    filecontent: tstringlist;
begin
  timer1.Enabled:=false;
  K:=0;
  for k:=0 to filelistbox1.Items.Count-1 do begin
     {$IFDEF UNIX}
         xmlpropstorage.FileName:='./config/'+filelistbox1.Items[k];
     {$ENDIF}
     {$IFDEF WIN32}
         xmlpropstorage.FileName:='.\config\'+filelistbox1.Items[k];
     {$ENDIF}

     //showmessage(filelistbox1.Items[k]);
         if xmlpropstorage.ReadInteger('STATUS',0)=1 then begin

            filelistboxproc.Directory:=xmlpropstorage.ReadString('LOADFILESFROM','');
            filelistboxproc.Mask:=xmlpropstorage.ReadString('FILESEXT','*.txt');
            filelistboxproc.UpdateFileList;
            if filelistboxproc.Items.Count>0 then begin
                // carica file e invia alla stampa
            if checkbox4.Checked = false then begin
               trayicon1.BalloonHint:='Esecuzione processo: <<'+filelistbox1.Items[k]+'>>'+#10+'Stampa in corso di <<'+filelistboxproc.Items[0]+'>> su <<'+xmlpropstorage.ReadString('REDIRTOPRINTER','Stampante non impostata')+'>>';
               trayicon1.ShowBalloonHint;
            end;
            if (fileexists(filelistboxproc.Directory+'/'+filelistboxproc.Items[0]))
            and (MillisecondsBetween(now,FileDateTodateTime(fileage(filelistboxproc.Directory+'/'+filelistboxproc.Items[0]))) > 3000)
            then begin

            //showmessage(datetimetostr(Datetimetofiledate(now)-FileDateTodateTime(fileage(filelistboxproc.Directory+'/'+filelistboxproc.Items[0]))));
            //showmessage(inttostr(MillisecondsBetween(now,FileDateTodateTime(fileage(filelistboxproc.Directory+'/'+filelistboxproc.Items[0])))));

               filecontent:=tstringlist.Create;
               filecontent.LoadFromFile(filelistboxproc.Directory+'/'+filelistboxproc.Items[0]);

               LSImageAnimator1.Active:=true;
               form_progress.Show;

               form_progress.Label1.Caption:='FAST DOSPrint sta elaborando '+filelistbox1.Items[k]+'...';
               form_progress.Labelmsg.Caption:='Apertura fonte di stampa';
               form_progress.Labelmsg1.Caption:=filelistboxproc.Directory+'/'+filelistboxproc.Items[0];
               //showmessage('Trovato file in '+filelistbox1.Items[k]);



               //  PrintFile(filecontent,xmlpropstorage.FileName);
              // Printer.SetPrinter('Bullzip PDF Printer');
               //PrintLines(filecontent);
             // PrintTStrings(filecontent);
               PrintLines1(filecontent,xmlpropstorage.FileName);
               filecontent.Free;
               while Printer.Printing do begin
                 form_progress.Labelmsg.Caption:='Stampa in corso...';
                 application.ProcessMessages;
               end;
               deletefile(filelistboxproc.Directory+'/'+filelistboxproc.Items[0]);
            end;
            form_progress.Hide;
            LSImageAnimator1.Active:=false;
            end;

         end;
  end;

  timer1.Enabled:=true;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var livello:string;
begin
  if (TrackBar1.Position >=0) and (TrackBar1.Position <=3) then livello:='Alta';
  if (TrackBar1.Position >=4) and (TrackBar1.Position <=6) then livello:='Media';
  if (TrackBar1.Position >=7) and (TrackBar1.Position <=9) then livello:='Bassa';
  labelpri.Caption:='Priorità '+livello;
  CheckBox1Change(sender);
end;

procedure TForm1.XMLPropStorage1SaveProperties(Sender: TObject);
begin

end;

end.
