# Written by Duy Le - ledduy@ieee.org
# Last update Jun 26, 2012
#!/bin/sh
# Force to use shell sh. Note that #$ is SGE command
#$ -S /bin/sh
# Force to limit hosts running jobs
#$ -q all.q@@bc3hosts,all.q@@bc4hosts
# Log starting time
date 
# for opencv shared lib
export LD_LIBRARY_PATH=/home/ntrang/software/ffmpeg-2.0/release-shared/lib:/home/ntrang/software/gcc-4.8.1/release/lib:/home/ntrang/software/boost_1_54_0/release/lib:/home/ntrang/usr/lib:/home/ntrang/software/opencv-2.4.6.1/release/lib:/home/ntrang/usr.local/lib:/usr/local/lib:/home/ntrang/usr.local/usrlib:$LD_LIBRARY_PATH
# Log info of the job to output file  *** CHANGED ***
echo [$HOSTNAME] [$JOB_ID] [matlab -nodisplay -r "densetraj_encode_sge( '$1', $2, $3)"]
# change to the code dir  --> NEW!!! *** CHANGED ***
cd /home/ntrang/codes/kaori-secode-med14.2
# Log info of current dir
pwd
# Command - -->  must use " (double quote) for $2 because it contains a string  --- *** CHANGED ***
# LD_PRELOAD="/home/ntrang/usr.local/lib/libstdc++.so.6" matlab -nodisplay -r "densetraj_encode_sge( '$1', '$2', '$3', $4, $5 )"
matlab -nodisplay -r "densetraj_encode_sge( '$1', $2, $3)"
# Log ending time
date

