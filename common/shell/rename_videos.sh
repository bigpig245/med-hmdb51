# Written by Sang Phan - plsang@nii.ac.jp
#!/bin/sh

# found in /net/per610a/export/das11f/plsang/codes/youtube2text

map_file="/net/per610a/export/das11f/plsang/youtube2text/data/youtube_mapping.txt"
#input_dir="/net/per610a/export/das11f/plsang/dataset/YouTubeClips-Resized"
#output_dir="/net/per610a/export/das11f/plsang/dataset/YouTubeClips-Renamed"
input_dir="/net/per610a/export/das11f/plsang/dataset/YouTubeClips"
output_dir="/net/per610a/export/das11f/plsang/youtube2text/videos_renamed"
count=1
while read line; do 
	#splits into two string, delimiter is ' '
	IFS=' ' read -ra ADDR <<< "$line"
	#ori_name="${ADDR[0]}"
	#new_name="${ADDR[1]}"
	ori_name=$(echo "${ADDR[0]}" | tr -d '\r')
	new_name=$(echo "${ADDR[1]}" | tr -d '\r')
	echo "------ $count ------ Renaming video file $ori_name to $new_name ..."
	cp "$input_dir/$ori_name.avi" "$output_dir/$new_name.avi"	
	#count=$((count+1))
	let count++; 
done < $map_file
