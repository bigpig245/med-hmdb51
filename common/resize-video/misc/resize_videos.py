
import sys
import os
import commands

video_path = '/net/per900a/raid0/plsang/dataset/MED11_Resized/';
#orig_video_path = video_path + 'AVIClipstest/';
orig_video_path = '/net/sfv215/export/raid4/ledduy/trecvid-med-2011/test/MED11TEST/';

#default to Hollywood2 dataset: starting with half size, resize by a factor of 1/sqrt(2)
sizes = ['0.5'];

for size in sizes:

    files = os.listdir(orig_video_path)
    m = len(files)
    counter = 0
    new_folder_name = 'MED11TEST/';
    os.system('mkdir '+video_path+new_folder_name)

    for file in files:
        counter = counter + 1;
        old_file = orig_video_path + file    
        new_file = video_path + new_folder_name + file
        if os.path.exists(new_file):
             continue
        print "@@@ Working on video " + str(counter) + " out of " + str(m) + " videos in total"
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
            #sys.exit()
            continue
        print w, h
        #command = 'ffmpeg -i ' + old_file + ' -s '+str(int(w*float(size)))+'x'+str(int(h*float(size))) + ' ' + new_file
        new_h = int(round(320*h/w));
        if new_h % 2 != 0:
            new_h = new_h - 1 
        command = 'ffmpeg -i ' + old_file + ' -ab 128k -s 320x' + str(new_h) + ' -aspect ' + str(w) + ':' + str(h) + ' ' + new_file
        #print command
        commands.getoutput(command)
