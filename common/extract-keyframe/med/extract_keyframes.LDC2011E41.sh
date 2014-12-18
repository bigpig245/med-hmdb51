export PATH=/net/per900a/raid0/plsang/software/gcc-4.8.1/release/bin:/net/per900a/raid0/plsang/usr.local/bin:$PATH
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH

./runme_extract_keyframes.sh LDC2011E41/MED11TrainingDataPart2/events 0 1000000 & 
./runme_extract_keyframes.sh LDC2011E41/MED11TrainingDataPart2/video/DEV 0 2000 &
./runme_extract_keyframes.sh LDC2011E41/MED11TrainingDataPart2/video/DEV 2000 4000 &
./runme_extract_keyframes.sh LDC2011E41/MED11TrainingDataPart2/video/DEV 4000 6000 &
./runme_extract_keyframes.sh LDC2011E41/MED11TrainingDataPart2/video/DEV 6000 8000 &
wait
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 0 4000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 4000 8000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 8000 12000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 12000 16000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 16000 20000 &
wait
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 20000 24000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 24000 28000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 28000 32000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 32000 36000 &
./runme_extract_keyframes.sh LDC2011E41/MED11EvaluationData/video/MED11TEST 36000 40000 &
wait
date






