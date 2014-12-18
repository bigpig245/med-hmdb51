# Written by Sang Phan - plsang@nii.ac.jp
#!/bin/sh

# found in /net/per610a/export/das11f/plsang/codes/youtube2text

export LD_LIBRARY_PATH=/net/dl380g7a/export/ddn11a3/satoh-lab/stylix/webstylix/local/lib:$LD_LIBRARY_PATH

ffmpeg_bin=/net/dl380g7a/export/ddn11a3/satoh-lab/stylix/webstylix/local/bin/ffmpeg

map_file="/net/per610a/export/das11f/plsang/youtube2text/data/youtube_mapping.txt"
input_dir="/net/per610a/export/das11f/plsang/dataset/YouTubeClips-Renamed"
output_dir="/net/per610a/export/das11f/plsang/dataset/YouTubeClips-WebM"
count=0
video_ext=avi

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <start_video> <end_end>" >&2
  exit 1
fi

for f in `find $input_dir -name "*.$video_ext"`
do 
	if [ "$count" -ge $1 ] && [ "$count" -lt $2 ]; then
		#echo $count
		fp="${f%}" 		#get file path
		fn="${fp##*/}"	#get file name with extension
		vid="${fn%.*}"	#get file name without extension (image id)
		#pat="${fp#${ldc_dir}}"	# not equal $1 for events kits dir, ie. E001/...
		
		of=$output_dir/$vid.webm
		if [ ! -f $of ]
		then
			echo [$count]" Converting video $vid ..."
			#ffmpeg -i $f -loglevel quiet -r $rate $od/$vid-%6d.jpg
			/net/dl380g7a/export/ddn11a3/satoh-lab/stylix/webstylix/local/bin/ffmpeg -i $f -loglevel quiet -acodec libvorbis -b:a 96k -ac 2 -vcodec libvpx -b:v 400k -f webm $output_dir/$vid.webm
		else
			echo " --- Video $vid already processed...";
		fi
	fi
	let count++;
	
done


# while read line; do 
#	splits into two string, delimiter is ' '
	# IFS=' ' read -ra ADDR <<< "$line"
#	ori_name="${ADDR[0]}"
#	new_name="${ADDR[1]}"
	# ori_name=$(echo "${ADDR[0]}" | tr -d '\r')
	# new_name=$(echo "${ADDR[1]}" | tr -d '\r')
	# echo "------ $count ------ Converting  video file $ori_name to $new_name ..."
	# cmd="$ffmpeg_bin -i $input_dir/$ori_name.avi -loglevel quiet -acodec libvorbis -b:a 96k -ac 2 -vcodec libvpx -b:v 400k -f webm $output_dir/$new_name.webm"
	# echo $cmd
	# eval "$cmd"
	# let count++; 
# done < $map_file
