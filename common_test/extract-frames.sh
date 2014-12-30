if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <ldc pat> <start_video> <end_end>" >&2
  exit 1
fi

count=0
outdir='/home/ntrang/project/output/keyframes'
if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

ldc_dir='/home/ntrang/project/dataset/hmdb51'
video_dir=$ldc_dir/$1


for f in `find $video_dir -name "*.avi"`
do 
	if [ "$count" -ge $2 ] && [ "$count" -lt $3 ]; then
		#echo $count
		fp="${f%}" 			#get file path
		fn="${fp##*/}"			#get file name with extension
		vid="${fn%.*}"			#get file name without extension (image id)
		pat="${fp#${ldc_dir}}"		# not equal $1 for events kits dir, ie. E001/...
		
		od=$outdir${pat%/*}/$vid 	#every extracted frames are saved in the same folder which is named by video file name
		echo $od
		if [ ! -d $od ] 		# if folder does not exist, extract frames
		then
			mkdir -p $od
			{
				echo [$count]" Extracting keyframes for video $vid ..."
				ffmpeg -i $f -loglevel error -r 0.5 $od/$vid-%6d.jpg
			} || {
				echo "Error in $vid..."
			}
		else 				# if folder exists, continue to the next video
			echo " --- Video $vid already processed..."
		fi
	fi
	let count++;
	
done
