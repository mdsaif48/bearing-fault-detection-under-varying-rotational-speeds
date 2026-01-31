

function avgFFT = averageFFT(dataStruct, idx)
   Nfft = 50000;  % first 50k samples
for k = 1:numFiles
    sig = dataStruct(k).vibrationProcessed(1:Nfft);  % segment
    Y = fft(sig);
    f = (0:Nfft-1)*(fs/Nfft);
    dataStruct(k).FFT = abs(Y(1:Nfft/2));
    dataStruct(k).f   = f(1:Nfft/2);
end

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
