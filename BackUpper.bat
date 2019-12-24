echo off

chcp 1251
cls

rem /*Настройки выгрузки и загрузки

set IBName=KA
set ServerName=server
set UserName=Админ
set Password=1
set Platform=1cv8.exe
set CopyName=KA_Copy

rem Конец настроек*/

rem /Рабочая часть
set CurDate=%date%
set ServerBase=%ServerName%\%IBName%
set CopyBase=%ServerName%\%CopyName%
set backupdate=%CurDate%
set DtName=%IBName%_%CurDate%.dt
set LogName=Log_%CurDate%.txt
set	RestoreToName=%CopyName%_%CurDate%.dt
set CurDir="%cd%"
set CurDir=%CurDir:"=%
set BlockProcesses=ЗавершитьРаботуПользователей
set UnblockProcesses=РазрешитьРаботуПользователей
set PermissionCode=кодразрешения
set YandexDiskAdress=C:\users\server\YandexDisk

chcp 866

cls

echo Deleting previous IB copy...
del "%cd%\%IBName%_??.??.20??.dt"

echo Closing and blocking processes on %IBName%...
%Platform% ENTERPRISE /S %ServerBase% /N %UserName% /P %Password% /DisableStartupMessages /C %BlockProcesses% /Execute Close1C.epf

echo Uploading %IBName%...
%Platform% config /S %ServerBase% /N %UserName% /P %Password% /DumpIB %DtName% /Out %LogName% /UC %PermissionCode%

echo Unblocking processes on %IBName%...
%Platform% ENTERPRISE /S %ServerBase% /N %UserName% /P %Password% /DisableStartupMessages /C %UnblockProcesses% /UC %PermissionCode%

echo Closing and blocking processes on %CopyName%...
%Platform% ENTERPRISE /S %CopyBase% /N %UserName% /P %Password% /DisableStartupMessages /C %BlockProcesses% /Execute Close1C.epf

echo Downloading into %CopyName%...
%Platform% config /S %CopyBase% /N %UserName% /P %Password% /RestoreIB %DtName% /Out %LogName% /UC %PermissionCode%

echo Unblocking processes on %CopyName%...
%Platform% ENTERPRISE /S %CopyBase% /N %UserName% /P %Password% /DisableStartupMessages /C %UnblockProcesses% /UC %PermissionCode%

echo Deleting previous IB copy from Yandex disk...
del "%YandexDiskAdress%\%IBName%_??.??.20??.dt"
YaDiskTrashEraser

echo Copying Dt file onto Yandex disk...
copy %DtName% %YandexDiskAdress%\%DtName%

echo Process complete

pause