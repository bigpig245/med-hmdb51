if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <ldc pat> <start_video> <end_end>" >&2
  exit 1
fi

#count=0
#outdir='/home/ntrang/projects/output/keyframes'
#if [ ! -d $outdir ]; then
#    mkdir -p $outdir
#fi

ldc_dir='/home/ntrang/project/dataset/hmdb51'
video_dir=$ldc_dir/$1
echo $video_dir;


#remove all special characters in file name
for f in `find $video_dir -name "*.avi"`
do 
	mv "$f" "$(sed 's/[^0-9A-Za-z_.]/_/g' <<< "$f")";	
done
