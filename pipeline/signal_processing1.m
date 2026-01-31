fs = 200000; % sampling frequency
for k = 1:numFiles
    sig = dataStruct(k).vibration;
    sig = detrend(sig);                 % remove DC trend
    sig = sig / max(abs(sig));          % normalize amplitude
    dataStruct(k).vibrationProcessed = sig;
end
