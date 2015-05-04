function [code_gmp, code_sump] = imprv_densetraj_gmp_extract_and_encode_with_blocks(descriptor, kernel, video_file, codebook, low_proj)
	
	set_env;

	configs = set_global_config();
	logfile = sprintf('%s/%s.log', configs.logdir, mfilename);
	change_perm(logfile);
	
	densetraj = '/home/ntrang/project/tools/improved_trajectory_release/release/DenseTrackStab';
	
	%% fisher initialization
	fisher_params.grad_weights = false;		% "soft" BOW
	fisher_params.grad_means = true;		% 1st order
	fisher_params.grad_variances = true;		% 2nd order
	fisher_params.alpha = single(1.0);		% power normalization (set to 1 to disable)
	fisher_params.pnorm = single(0.0);		% norm regularisation (set to 0 to disable)

	%% gmp initialization
	gmp_params.lambda = 1;
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
	X_c = cell(1,256);
	for i = 1:size(F, 2),
		cpp_handle = mexFisherEncodeHelperSP('init', codebook, fisher_params);
		k = mexFisherEncodeHelperSP('accumulate', cpp_handle, single(low_proj * F(:, i))) + 1;
		code = mexFisherEncodeHelperSP('getfk', cpp_handle);
		mexFisherEncodeHelperSP('clear', cpp_handle);
		code = code/norm(code);
		X_c{k}(:, end+1) = code;
	end
	X_c = X_c(~cellfun(@isempty,X_c));

	alpha = solve_multiple_gmp_with_blocks(gmp_params.lambda, X_c, gmp_params.calpha, gmp_params.sigma, gmp_params.kernel);
	code_gmp = zeros(encode_dim, size(alpha, 2));
	X = cell2mat(X_c);
	for i = 1:size(alpha, 2),
		code_gmp(:,i) = X * alpha(:,i);
	end
	code_sump = sum(X,2);
	popenr(p, -1);
end
