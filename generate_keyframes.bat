@echo off
echo Making SCXvid keyframes...
set input="%~1"
set output="%~n1"
ffmpeg -i %input% -f yuv4mpegpipe -vf scale=640:360 -pix_fmt yuv420p -vsync drop - | scxvid.exe %output%_keyframes.txt
echo Keyframes complete
@pause
