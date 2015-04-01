function ker = calker_build_kerdb(feature_raw, feat_norm, ker_type, feat_dim, suffix)

% Build kernel database,
ker.suffix 	 = suffix;		% suffix used for naming experiment folder
ker.type     = ker_type ;
ker.feat_norm = feat_norm;
ker.feat_raw = feature_raw;
feature_ext = [feature_raw, '.', ker.feat_norm];

ker.feat     = feature_ext ;
ker.fea_fmt  = 'dvf';
ker.num_dim = feat_dim; %98304;
%ker.num_dim = 65536;
ker.pyrLevel = [] ;
ker.histName = [feature_ext '.dev_hists'];
ker.scaleparamsName = [feature_ext '.scaleparams.' ker_type];
ker.testHists = [feature_ext '.test_hists.' ker_type];
ker.name = feature_ext;
ker.resname = [feature_ext '.calker.' ker_type];
ker.devname = [feature_ext '.devel.' ker_type];
ker.testname = [feature_ext '.test.' ker_type];
ker.descname = [feature_ext '.desc.' ker_type];
ker.feature_scale = 0;
ker.chunk_size = 100;  % number of samples per each test chunk

ker.cross = 0; % whether to do cross validation or not
if exist('cross', 'var'),
	ker.cross = cross;
end
% common params for cross validation
ker.startC = -10;
ker.endC = 0;
ker.stepC = 2;

ker.startG = -12;
ker.endG = 3;
ker.stepG = 1;

ker.proj_dir = 'project/output/';
end
