export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos.py LDC2012E26 0 24000 28000 & 
python resize_videos.py LDC2012E26 0 28000 32000 & 
python resize_videos.py LDC2012E26 0 32000 36000 & 
python resize_videos.py LDC2012E26 0 36000 40000 & 
python resize_videos.py LDC2012E26 0 40000 44000 & 
python resize_videos.py LDC2012E26 0 44000 48000 & 
python resize_videos.py LDC2012E26 0 48000 52000 & 
python resize_videos.py LDC2012E26 0 52000 56000 & 
wait
date
