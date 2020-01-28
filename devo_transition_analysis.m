function figs = fig_transitions_heatmap( transitions, params )

nTrans = numel(transitions.type);
D = zscore([transitions.medianDFF{:}],0,2);

figure;
ax(1) = subplot(2,1,1); hold on;
imagesc(D); colormap(flipud(cbrewer('seq','Blues',256))); %[colormap] = cbrewer(ctype, cname, ncol [, interp_method])
ax(2) = subplot(2,1,2); hold on;
plot(median(D));

%Colored bars for rule switches
color = cell(nTrans,1); 
color(:) = {[0.5 0.5 0.5]};
color(strcmp(transitions.type,'actionL_sound')) = {'r'};
color(strcmp(transitions.type,'actionR_sound')) = {'b'};

axis(ax,'tight');
for i = 1:nTrans
    X = transitions.firstTrial(i);
    plot(ax(1),[X,X],ax(1).YLim,'Color',color{i},'LineWidth',1);
    plot(ax(2),[X,X],ax(2).YLim,'k:','LineWidth',1);
end
