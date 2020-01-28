
%**Remember to restrict to rule modulated neurons before transition analysis...

save_dir = fullfile(dirs.notebook,'Transition analysis');
create_dirs(save_dir); %Create dir for these figures
nSessions = numel(expData);

plot_checkNorm = false;
plot_similarityDiff = false;
plot_binnedSimilarity = true;

stat = 'Cs'; %Statistic to use as similarity measure: {'R','Rho','Cs'}

%% EXPLORE WHETHER THE NORMALITY ASSUMPTION IS SOUND
if plot_checkNorm
    
    fig_dir = fullfile(save_dir,'Boxplots of Origin');
    create_dirs(fig_dir); %Create dir for these figures
    fig = gobjects(nSessions,1); %Initialize graphics array
    
    for idx = 1:numel(expData)
        clear vect
        load(mat_file.results(idx),'transitions');
        T = transitions;
        
        fig(idx) = figure('Name',['Boxplot of Activity Vectors (Origin) - ' T.sessionID]);
        for j = 1:numel(T.origin)
            vect(:,j) = T.origin(j).vector; %#ok<SAGROW>
        end
        boxplot(vect);
        txt.x = max(xlim)-0.2*range(xlim);
        txt.y = min(ylim)+0.1*range(ylim);
        text(txt.x,txt.y,['N = ' num2str(numel(T.cellID))]);
    end
    save_multiplePlots(fig,fig_dir); %save as FIG and PNG
    clearvars fig;
end
% Data consistently right-skewed; use Spearman's Rho or possibly ...

%% COMPARE SIMILARITY OF EACH TRIAL VECTOR TO DESTINATION & ORIGIN
if plot_similarityDiff
    
    fig_dir = fullfile(save_dir,'Evolution of Similarity within Blocks');
    create_dirs(fig_dir); %Create dir for these figures
    fig = gobjects(nSessions,1); %Initialize graphics array
    
    for idx = 1:nSessions
        clearvars d;
        load(mat_file.results(idx),'transitions');
        T = transitions;
        
        % Difference between dest and origin
        for i = 1:numel(transitions.type)
            dest = T.destination(i).similarity.(stat);
            origin = T.origin(i).similarity.(stat);
            dif{i} = (dest-origin); %Note that distance rather than similarity was used in NatNeuro study...
        end
        
        % Plot specified similarity difference
        soundIdx = find(ismember(T.type,{'actionL_sound','actionR_sound'}));
        actionIdx = find(ismember(T.type,{'sound_actionL','sound_actionR'}));
        
        fig(idx) = figure('Name',[expData(idx).sub_dir ' Similarity Ratio - Sound Blocks (' stat ')']);
        for i = soundIdx'
            X = 1:numel(dif{i});
            mdl = fitlm(X,dif{i});
            p = plot(dif{i},'o','LineStyle','none'); hold on
            plot(X,mdl.Fitted,'Color',p.Color);
        end
        fig(nSessions+idx) = figure('Name',[expData(idx).sub_dir ' Similarity Ratio - Action Blocks (' stat ')']);
        % Plot specified similarity ratio
        for i = actionIdx'
            X = 1:numel(dif{i});
            mdl = fitlm(X,dif{i});
            p = plot(dif{i},'o','LineStyle','none'); hold on
            plot(X,mdl.Fitted,'Color',p.Color);
        end
        
    end
    save_multiplePlots(fig,save_dir); %save as FIG and PNG
    clearvars fig;
end

%% BIN DATA FROM EACH BLOCK

if plot_binnedSimilarity
    setup_figprops('timeseries');
    fig_dir = fullfile(save_dir,'Evolution of Similarity Index by Rule (binned)');
    create_dirs(fig_dir); %Create dir for these figures
    fig = gobjects(nSessions,1); %Initialize graphics array
    
    for i = 1:nSessions
        
        load(mat_file.results(i),'transitions');
        T = transitions;
        fig(i) = figure('Name',[expData(i).sub_dir ' ' T.params.stat]);
        fig(i).Position = [100,100,900,600];
        tiledlayout(1,2);
        
        X = T.diffSimilarity.binIdx;
        
        %Sound blocks
        ax(1) = nexttile;
        for j = 1:size(T.aggregate.sound,1)
            Y = T.aggregate.sound(j,:);
            plot(X,Y,'Color',[0.5 0.5 0.5],'Marker','none','LineWidth',1); hold on;
        end
        Y = mean(T.aggregate.sound);
        plot(X,Y,'Color','k','Marker','none','LineWidth',3);
        title('Action->Sound');
        ylabel([T.params.stat '(dest)-' T.params.stat '(origin)']);
        axis square;
        
        %Action blocks
        ax(2) = nexttile;
        for j = 1:size(T.aggregate.action,1)
            Y = T.aggregate.action(j,:);
            plot(X,Y,'Color',[0.5 0.5 0.5],'Marker','none','LineWidth',1); hold on;
        end
        Y = mean(T.aggregate.action);
        plot(X,Y,'Color','r','Marker','none','LineWidth',3);
        title('Sound->Action');
        axis square;
        
        lims = cell2mat(ylim(ax));
        set(ax,'YLim',[min(lims(:)) max(lims(:))]);
        for j=1:numel(ax)
            plot(ax(j),[0,0],ylim,':k','LineWidth',1); %t0
            xlabel(ax(j),'Number of bins from rule switch');
            ax(j).XTick = X;
            box(ax(j),'off');
        end
    end
    
    %Save all figures
    save_multiplePlots(fig,fig_dir); %save as FIG and PNG
    clearvars fig;
    
      
    % Modified for inclusion in calc_transitionResults():
    %     for i = 1:nSessions
    %         clearvars d;
    %         load(mat_file.results(i),'transitions');
    %         T = transitions;
    %
    %         % Difference between dest and origin
    %         P = 1/nBins:1/nBins:1; %N evenly spaced quantiles for trial indices
    %         for j = 1:numel(transitions.type)
    %             dest = T.destination(j).similarity.(stat);
    %             origin = T.origin(j).similarity.(stat);
    %             values = (dest-origin); %Note that distance rather than similarity was used in NatNeuro study...
    % %
    %             X = 1:numel(values);
    %             edges = [0 round(quantile(X,P))]; %Split results into evenly spaced bins
    %             for k = 1:numel(edges)-1
    %                 idx = edges(k)+1:edges(k+1);
    %                 binned(k) = mean(values(idx));
    %             end
    % %             %OR
    % %             for k = unique(bin)
    % %                 binned(k) = mean(values(bin==k));
    % %             end
    %             T.diffSimilarity(j).values = values;
    %             T.diffSimilarity(j).binned = binned;
    %         end
    %         % Aggregate rule type specific transitions
    %         soundIdx    = find(ismember(T.type,{'actionL_sound','actionR_sound'}));
    %         actionIdx   = find(ismember(T.type,{'sound_actionL','sound_actionR'}));
    %         T.all       = mean(cell2mat({T.diffSimilarity.binned}'));
    %         T.sound     = mean(cell2mat({T.diffSimilarity(soundIdx).binned}'));
    %         T.action    = mean(cell2mat({T.diffSimilarity(actionIdx).binned}'));
    %     end
end

