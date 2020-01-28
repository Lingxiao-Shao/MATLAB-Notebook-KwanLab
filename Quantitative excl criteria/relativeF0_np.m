f = handles.curr_cellf;

tic;
windur = 200; % Duration in frames
f0 = nan(length(f),1);
for i = 1:length(f)
    idx = max(1,i-windur*0.5):min(length(f),i+windur*0.5);
    f0(i) = prctile(f(idx),5);
end
toc

%Same for neuropil annulus...
%np_f0 = 
%f_ratio = mean(f0)./mean(np_f0);