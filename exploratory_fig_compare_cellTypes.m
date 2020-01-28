figure;

%Four subplots: one for each decode type
S = stats.selectivity;
decodeType = fieldnames(S);
cellType = fieldnames(S.(decodeType{1}));

%Selectivity index and magnitude 
var_name = {'selIdx', 'selMag'};
for i = 1:numel(var_name)

for j = 1:numel(decodeType)
    ax(j) = subplot(2,4,j+4*(i-1)); hold on;
    for k=1:numel(cellType)
        var = S.(decodeType{j}).(cellType{k}).(var_name{i});
        Mean(k) = var.mean;
        SEM = var.sem;
        Y{k} = var.data;
        X{k} = k*ones(size(Y{k}));
    end
    b = bar(Mean,'FaceColor','none','EdgeColor','flat','LineWidth',1,'CData',c);
    %Plot data by N
    for k=1:numel(cellType)
        plot(X{k},Y{k},'o','Color',[0.5 0.5 0.5],'LineWidth',1);
    end
    
    %Titles and labels
    title_str = [upper(decodeType{j}(1)), decodeType{j}(2:end)];
    title_str(title_str=='_') = ' ';
    ax(j).Title.String = title_str;
    ax(j).XTick = 1:numel(cellType);
    ax(j).XTickLabels = cellType;
    
end
ax(1).YLabel.String = var_label(any(strcmp(var_label,(var_name{i})),2),end);
end

%Specify y-axis label and colors

params.figs.summary_selectivity.var_label = ...
    {'selIdx','selIdx_t','sigIdx','sigIdx_t','Modulation index';...
     'selMag','selMag_t','sigMag','sigMag_t','Modulation magnitude';...
     'pSig',  'pSig_t',     [],     [],      'Proportion sig. mod.';...
     'pPrefPos',    [],     [],     [],      'Proportion pref. pos. class';...
     'pPrefNeg',    [],     [],     [],      'Proportion pref. neg. class';...
    };
