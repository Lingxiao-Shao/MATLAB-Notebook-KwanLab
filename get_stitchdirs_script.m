clearvars;

data_dir = 'J:\Data & Analysis\Rule Switching\Data';
dirs.regData = get_stitch_dirs(data_dir);

%%
dir_list = dir(data_dir);

status = false(numel(dir_list),1);
for i=1:numel(dir_list)
    flist = dir(fullfile(dir_list(i).name,'registered','*.tif'));
    if ~isempty(flist) && numel(flist)<2
        status(i) = true;
    end
end
dirs.stitch = {dir_list(status).name}';
disp(dirs);