PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/bin:/net/per900a/raid0/plsang/usr.local/bin:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/bin:$PATH
LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH
export PATH
export LD_LIBRARY_PATH


./runme_extract_keyframes.sh LDC2014E42 64000 68000 & 
./runme_extract_keyframes.sh LDC2014E42 68000 72000 & 
./runme_extract_keyframes.sh LDC2014E42 72000 76000 & 
./runme_extract_keyframes.sh LDC2014E42 76000 80000 & 
./runme_extract_keyframes.sh LDC2014E42 80000 84000 & 
./runme_extract_keyframes.sh LDC2014E42 84000 88000 & 
./runme_extract_keyframes.sh LDC2014E42 88000 92000 & 
./runme_extract_keyframes.sh LDC2014E42 92000 96000 & 
./runme_extract_keyframes.sh LDC2014E42 96000 100000 &
wait
date
