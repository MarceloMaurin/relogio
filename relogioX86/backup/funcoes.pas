unit funcoes;

{$mode objfpc}{$H+}


interface

uses
windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
StdCtrls, ExtCtrls, jwaWinBase, UTF8Process, uSMBIOS;



Function RetiraInfo(Value : string): string;
function BuscaChave( lista : TStringList; Ref: String; var posicao:integer): boolean;
function iif(condicao : boolean; verdade : variant; falso: variant):variant;
function GetTotalCpuUsagePct(): double;
function GetProcessorUsage : integer;
function GetCPUCount : integer;
function GetMemorySize : DWORD;

implementation

var LastTickCount     : cardinal = 0;
    LastProcessorTime : int64    = 0;
    FLastIdleTime: Int64;
    FLastKernelTime: Int64;
    FLastUserTime: Int64;

function GetCPUCount : integer;
begin
  result := GetSystemThreadCount;
end;

function GetMemorySize : DWORD;
Var
  SMBios : TSMBios;
  LPhysicalMemArr  : TPhysicalMemoryArrayInformation;
begin
 SMBios:=TSMBios.Create;
  try
      //WriteLn('Physical Memory Array Information');
      //WriteLn('--------------------------------');
      if SMBios.HasPhysicalMemoryArrayInfo then
      for LPhysicalMemArr in SMBios.PhysicalMemoryArrayInfo do
      begin
        //WriteLn('Location         '+LPhysicalMemArr.GetLocationStr);
        //WriteLn('Use              '+LPhysicalMemArr.GetUseStr);
        //WriteLn('Error Correction '+LPhysicalMemArr.GetErrorCorrectionStr);
        if LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.MaximumCapacity<>$80000000 then
        begin
            result := LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.MaximumCapacity div 1024;
            break;
        end
        //  WriteLn(Format('Maximum Capacity %d Kb',[LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.MaximumCapacity]))
        else
        begin
          //WriteLn(Format('Maximum Capacity %d bytes',[LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.ExtendedMaximumCapacity]));
          result :=LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.ExtendedMaximumCapacity div 1024;
          break;
        end;

        //WriteLn(Format('Memory devices   %d',[LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.NumberofMemoryDevices]));
        //WriteLn;
      end
      else
      //Writeln('No Physical Memory Array Info was found');
      result := 0;
  finally
   SMBios.Free;
  end;
end;

function iif(condicao : boolean; verdade : variant; falso: variant):variant;
begin
     if condicao then
     begin
          result := verdade;
     end
     else
     begin
       result := falso
     end;
end;

//Retira o bloco de informação
Function RetiraInfo(Value : string): string;
var
  posicao : integer;
  resultado : string;
begin
     resultado := '';
     posicao := pos(':',value);
     if(posicao >-1) then
     begin
          resultado := copy(value,posicao+1,length(value));
     end;
     result := resultado;
end;

function BuscaChave( lista : TStringList; Ref: String; var posicao:integer): boolean;
var
  contador : integer;
  maximo : integer;
  item : string;
  indo : integer;
  resultado : boolean;
begin
     maximo := lista.Count-1;
     resultado := false;
     for contador := 0 to maximo do
     begin
       item := lista.Strings[contador];
       indo := pos(Ref,item);
       if (indo > 0) then
       begin
            posicao := contador;
            resultado := true;
            break;
       end;
     end;
     result := resultado;
end;

function GetCPU(): double;
{$PUSH}
{$CODEALIGN LOCALMIN=8}
var
  IdleTimeRec: TFileTime;
  KernelTimeRec: TFileTime;
  UserTimeRec: TFileTime;
  IdleTime: Int64 absolute IdleTimeRec;
  KernelTime: Int64 absolute KernelTimeRec;
  UserTime: Int64 absolute UserTimeRec;
  IdleDiff: Int64;
  KernelDiff: Int64;
  UserDiff: Int64;
  SysTime: Int64;
{$POP}
begin
     if GetSystemTimes(@IdleTimeRec, @KernelTimeRec, @UserTimeRec) then
     begin
        IdleDiff := IdleTime - FLastIdleTime;
        KernelDiff := KernelTime - FLastKernelTime;
        UserDiff := UserTime - FLastUserTime;
        FLastIdleTime := IdleTime;
        FLastKernelTime := KernelTime;
        FLastUserTime := UserTime;
        SysTime := KernelDiff + UserDiff;
        result :=  (SysTime - IdleDiff)/SysTime * 100;

     end;
end;

