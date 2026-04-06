@echo off

REM Rename A.swf -> A.zip
del SourceFlash.zip
copy SourceFlash.swc SourceFlash.zip

REM Extract A.zip into folder "A"
rmdir /s /q SourceFlash
powershell -command "Expand-Archive -Force SourceFlash.zip SourceFlash"

REM Rename extracted library.swf -> 2.png
rename SourceFlash\library.swf 2.png

echo Done!
pause