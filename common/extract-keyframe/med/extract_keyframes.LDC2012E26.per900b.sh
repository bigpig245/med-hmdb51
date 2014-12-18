export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH
./runme_extract_keyframes.sh LDC2012E26 24000 28000 & 
./runme_extract_keyframes.sh LDC2012E26 28000 32000 & 
./runme_extract_keyframes.sh LDC2012E26 32000 36000 & 
wait
./runme_extract_keyframes.sh LDC2012E26 36000 40000 & 
./runme_extract_keyframes.sh LDC2012E26 40000 44000 & 
./runme_extract_keyframes.sh LDC2012E26 44000 48000 & 
wait
date
