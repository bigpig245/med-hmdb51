function sift_encode_gmp_index(sift_algo, param, kernel, index)
	% encoding method: fisher vector
	% representation: video-based, (can be extended to segment level)
	% power normalization, which one is the best? alpha = 0.2? 
	
	% setting
	set_env;
	dimred = 128;
	feat_dim = 128;
	
	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	%msg = sprintf('Start running %s', mfilename);
	%logmsg(logfile, msg);
	change_perm(logfile);
	tic;

	if ~exist('kernel', 'var'),
		kernel = 'linear';
	end

	if ~exist('index', 'var'),
		index = 1;
	end
	
	
	video_dir = '/home/ntrang/project/dataset/hmdb51';
	fea_dir = '/home/ntrang/project/output/hmdb51/feature';
	
	f_metadata = sprintf('/home/ntrang/project/output/hmdb51/metadata/metadata.mat');  % for kinddevel only
	
	fprintf('Loading basic metadata...\n');
	metadata = load(f_metadata, 'metadata');
	metadata = metadata.metadata;
	
	codebook_gmm_size = 256; %cluster_count

	feature_ext_fc = sprintf('sift.%s.%s.cb%d.fc', sift_algo, kernel, codebook_gmm_size);
	feature_ext_sum = sprintf('sift.%s.%s.cb%d.fc', sift_algo, 'sump', codebook_gmm_size);
	feature_ext_max = sprintf('sift.%s.%s.cb%d.fc', sift_algo, 'maxp', codebook_gmm_size);
	if dimred > 0,
		feature_ext_fc = sprintf('sift.%s.%s.cb%d.fc.pca', sift_algo, kernel, codebook_gmm_size);
		feature_ext_sum = sprintf('sift.%s.%s.cb%d.fc.pca', sift_algo, 'sump', codebook_gmm_size);
		feature_ext_max = sprintf('sift.%s.%s.cb%d.fc.pca', sift_algo, 'maxp', codebook_gmm_size);
	end

	output_dir_fc = sprintf('%s/%s', fea_dir, feature_ext_fc);
	output_dir_sum = sprintf('%s/%s', fea_dir, feature_ext_sum);
	output_dir_max = sprintf('%s/%s', fea_dir, feature_ext_max);
	
	if ~exist(output_dir_fc, 'file'),
		mkdir(output_dir_fc);
		change_perm(output_dir_fc);
	end

	if ~exist(output_dir_sum, 'file'),
		mkdir(output_dir_sum);
		change_perm(output_dir_sum);
	end
	
	% loading gmm codebook
	codebook_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/%s.%s.sift/data/codebook.gmm.%d.%d.mat', sift_algo, num2str(param), codebook_gmm_size, dimred);
	low_proj_file = sprintf('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/%s.%s.sift/data/lowproj.%d.%d.mat', sift_algo, num2str(param), dimred, feat_dim);
	codebook_ = load(codebook_file, 'codebook');
	codebook = codebook_.codebook;
	
	low_proj_ = load(low_proj_file, 'low_proj');
	low_proj = low_proj_.low_proj;
	
	%samples = [48,18,44,51,46,45,21,9,33,7];
	samples = [1:51];
	%for i = index:length(metadata.videos),
	event_name = metadata.events{index};
	video_name = metadata.videos{index};
	classid = metadata.classids(index);
	
	video_file = sprintf('%s/%s/%s.avi', video_dir, event_name, video_name);
	
	output_file = sprintf('%s.%d/%s/%s.mat', output_dir_fc, 10, event_name, video_name);

	output_sum_file = sprintf('%s/%s/%s.mat', output_dir_sum, event_name, video_name);

	output_max_file = sprintf('%s/%s/%s.mat', output_dir_max, event_name, video_name);
	
	if exist(output_file, 'file'),
		fprintf('File [%s] already exist. Skipped!!\n', output_file);
		return;
	end
	
	if isempty(find(samples == classid)),
		fprintf('[%s] belongs to [%s] is not in samples, ignore!!\n', video_name, event_name);
		return;
	end
	
	fprintf(' [%d] Extracting & Encoding for [%s]\n', index, video_name);
	
	[code_gmp, code_sump, code_maxp] = sift_gmp_extract_and_encode_with_blocks(sift_algo, kernel, event_name, video_name, codebook, low_proj); %important
	
	% power normalization (with alpha = 0.5)
	lambda = 1;
	for i = 1:size(code_gmp, 2),
		lambda = lambda * 10;
		output_file = sprintf('%s.%d/%s/%s.mat', output_dir_fc, lambda, event_name, video_name);
		code = sign(code_gmp(:,i)) .* sqrt(abs(code_gmp(:,i)));
		par_save(output_file, code, 1);
	end

	code = sign(code_sump) .* sqrt(abs(code_sump));
	par_save(output_sum_file, code, 1); 

	code = sign(code_maxp) .* sqrt(abs(code_maxp));
	par_save(output_max_file, code, 1);

	elapsed = toc;
	elapsed_str = datestr(datenum(0,0,0,0,0,elapsed),'HH:MM:SS');
	msg = sprintf('%d, Finish running %s. Elapsed time: %s\n', index, video_name, elapsed_str);
	fprintf(msg);
	logmsg(logfile, msg);
end

