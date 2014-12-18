# Written by Sang Phan - plsang@nii.ac.jp
# Last update May 22, 2013
#!/bin/sh
# Force to use shell sh. Note that #$ is SGE command
#$ -S /bin/sh
# Force to limit hosts running jobs
#$ -q all.q@@bc2hosts,all.q@@bc3hosts
# Log starting time

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <ldc pat> <start_video> <end_end>" >&2
  exit 1
fi

count=0
outdir='/net/per610a/export/das11f/plsang/trecvidmed13/keyframes'
if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

ldc_dir='/net/per610a/export/das11f/plsang/dataset/MED2013/LDCDIST-RSZ'
video_dir=$ldc_dir/$1

#for f in `ls /net/sfv215/export/raid4/ledduy/ndthanh/RecommendMe.ICCV/datasets/mqa/org/allimg.rsz/*.jpg`
#note: error argument list is too long because of large number of files

for f in `find $video_dir -name "*.mp4"`
do 
	if [ "$count" -ge $2 ] && [ "$count" -lt $3 ]; then
		#echo $count
		fp="${f%}" 		#get file path
		fn="${fp##*/}"	#get file name with extension
		vid="${fn%.*}"	#get file name without extension (image id)
		pat="${fp#${ldc_dir}}"	# not equal $1 for events kits dir, ie. E001/...
		
		od=$outdir${pat%/*}/$vid
		if [ ! -d $od ]
		then
			mkdir -p $od
			echo [$count]" Extracting keyframes for video $vid ..."
			ffmpeg -i $f -loglevel quiet -r 0.5 $od/$vid-%6d.jpg
		else
			echo " --- Video $vid already processed...";
		fi
	fi
	let count++;
	
done
