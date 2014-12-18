
import sys
import os
import commands
import string
import random
import os.path

def resize(in_video_path, out_video_path, file_ext = None, web_view = None, start_vid = None, end_vid = float('inf')):	
	
	tmp_dir = '/net/per610a/export/das11f/plsang/tmp/'
	tmp_name = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(10))
	tmp_path = tmp_dir + tmp_name;
	
	counter = 0
	
	if start_vid == None:
		start_vid = 0
	
	if file_ext == None:
		file_ext = '.mp4'
	
	if web_view == None:
		web_view = 'no'
		
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
		if not file.endswith(file_ext):
			print file
			print 'Irrelavant file. Skipped!'
			continue;
		
		counter = counter + 1;
		old_file = in_video_path + '/' + file    
		tmp_file = tmp_path + '/' + file
		new_file = out_video_path + '/' + file
		if web_view == 'yes':
			tmp_file = tmp_file.replace(file_ext, 'mp4');
			new_file = new_file.replace(file_ext, 'mp4');
			
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
			#f.write("FPS not found for video " + file + "\n") # python will convert \n to os.linesep
			f.write(("FPS not found for video <%s>. Used default fps %f instead! \n") % (file, 25) ) # python will convert \n to os.linesep
			f.close()
			fps = 25
			#sys.exit()
			#continue
			
		#command = 'ffmpeg -i ' + old_file + ' -s '+str(int(w*float(size)))+'x'+str(int(h*float(size))) + ' ' + new_file
		new_h = int(round(320*h/w));
		if new_h % 2 != 0:
			new_h = new_h - 1 
		print w, h, 320, new_h
		#command = 'ffmpeg -i ' + old_file + ' -sameq -f mp4 -ab 16k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + new_file
			
		if fps <= 60:
			#command = 'ffmpeg -i ' + old_file + ' -strict experimental -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
			
			#update Aug 17th: some time the resized video may have very high fps, says up to 1000fps. so consider about force using the original frame-rate
			
			if web_view == 'no':
				command = 'ffmpeg -i ' + old_file + ' -qscale 0 -r ' + str(fps) + ' -y -loglevel quiet -strict experimental -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
			elif web_view == 'yes':
				command = 'ffmpeg -i ' + old_file + ' -y -loglevel quiet -qscale 0 -c:v libx264 -crf 19 -preset slow -c:a libfaac -ac 2 -r ' + str(fps) + ' -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
			else:
				print 'Unknow web view'
			
			
		else:
			if web_view == 'no':
				command = 'ffmpeg -i ' + old_file + ' -qscale 0 -r 25 -y -loglevel quiet -strict experimental -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
			elif web_view == 'yes':	
				command = 'ffmpeg -i ' + old_file + ' -y -loglevel quiet -qscale 0 -c:v libx264 -crf 19 -preset slow -c:a libfaac -b:a 192k -ac 2 -r 25 -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + tmp_file
			else:
				print 'Unknow web view'
			
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

if (len(sys.argv) < 5):
	print sys.argv[0] + " <input_dir> <output_dir> <video_fmt> <web_view> (start video) (end video) ";
	exit();

input_dir = sys.argv[1]
output_dir = sys.argv[2]
video_fmt = sys.argv[3]
web_view = sys.argv[4]

log_file = 'resize_videos.log';
	
if len(sys.argv) == 5:
	resize(input_dir, output_dir, video_fmt, web_view)
else:
	start_vid = int(sys.argv[6]);
	end_vid = int(sys.argv[7]);	
	resize(input_dir, output_dir, video_fmt, web_view, start_vid, end_vid)
