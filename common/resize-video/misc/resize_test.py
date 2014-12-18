
import sys
import os
import commands
import os.path

video_path = '/net/per900a/raid0/plsang/tools/resize-video/';
#orig_video_path = video_path + 'AVIClipstest/';
orig_video_path = '/net/sfv215/export/raid4/ledduy/trecvid-med-2011/test/MED11TEST/';
#orig_video_path = '/net/sfv215/export/raid4/ledduy/trecvid-med-2011/devel/MED11-DEV-T1/';

#default to Hollywood2 dataset: starting with half size, resize by a factor of 1/sqrt(2)

files = os.listdir(orig_video_path)
m = len(files)	    
counter = 0;
new_folder_name = 'MED11TEST/';
if not os.path.exists(video_path+new_folder_name):
    os.system('mkdir '+video_path+new_folder_name)

for file in files:
    counter = counter + 1;
    if not file == "HVC033990.mp4":
        continue;
    
    old_file = orig_video_path + file    
    new_file = video_path + new_folder_name + file
    if os.path.exists(new_file):
         continue
    print "@@@ Working on video " + str(counter) + " out of " + str(m) + " videos in total"
    command = 'ffmpeg -i ' + old_file
    line = commands.getoutput(command)
    tokens = line.split()
    found = 0;
    found_fps = 0;
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
    for token in tokens:
        if 'fps' in token:
            #print 'Found token: ' + token
            tks = token.strip(',') # bugs: must strip ',' before spliting
            fps = eval(prev_token)
            print 'Found token: ' + token
            found_fps = 1;
            break
        prev_token = token;
                
    if not found or not found_fps:
        print "something wrong with file " + file
        print line
        f = open("log.txt", "a+")
        f.write("something wrong with file " + file + " " + line + "\n") # python will convert \n to os.linesep
        #sys.exit()
        continue
    #command = 'ffmpeg -i ' + old_file + ' -s '+str(int(w*float(size)))+'x'+str(int(h*float(size))) + ' ' + new_file
    new_h = int(round(320*h/w));
    if new_h % 2 != 0:
        new_h = new_h - 1 
    print w, h, 320, new_h
    #command = 'ffmpeg -i ' + old_file + ' -sameq -f mp4 -ab 16k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + new_file
    command = 'ffmpeg -i ' + old_file + ' -r ' + str(fps) + ' -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + new_file
    print command
    commands.getoutput(command)
