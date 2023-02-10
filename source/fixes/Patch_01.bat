:: gyrOS Patch_01

@echo off

:: Elevation Error when opening .txt files using Notepad
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "LowRiskFileTypes" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "LowRiskFileTypes" /t REG_SZ /d ".zip;.rar;.nfo;.exe;.bat;.cmd;.reg;.msi;.htm;.html;.gif;.bmp;.jpg;.jpeg;.png;.tif;.tiff;.mp3;.wma;.wav;.ogg;.mid;.midi;.avi;.mpg;.mpeg;.mov;.wmv;.asf;.swf;.vob;.mp4;.flv;.f4v;.mkv;.m4v;.rm;.rmvb;.doc;.docx;.xls;.xlsx;.ppt;.pptx;.pdf;.vsd;.vsdx;.odt;.odp;.ods;.odg;.odc;.odb;.odf;.rtf" /f

:: Fix Folder View Settings not saving
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSaveSettings" /t REG_SZ /d "0" /f
reg add "HKLM\software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSaveSettings" /t REG_SZ /d "0" /f
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\All Folders\Shell" /v "FolderType" /t "REG_SZ" /d "NotSpecified" /f
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell" /v "BagMRU Size" /t "REG_DWORD" /d "2710" /f

echo Restart computer for changes to take effect.

pause >nul