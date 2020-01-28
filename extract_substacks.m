%To bring all data into same processing stream (one substack/trial as matfile)
%Extract substack for each trial from stitched/registered tiff'
clearvars;

data_dir = 'J:\Data & Analysis\Rule Switching\Data\';
dir_list = dir(data_dir);

%First, get substacks for sessions that were stitched and then registered
for i=1:numel(dir_list)
    
    flist = dir(fullfile(dir_list(i).folder,dir_list(i).name,'registered','*.tif')); %Stacks registered with old method have only one TIF in this dir
    mat_dir = fullfile(dir_list(i).folder,dir_list(i).name,'mat');
    matlist = dir(fullfile(mat_dir,'*.mat'));
    if ~isempty(flist) && numel(flist)<2 && isempty(matlist)
        regDir = fullfile(dir_list(i).folder,dir_list(i).name,'registered');
        regFile = dir(fullfile(regDir,'*.tif'));
        regStack = loadtiffseq(regDir,regFile.name);
        regInfo = dir(fullfile(dir_list(i).folder,dir_list(i).name,'*regData*'));
        
        load(fullfile(regInfo.folder,regInfo.name),'nRepeats','options','params','run_times');
        load(fullfile(regInfo.folder,'stack_info'),'nFrames','rawFileName');
        
        %Create directory for registered matfiles
        create_dirs(mat_dir);
        
        %Tag structure
        tags = get_tagStruct(fullfile(regDir,regFile.name)); %Get tag struct for writing tiffs
        
        %Get frames and assign to trial-indexed substacks
        for j=1:numel(nFrames)
            if j==1
                idx = 1:nFrames(1);
            else
                idx = sum(nFrames(1:j-1))+1 : sum(nFrames(1:j));
            end
            stack = regStack(:,:,idx);
            
            [~,fname,ext] = fileparts(rawFileName{j});
            source = flist.name;
            save(fullfile(mat_dir,fname),'stack','tags','source');
        end
        save(fullfile(dir_list(i).folder,dir_list(i).name,'regInfo'),'nRepeats','options','params','run_times');
    end
    
end

%% Next, convert all registered substacks to MAT...




%Remember to save regInfo.m
%Later, delete regData...