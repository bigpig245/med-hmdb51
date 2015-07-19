function [ output_args ] = imprv_densetraj_encode_sge(descriptor)
	% encoding method: fisher vector
	% representation: video-based, (can be extended to segment level)
	% power normalization, which one is the best? alpha = 0.2? 
	
	% setting
	set_env;
	dimred = 128;
	
	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	msg = sprintf('Start running %s', mfilename);
	logmsg(logfile, msg);
	change_perm(logfile);
	tic;
	
	switch descriptor,
		case 'hoghof'
			start_idx = 41;
			end_idx = 244;
		case 'mbh'
			start_idx = 245;
			end_idx = 436;
		case 'hoghofmbh'
			start_idx = 41;
			end_idx = 436;
		case 'full'
			start_idx = 1;
			end_idx = 436;
		otherwise
			error('Unknown descriptor for dense trajectories!!\n');
	end
	
	feat_dim = end_idx - start_idx + 1;
	
	video_dir = '/home/ntrang/project/dataset/hmdb51';
	fea_dir = '/home/ntrang/project/output/hmdb51/feature';
	
	f_metadata = sprintf('/home/ntrang/project/output/hmdb51/metadata/metadata.mat');  % for kinddevel only
	
	fprintf('Loading basic metadata...\n');
	metadata = load(f_metadata, 'metadata');
	metadata = metadata.metadata;
	
	codebook_gmm_size = 256; %cluster_count
	isGMP = '0';
	
	if strcmp(isGMP, '0'),
		feature_ext_fc = sprintf('imprvdensetraj.%s.cb%d.fc', descriptor, codebook_gmm_size);
		if dimred > 0,
			feature_ext_fc = sprintf('imprvdensetraj.%s.cb%d.fc.pca', descriptor, codebook_gmm_size);
		end
	else
		feature_ext_fc = sprintf('imprvdensetraj.%s.cb%d.fc.%s', descriptor, codebook_gmm_size, kernel);
		if dimred > 0,
			feature_ext_fc = sprintf('imprvdensetraj.%s.cb%d.fc.pca.%s', descriptor, codebook_gmm_size, kernel);
		end
	end

	output_dir_fc = sprintf('%s/%s', fea_dir, feature_ext_fc);
	
	if ~exist(output_dir_fc, 'file'),
		mkdir(output_dir_fc);
		change_perm(output_dir_fc);
	end
	
	% loading gmm codebook
	codebook_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/imprvdensetraj.%s/data/codebook.gmm.%d.%d.mat', descriptor, codebook_gmm_size, dimred);
	low_proj_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/imprvdensetraj.%s/data/lowproj.%d.%d.mat', descriptor, dimred, feat_dim);
	codebook_ = load(codebook_file, 'codebook');
	codebook = codebook_.codebook;
	
	low_proj_ = load(low_proj_file, 'low_proj');
	low_proj = low_proj_.low_proj;
	
	
	for i = 1:length(metadata.videos),
		event_name = metadata.events{i};
		video_name = metadata.videos{i};
		%label = metadata.labels{i};
		
		%if label == 2, %if video is used for training, ignore it
		%	continue;
		%end
		
		video_file = sprintf('%s/%s/%s.avi', video_dir, event_name, video_name);
		
		output_file = sprintf('%s/%s/%s.mat', output_dir_fc, event_name, video_name);
		
		if exist(output_file, 'file'),
			fprintf('File [%s] already exist. Skipped!!\n', output_file);
			continue;
		end
		
		fprintf(' [%d] Extracting & Encoding for [%s]\n', i, video_name);
		
		code = imprv_densetraj_extract_and_encode(descriptor, video_file, codebook, low_proj); %important
		
		% power normalization (with alpha = 0.5)
		code = sign(code) .* sqrt(abs(code));
		par_save(output_file, code, 1); 	
		%change_perm(output_file);	

	end
	
	elapsed = toc;
	elapsed_str = datestr(datenum(0,0,0,0,0,elapsed),'HH:MM:SS');
	msg = sprintf('Finish running %s. Elapsed time: %s', mfilename, elapsed_str);
	logmsg(logfile, msg);
end

