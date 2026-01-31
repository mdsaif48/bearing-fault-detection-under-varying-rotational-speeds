clc; clear;

%% Parameters
dataDir = 'C:\Users\saif\OneDrive\Desktop\MIN_PROJECT\ML\v43hmbwxpm-1';
fs = 200000;
segmentLength = fs * 1;
overlap = 0.5;

files = dir(fullfile(dataDir,'*.mat'));
numFiles = length(files);

X = [];
Y = {};   % <-- CELL ARRAY (important)

%% Load, preprocess, segment, extract features
for k = 1:numFiles
    temp = load(fullfile(dataDir, files(k).name));

    % Signal extraction
    if isfield(temp,'Channel_1')
        sig = temp.Channel_1;
    else
        fn = fieldnames(temp);
        sig = temp.(fn{1});
    end

    sig = sig(:);
    sig = detrend(sig);
    sig = sig / max(abs(sig));

    % Label assignment
    fname = upper(files(k).name);
    if contains(fname,'_H_')
        label = 'Healthy';
    elseif contains(fname,'_I_')
        label = 'InnerFault';
    elseif contains(fname,'_O_')
        label = 'OuterFault';
    else
        error('Unknown label in %s', files(k).name);
    end

    % Segmentation
    segs = buffer(sig, segmentLength, floor(segmentLength*overlap), 'nodelay');

    for s = 1:size(segs,2)
        xseg = segs(:,s);

        feats = [ ...
            rms(xseg), ...
            std(xseg), ...
            skewness(xseg), ...
            kurtosis(xseg)];

        X = [X; feats];
        Y{end+1,1} = label;   % <-- SAFE append
    end
end

Y = categorical(Y);  % NOW this is a clean vector

fprintf('Total samples: %d\n', size(X,1));

%% Train-test split (now works)
rng(1);
cv = cvpartition(Y,'HoldOut',0.3);

XTrain = X(training(cv),:);
YTrain = Y(training(cv));

XTest  = X(test(cv),:);
YTest  = Y(test(cv));

%% Train classifier
model = fitcsvm(XTrain,YTrain,...
    'KernelFunction','rbf',...
    'Standardize',true);

%% Evaluate
YPred = predict(model,XTest);
accuracy = mean(YPred == YTest);

fprintf('Test Accuracy: %.2f %%\n', accuracy*100);
confusionchart(YTest, YPred);
