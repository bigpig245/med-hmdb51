export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH

./runme_extract_keyframes.sh LDC2014E42 0 4000 & 
./runme_extract_keyframes.sh LDC2014E42 4000 8000 & 
./runme_extract_keyframes.sh LDC2014E42 8000 12000 & 
./runme_extract_keyframes.sh LDC2014E42 12000 16000 & 
./runme_extract_keyframes.sh LDC2014E42 16000 20000 & 
./runme_extract_keyframes.sh LDC2014E42 20000 24000 & 
./runme_extract_keyframes.sh LDC2014E42 24000 28000 & 
./runme_extract_keyframes.sh LDC2014E42 28000 32000 & 
wait
./runme_extract_keyframes.sh LDC2014E42 32000 36000 & 
./runme_extract_keyframes.sh LDC2014E42 36000 40000 & 
./runme_extract_keyframes.sh LDC2014E42 40000 44000 & 
./runme_extract_keyframes.sh LDC2014E42 44000 48000 & 
./runme_extract_keyframes.sh LDC2014E42 48000 52000 & 
./runme_extract_keyframes.sh LDC2014E42 52000 56000 & 
./runme_extract_keyframes.sh LDC2014E42 56000 60000 & 
./runme_extract_keyframes.sh LDC2014E42 60000 64000 & 
wait
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
