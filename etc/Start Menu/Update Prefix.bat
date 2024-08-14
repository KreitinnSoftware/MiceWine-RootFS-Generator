@echo off

wineboot -u

reg delete HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\ThemeManager -v DllName /f