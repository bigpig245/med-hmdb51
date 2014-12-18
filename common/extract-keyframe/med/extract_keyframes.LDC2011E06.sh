export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

./runme_extract_keyframes.sh LDC2011E06/events 0 1000000 & 
./runme_extract_keyframes.sh LDC2011E06/video/DEV 0 1000 &
./runme_extract_keyframes.sh LDC2011E06/video/DEV 1000 2000 &
./runme_extract_keyframes.sh LDC2011E06/video/DEV 2000 3000 &
./runme_extract_keyframes.sh LDC2011E06/video/DEV 3000 4000 &
wait
./runme_extract_keyframes.sh LDC2011E06/video/DEV 4000 5000 &
./runme_extract_keyframes.sh LDC2011E06/video/MED10 0 1000 &
./runme_extract_keyframes.sh LDC2011E06/video/MED10 1000 2000 &
./runme_extract_keyframes.sh LDC2011E06/video/MED10 2000 3000 &
./runme_extract_keyframes.sh LDC2011E06/video/MED10 3000 4000 &
wait
date






