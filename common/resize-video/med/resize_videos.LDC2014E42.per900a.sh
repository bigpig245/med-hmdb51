export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos.py LDC2014E42/NOVEL1/video 0 0 5000 & 
python resize_videos.py LDC2014E42/NOVEL1/video 0 5000 10000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 10000 15000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 15000 20000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 20000 25000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 25000 30000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 30000 35000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 35000 40000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 40000 45000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 45000 50000 &
wait

date
