export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH
./runme_extract_keyframes.sh LDC2012E26 0 4000 & 
./runme_extract_keyframes.sh LDC2012E26 4000 8000 & 
./runme_extract_keyframes.sh LDC2012E26 8000 12000 & 
wait
./runme_extract_keyframes.sh LDC2012E26 12000 16000 & 
./runme_extract_keyframes.sh LDC2012E26 16000 20000 & 
./runme_extract_keyframes.sh LDC2012E26 20000 24000 & 
wait
