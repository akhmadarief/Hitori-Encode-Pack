Here's how the ffmpeg/libav dlls shipping with eac3to were compiled:

(1)
install TDM-GCC -> http://tdm-gcc.tdragon.net/
install MSYS    -> http://www.mingw.org/wiki/MSYS

(2)
create empty folder "c:\msys\home\ffmpeg"

(3)
git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg

(4)
apply patch "ac3dec.patch"

(5)
start msys
cd ../ffmpeg
configure --enable-shared --disable-static --enable-memalign-hack

(6)
make install

(7)
c:\msys\local\bin\avcodec-54.dll
c:\msys\local\bin\avutil-52.dll
