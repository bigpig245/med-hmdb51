PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/bin:/net/per900a/raid0/plsang/usr.local/bin:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/bin:$PATH
LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH
export PATH
export LD_LIBRARY_PATH


python resize_videos.py LDC2014E42/NOVEL1/video 0 85000 85500 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 85500 86000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 86000 86500 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 86500 87000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 87000 87500 &
wait
date
