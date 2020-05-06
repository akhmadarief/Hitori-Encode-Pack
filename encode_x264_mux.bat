@echo off

set input=%~1
echo Input file: "%input%"
set /p audio="Audio file: "
set vid=%~n1
set zones=
set settings=--preset veryslow --deblock 0:0 --crf 16 --bframes 16 --subme 11 --qcomp 0.7 --aq-mode 3 --aq-strength 0.75 --psy-rd 0.80:0.00 --merange 32 --no-fast-pskip --no-dct-decimate --colorprim bt709 --transfer bt709 --colormatrix bt709 --output-depth 10 %zones%
echo Encoding settings: %settings%
echo.

echo Encoding %vid%.vpy...
vspipe -y "%input%" - | x264-r3000-33f9e14.exe %settings% --demuxer y4m --output "%vid%.264" -
echo.
echo Muxing...
"C:\Program Files\MKVToolNix\mkvmerge.exe" --output "done\%vid%.mkv" "%vid%.264" --language 0:jpn %audio%
echo.

@pause
