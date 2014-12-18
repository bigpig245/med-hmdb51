% when using screen (it unsets environment variables...)
% not working
% system('export LD_LIBRARY_PATH=/net/per900b/raid0/ledduy/usr.local/lib:/home/ntrang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH');

% vlfeat
run('/home/ntrang/tools/vlfeat-0.9.16/toolbox/vl_setup');

% libsvm
addpath('/home/ntrang/tools/libsvm-3.12/matlab');

addpath('/home/ntrang/codes/common');

% mfcc - kmail
addpath('/home/ntrang/tools/mfcc-kamil');

% voicebox
addpath('/home/ntrang/tools/voicebox');

% rastamat
addpath('/home/ntrang/software/rastamat');

% lib gmm-fisher
addpath('/home/ntrang/tools/gmm-fisher-kaori/matlab');

% gist descriptor
addpath('/home/ntrang/software/gistdescriptor');

%featpipem_addpaths
