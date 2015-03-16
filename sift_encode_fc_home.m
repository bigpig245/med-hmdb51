function sift_encode_fc_home( proj_name, exp_ann, sift_algo, param, codebook_size, dimred, spm, start_seg, end_seg)
%ENCODE Summary of this function goes here
%   Detailed explanation goes here
%% kf_dir_name: name of keyframe folder, e.g. keyframe-60 for segment length of 60s   

	% update: Jun 25th, SPM suported
    % setting
    set_env;
        
    % encoding type
    enc_type = 'fisher';
	
	%f_metadata = sprintf('/net/per610a/export/das11f/plsang/trecvidmed13/metadata/common/metadata_devel.mat');  % for kinddevel only
	%fprintf('Loading basic metadata...\n');
	%metadata = load(f_metadata, 'metadata');
	%metadata = metadata.metadata;
	
	if ~exist('codebook_size', 'var'),
		codebook_size = 256;
	end
    
	if ~exist('spm', 'var'),
		spm = 0;
	end
	
	default_dim = 128;
	if ~exist('dimred', 'var'),
		dimred = 80;
	end
	
	feature_ext = sprintf('%s.%s.bg.sift.cb%d.%s', sift_algo, num2str(param), codebook_size, enc_type);
	if spm > 0,
		feature_ext = sprintf('%s.spm', feature_ext);
	end
	
	if dimred < default_dim,
		feature_ext = sprintf('%s.pca', feature_ext);
	end
	
	%output_dir = sprintf('/net/per610a/export/das11f/plsang/%s/feature/%s/%s', proj_name, exp_ann, feature_ext);
    output_dir = sprintf('/home/ntrang/project/output/%s/feature/encode', proj_name);
    if ~exist(output_dir, 'file'),
		mkdir(output_dir);
    end
    
    codebook_file = '/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/idensetraj.mbh/data/codebook.gmm.training.256.192.mat';
		
	fprintf('Loading codebook [%s]...\n', codebook_file);
    codebook_ = load(codebook_file, 'codebook');
    codebook = codebook_.codebook;
 
 	low_proj = [];
	if dimred <= default_dim,
		lowproj_file = '/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/idensetraj.mbh/data/lowproj.training.128.192.mat';
			
		fprintf('Loading low projection matrix [%s]...\n', lowproj_file);
		low_proj_ = load(lowproj_file, 'low_proj');
		low_proj = low_proj_.low_proj;
	end

	%fprintf('Loading metadata...\n');
	%medmd_file = '/net/per610a/export/das11f/plsang/trecvidmed13/metadata/medmd.mat';
	%load(medmd_file, 'MEDMD'); 
	
	%train_clips = [MEDMD.EventKit.EK10Ex.clips, MEDMD.EventKit.EK100Ex.clips, MEDMD.EventKit.EK130Ex.clips, MEDMD.EventBG.default.clips];
	%train_clips = unique(train_clips);
	
	%test_clips = MEDMD.RefTest.KINDREDTEST.clips;
	
	%clips = [train_clips, test_clips];
    
    video_dir = '/home/ntrang/project/dataset/hmdb51';
	clips = dir(video_dir);
    
    if ~exist('start_seg', 'var') || start_seg < 1,
        start_seg = 1;
    end
    
    if ~exist('end_seg', 'var') || end_seg > length(clips),
        end_seg = length(clips);
    end
    
    %tic
	
    kf_dir = sprintf('/home/ntrang/project/output/hmdb51/keyframes');
    
    f_metadata = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
    load(f_metadata, 'metadata');
    
    for i = 1:length(metadata.videos),
        event_name = metadata.classes{i};
        video_name = metadata.videos{i};
        label = metadata.labels{i};
        
        if label == 2, %if video is used for training, ignore it
            continue;
        end
        
        
        output_file = sprintf('%s/%s/%s.mat', output_dir, event_name, video_name);
		
        if exist(output_file, 'file'),
            fprintf('File [%s] already exist. Skipped!!\n', output_file);
            continue;
        end
        
		video_kf_dir = fullfile(kf_dir, event_name, video_name);
		%video_kf_dir = video_kf_dir(1:end-4);
		kfs = dir([video_kf_dir, '/*.jpg']);
       
		%% update Jul 5, 2013: support segment-based
		
		fprintf(' [%d --> %d --> %d] Extracting & encoding for [%s - %d kfs]...\n', start_seg, i, end_seg, video_name, length(kfs));
        
		code = cell(length(kfs), 1);
		
		for jj = 1:length(kfs),
			if ~mod(jj, 10),
				fprintf('%d ', jj);
			end
			img_name = kfs(jj).name;
			img_path = fullfile(video_kf_dir, img_name);
			
			[frames, descrs] = sift_extract_features( img_path, sift_algo, param )
            
            % if more than 50% of points are empty --> possibley empty image
            count_zero_points = sum(all(descrs == 0, 1));
            numbers_of_points = size(descrs, 2);
            if isempty(descrs) || count_zero_points > 0.5*numbers_of_points,
                warning('Maybe blank image...[%s]. Skipped!\n', img_name);
                descrs = descrs(:, any(descrs));
                %continue;
            end
			
			code_ = sift_do_encoding(enc_type, descrs, codebook, [], low_proj);
			code{jj} = code_;	
		end 
        
		code = cat(2, code{:});
		code = mean(code, 2);
		
		% apply power normalization again
		code = sign(code) .* sqrt(abs(code));
		
        par_save(output_file, 'code'); % MATLAB don't allow to save inside parfor loop             
        
    end
    
    %toc
    % quit;

end