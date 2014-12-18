%testset: KINDREDTEST (14464 clips), MEDTEST (27033 clips)
% 48396 
function convert_mat_to_csv()
	
	%in_dir = '/net/per610a/export/das11f/plsang/trecvidmed13/feature/segment-100000/densetrajectory.mbh.cb256.fc.pca/devel';
	%out_dir = '/net/per610a/export/das11f/plsang/trecvidmed13/feature/segment-100000/densetrajectory.mbh.cb256.fc.pca/devel-csv';
	
	in_dir = '/net/per610a/export/das11f/plsang/trecvidmed13/feature/segment-100000/densetrajectory.mbh.cb256.fc/devel';
	out_dir = '/net/per610a/export/das11f/plsang/trecvidmed13/feature/segment-100000/densetrajectory.mbh.cb256.fc/devel-csv';
	
	%% dataset
	fprintf('Loading metadata...\n');
	%medmd_file = sprintf('/net/per610a/export/das11f/plsang/trecvidmed13/metadata/common/metadata_devel.mat');
	%metadata = load(medmd_file, 'metadata');
	%metadata = metadata.metadata;
	%clips = fieldnames(metadata);  % 60614 clips
	%clear metadata;
	
	medmd_file = '/net/per610a/export/das11f/plsang/trecvidmed13/metadata/medmd.mat';
	load(medmd_file, 'MEDMD'); 
	
	clips = [MEDMD.EventKit.EK10Ex.clips];
	clips = unique(clips);	% 48396 clips
	
	for ii = 1:length(clips),
		
		clip = clips{ii};
		
		input_file = sprintf('%s/%s/%s.mat', in_dir, clip, clip);
		
		if ~exist(input_file, 'file'),
			warning('File [%s] does not exist\n', input_file);
			continue;
		end
		
		fprintf('[%d/%d] Loading [%s]... \n', ii, length(clips), input_file);
		load(input_file, 'code');
		output_file = sprintf('%s/%s.csv', out_dir, clip);
		fprintf('[%d/%d] Saving [%s]... \n', ii, length(clips), output_file);
		csvwrite(output_file, code);
	end
	

	
end	

