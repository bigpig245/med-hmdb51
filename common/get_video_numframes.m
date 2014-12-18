function num_frames = get_video_numframes(video_file)
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes her
    
	%cmd = sprintf('ffmpeg -i %s 2>&1 | sed -n "s/.*Duration: \([^,]*\), .*/\1/p"', video_file);
	%cmd = sprintf('ffmpeg -i %s 2>&1 | sed -n "s/.*Duration: \\([^,]*\\), .*/\\1/p"', video_file);
    cmd = sprintf('ffmpeg -i %s 2>&1 | grep Duration | awk | tr -d ,', video_file);
	
	try
		[~, duration] = system(cmd);
	catch
		error();
	end
	
	pattern = '(?<hh>\d\d)\:(?<mm>\d\d)\:(?<ss>\d\d.\d+)';
	
	info = regexp(strtrim(duration), pattern, 'names');
	
	t = str2num(info.hh)*3600 + str2num(info.mm)*60 + str2num(info.ss);
	
	cmd_fps = sprintf('ffmpeg -i %s 2>&1 | sed -n "0,/.*, \\(.*\\) fps.*/s/.*, \\(.*\\) fps.*/\\1/p"', video_file);
	[~, fps] = system(cmd_fps);	
	fps = str2num(strtrim(fps));

	num_frames = floor(t * fps);
		
end
