:: Fix elevation error when opening .txt files using Notepad

@echo off

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "LowRiskFileTypes" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "LowRiskFileTypes" /t REG_SZ /d ".zip;.rar;.nfo;.exe;.bat;.cmd;.reg;.msi;.htm;.html;.gif;.bmp;.jpg;.jpeg;.png;.tif;.tiff;.mp3;.wma;.wav;.ogg;.mid;.midi;.avi;.mpg;.mpeg;.mov;.wmv;.asf;.swf;.vob;.mp4;.flv;.f4v;.mkv;.m4v;.rm;.rmvb;.doc;.docx;.xls;.xlsx;.ppt;.pptx;.pdf;.vsd;.vsdx;.odt;.odp;.ods;.odg;.odc;.odb;.odf;.rtf" /f

echo Restart computer for changes to take effect.

pause >nul