fc = 10; % Hz
[b,a] = butter(4, fc/(fs/2), 'high');
for k = 1:numFiles
    sig = dataStruct(k).vibrationProcessed;
    sigFiltered = filtfilt(b,a,sig);
    dataStruct(k).vibrationFiltered = sigFiltered;
end
