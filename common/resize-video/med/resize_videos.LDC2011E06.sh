export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

#python resize_videos.py LDC2011E06/events 1 & 
python resize_videos.py LDC2011E06/video/DEV 0 0 1000 &
python resize_videos.py LDC2011E06/video/DEV 0 1000 2000 &
python resize_videos.py LDC2011E06/video/DEV 0 2000 3000 &
python resize_videos.py LDC2011E06/video/DEV 0 3000 4000 &
python resize_videos.py LDC2011E06/video/DEV 0 4000 5000 &
wait
python resize_videos.py LDC2011E06/video/MED10 0 0 1000 &
python resize_videos.py LDC2011E06/video/MED10 0 1000 2000 &
python resize_videos.py LDC2011E06/video/MED10 0 2000 3000 &
python resize_videos.py LDC2011E06/video/MED10 0 3000 4000 &
wait
date






