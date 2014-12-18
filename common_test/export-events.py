
import sys
import os
import commands
import os.path

orig_current_path = '/home/ntrang/project/dataset/hmdb51';

#if (len(sys.argv) < 3):
#	print sys.argv[0] + " <start video> <end video>";
#	exit();
#i = 1;

#traverse all subdirs in original path
for root,dirs,files in os.walk(orig_current_path):
	if len(dirs) == 0:
		break;

	# each folder is each event
	for subdir in dirs:
		#print subdir;
		orig_video_path = orig_current_path + '/' + subdir;
		f = open(orig_video_path + '.csv', 'w');
		
		#get all files in subfolders
		files = os.listdir(orig_video_path);

		# do write list file
		for file in files:
			f.writelines(file + '\n');
			continue
			

