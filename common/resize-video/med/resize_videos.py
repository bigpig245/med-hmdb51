
import sys
import os
import commands
import os.path

def resize(in_video_path, out_video_path, tmp_path, start_vid = None, end_vid = float('inf')):	
	
	
	counter = 0
	
	if start_vid == None:
		start_vid = 0
	
	if not os.path.exists(out_video_path):
		os.system('mkdir -p ' + out_video_path);
	
	if not os.path.exists(tmp_path):
		os.system('mkdir -p ' + tmp_path);
		
	files = os.listdir(in_video_path)
	m = len(files)
	
	if end_vid > m:
		end_vid = m;
	
	for idx in range(start_vid, end_vid):
		file = files[idx];
		if not file.endswith('.mp4'):
			#print 'Irrelavant file. Skipped!'
			continue;
		
		counter = counter + 1;
		old_file = in_video_path + '/' + file    
		tmp_file = tmp_path + '/' + file
		new_file = out_video_path + '/' + file
		if os.path.exists(new_file):
			 continue
		print "@@@ Working on video " + str(counter) + " out of " + str(end_vid - start_vid) + " videos in total"
		command = 'ffmpeg -i ' + old_file
		line = commands.getoutput(command)
		tokens = line.split()
		found = 0;
		print command
		for token in tokens:
			if 'x' in token and 'Header' not in token:
				#print 'Found token: ' + token
				tks = token.strip(',').split('x') # bugs: must strip ',' before spliting
				if tks[0].isdigit() and tks[1].isdigit():
					w = eval(tks[0])
					h = eval(tks[1])
					print 'Found token: ' + token
					found = 1;
					break

		line = commands.getoutput(command)
		tokens = line.split(',')
		found_fps = 0;
		for token in tokens:
			if 'fps' in token and 'Header' not in token:
				#print 'Found token: ' + token
				tks = token.strip().split(' ') # bugs: must strip ',' before spliting	
				if tks[0].replace('.', '').isdigit():
					fps = eval(tks[0])
					print 'Found fps: ' + str(fps)
					found_fps = 1;
					break

		if not found:
			print "Video size not found for video " + file
			print line
			f = open(log_file, "a+")
			f.write("Video size not found for video " + file + "\n") # python will convert \n to os.linesep
			f.close()
			#sys.exit()
			continue
		
		if not found_fps:
			print "FPS not found for video " + file
			print line
			f = open(log_file, "a+")
			f.write("FPS not found for video " + file + "\n") # python will convert \n to os.linesep
			f.close()
			#sys.exit()
			continue
			
		#command = 'ffmpeg -i ' + old_file + ' -s '+str(int(w*float(size)))+'x'+str(int(h*float(size))) + ' ' + new_file
		new_h = int(round(320*h/w));
		if new_h % 2 != 0:
			new_h = new_h - 1 
		print w, h, 320, new_h
		#command = 'ffmpeg -i ' + old_file + ' -sameq -f mp4 -ab 16k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + new_file
			
		if fps <= 50:
			#command = 'ffmpeg -i ' + old_file + ' -strict experimental -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
			
			#update Aug 17th: some time the resized video may have very high fps, says up to 1000fps. so consider about force using the original frame-rate
			command = 'ffmpeg -i ' + old_file + ' -r ' + str(fps) + ' -y -loglevel quiet -strict experimental -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
		else:
			command = 'ffmpeg -i ' + old_file + ' -r 24 -y -loglevel quiet -strict experimental -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
			f = open(log_file, "a+")
			f.write(("FPS too high %f. Used default fps %f instead! " + file + "\n") % (fps, 25) ) # python will convert \n to os.linesep
			f.close()
			
		print command
		#commands.getoutput(command)
		exit_status = os.system(command)
		if not exit_status:
			#moving tmp_file to new_file
			command = 'mv -f ' + tmp_file + ' ' + new_file
			os.system(command);
		else:
			f = open(log_file, "a+")
			f.write( "File: %s - Exit code: %d \n" % (file, exit_status) ) # python will convert \n to os.linesep
			f.close()

		
ldc_dir = '/net/per610a/export/das11f/plsang/dataset/MED2013/LDCDIST'
rsz_dir = '/net/per610a/export/das11f/plsang/dataset/MED2013/LDCDIST-RSZ'
tmp_dir = '/net/per610a/export/das11f/plsang/dataset/MED2013/tmp'

if (len(sys.argv) < 3):
	print sys.argv[0] + " <ldc_pat> <sub> (start video) (end video) ";
	exit();

ldc_pat = sys.argv[1]

sub = int(sys.argv[2])

log_file = ldc_pat.replace('/', '-') + '.log';

in_video_path = ldc_dir + '/' + ldc_pat;

out_video_path = rsz_dir + '/' + ldc_pat;

tmp_path = tmp_dir + '/' + ldc_pat;
	
# no sub directories
if (sub == 0):
	
	if len(sys.argv) == 3:
		resize(in_video_path, out_video_path, tmp_path)
	else:
		start_vid = int(sys.argv[3]);
		end_vid = int(sys.argv[4]);	
		resize(in_video_path, out_video_path, tmp_path, start_vid, end_vid)

# with sub directories
else:	
	
	files = os.listdir(in_video_path)

	for file in files:
		sub_in_video_path = in_video_path + '/' + file
		
		sub_out_video_path = out_video_path + '/' + file
		
		sub_tmp_path = tmp_path + '/' + file
		
		resize(sub_in_video_path, sub_out_video_path, sub_tmp_path)
