%%
clearvars;
% Set MATLAB path and get experiment-specific parameters
[dirs, expData] = expData_RuleSwitching(pathlist_RuleSwitching);
%[dirs, expData] = expData_RuleSwitching_DEVO(pathlist_RuleSwitching);
% Set parameters for analysis
[calculate, summarize, do_plot, mat_file, params] = params_RuleSwitching(dirs,expData);
% Generate directory structure
create_dirs(dirs.results,dirs.summary,dirs.figures);

plot_adjusted_RT = false;
regress_RT = true;

params.reactionTime.pThresh = 25;
params.reactionTime.COR.predictors =...
    {'choice','priorChoice','outcome','priorOutcome','rule','trialIdx'};
params.reactionTime.COR.subset = 'last20';
params.reactionTime.transitions.predictors =...
    {'choice','transType','transIdx','trialIdx'};
params.reactionTime.transitions.subset = 'trans20';
params.figs.FaceAlpha = 0.2;

%%
if regress_RT
    for i = 1:numel(expData)
        load(mat_file.behavior(i),'trialData','trials','blocks');
        RT = calc_reactionTimeStats(trialData,trials,blocks,params.reactionTime);
        save(mat_file.behavior(i),'RT','-append');
    end
end

if plot_adjusted_RT
    save_dir = fullfile(dirs.figures,'Reaction Time');   %Figures directory: cellular fluorescence
    create_dirs(save_dir); %Create dir for these figures
    figs = gobjects(numel(expData),1); %Initialize figures
    for i = 1:numel(expData)
        behavior = load(mat_file.behavior(i));
        figs(i) = fig_RTbyTrial(behavior,params.figs);
        figs(i+numel(expData)) = fig_RTbyTrial(behavior,params.figs,'correct');
    end
    %Save batch as FIG and PNG
    save_multiplePlots(figs,save_dir);
    clearvars figs;
end


%[ B, CI, RT_corrected, stats ] = regress_RT( behavior.trialData.reactionTimes, behavior.blocks );