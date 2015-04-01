function calker_build_train_test_splist()
	split_file = '/home/ntrang/project/output/hmdb51/metadata/splits.mat';
	if exist(split_file, 'file'),
		fprintf('File already exist! Skipped\n');
		return;
	end
	
	meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
	fprintf('load metadata...\n');
	metadata = load(meta_file, 'metadata');
	metadata = metadata.metadata;
	splits = {};

	test_idx = find(metadata.labels == 2);
	train_idx = find(metadata.labels == 1);
	splits{1}.train_idx = train_idx;
	splits{1}.test_idx = test_idx;
	
	save(split_file, 'splits');
	
end
