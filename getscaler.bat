@echo off
set /p nh="Enter native heigth: "
python "C:\Program Files\Python38\Lib\site-packages\getscaler.py" "%~1" -nh %nh%
@pause
