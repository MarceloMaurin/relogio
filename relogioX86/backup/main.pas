unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, PopupNotifier,
  ComCtrls, Menus, ExtCtrls, StdCtrls, splash, clock, dmDados, SetupIoT,
  setmain, temp;


const Versao = '0.2B';


type
  { TfrmMenu }

  TfrmMenu = class(TForm)
    ckDevice: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MnRelogio: TMenuItem;
    mnMenu: TMenuItem;
    MenuItem3: TMenuItem;
    popTray: TPopupMenu;
    PopupNotifier1: TPopupNotifier;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    ToggleBox3: TToggleBox;
    ToggleBox4: TToggleBox;
    ToggleBox5: TToggleBox;
    TrayIcon1: TTrayIcon;
    procedure ComboBox5Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image6DblClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure mnMenuClick(Sender: TObject);
    procedure MnRelogioClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    Fsetmain :TSetMain;
    procedure SalvaContexto();
    procedure CarregaContexto();
  public

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.lfm}

{ TfrmMenu }

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  Fsetmain := TSetMain.create();
  frmSplash := TfrmSplash.create(self);
  frmSplash.show;
  Application.ProcessMessages;
  dmDados1 := TdmDados1.create(self);
  frmclock := Tfrmclock.create(self);
  frmSetupIoT := TFrmSetupIoT.Create(self);
  CarregaContexto();

  TrayIcon1.Visible := true;
  frmclock.show;
  application.ProcessMessages;

  sleep(4000);
  frmSplash.close;
  Application.ProcessMessages;
end;

procedure TfrmMenu.FormDestroy(Sender: TObject);
begin
  Fsetmain.posx := Left;
  Fsetmain.posy := top;
  Fsetmain.SalvaContexto();

  frmclock.Destroy();

  if Fsetmain <> nil then
    Fsetmain.free();
end;

procedure TfrmMenu.ComboBox5Change(Sender: TObject);
begin

end;

procedure TfrmMenu.FormHide(Sender: TObject);
begin
   mnMenu.Caption := 'Mostrar Menu';
end;

procedure TfrmMenu.FormShow(Sender: TObject);
begin
     mnMenu.Caption := 'Esconder Menu';
end;

procedure TfrmMenu.Image6Click(Sender: TObject);
begin


end;

procedure TfrmMenu.CarregaContexto();
begin
  //Fsetmain.CarregaContexto();
  frmSetupIoT.Fsetsiot.CarregaContexto();
  ckDevice.Checked := frmSetupIoT.Fsetsiot.device;
  Left:= Fsetmain.posx;
  top:= Fsetmain.posy;

end;

procedure TfrmMenu.SalvaContexto();
begin
  Fsetmain.device:= ckDevice.Checked;
  Fsetmain.SalvaContexto();
end;

procedure TfrmMenu.Image6DblClick(Sender: TObject);
begin
  SalvaContexto();
  ShowMessage('Information save!')
end;

procedure TfrmMenu.MenuItem3Click(Sender: TObject);
begin
  close;
end;

procedure TfrmMenu.mnMenuClick(Sender: TObject);
begin
  if self.Visible then
  begin
    hide;
  end
  else
  begin
    Show;
  end;

end;

procedure TfrmMenu.MnRelogioClick(Sender: TObject);
begin
    if frmclock.Visible then
  begin
    frmclock.hide;
  end
  else
  begin
    frmclock.Show;
  end;
end;

procedure TfrmMenu.Timer1Timer(Sender: TObject);
begin
  //Device leitor de temperatura
  if ckDevice.Checked then
  begin
    if (frmSetupIoT.Fsetsiot.TypeC = ) then (*Device Sensor de temperatura*)
    begin
        if frmtemp= nil then
        begin
          frmtemp := Tfrmtemp.create(self);
          frmtemp.Show;
        end;
    end;
    if (frmSetupIoT.Fsetsiot.TypeC = 1) then (*Device Relogio*)
    begin

    end;
  end
  else
  begin
    if frmtemp <> nil then
    begin
      frmtemp.Free;
      frmtemp := nil;
    end;
  end;
end;

procedure TfrmMenu.ToggleBox1Change(Sender: TObject);
begin
  if frmSetupIoT = Nil then
    frmSetupIoT := TfrmSetupIoT.create(self);
  //frmSetupIoT.Fsetsiot := Fsetsiot;
  frmSetupIoT.Showmodal();
  //frmSetupIoT.Fsetsiot.CarregaContexto();  (*Atualiza o contexto salvo*)
  frmSetupIoT.Fsetsiot.SalvaContexto();
  ckDevice.Checked := frmSetupIoT.Fsetsiot.device;
  ckDevice.Refresh;


end;

end.

