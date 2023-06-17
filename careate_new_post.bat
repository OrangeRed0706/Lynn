@echo off
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YYYY=%dt:~0,4%"
set "MM=%dt:~4,2%"
set "DD=%dt:~6,2%"
set formattedDate=%YYYY%-%MM%-%DD%
set /p title="please input title: "
hugo new post/%formattedDate%-%title%.md
