function calker_create_result(feature_ext, feat_dim, feat_norm, ker_type, suffix)

	if ~exist('suffix', 'var'),
		suffix = '--calker-hmdb51';
	end

	if ~exist('feat_dim', 'var'),
		feat_dim = 4000;
	end

	if ~exist('ker_type', 'var'),
		ker_type = 'kl2';
	end
	
	ker = calker_build_kerdb(feature_ext, feat_norm, ker_type, feat_dim, suffix);
	
	meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
	fprintf('--- Loading metadata...\n');
	metadata = load(meta_file, 'metadata');
	metadata = metadata.metadata;

	split_file = '/home/ntrang/project/output/hmdb51/metadata/splits.mat';
	fprintf('--- Loading splits...\n');
	splits = load(split_file, 'splits');
	splits = splits.splits;
	

	% event names
	calker_exp_dir = sprintf('%s/%s/experiments/%s%s', ker.proj_dir, ker.proj_name, ker.feat, ker.suffix);
	
	fprintf('Scoring for feature %s...\n', ker.name);

	
	scorePath = sprintf('%s/scores/%s.%s.scores.mat', calker_exp_dir, ker.name, ker.type);
	
	mapPath = sprintf('/home/ntrang/project/output/hmdb51/metadata/results.mat');
    
	if ~checkFile(scorePath), 
		error('File not found!! %s \n', scorePath);
	end
	
	load(scorePath, 'scores');

	samples = [48,18,44,51,46,45,21,9,33,7];

	n_class = metadata.numclass;
	
	results = struct;
	results.classes = {};
	results.classids = [];
	results.labels = {};
	for ss = 1:length(splits),
		fprintf('Cal accuracy for split %d...\n', ss);
		
		split = splits{ss};
		
		split_scores = scores{ss};
		
		kk = 1;
		for jj = 1:n_class,
			class_name = metadata.classes{jj};
			
			if isempty(find(samples == jj)),
				fprintf('[%s] is not in samples, ignore!!\n', class_name);
				%continue;
			end
			this_scores = split_scores(kk, :);
			
			fprintf('Scoring for event [%s]...\n', class_name);
			
			[~, idx] = sort(this_scores, 'descend');
			
			all_test_class_idx = metadata.classids(split.test_idx);
			
			gt_idx = find(all_test_class_idx == jj);
			
			rank_idx = idx(1:length(gt_idx));
			
			labels = [];
			success_idxs = [];
			for ll = 1:length(rank_idx),
				video_idx = rank_idx(ll);
				% if predicted videos is in not events, labeled 0
				if isempty(find(gt_idx == video_idx)),
					labels = [labels;[video_idx, 0]];
				else
					% if predicted videos is in events, labeled 1
					labels = [labels;[video_idx, 1]];
					success_idxs = [success_idxs; video_idx];
				end
			end
			
			for ll = 1:length(gt_idx),
				video_idx = gt_idx(ll);
				% remained videos labeled 2
				if isempty(find(success_idxs == video_idx)),
					labels = [labels;[video_idx, 2]];
				end
			end
			
			results.labels = [results.labels; labels];
			results.classes = [results.classes; class_name];
			results.classids = [results.classids; kk];

			kk = kk + 1;
		end
	end
	
	fprintf('Saving...%s\n', mapPath);
	save(mapPath, 'results');
end


function ker = calker_build_kerdb(feature_raw, feat_norm, ker_type, feat_dim, suffix)

% Build kernel database,
% call BuildKerDb('baseline'), or BuildKerDb('baseline', 'dense_sift')...
%
ker.suffix 	 = suffix;		% suffix used for naming experiment folder
ker.type     = ker_type;
ker.feat_norm = feat_norm;
ker.feat_raw = feature_raw;
feature_ext = sprintf('%s.%s', feature_raw, ker.feat_norm);

ker.feat     = feature_ext;
ker.num_dim = feat_dim;
ker.name = feature_ext;
ker.proj_name = 'hmdb51';
ker.proj_dir = 'project/output/';
end