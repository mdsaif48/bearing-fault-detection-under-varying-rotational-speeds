load('RF_BearingModel.mat','RFmodel');  % your trained TreeBagger model

YPredNew = predict(RFmodel, XNew);
YPredNew = categorical(YPredNew);
figure;
hold on;
colors = lines(numel(categories(YNew)));
catLabels = categories(YNew);

for i = 1:numFilesNew
    actualIdx = find(catLabels == YNew(i));
    predIdx   = find(catLabels == YPredNew(i));
    
    % plot actual vs predicted as a colored dot
    plot(actualIdx, predIdx, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', colors(actualIdx,:));
end

xlim([0.5 numel(catLabels)+0.5]);
ylim([0.5 numel(catLabels)+0.5]);
xticks(1:numel(catLabels)); yticks(1:numel(catLabels));
xticklabels(catLabels); yticklabels(catLabels);
xlabel('Actual Fault');
ylabel('Predicted Fault');
title('Predicted vs Actual Faults on New Dataset');
grid on;
hold off;
