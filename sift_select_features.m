function sift_select_features(sift_algo, param)
%SELECT_FEATURES Summary of this function goes here
%   Detailed explanation goes here
	% nSize: step for dense sift
	% parameters
	
	%%

	set_env;
	
	max_features = 1000000;
	%video_sampling_rate = 1;
	sample_length = 5; % frames
	%ensure_coef = 1.1;
	
	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	msg = sprintf('Start running %s(%s, %s)', mfilename, sift_algo, param);
	logmsg(logfile, msg);
	tic;
	
	f_metadata = sprintf('/home/ntrang/project/output/hmdb51/metadata/metadata.mat');
	fprintf('Loading metadata...\n');
	metadata_ = load(f_metadata, 'metadata');
	metadata = metadata_.metadata;

	kf_dir = '/home/ntrang/project/dataset/keyframes';
	videos = metadata.videos;
	video_dir = '/home/ntrang/project/dataset/hmdb51';

	max_features_per_video = 10000;

	output_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/%s.%s.sift/data/selected_feats_%d.mat', sift_algo, num2str(param), max_features);
	if exist(output_file),
		fprintf('File [%s] already exist. Skipped\n', output_file);
		return;
	end
	
	%parfor ii = 1:length(videos),
	for ii = 1:length(videos),
		video_name = videos{ii};
		event_name = metadata.events{ii};
		label = metadata.labels{ii};
		
		if label == 2, %if video is used for training, ignore it
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
		
		fprintf('Computing features for: %d - %s %f %% complete\n', ii, video_name, ii/length(videos)*100.00);
		feat = [];
		for jj = selected_idx,
			img_name = kfs(jj).name;
			img_path = fullfile(video_kf_dir, img_name);
			
			[frames, descrs] = sift_extract_features( img_path, sift_algo, param );
			
			% if more than 50% of points are empty --> possibley empty image
			count_zero_points = sum(all(descrs == 0, 1));
			numbers_of_points = size(descrs, 2);
			if isempty(descrs) || count_zero_points > 0.5*numbers_of_points,
				warning('%d/%d: Maybe blank image...[%s]. Skipped!\n', count_zero_points, number_of_points, img_name);
				continue;
			end
			%feat = [feat descrs];
			feat = [feat descrs];
		end
		
		if size(feat, 2) > max_features_per_video,
			feats{ii} = vl_colsubset(feat, max_features_per_video);
		else
			feats{ii} = feat;
		end
		
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

