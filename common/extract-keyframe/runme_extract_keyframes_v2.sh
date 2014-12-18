# Written by Sang Phan - plsang@nii.ac.jp
# Last update May 22, 2013
#!/bin/sh
# Force to use shell sh. Note that #$ is SGE command
#$ -S /bin/sh
# Force to limit hosts running jobs
#$ -q all.q@@bc2hosts,all.q@@bc3hosts
# Log starting time

if [ "$#" -ne 6 ]; then
  echo "Usage: $0 <input_dir> <output_dir> <video_ext> <rate> <start_video> <end_end>" >&2
  exit 1
fi

indir=$1
outdir=$2
video_ext=$3
rate=$4			# rate = 0.5: one keyframes every two seconds
count=0

if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

#for f in `ls /net/sfv215/export/raid4/ledduy/ndthanh/RecommendMe.ICCV/datasets/mqa/org/allimg.rsz/*.jpg`
#note: error argument list is too long because of large number of files

for f in `find $indir -name "*.$video_ext"`
do 
	if [ "$count" -ge $5 ] && [ "$count" -lt $6 ]; then
		#echo $count
		fp="${f%}" 		#get file path
		fn="${fp##*/}"	#get file name with extension
		vid="${fn%.*}"	#get file name without extension (image id)
		#pat="${fp#${ldc_dir}}"	# not equal $1 for events kits dir, ie. E001/...
		
		od=$outdir/$vid
		if [ ! -d $od ]
		then
			mkdir -p $od
			echo [$count]" Extracting keyframes for video $vid ..."
			ffmpeg -i $f -loglevel quiet -r $rate $od/$vid-%6d.jpg
		else
			echo " --- Video $vid already processed...";
		fi
	fi
	let count++;
	
done
