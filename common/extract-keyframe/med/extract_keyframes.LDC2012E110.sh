export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

./runme_extract_keyframes.sh LDC2012E110/KindredPart1/video/Kindred 0 2000 &
./runme_extract_keyframes.sh LDC2012E110/KindredPart1/video/Kindred 2000 4000 &
./runme_extract_keyframes.sh LDC2012E110/KindredPart1/video/Kindred 4000 6000 &
wait
./runme_extract_keyframes.sh LDC2012E110/KindredPart1/video/Kindred 6000 8000 &
./runme_extract_keyframes.sh LDC2012E110/KindredPart1/video/Kindred 8000 10000 &
./runme_extract_keyframes.sh LDC2012E110/KindredPart1/video/Kindred 10000 11000 &
wait
date






