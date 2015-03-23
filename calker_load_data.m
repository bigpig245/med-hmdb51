
function calker_load_data(ker)

%%Update change parameter to ker
% load database


fea_dir = '/home/ntrang/project/output/hmdb51/feature';
meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';

fprintf('load metadata...\n');
metadata = load(meta_file, 'metadata');
metadata = metadata.metadata;

videos = metadata.videos;



calker_exp_dir = sprintf('%s/%s/experiments/%s%s', ker.proj_dir, ker.proj_name, ker.feat, ker.suffix);

histPath = sprintf('%s/kernels/%s.mat', calker_exp_dir, ker.histName);
selPath = sprintf('%s/kernels/%s.sel.mat', calker_exp_dir, ker.histName);
if exist(histPath, 'file'),
	fprintf('Exist [%s]!\n', histPath);
	return;
end

data = struct;
hists = zeros(ker.num_dim, length(videos));
selected_idx = ones(1, length(videos));
num_video_contains_NaN = 0;
num_video_all_zero = 0;
samples = [48,18,44,51,46,45,21,9,33,7];
% parfor
for ii = 1:length(videos), %
	event_name = metadata.events{ii};
	video_name = videos{ii};
	segment_path = sprintf('%s/%s/%s/%s.mat', fea_dir, ker.feat_raw, event_name, video_name);
	classid = metadata.classids(ii);
	if isempty(find(samples == classid)),
		fprintf('[%s] is not in samples, ignore!!\n', event_name);
		continue;
	end
	
	if ~exist(segment_path),
		warning('File [%s] does not exist!\n', segment_path);
		code = zeros(ker.num_dim, 1);
	else
		code = load(segment_path, 'code');
		code = code.code;
	end
	
	codebook_size = size(code, 1);
	if codebook_size ~= ker.num_dim,
		warning('Dimension mismatch [%d-%d-%s]. Skipped !!\n', size(code, 1), ker.num_dim, segment_path);
		code = zeros(ker.num_dim, 1);
		continue;
	end
	
	if any(isnan(code)),
		warning('Feature contains NaN [%s]. Skipped !!\n', segment_path);
		%msg = sprintf('Feature contains NaN [%s]', segment_path);
		num_video_contains_NaN = num_video_contains_NaN + 1;
		code = zeros(ker.num_dim, 1);
		continue;
	end
	
	% event video contains all zeros --> skip, keep backgroud video
	if all(code == 0),
		warning('Feature contains all zeros [%s]. Skipped !!\n', segment_path);
		num_video_all_zero = num_video_all_zero + 1;
		continue;
		
		selected_idx(ii) = 0;
	end
	
	if ~all(code == 0),
		
		%code = sign(code) .* sqrt(abs(code));
		
		if strcmp(ker.feat_norm, 'l1'),
			code = code / norm(code, 1);
		elseif strcmp(ker.feat_norm, 'l2'),
			code = code / norm(code, 2);
		else
			error('unknown norm!\n');
		end
	end
	
	hists(:, ii) =  code;
	
end

data.hists = hists;
data.selected_idx = selected_idx;

fprintf('Saving data...\n');
save(histPath, 'data', '-v7.3');
save(selPath, 'selected_idx');

end


