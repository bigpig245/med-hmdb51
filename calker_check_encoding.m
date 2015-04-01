function calker_check_encoding(feature_ext)

% Remove all features contain NaN or all zeros

fea_dir = '/home/ntrang/project/output/hmdb51/feature';
meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
logfile = '/home/ntrang/project/logs/check_encoding_old.log';
logID = fopen(logfile, 'w');
fprintf('load metadata...\n');
metadata = load(meta_file, 'metadata');
metadata = metadata.metadata;

videos = metadata.videos;

num_video_contains_NaN = 0;
num_video_all_zero = 0;
msg = '';
num_sparse = 0;
check_sparse = 65536/2;
% parfor
for ii = 1:length(videos), %
	event_name = metadata.events{ii};
	video_name = videos{ii};
	segment_path = sprintf('%s/%s/%s/%s.mat', fea_dir, feature_ext, event_name, video_name);
	
	if ~exist(segment_path),
		%warning('File [%s] does not exist!\n', segment_path);
		continue;
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
	num_zeros = size(find(code == 0), 1);
	if num_zeros > check_sparse,
		num_sparse = num_sparse + 1;
	end
	%msg = sprintf('%s%s\t:%d\n', msg, video_name, num_zeros);
	%fprintf('%s\t:%d\n', video_name, num_zeros);
	%logmsg(logfile, msg);
end
%logid = fopen(logfile, 'w');
%fprintf(logid, 'Total sparse encoding (zero > %d): %d\n', check_sparse, num_sparse);
%fprintf(logid, msg);
%fclose(logid);
fprintf('Total sparse encoding (zero > %d): %d\n', check_sparse, num_sparse);

sprintf('Total files contain NaN [%d]', num_video_contains_NaN);
sprintf('Total files contain zeros [%d]', num_video_all_zero);

end


