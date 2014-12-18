
import sys
import os
import commands
import os.path

video_path = '/net/per900a/raid0/plsang/dataset/ASLAN_Resized/';
#orig_video_path = video_path + 'AVIClipstest/';
orig_video_path = '/net/per610a/export/das09f/satoh-lab/plsang/aslan/Data/';

if (len(sys.argv) < 3):
	print sys.argv[0] + " <start video> <end video>";
	exit();

#default to Hollywood2 dataset: starting with half size, resize by a factor of 1/sqrt(2)
sizes = ['0.5'];

for size in sizes:

    files = os.listdir(orig_video_path)
    m = len(files)
    start_vid = int(sys.argv[1]);
    end_vid = int(sys.argv[2]);
    if end_vid > m:
        end_vid = m;
	    
    counter = 0;
    new_folder_name = 'mp4/';
    if not os.path.exists(video_path+new_folder_name):
	    os.system('mkdir '+video_path+new_folder_name)

    #for file in files:
    for idx in range(start_vid, end_vid):
        file = files[idx];
        counter = counter + 1;
        old_file = orig_video_path + file    
        new_file = video_path + new_folder_name + file
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
        if not found:
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
        command = 'ffmpeg -i ' + old_file + ' -r 24 -ab 0k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + new_file
        print command
        commands.getoutput(command)
