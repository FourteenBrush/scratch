@echo off

set COLLECTIONS="reader=dependencies/Classreader/src"
set FLAGS=-strict-style rem -vet-unused
set OUT_NAME=scratch

if "%1" == "debug" (
    rem debug build
    set EXTRA_FLAGS=-debug
) else if "%1" == "check" (
    odin check src -collection=%COLLECTIONS% %FLAGS%
) else if "%1" == "run" (
    shift
    shift
    rem set %OUT_NAME% to be args[0] for the program
    odin run src -collection=%COLLECTIONS% %FLAGS% %EXTRA_FLAGS% -- %OUT_NAME% %*
    exit
) else ( 
    rem release build
    set EXTRA_FLAGS=-o:speed
)

odin build src -out:%OUT_NAME%.exe -collection=%COLLECTIONS% %FLAGS% %EXTRA_FLAGS%
