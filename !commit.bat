@echo off
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%b-%%a)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
echo Commiting %mydate%-%mytime%

git add *
git commit -m "%mydate%-%mytime%"
git push -u origin main
