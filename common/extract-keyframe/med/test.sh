# Written by Sang Phan - plsang@nii.ac.jp
# Last update May 22, 2013
#!/bin/sh
# Force to use shell sh. Note that #$ is SGE command
#$ -S /bin/sh
# Force to limit hosts running jobs
#$ -q all.q@@bc2hosts,all.q@@bc3hosts
# Log starting time

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <detector> <start_image> <end_image>" >&2
  exit 1
fi

count=0
outdir='/net/per900a/raid0/plsang/tools/featurespace/tmp'/$1.sift

if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

img_dir='/net/per610a/export/das11f/ledduy/trecvid-ins-2013/keyframe-5/tv2011/query'
tmp_dir='/tmp'

#instance_dir='/net/sfv215/export/raid4/ledduy/ndthanh/RecommendMe.ICCV/datasets/oxford/org/oxbuild_images_good'

#for f in `ls /net/sfv215/export/raid4/ledduy/ndthanh/RecommendMe.ICCV/datasets/mqa/org/allimg.rsz/*.jpg`
#note: error argument list is too long because of large number of files

# extract features for distractor image

for f in `find $img_dir -follow -type f -name "*.jpg"`
do 
	if [ "$count" -ge $2 ] && [ "$count" -lt $3 ]; then
		
		fp="${f%}" 		#get file path
		fn="${fp##*/}"	#get file name with extension
		img="${fn%.*}"	#get file name without extension (image id)
		pat="${fp#${img_dir}}"
		#echo 'pat is: ' $pat
		
                new_outdir=$outdir${pat%/*}
                tmp_outdir=$tmp_dir${pat%/*}
                
                if [ ! -d $new_outdir ]; then
                     mkdir -p $new_outdir
                fi
                
                if [ ! -d $tmp_outdir ]; then
                     mkdir -p $tmp_outdir
                fi                

                of=$new_outdir/$img.$1.sift
    
		if [ -f $of ]
		then
			echo "File $of already exist! skipped!"
			let count++;
			continue
		fi
                
                rsz_of=$tmp_outdir/$img.rsz.jpg
                echo [$count]" Resizing image $fn ..."
                ffmpeg -i $f -vf scale=320:-1 $rsz_of

		echo [$count]" Extracting image $fn ..."
		/net/per900a/raid0/plsang/tools/featurespace/compute_descriptors_64bit.ln -$1 -sift -i $rsz_of -o1 $of
                
		echo [$count]" Deleting resized image $rsz_of ..."
                rm $rsz_of
	fi
	let count++;		
done
