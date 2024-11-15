@echo off

C:\\windows\\system32\\wineboot -u

reg delete HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\ThemeManager -v DllName /f