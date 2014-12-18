function lookup = get_dataset_info(dataset_dir, video_ext)
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes her
    
	
	info_dir = '/net/per610a/export/das11f/plsang/dataset/dataset_infos';
	
    % Set up the mpeg audio decode command as a readable stream
	%ref_dir = '/net/per610a/export/das11f/plsang/dataset/MED2013/LDCDIST/LDC2014E56/MED14AH/video';
	
	fprintf('Listing...\n');
	test_video = dir(dataset_dir);	
	
	%output_mat_file = sprintf('%s/%s.mat', info_dir, dataset);
	
	%fh = fopen(output_file, 'w+');
	%fprintf(fh, 'VIDEO,DURATION,NUMFRAMES\n');
	
	fprintf('Start calculating...\n');
	
	pattern = '(?<hh>\d\d)\:(?<mm>\d\d)\:(?<ss>\d\d.\d+)';
	
	DR = zeros(length(test_video), 1);
	NF = zeros(length(test_video), 1);
	
	parfor ii = 1:length(test_video),
        
		if ~mod(ii, 100),
			fprintf('%d \n', ii);
		end
		
		video_id = test_video(ii).name;
		
		if isempty(strfind(video_id, video_ext)),
			warning('Video <%s> does not end with <%s>\n', video_id, video_ext);
			continue;
		end
		
		video_file = sprintf('%s/%s', dataset_dir, video_id);
		
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
		
		cmd_fps = sprintf('ffmpeg -i %s 2>&1 | sed -n "0,/.*, \\(.*\\) fps.*/s/.*, \\(.*\\) fps.*/\\1/p"', video_file);
		[~, fps] = system(cmd_fps);	
		fps = str2num(strtrim(fps));
	
		if isempty(fps),
			fps = 25;
		end
		
		num_frames = floor(t * fps);
		
		
		t = round(t);
		%fprintf(fh, '%s,%d,%d\n', video_name, t, num_frames);
			
		DR(ii) = t;
		NF(ii) = num_frames;
	end
	
	lookup = struct;
	
	sum_t = 0;
	fprintf('Building struct...\n');
	for ii = 1:length(test_video),
		if ~mod(ii, 1000),
			fprintf('%d \n', ii);
		end
		
		video_id = test_video(ii).name;
		if isempty(strfind(video_id, video_ext)),
			warning('Video <%s> does not end with <%s>\n', video_id, video_ext);
			continue;
		end
		
		video_name = video_id(1:end-4);
		
		%video_name = strrep(video_name, '-', '_');
		%video_name = sprintf('yt_%s', video_name);
		
		lookup_id = sprintf('vid%s', video_name);
		
		lookup.(lookup_id).duration = DR(ii);
		lookup.(lookup_id).num_frames = NF(ii);
		sum_t = sum_t + DR(ii);
	end
	
	%lookup.total_durations = sum_t;
	fprintf('total: %d seconds\n', sum_t);
	%save(output_mat_file, 'lookup');
	
end
