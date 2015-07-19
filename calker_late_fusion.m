function calker_late_fusion(proj_name, suffix)
	
	if ~exist('suffix', 'var'),
		suffix = '--calker-hmdb51';
	end
	
	ker.proj_dir = 'project/output/';
	ker.proj_name = 'hmdb51';
	ker.type = 'kl2';
	
	addpath('/home/ntrang/project/tools/libsvm-3.18/matlab');
	addpath('/home/ntrang/project/tools/vlfeat-0.9.19-bin/vlfeat-0.9.19/toolbox');

	meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
	fprintf('--- Loading metadata...\n');
	metadata = load(meta_file, 'metadata');
	metadata = metadata.metadata;
	n_class = metadata.numclass;
			
	ker_names = struct;
	ker_names.('hofhogmbh_fc_pca') = 'imprvdensetraj.hoghofmbh.linear.cb256.fc.pca.10.l2';	
	ker_names.('sift_fc_pca') = 'sift.covdet.linear.cb256.fc.pca.10.l2';
				
	calker_exp_dir = sprintf('/home/ntrang/project/output/hmdb51/experiments');
	
	fused_ids = fieldnames(ker_names);
	fusion_name = 'fusion';
	for ii=1:length(fused_ids),
		fusion_name = sprintf('%s.%s', fusion_name, fused_ids{ii});
	end
	
	output_file = sprintf('%s/%s%s/scores/%s.%s.scores.mat', calker_exp_dir, fusion_name, suffix, fusion_name, ker.type);
	output_dir = fileparts(output_file);
	if ~exist(output_dir, 'file'),
		mkdir(output_dir);
	end
	
	fused_scores = struct;
	scores_arr = [];
	for ii=1:n_class,
		event_name = metadata.classes{ii};
		fprintf('Fusing for event [%s]...\n', event_name);
		for jj = 1:length(fused_ids),
			ker_name = ker_names.(fused_ids{jj});
			fprintf(' -- [%d/%d] kernel [%s]...\n', jj, length(fused_ids), ker_name);
			scorePath = sprintf('%s/%s%s/scores/%s.video.scores.mat', calker_exp_dir, ker_name, suffix, ker_name);
			
			if ~exist(scorePath, 'file');
				scorePath = sprintf('%s/%s%s/scores/%s.%s.scores.mat', calker_exp_dir, ker_name, suffix, ker_name, ker.type);
			end
			
			if ~exist(scorePath, 'file');
				error('File not found! [%s]', scorePath);
			end
			
			rawscores = load(scorePath);
			rawscores = rawscores.scores{1};
			if isfield(fused_scores, event_name),			
				%fused_scores.(event_name) = [fused_scores.(event_name); scores.(event_name)];
				fused_scores.(event_name) = [fused_scores.(event_name); rawscores(ii, :)];
			else
				fused_scores.(event_name) = rawscores(ii, :);
			end
		end
		scores_arr = [scores_arr;mean(fused_scores.(event_name))]; %scores: 1 x number of videos
	end
	
	scores = {};
	scores{1} = scores_arr;
	save(output_file, 'scores');
	
	ker.feat = fusion_name;
	ker.name = fusion_name;
	ker.suffix = suffix;
	
	fprintf('Saving...%s\n', output_file);
	fprintf('Calculating MAP...\n');
	calker_cal_map(ker);
end