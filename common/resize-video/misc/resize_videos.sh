export LD_LIBRARY_PATH=/net/per900b/raid0/ledduy/usr.local/lib:/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos_m.py 0 1000 &
python resize_videos_m.py 1000 2000 &
python resize_videos_m.py 2000 3000 &
python resize_videos_m.py 3000 4000 &
python resize_videos_m.py 4000 5000 &
python resize_videos_m.py 5000 6000 &
python resize_videos_m.py 6000 7000 &
python resize_videos_m.py 7000 8000 &
python resize_videos_m.py 8000 9000 &
python resize_videos_m.py 9000 10000 &
