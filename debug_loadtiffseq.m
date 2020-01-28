
handles.pathname = 'J:\Data & Analysis\Rule Switching\Data\171005 M50 RuleSwitching';
handles.filename = 'NRMC_171005 M50 RuleSwitching  _regDS2.tif';

tic;
disp(['Loading ' handles.pathname handles.filename '...']);
handles.stack = double(loadtiffseq(handles.pathname,handles.filename));
toc