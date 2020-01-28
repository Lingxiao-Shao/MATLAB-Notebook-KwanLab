clearvars;
tic;

data_dir = 'J:\Data & Analysis\Rule Switching';
[dirs,expData] = expData_RuleSwitching_DEVO(data_dir);
save_dir = fullfile(dirs.figures,'ROI images');   %Figures directory: cellular fluorescence
create_dirs(save_dir); %Create dir for these figures

subtractmaskRadii = [0,2];
for i = 1:numel(expData)
    roi_dir = fullfile(dirs.data,expData(i).sub_dir,expData(i).roi_dir);
    get_neuropilMasks(roi_dir,subtractmaskRadii);
end

toc