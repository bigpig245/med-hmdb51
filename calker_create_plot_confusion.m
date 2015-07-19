function calker_create_plot_confusion(scorePath)
	%create confusion matrix from score path
	confusionPath = sprintf('/home/ntrang/project/output/hmdb51/metadata/results.mat');
    
	if ~checkFile(scorePath), 
		error('File not found!! %s \n', scorePath);
	end
	
	load(scorePath, 'scores');

	%samples = [48,18,44,51,46,45,21,9,33,7];
	samples = [1:51];
	
	meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
	fprintf('--- Loading metadata...\n');
	metadata = load(meta_file, 'metadata');
	metadata = metadata.metadata;
	n_class = metadata.numclass;
	
	split_file = '/home/ntrang/project/output/hmdb51/metadata/splits.mat';
	fprintf('--- Loading splits...\n');
	splits = load(split_file, 'splits');
	splits = splits.splits;
	
	for ss = 1:length(splits),
		split = splits{ss};
		split_scores = scores{ss};
		result = [];
		truth = [];

		for jj = 1:n_class,
			class_name = metadata.classes{jj};
			if isempty(find(samples == jj)),
				fprintf('[%s] is not in samples, ignore!!\n', class_name);
				continue;
			end
			
			this_scores = split_scores(jj, :);			
			[~, idxes] = sort(this_scores, 'descend');
			truth = [truth,ones(1,30)*jj];
			for ll = 1:30,
				idx = idxes(ll);
				if mod(idx, 30) == 0,
					result = [result, floor(idx/30)];
				else
					result = [result, floor((idx/30)+1)];
				end
			end
		end
	end
	
	[results, ~] = confusionmat(truth, result);
	
	fprintf('Saving...%s\n', confusionPath);
	save(confusionPath, 'results');
end
