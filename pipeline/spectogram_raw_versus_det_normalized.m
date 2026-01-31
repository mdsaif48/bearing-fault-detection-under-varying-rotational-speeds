window = 4096;
noverlap = 2048;
nfft = 8192;

figure;
spectrogram(dataStruct(1).vibrationProcessed, window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram of Bearing Vibration');
sigRaw  = dataStruct(1).vibration;
sigProc = dataStruct(1).vibrationProcessed;

t = (0:length(sigRaw)-1)/fs;  % time vector in seconds


