export LD_LIBRARY_PATH=/net/per900b/raid0/ledduy/usr.local/lib:/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos_events.py E006 &
python resize_videos_events.py E007 &
wait
python resize_videos_events.py E008 &
python resize_videos_events.py E009 &
python resize_videos_events.py E010 &
python resize_videos_events.py E011 &
wait
python resize_videos_events.py E012 &
python resize_videos_events.py E013 &
python resize_videos_events.py E014 &
python resize_videos_events.py E015 &
