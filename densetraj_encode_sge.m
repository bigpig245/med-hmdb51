function [ output_args ] = densetraj_encode_sge()
%ENCODE Summary of this function goes here
%   Detailed explanation goes here
%% kf_dir_name: name of keyframe folder, e.g. keyframe-60 for segment length of 60s   
   
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
	descriptor = 'hoghofmbh';
	tic;
	
	video_dir = '/home/ntrang/project/dataset/hmdb51';
	fea_dir = '/home/ntrang/project/output/hmdb51/feature';
	
	f_metadata = sprintf('/home/ntrang/project/output/hmdb51/metadata/metadata.mat');  % for kinddevel only
	
	fprintf('Loading basic metadata...\n');
	metadata = load(f_metadata, 'metadata');
	metadata = metadata.metadata;
	
	codebook_gmm_size = 256; %cluster_count
	
	feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc', descriptor, codebook_gmm_size);
	if dimred > 0,
		feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc.pca', descriptor, codebook_gmm_size);
	end

	output_dir_fc = sprintf('%s/%s', fea_dir, feature_ext_fc);
	
	if ~exist(output_dir_fc, 'file'),
		mkdir(output_dir_fc);
		change_perm(output_dir_fc);
	end
	
	% loading gmm codebook
	
	codebook_hoghof_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/idensetraj.hoghof/data/codebook.gmm.%d.%d.mat', codebook_gmm_size, dimred);
	low_proj_hoghof_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/idensetraj.hoghof/data/lowproj.%d.%d.mat', dimred, 204);
	
	codebook_mbh_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/idensetraj.mbh/data/codebook.gmm.%d.%d.mat', codebook_gmm_size, dimred);
	low_proj_mbh_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/idensetraj.mbh/data/lowproj.%d.%d.mat', dimred, 192);

	codebook_hoghof_ = load(codebook_hoghof_file, 'codebook');
	codebook_hoghof = codebook_hoghof_.codebook;
	
	codebook_mbh_ = load(codebook_mbh_file, 'codebook');
	codebook_mbh = codebook_mbh_.codebook;
	
	low_proj_hoghof_ = load(low_proj_hoghof_file, 'low_proj');
	low_proj_hoghof = low_proj_hoghof_.low_proj;
	
	low_proj_mbh_ = load(low_proj_mbh_file, 'low_proj');
	low_proj_mbh = low_proj_mbh_.low_proj;
	
	
	for i = 1:length(metadata.videos),
		event_name = metadata.events{i};
		video_name = metadata.videos{i};
		%label = metadata.labels{i};
		
		%if label == 2, %if video is used for training, ignore it
		%	continue;
		%end
		
		video_file = sprintf('%s/%s/%s.avi', video_dir, event_name, video_name);
		
		%output_hoghof_file = sprintf('%s/%s/%s.hoghof.mat', output_dir_fc, fileparts(metadata.(video_id).ldc_pat), video_id);
		%output_mbh_file = sprintf('%s/%s/%s.mbh.mat', output_dir_fc, fileparts(metadata.(video_id).ldc_pat), video_id);
		output_file = sprintf('%s/%s/%s.mat', output_dir_fc, event_name, video_name);
		
		if exist(output_file, 'file'),
			fprintf('File [%s] already exist. Skipped!!\n', output_file);
			continue;
		end
		
		fprintf(' [%d] Extracting & Encoding for [%s]\n', i, video_name);
		
		[code_hoghof, code_mbh] = densetraj_extract_and_encode_hoghofmbh(video_file, codebook_hoghof, low_proj_hoghof, codebook_mbh, low_proj_mbh); %important
		%code_mbh = densetraj_extract_and_encode_hoghofmbh(video_file, codebook_mbh, low_proj_mbh); %important
		
		code = [code_hoghof; code_mbh];
		%code = code_mbh;
		
		par_save(output_file, code, 1); 	
		%change_perm(output_file);	

	end
	
	elapsed = toc;
	elapsed_str = datestr(datenum(0,0,0,0,0,elapsed),'HH:MM:SS');
	msg = sprintf('Finish running %s. Elapsed time: %s', mfilename, elapsed_str);
	logmsg(logfile, msg);

	%toc
	%quit;
end

