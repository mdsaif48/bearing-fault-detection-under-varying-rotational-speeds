for k = 1:numFiles
    sig = dataStruct(k).vibrationProcessed;
    N = length(sig);
    Y = fft(sig);                     % compute FFT
    f = (0:N-1)*(fs/N);               % frequency vector
    dataStruct(k).FFT = abs(Y(1:N/2));% store magnitude
    dataStruct(k).f   = f(1:N/2);     % store frequency axis
end
