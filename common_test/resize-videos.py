
import sys
import os
import commands
import os.path

out_video_path = '/home/ntrang/project/dataset/hmdb51/';
orig_video_path = '/home/ntrang/project/dataset/hmdb51_format_filename/';

#if (len(sys.argv) < 3):
#	print sys.argv[0] + " <start video> <end video>";
#	exit();
#i = 1;

#traverse all subdirs in original path
for root,dirs,files in os.walk(orig_video_path):
	if len(dirs) == 0:
		break;
	for subdir in dirs:
		#print subdir;
		orig_current_path = orig_video_path + subdir;
		out_current_path = out_video_path + subdir;
		if not os.path.exists(out_current_path):
			os.system('mkdir -p '+out_current_path);
		#get all files in subfolders
		files = os.listdir(orig_current_path);
		#m = subdir + ' ' + str(len(files));
		#print m;
		# do resize
		for file in files:
			old_file = '\'' + orig_current_path + '/' + file + '\'';
			new_file = '\'' + out_current_path + '/' + file + '\'';
			if os.path.exists(out_current_path + '/' + file):
				continue

			command = 'ffmpeg -i ' + old_file + ' -ab 0k -s 320x240 -aspect 4:3 ' + new_file
        		print command;
        		commands.getoutput(command)
			continue
			

