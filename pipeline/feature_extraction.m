for k = 1:numFiles
    sig = dataStruct(k).vibrationFiltered;
    
    % Time-domain features
    dataStruct(k).RMS   = rms(sig);
    dataStruct(k).STD   = std(sig);
    dataStruct(k).Skew  = skewness(sig);
    dataStruct(k).Kurt  = kurtosis(sig);
    
    % FFT features (magnitude spectrum)
    N = length(sig);
    Y = fft(sig);
    f = (0:N-1)*(fs/N);
    dataStruct(k).FFT = abs(Y(1:N/2));
    dataStruct(k).f   = f(1:N/2);
end
