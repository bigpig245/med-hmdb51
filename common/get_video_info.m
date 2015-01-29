function feat = get_video_info()
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes her
    
    % Set up the mpeg audio decode command as a readable streamccc
    ref_dir = '/home/ntrang/project/dataset/hmdb51';
	
	fprintf('Listing...\n');
	test_video = dir(ref_dir);
    ldc_pat = 'brush_hair';
	
    output_mat_file = sprintf('/home/ntrang/project/output/hmdb51_%s.info.mat', ldc_pat);
	
	%fh = fopen(output_file, 'w+');
	%fprintf(fh, 'VIDEO,DURATION,NUMFRAMES\n');
	
	fprintf('Start calculating...\n');
	
	pattern = '(?<hh>\d\d)\:(?<mm>\d\d)\:(?<ss>\d\d.\d+)';
	
	DR = zeros(length(test_video), 1);
	NF = zeros(length(test_video), 1);
	
	%parfor ii = 1:length(test_video),
    for ii = 1:length(test_video),
        
		if ~mod(ii, 100),
			fprintf('%d \n', ii);
		end
		
		video_id = test_video(ii).name;
		
        %ignore 2 strange file: '.' and '..'
		%if isempty(strfind(video_id, 'HVC')),
        %if strcmp(video_id, '.') == 1 || strcmp(video_id, '..'),
        if isempty(strfind(video_id, '.avi')),
			%warning('not video id format <%s>\\n', video_id);
			continue;
		end
		
		video_file = sprintf('%s/%s', ref_dir, video_id);
		
		cmd = sprintf('ffmpeg -i %s 2>&1 | sed -n "s/.*Duration: \\([^,]*\\), .*/\\1/p"', video_file);
        %cmd = sprintf('ffmpeg -i %s', video_file);
    	        
		try
			[~, duration] = system(cmd);
		catch
			continue;
		end
		
 		if isempty(duration),
            fprintf(cmd);
            fprintf('\n');
			continue;
		end
		
		info = regexp(strtrim(duration), pattern, 'names');
		
		t = str2num(info.hh)*3600 + str2num(info.mm)*60 + str2num(info.ss);
		
		video_name = video_id(1:end-4);
		
		%cmd_fps = sprintf('ffmpeg -i "%s" 2>&1 | sed -n "0,/.*, \\(.*\\) fps.*/s/.*, \\(.*\\) fps.*/\\1/p"', video_file);
		%[~, fps] = system(cmd_fps);	
		%fps = str2num(strtrim(fps));
        fps = 30; % use old ffmpeg > cannot get fps
	
		num_frames = floor(t * fps);
		
		t = round(t);
		%fprintf(fh, '%s,%d,%d\n', video_name, t, num_frames);
			
		DR(ii) = t;
		NF(ii) = num_frames;
	end
	
	%lookup = struct;
    metadata = struct;
	
	fprintf('Building struct...\n');
	for ii = 1:length(test_video),
		if ~mod(ii, 1000),
			fprintf('%d \n', ii);
		end
		
		video_id = test_video(ii).name;
        %ignore 2 strange file: '.' and '..'
		%if isempty(strfind(video_id, 'HVC')),
        %if strcmp(video_id, '.') == 1 || strcmp(video_id, '..'),
        if isempty(strfind(video_id, '.avi')),
			%warning('not video id format <%s>\n', video_id);
			continue;
		end
		
		video_name = video_id(1:end-4);
		
		%lookup.(video_name).duration = DR(ii);
		%lookup.(video_name).num_frames = NF(ii);
        metadata.(video_name).duration = DR(ii);
        metadata.(video_name).num_frames = NF(ii);
        metadata.(video_name).ldc_pat = ldc_pat;
        metadata.(video_name).full_name = video_name;
	end
	
	%fprintf(fh, 'ALL,%d,#\n', sum_t);
	%fprintf('total: %d seconds\n', sum_t);
	%save(output_mat_file, 'lookup');
    save(output_mat_file, 'metadata');
end
