export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

./runme_extract_keyframes.sh LDC2012E26 52000 56000 & 
./runme_extract_keyframes.sh LDC2012E26 56000 60000 & 
./runme_extract_keyframes.sh LDC2012E26 60000 64000 & 
wait
./runme_extract_keyframes.sh LDC2012E26 64000 68000 & 
./runme_extract_keyframes.sh LDC2012E26 68000 72000 & 
./runme_extract_keyframes.sh LDC2012E26 72000 76000 & 
wait
./runme_extract_keyframes.sh LDC2012E26 76000 80000 & 
./runme_extract_keyframes.sh LDC2012E26 80000 84000 & 
./runme_extract_keyframes.sh LDC2012E26 84000 88000 & 
wait
./runme_extract_keyframes.sh LDC2012E26 88000 92000 & 
./runme_extract_keyframes.sh LDC2012E26 92000 96000 & 
./runme_extract_keyframes.sh LDC2012E26 96000 100000 &
wait
date
