PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/bin:/net/per900a/raid0/plsang/usr.local/bin:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/bin:$PATH
LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH
export PATH
export LD_LIBRARY_PATH

./runme_extract_keyframes.sh LDC2014E42 0 4000 & 
./runme_extract_keyframes.sh LDC2014E42 4000 8000 & 
./runme_extract_keyframes.sh LDC2014E42 8000 12000 & 
./runme_extract_keyframes.sh LDC2014E42 12000 16000 & 
./runme_extract_keyframes.sh LDC2014E42 16000 20000 & 
./runme_extract_keyframes.sh LDC2014E42 20000 24000 & 
./runme_extract_keyframes.sh LDC2014E42 24000 28000 & 
./runme_extract_keyframes.sh LDC2014E42 28000 32000 & 
wait
date
