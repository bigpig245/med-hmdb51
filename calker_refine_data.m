function calker_refine_data()

% Remove all features contain NaN or all zeros

fea_dir = '/home/ntrang/project/output/hmdb51/feature';
meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';

fprintf('load metadata...\n');
metadata = load(meta_file, 'metadata');
metadata = metadata.metadata;

videos = metadata.videos;

num_video_contains_NaN = 0;
num_video_all_zero = 0;
% parfor
for ii = 1:length(videos), %
	event_name = metadata.events{ii};
	video_name = videos{ii};
	segment_path = sprintf('%s/%s/%s/%s.mat', fea_dir, 'idensetraj.mbh.cb256.fc.pca', event_name, video_name);
	
	if ~exist(segment_path),
		warning('File [%s] does not exist!\n', segment_path);
	else
		code = load(segment_path, 'code');
		code = code.code;
	end
	
	if any(isnan(code)),
		warning('Feature contains NaN [%s]. Skipped !!\n', segment_path);
		delete(segment_path);
		num_video_contains_NaN = num_video_contains_NaN + 1;
		continue;
	end
	
	% event video contains all zeros --> skip, keep backgroud video
	if all(code == 0),
		warning('Feature contains all zeros [%s]. Skipped !!\n', segment_path);
		num_video_all_zero = num_video_all_zero + 1;
		delete(segment_path);
		continue;		
	end
	
end

sprintf('Total files contain NaN [%d]', num_video_contains_NaN);
sprintf('Total files contain zeros [%d]', num_video_all_zero);

end


