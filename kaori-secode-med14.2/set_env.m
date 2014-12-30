% when using screen (it unsets environment variables...)
% not working
% system('export LD_LIBRARY_PATH=/net/per900b/raid0/ledduy/usr.local/lib:/home/ntrang/project/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH');

% vlfeat
run('/home/ntrang/project/tools/vlfeat-0.9.19-bin/vlfeat-0.9.19/toolbox/vl_setup');

% libsvm
addpath('/home/ntrang/project/tools/libsvm-3.12/matlab');

addpath('/home/ntrang/project/codes/common');

% mfcc - kmail
addpath('/home/ntrang/project/tools/mfcc-kamil');

% voicebox
addpath('/home/ntrang/project/tools/voicebox');

% rastamat
addpath('/home/ntrang/project/software/rastamat');

% lib gmm-fisher
addpath('/home/ntrang/project/tools/gmm-fisher-kaori/matlab');

% gist descriptor
addpath('/home/ntrang/project/tools/gistdescriptor');

%featpipem_addpaths
