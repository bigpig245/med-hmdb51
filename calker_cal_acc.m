function calker_cal_acc(ker)
	
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
	
	accPath = sprintf('%s/scores/%s.%s.accuracy.mat', calker_exp_dir, ker.name, ker.type);
    
	if ~checkFile(scorePath), 
		error('File not found!! %s \n', scorePath);
	end
	
	samples = [48,18,44,51,46,45,21,9,33,7];

	load(scorePath, 'scores');

	n_class = metadata.numclass;
	
	results = {};
	for ss = 1:length(splits),
	%for ss = 2:3,
		fprintf('Cal accuracy for split %d...\n', ss);
		
		split = splits{ss};
		
		split_scores = scores{ss};
		
		[~, predict_label] = max(split_scores);
		
		acc = zeros(n_class + 1, 1);
		kk = 1;
		for jj = 1:n_class,
			class_name = metadata.classes{jj};
			if isempty(find(samples == jj)),
				fprintf('[%s] is not in samples, ignore!!\n', class_name);
				continue;
			end
			
			all_test_class_idx = metadata.classids(split.test_idx);
			
			test_class_idx = find(all_test_class_idx == jj);
			
			test_class_pre_label = predict_label(test_class_idx);
			
			acc(kk) = length(find(test_class_pre_label == jj))/length(test_class_idx);
			kk = kk + 1;
			
		end
		
		acc(n_class + 1) = mean(acc(1:n_class));
		
		results{ss} = acc;
	end
	
	fprintf('Saving...\n');
	save(accPath, 'results');
	
end
