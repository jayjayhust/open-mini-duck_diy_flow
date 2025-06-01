@echo off
setlocal

set libFile=gjw-libraries-241129zip
set setupFilePath=%LocalAppData%\Temp

if exist %setupFilePath%\setup.log del /q %setupFilePath%\setup.log
if exist %setupFilePath%\setup_en.log del /q %setupFilePath%\setup_en.log
if exist %setupFilePath%\setup_modbus.log del /q %setupFilePath%\setup_modbus.log
if exist %setupFilePath%\setup_modbus_en.log del /q %setupFilePath%\setup_modbus_en.log
if exist %setupFilePath%\setup_pwm.log del /q %setupFilePath%\setup_pwm.log
if exist %setupFilePath%\setup_pwm_en.log del /q %setupFilePath%\setup_pwm_en.log

powershell -Command "cp setup.log %setupFilePath%\setup.log"
powershell -Command "cp setup_en.log %setupFilePath%\setup_en.log"
powershell -Command "cp setup_modbus.log %setupFilePath%\setup_modbus.log"
powershell -Command "cp setup_modbus_en.log %setupFilePath%\setup_modbus_en.log"

echo completed
pause