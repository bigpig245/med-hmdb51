#export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH
PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/bin:/net/per900a/raid0/plsang/usr.local/bin:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/bin:$PATH
LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH
export PATH
export LD_LIBRARY_PATH

python resize_videos_vsd.py devel2013 0 3 &
python resize_videos_vsd.py devel2013 3 6 &
python resize_videos_vsd.py devel2013 6 9 &
python resize_videos_vsd.py devel2013 9 12 &
python resize_videos_vsd.py devel2013 12 15 &
python resize_videos_vsd.py devel2013 15 18 &
wait
python resize_videos_vsd.py test2013 1 3 &
python resize_videos_vsd.py test2013 3 6 &
python resize_videos_vsd.py test2013 6 8 &
python resize_videos_vsd.py test2014 0 3 &
python resize_videos_vsd.py test2014 3 6 &
python resize_videos_vsd.py test2014 6 7 &
python resize_videos_vsd.py Clips 0 86 &
wait







