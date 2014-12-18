export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos.py LDC2012E110/KindredPart1/video/Kindred 0 0 2000 &
python resize_videos.py LDC2012E110/KindredPart1/video/Kindred 0 2000 4000 &
python resize_videos.py LDC2012E110/KindredPart1/video/Kindred 0 4000 6000 &
python resize_videos.py LDC2012E110/KindredPart1/video/Kindred 0 6000 8000 &
python resize_videos.py LDC2012E110/KindredPart1/video/Kindred 0 8000 10000 &
python resize_videos.py LDC2012E110/KindredPart1/video/Kindred 0 10000 11000 &
wait
date






