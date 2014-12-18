function [frames, feats] = load_fspace_feature(feat_file, fmt_str)
	if ~exist('fmt_str', 'var'),
		fmt_str = '%f %f %f %f %f';
		for ii = 1:128,
			fmt_str = [fmt_str ' %d'];
		end
	end
	
	fid = fopen(feat_file, 'r');
	
	if fid ~= -1,
		num_dim = textscan(fid, '%d', 1);
		num_desc = textscan(fid, '%d', 1);
		
		feats = textscan(fid, fmt_str);
		frames = cell2mat(feats(:,1:2));
		frames = frames';				
		feats = cell2mat(feats(:,6:133)); 	% discard first 5 parameters
		feats = feats';						% do transpose: 128 x numpoints
		fclose(fid);
	else
		frames = [];
		feats = [];
	end

end