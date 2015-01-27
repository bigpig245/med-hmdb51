function sift_select_features( sift_algo, param, version)
%SELECT_FEATURES Summary of this function goes here
%   Detailed explanation goes here
	% nSize: step for dense sift
    % parameters
	
	%%

	set_env;
	
	if ~exist('version', 'var'),
		version = 'v0.1';  %% using both event video + bg video
    end
	
    max_features = 1000000;
	%video_sampling_rate = 1;
    sample_length = 5; % frames
    %ensure_coef = 1.1;
	
	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	msg = sprintf('Start running %s(%s, %s)', mfilename, sift_algo, param);
	logmsg(logfile, msg);
	tic;
	
	f_metadata = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
    
	fprintf('Loading metadata...\n');
	load(f_metadata, 'metadata');
	
    %kf_dir = '/net/per610a/export/das11f/plsang/trecvidmed13/keyframes';
    kf_dir = '/home/ntrang/project/output/hmdb51/keyframes';
	
	%fprintf('Loading metadata...\n');
	%medmd_file = '/net/per610a/export/das11f/plsang/trecvidmed13/metadata/medmd.mat';
	%load(medmd_file, 'MEDMD'); 
	
	%clips = MEDMD.EventBG.default.clips;
	%list_video = unique(clips);	% 4992 clips
	
	%num_selected_videos = ceil(video_sampling_rate * length( list_video ));
	%rand_index = randperm(length(list_video));
	%selected_index = rand_index(1:num_selected_videos);
    %selected_videos = list_video(selected_index);
    %configs = set_global_config();
    %video_dir = '/home/ntrang/project/dataset/hmdb51/';
    %db_dir = configs.db_dir;
    %video_dir = sprintf('%s/%s', db_dir, ldc_pat);
	%selected_videos = dir(video_dir);
	
	%max_features_per_video = ceil(ensure_coef * max_features/length(selected_videos));
    max_features_per_video = 1000;
    
    %feats = cell(length(selected_videos), 1);

	%output_file = sprintf('/net/per610a/export/das11f/plsang/trecvidmed13/feature/bow.codebook.devel/%s.%s.sift/data/selected_feats_%d.mat', sift_algo, num2str(param), max_features);
	%output_file = sprintf('/net/per610a/export/das11f/plsang/trecvidmed13/feature/bow.codebook.devel/%s.%s.%s.sift/data/selected_feats_%d.mat', sift_algo, num2str(param), version, max_features);
    output_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/%s.%s.%s.sift/data/selected_feats_%d_mod.mat', sift_algo, num2str(param), version, max_features);
	if exist(output_file),
		fprintf('File [%s] already exist. Skipped\n', output_file);
		return;
	end
	
    ii = 1;
    for i = 1:length(metadata.videos),
        event_name = metadata.classes{i};
        video_name = metadata.videos{i};
        label = metadata.labels{i};
        
        if label == 1, %if video is used for training, ignore it
            continue;
        end
        
		video_kf_dir = fullfile(kf_dir, event_name, video_name);
        
		kfs = dir([video_kf_dir, '/*.jpg']);
        
		selected_idx = [1:length(kfs)];
        
        % trangnt ........
		if length(kfs) > sample_length,
			rand_idx = randperm(length(kfs));
			selected_idx = selected_idx(rand_idx(1:sample_length));
		end
		
		fprintf('Computing features for: %d - %s %f %% complete\n', ii, video_name, ii/length(metadata.videos)*100.00);
		feat = [];
		for jj = selected_idx,
			img_name = kfs(jj).name;
			img_path = fullfile(video_kf_dir, img_name);
			
			[frames, descrs] = sift_extract_features( img_path, sift_algo, param );
            
            % if more than 50% of points are empty --> possibly empty image
			descrs = descrs(:,any(descrs));
            count_zero_points = sum(all(descrs == 0, 1));
            numbers_of_points = size(descrs, 2);
            if isempty(descrs) || count_zero_points > 0.5*numbers_of_points,
                warning('Maybe blank image...[%s]. Skipped!\n', img_name);
                %continue;
            end
			%feat = [feat descrs];
            feat = [feat descrs];
		end
        
        if size(feat, 2) > max_features_per_video,
            feats{ii} = vl_colsubset(feat, max_features_per_video);
        else
            feats{ii} = feat;
        end
        ii = ii + 1;
        
    end
    
    % concatenate features into a single matrix
    feats = cat(2, feats{:});
    
    if size(feats, 2) > max_features,
         feats = vl_colsubset(feats, max_features);
    end

	output_dir = fileparts(output_file);
	if ~exist(output_dir, 'file'),
		mkdir(output_dir);
		%cmd = sprintf('mkdir -p %s', output_dir);
		%system(cmd);
	end
	
	fprintf('Saving selected features to [%s]...\n', output_file);
    save(output_file, 'feats', '-v7.3');
    
	elapsed = toc;
	elapsed_str = datestr(datenum(0,0,0,0,0,elapsed),'HH:MM:SS');
	msg = sprintf('Finish running %s(%s, %s). Elapsed time: %s', mfilename, sift_algo, param, elapsed_str);
	logmsg(logfile, msg);
end

