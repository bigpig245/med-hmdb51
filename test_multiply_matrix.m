function [] = test_multiply_matrix(descriptor, video_file)
	
	addpath('/home/ntrang/project/tools/mod-gmm-fisher.git/matlab');

	codebook_ = load('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/imprvdensetraj.hoghof/data/codebook.gmm.256.128.mat', 'codebook');
	codebook = codebook_.codebook;
	
	low_proj_ = load('/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/imprvdensetraj.hoghof/data/lowproj.128.204.mat', 'low_proj');
	low_proj = low_proj_.low_proj;
	
	densetraj = 'LD_PRELOAD=/home/ntrang/usr.local/lib/libstdc++.so /home/ntrang/project/tools/improved_trajectory_release/release/DenseTrackStab';
	
	%% fisher initialization
	fisher_params.grad_weights = false;		% "soft" BOW
	fisher_params.grad_means = true;		% 1st order
	fisher_params.grad_variances = true;		% 2nd order
	fisher_params.alpha = single(1.0);		% power normalization (set to 1 to disable)
	fisher_params.pnorm = single(0.0);		% norm regularisation (set to 0 to disable)
	
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
	
	BLOCK_SIZE = 50000; % initial capacity (& increment size)
	F = zeros(feat_dim, BLOCK_SIZE);
	listPtr = 1;
	
	tic;
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
	toc;

	tic;
	F(:, listPtr:end) = [];   % remove unused slots

	X_c = cell(1,256);
	X = zeros(65536, size(F, 2));
	for i = 1:size(F, 2),
		cpp_handle = mexFisherEncodeHelperSP('init', codebook, fisher_params);
		k = mexFisherEncodeHelperSP('accumulate', cpp_handle, single(low_proj * F(:, i)));
		T = X_c{k};
		s = size(T,2) + 1;
		T(:, s) = mexFisherEncodeHelperSP('getfk', cpp_handle);
		mexFisherEncodeHelperSP('clear', cpp_handle);
		T(:, s) = T(:, s)/norm(T(:, s));
		X(:, i) = T(:, s);
		X_c{k} = T;
	end
	X_c = X_c(~cellfun(@isempty,X_c));
	toc;
	
	tic;
	k = X'*X;
	toc;

	tic;
	ki = cell(1,256);
	for i = 1:size(X_c,2),
		xi = X_c{i};
		if isempty(xi),
			continue;
		end
		ki{i} = xi'*xi;
	end
	
	kx = cell2mat(ki);
	toc;

	
	if sum(~eq(k, kx)) == 0,
		fprintf('Equal!');
	end
	popenr(p, -1);
end
