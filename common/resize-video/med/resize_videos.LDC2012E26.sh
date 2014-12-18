export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos.py LDC2012E26 0 0 4000 & 
python resize_videos.py LDC2012E26 0 4000 8000 & 
python resize_videos.py LDC2012E26 0 8000 12000 & 
python resize_videos.py LDC2012E26 0 12000 16000 & 
python resize_videos.py LDC2012E26 0 16000 20000 & 
python resize_videos.py LDC2012E26 0 20000 24000 & 
wait
date
