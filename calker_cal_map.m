function calker_cal_map(ker)
	
	%videolevel: 1 (default): video-based approach, 0: segment-based approach
	
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
	
	mapPath = sprintf('%s/scores/%s.%s.map.mat', calker_exp_dir, ker.name, ker.type);
    
	if ~checkFile(scorePath), 
		error('File not found!! %s \n', scorePath);
	end
	
	load(scorePath, 'scores');

	n_class = metadata.numclass;
	
	results = {};
	for ss = 1:length(splits),
		fprintf('Cal accuracy for split %d...\n', ss);
		
		split = splits{ss};
		
		split_scores = scores{ss};
		
		map = zeros(n_class + 1, 1);
		for jj = 1:n_class,
		
			this_scores = split_scores(jj, :);
			
			class_name = metadata.classes{jj};
			
			fprintf('Scoring for event [%s]...\n', class_name);
			
			[~, idx] = sort(this_scores, 'descend');
			
			all_test_class_idx = metadata.classids(split.test_idx);
			
			gt_idx = find(all_test_class_idx == jj);
			
			rank_idx = arrayfun(@(x)find(idx == x), gt_idx);
			
			sorted_idx = sort(rank_idx);	
			ap = 0;
			for kk = 1:length(sorted_idx), 
				ap = ap + kk/sorted_idx(kk);
			end
			ap = ap/length(sorted_idx);
			map(jj) = ap;
			
		end
		
		map(n_class + 1) = mean(map(1:n_class));
		
		results{ss} = map;
	end
	
	fprintf('Saving...%s\n', mapPath);
	save(mapPath, 'results');
end
