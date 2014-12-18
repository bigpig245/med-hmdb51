function feat = get_video_durations()
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes her
    
    % Set up the mpeg audio decode command as a readable stream
	ref_dir = '/net/per610a/export/das11f/plsang/dataset/MED2013/LDCDIST/LDC2014E42/NOVEL1/video';
	
	fprintf('Listing...\n');
	test_video = dir(ref_dir);
	ldc_pat = 'LDC2012E26';
	
	output_file = sprintf('/net/per610a/export/das11f/plsang/codes/resize-video/%s.info.csv', ldc_pat);
	
	output_mat_file = sprintf('/net/per610a/export/das11f/plsang/codes/resize-video/%s.info.mat', ldc_pat);
	
	fh = fopen(output_file, 'w+');
	fprintf(fh, 'VIDEO,DURATION,NUMFRAMES\n');
	
	fprintf('Start calculating...\n');
	
	pattern = '(?<hh>\d\d)\:(?<mm>\d\d)\:(?<ss>\d\d.\d+)';
	
	info = struct;
	
	sum_t = 0;
	
	for ii = 1:length(test_video),
        
		if ~mod(ii, 1000),
			fprintf('%d ', ii);
		end
		
		video_id = test_video(ii).name;
		
		if isempty(strfind(video_id, 'HVC')),
			warning('not video id format <%s>\n', video_id);
			continue;
		end
		
		video_file = sprintf('%s/%s', ref_dir, video_id);
		
		%cmd = sprintf('ffmpeg -i %s 2>&1 | sed -n "s/.*Duration: \([^,]*\), .*/\1/p"', video_file);
		cmd = sprintf('ffmpeg -i %s 2>&1 | sed -n "s/.*Duration: \\([^,]*\\), .*/\\1/p"', video_file);
		
		try
			[~, duration] = system(cmd);
		catch
			continue;
		end
		
		if isempty(duration),
			continue;
		end
		
		info = regexp(strtrim(duration), pattern, 'names');
		
		t = str2num(info.hh)*3600 + str2num(info.mm)*60 + str2num(info.ss);
		
		video_name = video_id(1:end-4);
		
		sum_t = sum_t + t;
		
		cmd_fps = sprintf('%s -i %s 2>&1 | sed -n "0,/.*, \\(.*\\) fps.*/s/.*, \\(.*\\) fps.*/\\1/p"', ffmpeg_bin, filepath);
		[~, fps] = system(cmd_fps);	
		fps = str2num(strtrim(fps));
	
		num_frames = floor(t * fps);
		
		t = round(t)
		fprintf(fh, '%s,%d,%d\n', video_name, t, num_frames);
		
		info.(video_name).duration = t;
		info.(video_name).num_frames = num_frames;
	end
	
	fprintf(fh, 'ALL,%d,#\n', sum_t);
	fprintf('total: %d seconds\n', sum_t);
	save(output_mat_file, 'info');
	
	fclose(fh);	
end
