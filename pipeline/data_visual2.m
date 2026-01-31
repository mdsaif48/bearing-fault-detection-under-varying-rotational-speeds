figure;
plot(dataStruct(1).f, dataStruct(1).FFT); hold on;
plot(dataStruct(10).f, dataStruct(10).FFT);
plot(dataStruct(20).f, dataStruct(20).FFT);
legend('Healthy','InnerFault','OuterFault');
xlim([0 20000]); % focus on low frequencies
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT Spectrum Comparison');
