function imprv_densetraj_gmp_hoghofmbh_sample(kernel, index)
%EXTRACT_AND_ENCODE Summary of this function goes here
% Detailed explanation goes here
	
	tic;
	set_env;
	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	msg = sprintf('Start running %s', mfilename);
	logmsg(logfile, msg);
	change_perm(logfile);

	if ~exist('kernel', 'var'),
		kernel = 'linear';
	end
	gmp_params.lambda = 1e-4;
	gmp_params.calpha = 0;
	gmp_params.sigma = 1;
	gmp_params.kernel = kernel;

	dimred = 128;
	codebook_gmm_size = 256;
	descriptor = 'hoghof';
	hoghof_feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc', descriptor, codebook_gmm_size);
	if dimred > 0,
		hoghof_feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc.pca', descriptor, codebook_gmm_size);
	end

	descriptor = 'mbh';
	mbh_feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc', descriptor, codebook_gmm_size);
	if dimred > 0,
		mbh_feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc.pca', descriptor, codebook_gmm_size);
	end

	descriptor = 'hoghofmbh';
	feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc.%s', descriptor, codebook_gmm_size, kernel);
	if dimred > 0,
		feature_ext_fc = sprintf('idensetraj.%s.cb%d.fc.pca.%s', descriptor, codebook_gmm_size, kernel);
	end

	%video_dir = '/home/ntrang/project/dataset/hmdb51';
	fea_dir = '/home/ntrang/project/output/hmdb51/feature';
	hoghof_dir_fc = sprintf('%s/%s', fea_dir, hoghof_feature_ext_fc);
	mbh_dir_fc = sprintf('%s/%s', fea_dir, mbh_feature_ext_fc);
	output_dir_fc = sprintf('%s/%s', fea_dir, feature_ext_fc);
	
	f_metadata = sprintf('/home/ntrang/project/output/hmdb51/metadata/metadata.mat');  % for kinddevel only
	
	fprintf('Loading basic metadata...\n');
	metadata = load(f_metadata, 'metadata');
	metadata = metadata.metadata;

	samples = [48,18,44,51,46,45,21,9,33,7];

	for i = index:length(metadata.videos),
		event_name = metadata.events{i};
		video_name = metadata.videos{i};
		classid = metadata.classids(i);
		%label = metadata.labels{i};
		
		%if label == 2, %if video is used for training, ignore it
		%	continue;
		%end
		
		if isempty(find(samples == classid)),
			fprintf('[%s] belongs to [%s] is not in samples, ignore!!\n', video_name, event_name);
			continue;
		end

		output_file = sprintf('%s/%s/%s.mat', output_dir_fc, event_name, video_name);
		hoghof_code_file = sprintf('%s/%s/%s.mat', hoghof_dir_fc, event_name, video_name);
		mbh_code_file = sprintf('%s/%s/%s.mat', mbh_dir_fc, event_name, video_name);
		
		if exist(output_file, 'file'),
			fprintf('File [%s] already exist. Skipped!!\n', output_file);
			continue;
		end

		if ~exist(hoghof_code_file, 'file'),
			fprintf('Not exist hoghof encoding file for %s\n', video_name);
			continue;
		end
		
		if ~exist(mbh_code_file, 'file'),
			fprintf('Not exist mbh encoding file for %s\n', video_name);
			continue;
		end
		
		
		fprintf(' [%d] Pooling for [%s]\n', i, video_name);
		
		code_hoghof = load(hoghof_code_file, 'code');
		code_hoghof = code_hoghof.code;
		code_mbh = load(mbh_code_file, 'code');
		code_mbh = code_mbh.code;
		code_pool = [code_hoghof, code_mbh];
		code = solve_gmp(gmp_params.lambda, code_pool, gmp_params.calpha, gmp_params.sigma, gmp_params.kernel);
		code = code';
		par_save(output_file, code, 1); 	
		%change_perm(output_file);	

	end

	elapsed = toc;
	elapsed_str = datestr(datenum(0,0,0,0,0,elapsed),'HH:MM:SS');
	msg = sprintf('Finish running %s. Elapsed time: %s', mfilename, elapsed_str);
	logmsg(logfile, msg);


end
