dataDir = 'C:\Users\saif\OneDrive\Documents\Desktop\MIN_PROJECT\ML\v43hmbwxpm-1';
files = dir(fullfile(dataDir, '*.mat'));

for k = 1:length(files)
    fullPath = fullfile(dataDir, files(k).name);
    data = load(fullPath);
    fprintf('Loaded %s successfully\n', files(k).name);
end


numFiles = length(files);

fs = 200000;  % sampling frequency
dataStruct = struct();  % initialize struct

for k = 1:numFiles
    fullPath = fullfile(dataDir, files(k).name);
    temp = load(fullPath);
    varNames = fieldnames(temp);
    sig = temp.(varNames{1});  % get the vibration signal

    % Preprocessing
    sig = detrend(sig);          % remove DC offset
    sig = sig / max(abs(sig));   % normalize amplitude

    % Store in struct
    dataStruct(k).filename = files(k).name;
    dataStruct(k).vibrationProcessed = sig;

    % Assign health label based on filename
    fname = files(k).name;
    if startsWith(fname,'H')
        dataStruct(k).health = 'Healthy';
    elseif startsWith(fname,'I')
        dataStruct(k).health = 'InnerFault';
    elseif startsWith(fname,'O')
        dataStruct(k).health = 'OuterFault';
    else
        dataStruct(k).health = 'Unknown';
    end

    fprintf('Loaded and preprocessed %s successfully\n', files(k).name);
end

disp('All files loaded, preprocessed, and labeled.');
numFiles = length(dataStruct);
X = zeros(numFiles, 8);   % 8 features
Y = cell(numFiles,1);     % labels

for k = 1:numFiles
    sig = dataStruct(k).vibrationProcessed;
    
    % Time-domain features
    X(k,1) = rms(sig);                       % RMS
    X(k,2) = std(sig);                       % Standard deviation
    X(k,3) = skewness(sig);                  % Skewness
    X(k,4) = kurtosis(sig);                  % Kurtosis
    X(k,5) = max(sig) - min(sig);            % Peak-to-Peak
    X(k,6) = max(abs(sig)) / rms(sig);       % Crest Factor
    X(k,7) = max(abs(sig)) / mean(abs(sig)); % Impulse Factor
    X(k,8) = max(abs(sig)) / mean(sqrt(abs(sig))); % Margin Factor
    
    % Label
    Y{k} = dataStruct(k).health;
end

Y = categorical(Y);  % convert to categorical for classification
rng(1); % for reproducibility
cv = cvpartition(Y,'HoldOut',0.3);

XTrain = X(training(cv),:);
YTrain = Y(training(cv));

XTest = X(test(cv),:);
YTest = Y(test(cv));
numTrees = 90; % like your Python example
RFmodel = TreeBagger(numTrees, XTrain, YTrain, ...
                     'Method','classification', ...
                     'OOBPrediction','On', ...
                     'MinLeafSize',1);

% Plot OOB Error
figure;
oobErrorBaggedEnsemble = oobError(RFmodel);
plot(oobErrorBaggedEnsemble,'LineWidth',1.5);
xlabel('Number of Trees');
ylabel('OOB Classification Error');
title('Random Forest Out-of-Bag Error');
grid on;
numTrees = 90; % like your Python example
RFmodel = TreeBagger(numTrees, XTrain, YTrain, ...
                     'Method','classification', ...
                     'OOBPrediction','On', ...
                     'MinLeafSize',1);


YPred = predict(RFmodel, XTest);
YPred = categorical(YPred);

accuracy = sum(YPred == YTest)/numel(YTest);
fprintf('Test Accuracy: %.2f%%\n', accuracy*100);

% Confusion Matrix
figure;
cm = confusionmat(YTest, YPred);
confusionchart(cm, categories(YTest));
title('Confusion Matrix — Test Set');
featureImp = RFmodel.OOBPermutedPredictorDeltaError;
figure;
bar(featureImp);
xticklabels({'RMS','STD','Skewness','Kurtosis','Peak-to-Peak','Crest','Impulse','Margin'});
ylabel('Feature Importance');
title('Feature Importance from Random Forest');
grid on;
save('RF_BearingModel.mat','RFmodel'); 
