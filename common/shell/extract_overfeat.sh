# Written by Sang Phan - plsang@nii.ac.jp
# Last update Sep 29, 2014
#!/bin/sh
# Force to use shell sh. Note that #$ is SGE command
#$ -S /bin/sh
# Force to limit hosts running jobs
#$ -q all.q@@bc2hosts,all.q@@bc3hosts
# Log starting time

# found in /net/per610a/export/das11f/plsang/overfeat/overfeat/src

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <proj_name> <start_video> <end_video>" >&2
  exit 1
fi

root_dir=/net/per610a/export/das11f/plsang

proj_name=$1
count=0

kf_dir=$root_dir/$proj_name/keyframes

feat_dir=$root_dir/$proj_name/feature/keyframes_overfeat

if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

for kf_vid_dir in `find $kf_dir/* -type d`
do 
	if [ "$count" -ge $2 ] && [ "$count" -lt $3 ]; then
		vidfp="${kf_vid_dir%}" 		#get file path
		vid="${vidfp##*/}"	#get file name with extension
		
		echo [$count] "Extracting feature for video {$vid}..."
		
		od=$feat_dir/$vid
		if [ ! -d $od ]
		then
			mkdir -p $od
		fi
		
		echo $kf_vid_dir
		for f in `find $kf_vid_dir -type f -name "*.jpg"`
		do
			fp="${f%}" 		#get file path
			fn="${fp##*/}"	#get file name with extension
			kfid="${fn%.*}"	#get file name without extension (image id)
			
			of=$od/$kfid.overfeat.txt
			
			if [ ! -f $of ]
			then
				python overfeat -n 5 $f > $of
			fi
		done
	fi
	let count++;
	
done
