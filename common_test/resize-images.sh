if [ "$#" -ne 2 ]; then
	echo "Usage <event><specific_file>"
	exit 1
fi

org_dir='/home/ntrang/projects/output/keyframes'
out_dir='/home/ntrang/projects/output/keyframes_resize'
video_dir=$org_dir/$1/$2
out_video_dir=$out_dir/$1/$2

for f in `find $video_dir -name "*.jpg"`
do
	fp="${f%}" 			#get file pathc
	fn="${fp##*/}"			#get file name with extension
	#vid="${fn%.*}"			#get file name without extension (image id)
	if [ ! -d $out_video_dir ]; then
		mkdir -p $out_video_dir
	fi
	echo "Processing" $f
	ffmpeg -i $f -loglevel quiet -qmax 1 -vf scale=320:240 -sws_flags lanczos $out_video_dir/$fn
done
