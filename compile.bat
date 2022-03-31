@REM Nome del gioco
set game=NotNot

@REM Creo uno zip con estensione .love (in cui comprendo i file lua e le cartelle assets e src)
7z a -tzip ..\Compiling\%game%.love *.lua assets src
@REM Compilo il gioco (serve scaricare la versione zippata di love in https://love2d.org/)
cd ..\Compiling
copy /b love.exe+%game%.love %game%.exe
@REM Creo una cartella in cui metto tutti i file necessari per il gioco
mkdir "..\Release %game%"
copy %game%.exe "..\Release %game%"
copy *.dll "..\Release %game%"
@REM Elimino i file che non mi servono più
del %game%.love
del %game%.exe
@REM Creo uno zip con il gioco
cd "..\Release %game%"
7z a -tzip %game%.zip *