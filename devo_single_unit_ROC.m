
analyze_RuleSwitching; %Run script to obtain decoding results

%%

fig = gobjects(numel(decode.choice.selectivity),1);
for idx = 1:numel(decode.choice.selectivity)

% Plot AUROC with CI as a function of time
fig(idx) = figure('Name',['Cell ' num2str(idx) ' ' 'ROC']);
subplot(1,3,1); hold on;
title(['ROC (choice): cell ' num2str(idx)]);
ylabel('Area under ROC curve');
xlabel('Time relative to sound cue');
%Shuffled class labels
Y = decode.choice.AUC_shuffle{idx};
Y = prctile(Y,[5,95],1); %Confidence intervals for shuffle
errorshade(decode.t, Y(1,:), Y(2,:), 'k', 0.1); %errorshade(x,h,l,c,t)
%True class labels
Y = decode.choice.AUC{idx};
plot(decode.t,Y,'k-','LineWidth',3);
plot([0 0],ylim,'k-'); %t0
axis square tight;

%ROC curve
sample = 17; %~2sec
subplot(1,3,2);hold on;
title('ROC at 2s');
ylabel('True positive rate');
xlabel('False positive rate');
plot(decode.choice.FPR{idx}(:,sample),...
    decode.choice.TPR{idx}(:,sample),'k-','LineWidth',3); %ROC curve
plot(decode.choice.FPR_shuffle{idx}(:,sample),...
    decode.choice.TPR_shuffle{idx}(:,sample),...
    ':','Color',[0.5 0.5 0.5],'LineWidth',3); %Shuffled ROC curve
legend('ROC','Shuffle','Location','southeast');
axis square;

% Plot bootstrapped selectivity and shuffle
subplot(1,3,3); hold on;
title('Selectivity Index');
ylabel('Selectivity = 2(AUC-0.5)');
xlabel('Time relative to sound cue');
Y = decode.choice.selectivity{idx};
errorshade(decode.t, Y(2,:), Y(3,:), 'k', 0.2); %errorshade(x,h,l,c,t)
plot(decode.t,Y(1,:),'k-','LineWidth',3); 
plot([decode.t(1) decode.t(end)],[0 0],'k:'); %Zero selectivity
plot([0 0],ylim,'k-'); %t0
axis square tight;

% Screen position/dimensions
fig(idx).Position = [400 100 1200 800];

end

%Save
% save_path = 'J:\Data & Analysis\Rule Switching\Notebook';
% save_singleUnitPlots(fig,save_path);