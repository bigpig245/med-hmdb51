export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos.py LDC2014E56/MED14AH/video 0 0 500 & 
python resize_videos.py LDC2014E56/MED14AH/video 0 500 1000 & 
python resize_videos.py LDC2014E56/MED14AH/video 0 1000 1500 & 
wait

date
