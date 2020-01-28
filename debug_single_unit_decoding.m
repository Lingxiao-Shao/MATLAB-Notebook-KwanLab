
analyze_RuleSwitching; %Run script to obtain decoding results

type = [upper(params.decode.classifier_type(1)) params.decode.classifier_type(2:end)];
fig = gobjects(numel(decode.choice.accuracy),1);
for idx = 1:numel(decode.choice.accuracy)

% Plot accuracy and shuffle
fig(idx) = figure('Name',['Cell ' num2str(idx) ' ' type]);
subplot(1,3,1); hold on;
title([type ' discriminant decoder (choice) cell ' num2str(idx)]);
ylabel('Decoder accuracy (%)')
Y = decode.choice.shuffle{idx};
errorshade(decode.t, Y(:,2), Y(:,3), 'k', 0.2); %errorshade(x,h,l,c,t)
plot(decode.t,Y(:,1),'-','Color',[0.5 0.5 0.5],'LineWidth',3);
Y = decode.choice.accuracy{idx};
plot(decode.t,Y(:,1),'g-','LineWidth',3); 
axis square;
plot([0 0],ylim,'k:');

% Plot difference from shuffle
subplot(1,3,2); hold on;
ylabel('Decoder accuracy: difference from shuffle (%)')
Y = repmat(decode.choice.accuracy{idx},1,3) - decode.choice.shuffle{idx};
errorshade(decode.t, Y(:,2), Y(:,3), 'g', 0.2);  %errorshade(x,h,l,c,t)
plot(decode.t,Y(:,1),'g-','LineWidth',3); 
plot([decode.t(1) decode.t(end)],[0 0],'k:');
axis square;
plot([0 0],ylim,'k:');

% Plot selectivity ***FIX scores input into perfcurve
subplot(1,3,3); hold on;
ylabel('Selectivity 2(AUC-0.5)')
Y = decode.choice.selectivity{idx};
errorshade(decode.t, Y(:,2), Y(:,3), 'm', 0.2);  %errorshade(x,h,l,c,t)
plot(decode.t,Y(:,1),'m-','LineWidth',3); 
plot([decode.t(1) decode.t(end)],[0 0],'k:');
axis square;
plot([0 0],ylim,'k:');

% Screen position/dimensions
fig(idx).Position = [400 100 1200 800];

end

%Save
save_path = 'J:\Data & Analysis\Rule Switching\Notebook';
save_singleUnitPlots(fig,save_path);


%% Try to speed up LOOCV
idx = 1:10;
for j = idx
testIdx = idx==j;
trainIdx = ~testIdx;
end

%%
dbstop in decodeTrialType at 27 if accuracy<0.3

%%
plot(0*dFF(trueTypes==1),dFF(trueTypes==1),'ro'); hold on
plot(0*dFF(trueTypes==2)+1,dFF(trueTypes==2),'bo');