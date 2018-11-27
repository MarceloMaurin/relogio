unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, acs_audio, acs_misc, acs_mixer, SdpoSerial, lNetComponents,
  LedNumber, AdvLed, indGnouMeter, IndLed;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    AcsAudioOut1: TAcsAudioOut;
    AcsMemoryIn1: TAcsMemoryIn;
    AdvAlarme: TAdvLed;
    clock: TTimer;
    hora: TLEDNumber;
    data: TLEDNumber;
    ativaalarme: TindLed;
    lbHora3: TLabel;
    lbHora4: TLabel;
    lbAlarme: TLabel;
    LTCPComponent1: TLTCPComponent;
    SdpoSerial1: TSdpoSerial;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    temp: TLEDNumber;
    humi: TLEDNumber;
    indHum: TindGnouMeter;
    lbHora: TLabel;
    lbHora1: TLabel;
    lbHora2: TLabel;
    lbTemp: TLabel;
    lbTemp1: TLabel;
    lbTemp2: TLabel;
    lbTemp3: TLabel;
    TrayIcon1: TTrayIcon;
    procedure AcsMemoryIn1BufferDone(Sender: TComponent);
    procedure clockTimer(Sender: TObject);
    procedure dataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ativaalarmeClick(Sender: TObject);
    procedure lbHoraClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Ativalarme();
    procedure SpeedButton3Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    function Temperatura(): double;
    function Humidade(): double;
  public
    defaulttemp : double;
    defaulthumid : double;
    horaalarme: TTime;
    diasemana: array[0..6] of byte;
    increse : double;
    alarme : boolean;
    const versao = '0.3';
    procedure Soneca();
    procedure TocaAlarme();


  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}
uses alarme, config;

{ Tfrmmain }

function Tfrmmain.Temperatura(): double;
begin
     result := defaulttemp;

     defaulttemp := defaulttemp+increse;
end;

function Tfrmmain.Humidade(): double;
begin
     result := defaulthumid;
     defaulthumid := defaulthumid+(increse*2);
     if (defaulthumid>=100) then
     begin
          increse := -0.1;
     end;
     if (defaulthumid<=0) then
     begin
          increse := +0.1;
     end;

end;

procedure Tfrmmain.Ativalarme();
begin
  AdvAlarme.Blink:=true;
  AdvAlarme.State:=lsOn;
end;

procedure Tfrmmain.Soneca();
begin
  AdvAlarme.State:=lsOff;
  horaalarme := now()+strtotime('00:10:00');

end;

procedure Tfrmmain.SpeedButton3Click(Sender: TObject);
begin
     Soneca();
end;

procedure Tfrmmain.TrayIcon1Click(Sender: TObject);
begin

end;

procedure Tfrmmain.TocaAlarme();
begin

end;

procedure Tfrmmain.clockTimer(Sender: TObject);
var
  tempera : double;
  horaatual : ttime;
  indice : integer;
begin
   hora.Caption:= timetostr(now);
   data.Caption:=datetostr(now);
   tempera := Temperatura();
   temp.Caption:= floattostr(Tempera);
   humi.Caption:= floattostr(Humidade());
   indHum.Value:= tempera;
   AdvAlarme.Blink:= alarme;
   lbAlarme.Caption:= timetostr(horaalarme);
   //Rotina de ativacao do alarme
   if  ativaalarme.LedValue then
   begin
      horaatual := now();
      if (timetostr(horaatual)=timetostr(horaalarme)) then
      begin
           indice := DayOfWeek(now)-1;
           if (diasemana[indice] = 1) then
           begin
                if AdvAlarme.Blink=false then
                begin
                    Ativalarme();

                end;

           end;
      end;
   end;
   //Verifica se há o alarme
   if  (AdvAlarme.State=lsOn) then
   begin
        TocaAlarme();
   end;
end;

procedure Tfrmmain.AcsMemoryIn1BufferDone(Sender: TComponent);
begin

end;

procedure Tfrmmain.dataClick(Sender: TObject);
begin

end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
    defaulttemp := 0;
    defaulthumid := 0;
    increse := +0.1;
    alarme := false;
end;

procedure Tfrmmain.ativaalarmeClick(Sender: TObject);
begin
  AcsAudioOut1.Run();
  AcsMemoryIn1.Init();

end;

procedure Tfrmmain.lbHoraClick(Sender: TObject);
begin

end;

procedure Tfrmmain.SpeedButton1Click(Sender: TObject);
begin
  frmconfig.showmodal;
end;

procedure Tfrmmain.SpeedButton2Click(Sender: TObject);
begin
  frmalarme.showmodal;
end;

end.

