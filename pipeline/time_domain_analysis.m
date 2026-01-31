for k = 1:numFiles
    sig = dataStruct(k).vibrationProcessed;
    
    % Time-domain features
    dataStruct(k).RMS   = rms(sig);        % Root Mean Square
    dataStruct(k).STD   = std(sig);        % Standard Deviation
    dataStruct(k).Skew  = skewness(sig);   % Skewness
    dataStruct(k).Kurt  = kurtosis(sig);   % Kurtosis
end
