vspipe -y "%~1" - | x264-r3000-33f9e14.exe --demuxer y4m --preset veryslow --deblock -1:-1 --crf 16.5 --bframes 16 --subme 11 --qcomp 0.7 --aq-mode 3 --aq-strength 0.75 --psy-rd 0.82:0.00 --merange 32 --no-fast-pskip --no-dct-decimate --colorprim bt709 --transfer bt709 --colormatrix bt709 --output-depth 10 --output "%~n1.264" -

@pause
