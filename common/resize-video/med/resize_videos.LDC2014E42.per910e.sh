PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/bin:/net/per900a/raid0/plsang/usr.local/bin:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/bin:$PATH
LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib64:/net/per900a/raid0/plsang/software/ffmpeg-2.0/release-shared/lib:/net/per900a/raid0/plsang/software/gcc-4.8.1/release/lib:/net/per900a/raid0/plsang/software/boost_1_54_0/release/lib:/net/per900a/raid0/plsang/software/opencv-2.4.6.1/release/lib:/net/per900a/raid0/plsang/usr.local/lib:/net/per900a/raid0/plsang/software/openmpi-1.6.5/release-shared/lib:/usr/local/lib:$LD_LIBRARY_PATH
export PATH
export LD_LIBRARY_PATH


#python resize_videos.py LDC2014E42/NOVEL1/video 0 50000 55000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 55000 60000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 60000 65000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 65000 70000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 70000 75000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 75000 80000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 80000 85000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 850000 90000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 90000 950000 &
#python resize_videos.py LDC2014E42/NOVEL1/video 0 95000 100000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 87500 88000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 88000 88500 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 88500 89000 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 89000 89500 &
python resize_videos.py LDC2014E42/NOVEL1/video 0 89500 90000 &
wait
date
