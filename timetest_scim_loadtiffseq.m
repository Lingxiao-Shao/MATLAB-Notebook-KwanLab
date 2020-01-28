
path = 'J:\Data & Analysis\Processing Pipeline\2 iNoRMCorre R2G\180416 M53 Discrim\raw';
filename = '180416 M53 Discrim 001.tif';

%loadTiffSeq
tic;
stack1 = loadtiffseq(path,filename); % load raw stack (.tif)
timer1 = toc;

%scim_openTif
tic;
[header] = scim_openTif(fullfile(path,filename));
timer2 = toc;