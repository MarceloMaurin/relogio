; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Relogio2"
#define MyAppVersion "2.3.7"
#define MyAppPublisher "Maurinsoft"
#define MyAppURL "http://maurinsoft.com.br"
#define MyAppExeName "relogio2.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{13BF7150-5F37-492E-A224-FAD75B59C0A2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin 

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Mude seu binario p o caminho correto
Source: "D:\projetos\maurinsoft\relogio\relogioX86\relogio2.exe"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{commonstartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
;Name: "{userstartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon



[Run]
;Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,MyApp}"; Flags: runascurrentuser nowait postinstall skipifsilent
Filename: "{app}\{#MyAppExeName}"; Flags: runascurrentuser; Parameters: "-install -svcName ""{#MyAppExeName}"" -svcDesc ""MyApp"" -mainExe ""{#MyAppExeName}""  "

