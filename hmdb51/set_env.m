% when using screen (it unsets environment variables...)
% not working
% system('export LD_LIBRARY_PATH=/net/per900b/raid0/ledduy/usr.local/lib:/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH');

% vlfeat
% run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
run('/home/ntrang/project/tools/vlfeat-0.9.19-bin/vlfeat-0.9.19/toolbox/vl_setup');

% libsvm
% addpath('/net/per900a/raid0/plsang/tools/libsvm-3.12/matlab');
addpath('/home/ntrang/project/tools/libsvm-3.18/matlab');

% common
% addpath('/net/per610a/export/das11f/plsang/codes/common');
addpath('/home/ntrang/project/codes/common');

% mfcc - kamil
% addpath('/net/per900a/raid0/plsang/tools/mfcc-kamil');
addpath('/home/ntrang/project/tools/mfcc/mfcc');

% voicebox
% addpath('/net/per900a/raid0/plsang/tools/voicebox');
addpath('/home/ntrang/project/tools/voicebox');

% rastamat
% addpath('/net/per900a/raid0/plsang/software/rastamat');
addpath('/home/ntrang/project/tools/rastamat');

% lib gmm-fisher
% addpath('/net/per900a/raid0/plsang/tools/gmm-fisher-kaori/matlab');
addpath('/home/ntrang/project/tools/gmm-fisher/matlab');

% gist descriptor
% addpath('/net/per900a/raid0/plsang/software/gistdescriptor');
addpath('/home/ntrang/project/tools/gistdescriptor');

%featpipem_addpaths
