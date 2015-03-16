function [ output_args ] = sift_encode_home( proj_name, kf_dir_name, szPat, codebook_size, spm, sift_algo, descriptor, param, start_seg, end_seg )
%ENCODE Summary of this function goes here
%   Detailed explanation goes here
%% kf_dir_name: name of keyframe folder, e.g. keyframe-60 for segment length of 60s   

	% update: Jun 25th, SPM suported
    % setting
    set_env;

    %fea_dir = sprintf('/net/per900a/raid0/plsang/%s/feature/%s', proj_name, kf_dir_name);
    fea_dir = sprintf('/home/ntrang/project/%s/feature/%s', proj_name, kf_dir_name);
    if ~exist(fea_dir, 'file'),
            mkdir(fea_dir);
    end
        
    % encoding type
    enc_type = 'fisher';
	
	if ~exist('codebook_size', 'var'),
		codebook_size = 4000;
	end
    
	feature_ext = sprintf('%s.%s.sift.Soft-%d-VL2.%s.devel', sift_algo, num2str(param), codebook_size, proj_name);
	if spm > 0,
		feature_ext = sprintf('%s.spm', feature_ext);
	end
	
    output_dir = sprintf('%s/%s.%s/%s', fea_dir, feature_ext, enc_type, szPat) ;
    if ~exist(output_dir, 'file'),
		mkdir(output_dir);
	end
    
    %codebook_file = sprintf('/home/ntrang/project/%s/feature/bow.codebook.%s.devel/%s.%s.sift/data/codebook.%d.mat', proj_name, proj_name, sift_algo, num2str(param), codebook_size);
    %codebook_file = sprintf('/home/ntrang/project/output/%s/feature/bow.codebook.devel/%s.%s/data/codebook.gmm.training.256.192.mat', proj_name, sift_algo, descriptor);
	codebook_file = '/home/ntrang/project/output/hmdb51/feature/bow.codebook.devel/idensetraj.mbh/data/codebook.gmm.training.256.192.mat';
	fprintf('Loading codebook [%s]...\n', codebook_file);
    codebook_ = load(codebook_file, 'codebook');
    codebook = codebook_.codebook;
    
	kdtree = vl_kdtreebuild(codebook.mean);
	
    %[segments, sinfos, vinfos] = load_segments(proj_name, szPat, kf_dir_name);
    %[segments, sinfos, vinfos] = load_segments(proj_name, szPat);
    
    if ~exist('start_seg', 'var') || start_seg < 1,
        start_seg = 1;
    end
    
    if ~exist('end_seg', 'var') , %|| end_seg > length(segments),
        end_seg = length(segments);
    end
    
    video_dir = '/home/ntrang/project/dataset/hmdb51/';
	
    %kf_dir = sprintf('/home/ntrang/project/%s/keyframes/%s', proj_name, szPat);
    kf_dir = sprintf('/home/ntrang/project/output/%s/keyframes', proj_name);
	
	if strcmp(proj_name, 'trecvidmed10'),
		kf_dir = sprintf('/home/ntrang/project/%s/keyframes', proj_name);
    end
    
    f_metadata = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
    load(f_metadata, 'metadata');
    
    for i = 1:length(metadata.videos),
        event_name = metadata.classes{i};
        video_name = metadata.videos{i};
        label = metadata.labels{i};
        
        if label == 2, %if video is used for training, ignore it
            continue;
        end
        
        video_file = sprintf('%s/%s/%s.avi', video_dir, event_name, video_name);
        
		
        %parfor ii = start_seg:end_seg,
        %segment = segments{ii};                 
    
        %pattern =  '(?<video>\w+)\.\w+\.frame(?<start>\d+)_(?<end>\d+)';
        %info = regexp(segment, pattern, 'names');
        
        output_file = [output_dir, '/', video_name, '.mat'];
        if exist(output_file, 'file'),
            fprintf('File [%s] already exist. Skipped!!\n', video_file);
            continue;
        end
        
        video_kf_dir = fullfile(kf_dir, event_name, video_name);
        
        %start_frame = str2num(info.start);
        %end_frame = str2num(info.end);
        
		kfs = dir([video_kf_dir, '/*.jpg']);
       
		%% update Jul 5, 2013: support segment-based
		%max_frames = get_num_frames(video_file);
		%max_keyframes = get_num_frames(length(dir(video_file))-2);
		
        %start_kf = floor(start_frame*max_keyframes/max_frames) + 1;
		%end_kf = floor(end_frame*max_keyframes/max_frames);
		
		%fprintf(' [%d --> %d --> %d] Extracting & encoding for [%s - %d/%d kfs (%d - %d)]...\n', start_seg, ii, end_seg, segment, end_kf - start_kf + 1, max_keyframes, start_kf, end_kf);
        fprintf(' [%d/%d] Extracting & encoding for %s...\n', i, length(metadata.videos), video_name);
		
        code = [];
		%for jj = start_kf:end_kf,
        for jj = 1: length(kfs),
			if ~mod(jj, 10),
				fprintf('%d ', jj);
			end
			img_name = kfs(jj).name;
			img_path = fullfile(video_kf_dir, img_name);
			
			try
				im = imread(img_path);
			catch
				warning('Error while reading image [%s]!!\n', img_path);
				continue;
			end
			
			[frames, descrs] = sift_extract_features( img_path, sift_algo, param )
            
            % if more than 50% of points are empty --> possibley empty image
            % trangnt remove all column 0
            % descrs = descrs(:,any(descrs));
            if sum(all(descrs == 0, 1)) > 0.5*size(descrs, 2),
                warning('Maybe blank image...[%s]. Skipped!\n', img_name);
            %    continue;
            end
			
			if spm > 0
				code_ = sift_encode_spm(enc_type,size(im), frames, descrs, codebook, kdtree);
			else
				code_ = kcb_encode(descrs, codebook, kdtree);	
			end
			
			code = [code code_];
		end
		fprintf('\n');
		% averaging...
		code = mean(code, 2);
                
        % output code
        output_vdir = [output_dir, '/', video_name];
        if ~exist(output_vdir, 'file'),
            mkdir(output_vdir);
        end
        
        
        par_save(output_file, code); % MATLAB don't allow to save inside parfor loop             
        
    end
    
    %toc
    % quit;

end

function par_save( output_file, code )
  save( output_file, 'code', '-v7.3');
end

function log (msg)
	fh = fopen('sift_encode_home.log', 'a+');
    msg = [msg, ' at ', datestr(now)];
	fprintf(fh, msg);
	fprintf(fh, '\n');
	fclose(fh);
end

function num_frames = get_num_frames(video_file)   

    cmd = sprintf('ffmpeg -i %s 2>&1 | sed -n "s/.*Duration: \\([^,]*\\), .*/\\1/p"', video_file);
    %cmd = sprintf('ffmpeg -i %s', video_file);

    try
        [~, duration] = system(cmd);
    catch
        
    end

    info = regexp(strtrim(duration), pattern, 'names');

    t = str2num(info.hh)*3600 + str2num(info.mm)*60 + str2num(info.ss);

    fps = 30; % use old ffmpeg > cannot get fps

    num_frames = floor(t * fps);
end