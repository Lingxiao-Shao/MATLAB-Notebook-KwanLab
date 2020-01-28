% Get all dirs in which data were first stitched and then registered 
%   in order to bring them into conformation with processing pipeline.  

function dirs = get_stitch_dirs(data_dir)

dir_list = dir(data_dir);

status = false(numel(dir_list),1);
for i=1:numel(dir_list)
    flist = dir(fullfile(dir_list(i).name,'*regData*.mat'));
    if ~isempty(flist)
        status(i) = true;
    end
end
dirs = {dir_list(status).name}';
disp(dirs);