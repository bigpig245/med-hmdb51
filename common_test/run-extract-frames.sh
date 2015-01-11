ldc_dir='/home/ntrang/project/dataset/hmdb51'

# traverse all folders in local directory
find $ldc_dir -mindepth 1 -maxdepth 1 -type d | while read -r dir
do
	# get current dir
	cur_dir=$(basename $dir)
	#
	echo 'Processing ' $cur_dir
	./extract-frames.sh $cur_dir 0 200
done
