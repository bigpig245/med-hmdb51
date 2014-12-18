#export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos_vsd.py 0 1 &
python resize_videos_vsd.py 1 2 &
python resize_videos_vsd.py 2 3 &
python resize_videos_vsd.py 3 4 &
python resize_videos_vsd.py 4 5 &
python resize_videos_vsd.py 5 6 &
wait
python resize_videos_vsd.py 6 7 &
python resize_videos_vsd.py 7 8 &
python resize_videos_vsd.py 8 9 &
python resize_videos_vsd.py 9 10 &
python resize_videos_vsd.py 10 11 &
python resize_videos_vsd.py 11 12 &
python resize_videos_vsd.py 12 13 &
wait
python resize_videos_vsd.py 13 14 &
python resize_videos_vsd.py 14 15 &
python resize_videos_vsd.py 15 16 &
python resize_videos_vsd.py 16 17 &
python resize_videos_vsd.py 17 18 &
python resize_videos_vsd.py 18 19 &






