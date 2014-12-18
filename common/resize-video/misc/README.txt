ffmped command:
-sameq: same quality
-f: force output format
-ab: audio bitrate e.g. 128, 196, etc.
-s: scale
-aspect: 
-r: force framerate ## -r input_video -r output_video
 
notes:
- there are two encoding stream #0.0 for video & #0.1 for audio
- without using -ab switch might cause some problems when bit rate is inconsistent.
for example, ffmpeg -i /net/sfv215/export/raid4/ledduy/trecvid-med-2011/test/MED11TEST/HVC018035.mp4 -ab 0k -s 320x240 -aspect 640:480 /net/per900a/raid0/plsang/tools/resize-video/MED11TEST/HVC018035.mp4
this command may not work with -ab 60k, -ab 64k, etc.
- sometimes using -r switch to specify the framerate. for example, this command will fail without a -r switch:
ffmpeg -i /net/sfv215/export/raid4/ledduy/trecvid-med-2011/test/MED11TEST/HVC773299.mp4 -ab 0k -s 320x240 -aspect 640:480 /net/per900a/raid0/plsang/tools/resize-video/MED11TEST/HVC773299.mp4
ffmpeg -i /net/sfv215/export/raid4/ledduy/trecvid-med-2011/test/MED11TEST/HVC773299.mp4 -r 24 -ab 0k -s 320x240 -aspect 640:480 /net/per900a/raid0/plsang/tools/resize-video/MED11TEST/HVC773299.mp4
- using fix framerate is more stable (r = 24), using framerate detected from ffmpeg output sometimes might not work.

problem files (MED11)
ffmpeg -i /net/sfv215/export/raid4/ledduy/trecvid-med-2011/test/MED11TEST/HVC814797.mp4
