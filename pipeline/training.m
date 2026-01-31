

fs = 200000;  % Sampling frequency
dataDir = 'C:\Users\saif\OneDrive\Desktop\MIN_PROJECT\ML\v43hmbwxpm-1';
fileList = dir(fullfile(dataDir,'*.mat'));
numFiles = length(fileList);
dataStruct = struct(); 
for k = 1:numFiles
    temp = load(fullfile(dataDir, fileList(k).name));
    varNames = fieldnames(temp);
    sig = temp.(varNames{1});  
    sig = detrend(sig);         
    sig = sig / max(abs(sig));    
    dataStruct(k).filename = fileList(k).name;
    dataStruct(k).vibrationProcessed = sig;
    if contains(fileList(k).name,'H','IgnoreCase',true)
        dataStruct(k).health = 'Healthy';
    elseif contains(fileList(k).name,'I','IgnoreCase',true)
        dataStruct(k).health = 'InnerFault';
    elseif contains(fileList(k).name,'O','IgnoreCase',true)
        dataStruct(k).health = 'OuterFault';
    else
        dataStruct(k).health = 'Unknown';
    end
    if ~isfield(dataStruct(k),'health')
        error('Health field not created for file %s', fileList(k).name);
    end
end
allFields = isfield(dataStruct,'health');
if ~all(allFields)
    error('Some entries are missing the health field!');
end

disp('All files loaded successfully with health labels.');



for k = 1:numFiles
    fileName = fullfile(dataDir, fileList(k).name);
    temp = load(fileName);
    fn = fieldnames(temp);
    sig = temp.(fn{1});           
    sig = detrend(sig);          
    sig = sig / max(abs(sig));   
    dataStruct(k).filename = fileList(k).name;
    dataStruct(k).vibrationProcessed = sig;
    if contains(fileList(k).name,'H')
        dataStruct(k).health = 'Healthy';
    elseif contains(fileList(k).name,'I')
        dataStruct(k).health = 'InnerFault';
    elseif contains(fileList(k).name,'O')
        dataStruct(k).health = 'OuterFault';
    else
        dataStruct(k).health = 'Unknown';
    end
end

%% Step 2: Compute Time-Domain Features (Optional)
for k = 1:numFiles
    sig = dataStruct(k).vibrationProcessed;
    dataStruct(k).RMS  = rms(sig);
    dataStruct(k).STD  = std(sig);
    dataStruct(k).Skew = skewness(sig);
    dataStruct(k).Kurt = kurtosis(sig);
end

%% Step 3: Compute FFT (Memory-Safe)
segmentLength = 50000;  % use first 50k samples
for k = 1:numFiles
    sig = dataStruct(k).vibrationProcessed(1:segmentLength);
    Y = fft(sig);
    f = (0:segmentLength-1)*(fs/segmentLength);
    dataStruct(k).FFT = abs(Y(1:segmentLength/2));
    dataStruct(k).f   = f(1:segmentLength/2);
end

%% Step 4: Visualize RMS Across Conditions
RMS_healthy = [dataStruct(strcmp({dataStruct.health}, 'Healthy')).RMS];
RMS_inner   = [dataStruct(strcmp({dataStruct.health}, 'InnerFault')).RMS];
RMS_outer   = [dataStruct(strcmp({dataStruct.health}, 'OuterFault')).RMS];

figure;
boxplot([RMS_healthy, RMS_inner, RMS_outer], ...
        [repmat({'Healthy'},1,length(RMS_healthy)), ...
         repmat({'InnerFault'},1,length(RMS_inner)), ...
         repmat({'OuterFault'},1,length(RMS_outer))]);
ylabel('RMS Value');
title('RMS Comparison Across Bearing Conditions');
grid on;

%% Step 5: Visualize Average FFT
function avgFFT = averageFFT(dataStruct, idx)
    filesIdx = find(idx);
    N = length(dataStruct(filesIdx(1)).FFT);
    sumFFT = zeros(1,N);
    for k = 1:length(filesIdx)
        sumFFT = sumFFT + dataStruct(filesIdx(k)).FFT;
    end
    avgFFT = sumFFT / length(filesIdx);
end

fAxis = dataStruct(1).f;
figure; hold on;
plot(fAxis, averageFFT(dataStruct, strcmp({dataStruct.health}, 'Healthy')), 'b', 'LineWidth', 1.5);
plot(fAxis, averageFFT(dataStruct, strcmp({dataStruct.health}, 'InnerFault')), 'r', 'LineWidth', 1.5);
plot(fAxis, averageFFT(dataStruct, strcmp({dataStruct.health}, 'OuterFault')), 'g', 'LineWidth', 1.5);
xlim([0 20000]);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Average FFT Spectrum per Bearing Condition');
legend('Healthy','Inner Fault','Outer Fault');
grid on;

%% Step 6: Prepare Data for 1D CNN
X = zeros(segmentLength,1,numFiles);
Y = categorical({dataStruct.health});  % categorical labels

for k = 1:numFiles
    X(:,1,k) = dataStruct(k).vibrationProcessed(1:segmentLength);
end

%% Step 7: Split Train/Test
numTrain = round(0.7*numFiles);
idx = randperm(numFiles);

XTrain = X(:,:,idx(1:numTrain));
YTrain = Y(idx(1:numTrain));

XTest = X(:,:,idx(numTrain+1:end));
YTest = Y(idx(numTrain+1:end));

%
layers = [
    sequenceInputLayer(1,'MinLength',segmentLength)
    
    convolution1dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(2,'Stride',2)
    
    convolution1dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(2,'Stride',2)
    
    globalAveragePooling1dLayer        
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];
options = trainingOptions('adam', ...
    'MaxEpochs',15, ...
    'MiniBatchSize',4, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false);

cnnModel = trainNetwork(XTrain,YTrain,layers,options);
YPred = classify(cnnModel,XTest);
accuracy = sum(YPred == YTest)/numel(YTest);
fprintf('Test Accuracy: %.2f%%\n', accuracy*100);
