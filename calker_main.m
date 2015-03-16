%function calker_main(feature_ext, feat_dim, ker_type, suffix, open_pool, start_split, end_split, start_class, end_class)
function calker_main(feature_ext, feat_dim, ker_type, suffix)

proj_name = 'hmdb51';

%addpath('/home/ntrang/project/tools/kaori-secode-calker-v7.2-master/support');
addpath('/home/ntrang/project/tools/libsvm-3.18/matlab');
addpath('/home/ntrang/project/tools/libsvm-3.18');
%addpath('/home/ntrang/project/tools/vlfeat-0.9.19-bin/vlfeat-0.9.19/toolbox');

% run vl_setup with no prefix
% vl_setup('noprefix');
vl_setup;


if ~exist('suffix', 'var'),
	%suffix = '--calker-ucf';
    suffix = '--calker-hmdb51';
end

if ~exist('feat_dim', 'var'),
	feat_dim = 4000;
end

if ~exist('ker_type', 'var'),
	ker_type = 'kl2';
end

meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
fprintf('--- Loading metadata...\n');
metadata = load(meta_file, 'metadata');
metadata = metadata.metadata;

split_file = '/home/ntrang/project/output/hmdb51/metadata/splits.mat';
fprintf('--- Loading splits...\n');
splits = load(split_file, 'splits');
splits = splits.splits;

start_split = 1;
end_split = length(splits);

start_class = 1;
end_class = metadata.numclass;

if isempty(strfind(suffix, '-hmdb')),
	warning('**** Suffix does not contain hmdb !!!!!\n');
end

ker = calker_build_kerdb(feature_ext, ker_type, feat_dim, suffix);
ker.proj_name = proj_name;
calker_exp_dir = sprintf('%s/%s/experiments/%s%s', ker.proj_dir, ker.proj_name, ker.feat, ker.suffix);
ker.log_dir = fullfile(calker_exp_dir, 'log');
 
%if ~exist(calker_exp_dir, 'file'),
mkdir(calker_exp_dir);
mkdir(fullfile(calker_exp_dir, 'metadata'));
mkdir(fullfile(calker_exp_dir, 'kernels'));
mkdir(fullfile(calker_exp_dir, 'scores'));
mkdir(fullfile(calker_exp_dir, 'models'));
mkdir(fullfile(calker_exp_dir, 'log'));
%end

%calker_create_database();

%open pool
%if matlabpool('size') == 0 && open_pool > 0, matlabpool(open_pool); end;
calker_load_data(ker);
calker_cal_kernel(ker);
calker_train_kernel(ker, start_split, end_split, start_class, end_class);
calker_test_kernel(ker, start_split, end_split);
%calker_cal_acc_mfcc(ker);
calker_cal_acc(ker);
calker_cal_map(ker);

%close pool
%if matlabpool('size') > 0, matlabpool close; end;
