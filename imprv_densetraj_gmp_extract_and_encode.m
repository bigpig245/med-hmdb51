function [ code_gmp, code_sump ] = imprv_densetraj_gmp_extract_and_encode(descriptor, kernel, video_file, codebook, low_proj)
	
	set_env;

	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	change_perm(logfile);
	
	densetraj = '/home/ntrang/project/tools/dense_trajectory_release_v1.2/release/DenseTrack';
	
	%% fisher initialization
	fisher_params.grad_weights = false;		% "soft" BOW
	fisher_params.grad_means = true;		% 1st order
	fisher_params.grad_variances = true;		% 2nd order
	fisher_params.alpha = single(1.0);		% power normalization (set to 1 to disable)
	fisher_params.pnorm = single(0.0);		% norm regularisation (set to 0 to disable)

	%% gmp initialization
	%%% em fix lambda 1e^-4 đi. lamda này quá lớn (tương đương trường hợp sum-pooling như trong paper)
	gmp_params.lambda = 1e-4;
	gmp_params.calpha = 0;
	gmp_params.sigma = 1;
	gmp_params.kernel = kernel;
	
	% Set up the mpeg audio decode command as a readable stream
	cmd = [densetraj, ' ''', video_file, ''''];

	% open pipe
	p = popenr(cmd);

	if p < 0
		error(['Error running popenr(', cmd,')']);
	end
	
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
		otherwise
			error('Unknown descriptor for dense trajectories!!\n');
	end

	feat_dim = end_idx - start_idx + 1;
	full_dim = 436;
	encode_dim = 65536;
	
	BLOCK_SIZE = 50000; % initial capacity (& increment size)
	F = zeros(feat_dim, BLOCK_SIZE);
	listPtr = 1;
	
	while true,

		% Get the next chunk of data from the process
		Y = popenr(p, full_dim, 'float');

		if isempty(Y), break; end;

		if length(Y) ~= full_dim,
				msg = ['wrong dimension [', num2str(length(Y)), '] when running [', cmd, '] at ', datestr(now)];
				logmsg(logfile, msg);
				continue;
		end

		%X = [X Y(8:end)]; % discard first 7 elements
		F(:, listPtr) = Y(start_idx:end_idx);
		listPtr = listPtr + 1;
	
	end

	% pooling with gmp
	F(:, listPtr:end) = [];   % remove unused slots
	X = zeros(encode_dim, size(F, 2));
	for i = 1:size(F, 2),
		cpp_handle = mexFisherEncodeHelperSP('init', codebook, fisher_params);
		mexFisherEncodeHelperSP('accumulate', cpp_handle, single(low_proj * F(:, i)));
		X(:, i) = mexFisherEncodeHelperSP('getfk', cpp_handle);
		mexFisherEncodeHelperSP('clear', cpp_handle);
		X(:, i) = X(:, i)/norm(X(:, i));
		
		%%% anh thay F(:, i) bằng số random rand(204, 1) thì kết quả X(:, i) rất sparse (số lượng phần tử khác 0 < 256)
		%%% em debug lại chỗ này đi nhé!!
	end

	alpha = solve_gmp(gmp_params.lambda, X', gmp_params.calpha, gmp_params.sigma, gmp_params.kernel);
	code_gmp = X * alpha';
	code_sump = sum(X,2);
	%nowstr = datestr(now, 'yyyymmddHHMMSS');
	%phi_sum_file = ['~/', nowstr, 'phi_sum_', '.mat'];
	%phi_file = ['~/', nowstr, 'phi_', nowstr, '.mat'];
	%par_save(phi_sum_file, sum(X,2), 1);
	%par_save(phi_file, code, 1);
	popenr(p, -1);
end
