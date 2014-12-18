export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

python resize_videos.py LDC2011E41/MED11TrainingDataPart2/events 1 & 
python resize_videos.py LDC2011E41/MED11TrainingDataPart2/video/DEV 0 0 2000 &
python resize_videos.py LDC2011E41/MED11TrainingDataPart2/video/DEV 0 2000 4000 &
python resize_videos.py LDC2011E41/MED11TrainingDataPart2/video/DEV 0 4000 6000 &
python resize_videos.py LDC2011E41/MED11TrainingDataPart2/video/DEV 0 6000 8000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 0 4000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 4000 8000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 8000 12000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 12000 16000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 16000 20000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 20000 24000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 24000 28000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 28000 32000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 32000 36000 &
python resize_videos.py LDC2011E41/MED11EvaluationData/video/MED11TEST 0 36000 40000 &
wait
date






