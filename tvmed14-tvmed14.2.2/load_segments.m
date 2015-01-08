function [ segments ] = load_segments( segment_ann, sz_pat )
%LOAD_SEGMENTS Summary of this function goes here
%   Detailed explanation goes here
    
	f_seg_meta = sprintf('/home/ntrang/project/output/%s/metadata/segments.%s.mat', segment_ann, sz_pat);
	
	if exist(f_seg_meta, 'file'),
		load(f_seg_meta, 'segments');
		return;
	end
	
	%videolst = sprintf('/net/per610a/export/das11f/plsang/trecvidmed13/metadata/common/trecvidmed13.%s.lst', sz_pat);

    %fh = fopen(videolst, 'r');
    %infos = textscan(fh, '%s');
    %fclose(fh);
    
    %videos = infos{1};
    
    %segments = cell(length(videos), 1);
    %for ii = 1:length(videos),
    f_metadata = '/home/ntrang/project/output/database/hmdb51.database.mat';
    
	fprintf('Loading metadata...\n');
    metadata_ = load(f_metadata);
    metadata = metadata_.database;
    for i = 1:length(metadata.event_names),
        event_name = metadata.event_names{i};
        event_info = metadata.events.(event_name);
        for ii = 1:length(event_info),
            if ~mod(ii, 1000),
                fprintf('%d ', ii);
            end
            video = event_info{ii};

            if strcmp(sz_pat, 'dev'),
                mfile = sprintf('/net/per610a/export/das11f/plsang/trecvidmed13/metadata/%s/%s/%s.lst', segment_ann, 'devel', video);
            else
                mfile = sprintf('/net/per610a/export/das11f/plsang/trecvidmed13/metadata/%s/%s/%s.lst', segment_ann, sz_pat, video);
            end

            fh = fopen(mfile);
            this_segments = textscan(fh, '%s');
            this_segments = this_segments{1};
            %segments = [segments; this_segments];
            segments{ii} = this_segments;
            fclose(fh);
        end
    end
	
	segments = cat(1, segments{:});
	% save segment_metadata
	save(f_seg_meta, 'segments');
	
end

