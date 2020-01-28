
%function figs = fig_summary_changePoints( transitions, params )

% Get Cell & Transition Types
cellType = fieldnames(transitions);
cellType = cellType(~strcmp(cellType,'all'));
transType = {'sound','action'};

% Setup Figure Properties
setup_figprops([]);
ax = gobjects(numel(transType),numel(cellType));

% Generate Scatter Plots for Neural vs. Behavioral Change-Points
figure('Name','Neural & behavioral change points plotted separately by cell type');
tiledlayout(2,4,'TileSpacing','none','Padding','none');
for i = 1:numel(transType)
    for j = 1:numel(cellType)
        ax(i,j) = nexttile; hold on
        beh_trans = transitions.(cellType{j}).(transType{i}).behChangePt;
        neural_trans = transitions.(cellType{j}).sound.changePt1;
        scatter(beh_trans,neural_trans,params.color.(cellType{j}));
        lims = max([ylim xlim]);
        plot([0 lims],[0 lims],':k');
        axis square
        
        
        
    end
end

% Label axes

for j = 1:numel(cellType)
    %Title for top row
    title(ax(1,j),cellType{j});
    %XLabel bottom row
    xlabel(ax(2,j),'Behavioral transition trial');
end

for i = 1:numel(transType)
    %YLabel left col
    ylabel(ax(i,1),'Neural transition trial');
end