//https://forum.lazarus.freepascal.org/index.php?topic=38839.0
function GetTotalCpuUsagePct(): double;
begin
  //Result := floattostr(GetProcessorUsage)+'%';
  Result :=  GetCPU();
  //Result :=   Format('%.2f', GetProcessorUsage) + '%';
   //  Result := Format('%.2f', [(SysTime - IdleDiff)/SysTime * 100]) + '%';
end;

function GetProcessorTime : int64;
type
  TPerfDataBlock = packed record
    signature              : array [0..3] of wchar;
    littleEndian           : cardinal;
    version                : cardinal;
    revision               : cardinal;
    totalByteLength        : cardinal;
    headerLength           : cardinal;
    numObjectTypes         : integer;
    defaultObject          : cardinal;
    systemTime             : TSystemTime;
    perfTime               : comp;
    perfFreq               : comp;
    perfTime100nSec        : comp;
    systemNameLength       : cardinal;
    systemnameOffset       : cardinal;
  end;
  TPerfObjectType = packed record
    totalByteLength        : cardinal;
    definitionLength       : cardinal;
    headerLength           : cardinal;
    objectNameTitleIndex   : cardinal;
    objectNameTitle        : PWideChar;
    objectHelpTitleIndex   : cardinal;
    objectHelpTitle        : PWideChar;
    detailLevel            : cardinal;
    numCounters            : integer;
    defaultCounter         : integer;
    numInstances           : integer;
    codePage               : cardinal;
    perfTime               : comp;
    perfFreq               : comp;
  end;
  TPerfCounterDefinition = packed record
    byteLength             : cardinal;
    counterNameTitleIndex  : cardinal;
    counterNameTitle       : PWideChar;
    counterHelpTitleIndex  : cardinal;
    counterHelpTitle       : PWideChar;
    defaultScale           : integer;
    defaultLevel           : cardinal;
    counterType            : cardinal;
    counterSize            : cardinal;
    counterOffset          : cardinal;
  end;
  TPerfInstanceDefinition = packed record
    byteLength             : cardinal;
    parentObjectTitleIndex : cardinal;
    parentObjectInstance   : cardinal;
    uniqueID               : integer;
    nameOffset             : cardinal;
    nameLength             : cardinal;
  end;
var  c1, c2, c3      : cardinal;
     i1, i2          : integer;
     perfDataBlock   : ^TPerfDataBlock;
     perfObjectType  : ^TPerfObjectType;
     perfCounterDef  : ^TPerfCounterDefinition;
     perfInstanceDef : ^TPerfInstanceDefinition;
begin
  result := 0;
  perfDataBlock := nil;
  try
    c1 := $10000;
    while true do begin
      ReallocMem(perfDataBlock, c1);
      c2 := c1;
      case RegQueryValueEx(HKEY_PERFORMANCE_DATA, '238', nil, @c3, pointer(perfDataBlock), @c2) of
        ERROR_MORE_DATA : c1 := c1 * 2;
        ERROR_SUCCESS   : break;
        else              exit;
      end;
    end;
    perfObjectType := pointer(cardinal(perfDataBlock) + perfDataBlock^.headerLength);
    for i1 := 0 to perfDataBlock^.numObjectTypes - 1 do begin
      if perfObjectType^.objectNameTitleIndex = 238 then begin   // 238 -> "Processor"
        perfCounterDef := pointer(cardinal(perfObjectType) + perfObjectType^.headerLength);
        for i2 := 0 to perfObjectType^.numCounters - 1 do begin
          if perfCounterDef^.counterNameTitleIndex = 6 then begin    // 6 -> "% Processor Time"
            perfInstanceDef := pointer(cardinal(perfObjectType) + perfObjectType^.definitionLength);
            result := PInt64(cardinal(perfInstanceDef) + perfInstanceDef^.byteLength + perfCounterDef^.counterOffset)^;
            break;
          end;
          inc(perfCounterDef);
        end;
        break;
      end;
      perfObjectType := pointer(cardinal(perfObjectType) + perfObjectType^.totalByteLength);
    end;
  finally FreeMem(perfDataBlock)end;
end;

function GetProcessorUsage : integer;
var tickCount     : cardinal;
    processorTime : int64;
begin
  result := 0;
  tickCount     := GetTickCount;
  processorTime := GetProcessorTime;
  if (LastTickCount <> 0) and (tickCount <> LastTickCount) then
    result := 100 - Round(((processorTime - LastProcessorTime) div 100) / (tickCount - LastTickCount));
  LastTickCount     := tickCount;
  LastProcessorTime := processorTime;
end;





end.

