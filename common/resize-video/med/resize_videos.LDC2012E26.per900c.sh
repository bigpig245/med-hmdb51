export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos.py LDC2012E26 0 56000 60000 & 
python resize_videos.py LDC2012E26 0 60000 64000 & 
python resize_videos.py LDC2012E26 0 64000 68000 & 
python resize_videos.py LDC2012E26 0 68000 72000 & 
python resize_videos.py LDC2012E26 0 72000 76000 & 
python resize_videos.py LDC2012E26 0 76000 80000 & 
#python resize_videos.py LDC2012E26 0 80000 84000 & 
#python resize_videos.py LDC2012E26 0 84000 88000 & 
#python resize_videos.py LDC2012E26 0 88000 92000 & 
#python resize_videos.py LDC2012E26 0 92000 96000 & 
#python resize_videos.py LDC2012E26 0 96000 100000 & 
wait
date
