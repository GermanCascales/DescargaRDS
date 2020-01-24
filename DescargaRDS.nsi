; DescargaRDS.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install example2.nsi into a directory that the user selects,

;--------------------------------

; The name of the installer
Name "DescargaRDS v1"

; The file to write
OutFile "DescargaRDSv1_installer.exe"

; The default installation directory
InstallDir $PROGRAMFILES\DescargaRDS

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\DescargaRDS" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin


BrandingText "© 2019, @GermanCascales"
;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "DescargaRDS v1 (obligatorio)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "dist\DescargaRDSv1.exe"
  SetOutPath $INSTDIR\lib
  File /nonfatal /a /r "dist\lib\" #note back slash at the end
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\DescargaRDS "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DescargaRDS" "DisplayName" "DescargaRDS v1"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DescargaRDS" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DescargaRDS" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DescargaRDS" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Menú Inicio"

  CreateDirectory "$SMPROGRAMS\DescargaRDS"
  CreateShortcut "$SMPROGRAMS\DescargaRDS\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortcut "$SMPROGRAMS\DescargaRDS\DescargaRDS.lnk" "$INSTDIR\DescargaRDSv1.exe" "" "$INSTDIR\DescargaRDSv1.exe" 0
  
SectionEnd

Section "Escritorio"

  CreateShortcut "$DESKTOP\DescargaRDS.lnk" "$INSTDIR\DescargaRDSv1.exe" "" "$INSTDIR\DescargaRDSv1.exe" 0

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DescargaRDS"
  DeleteRegKey HKLM SOFTWARE\DescargaRDS

  ; Remove files and uninstaller
  ; Delete $INSTDIR\DescargaRDSv1.exe
  ; Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\DescargaRDS\*.*"
  Delete "$DESKTOP\DescargaRDS.lnk"

  ; Remove directories used
  RMDir "$SMPROGRAMS\DescargaRDS"
  RMDir /r "$INSTDIR"

SectionEnd
