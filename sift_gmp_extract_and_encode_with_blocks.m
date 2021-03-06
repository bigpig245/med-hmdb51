function [code_gmp, code_sump, code_maxp] = sift_gmp_extract_and_encode_with_blocks(sift_algo, kernel, event_name, video_name, codebook, low_proj)
	
	set_env;

	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	change_perm(logfile);
	
	kf_dir = '/home/ntrang/project/dataset/keyframes';
	
	%% fisher initialization
	fisher_params.grad_weights = false;		% "soft" BOW
	fisher_params.grad_means = true;		% 1st order
	fisher_params.grad_variances = true;		% 2nd order
	fisher_params.alpha = single(1.0);		% power normalization (set to 1 to disable)
	fisher_params.pnorm = single(0.0);		% norm regularisation (set to 0 to disable)

	%% gmp initialization
	%%% em fix lambda 1e^-4 đi. lamda này quá lớn (tương đương trường hợp sum-pooling như trong paper)
	gmp_params.lambda = 1e5;
	gmp_params.calpha = 0;
	gmp_params.sigma = 1;
	gmp_params.kernel = kernel;
	
	% get sift feature
	sample_length = 5; % frames
	video_kf_dir = fullfile(kf_dir, event_name, video_name);
		
	kfs = dir([video_kf_dir, '/*.jpg']);
	
	selected_idx = [1:length(kfs)];
	
	% trangnt ........
	%if length(kfs) > sample_length,
	%	rand_idx = randperm(length(kfs));
	%	selected_idx = selected_idx(rand_idx(1:sample_length));
	%end
	
	F= [];
	for jj = selected_idx,
		img_name = kfs(jj).name;
		img_path = fullfile(video_kf_dir, img_name);
		
		[frames, descrs] = sift_extract_features( img_path, sift_algo);
		
		% if more than 50% of points are empty --> possibley empty image
		count_zero_points = sum(all(descrs == 0, 1));
		numbers_of_points = size(descrs, 2);
		if isempty(descrs) || count_zero_points > 0.5*numbers_of_points,
			warning('Maybe blank image...[%s]. Skipped!\n', img_name);
			continue;
		end
		
		cpp_handle = mexFisherEncodeHelperSP('init', codebook, fisher_params);
		mexFisherEncodeHelperSP('accumulate', cpp_handle, single(low_proj * descrs));
		code = mexFisherEncodeHelperSP('getfk', cpp_handle);
		mexFisherEncodeHelperSP('clear', cpp_handle);
		code = sign(code) .* sqrt(abs(code));
		F = [F code];
	end

	% pooling with gmp
	encode_dim = 40960;
	alpha = solve_multiple_gmp(gmp_params.lambda, F', gmp_params.calpha, gmp_params.sigma, gmp_params.kernel);
	code_gmp = zeros(encode_dim, size(alpha, 2));
	for i = 1:size(alpha, 2),
		if ~isempty(alpha),
			code_gmp(:,i) = F * alpha(:,i);
		end
	end
	code_sump = sum(F,2);
	code_maxp = max(F,[],2);
end
