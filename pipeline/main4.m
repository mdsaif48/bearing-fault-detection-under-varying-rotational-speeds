clc; clear;

% 1️⃣ Select folder containing .mat files
dataDir = uigetdir(pwd, 'Select folder with .mat files');
if dataDir == 0
    error('No folder selected');
end

files = dir(fullfile(dataDir, '*.mat'));
numFiles = length(files);

if numFiles == 0
    error('No .mat files found in the folder');
end

fs = 200000; % sampling frequency (adjust if needed)

% 2️⃣ Loop through each file
for k = 1:numFiles
    fullPath = fullfile(dataDir, files(k).name);
    temp = load(fullPath);
    varNames = fieldnames(temp);
    sig = temp.(varNames{1}); % get vibration signal
    
    % 3️⃣ Preprocess signal
    sig = detrend(sig);          % remove DC offset / trend
    sig = sig / max(abs(sig));   % normalize amplitude
    
    % 4️⃣ Plot signal
    figure('Name', files(k).name, 'NumberTitle', 'off');
    t = (0:length(sig)-1)/fs;  % time axis
    plot(t, sig, 'b', 'LineWidth', 1);
    xlabel('Time [s]');
    ylabel('Normalized Amplitude');
    title(['Vibration Signal: ', files(k).name]);
    grid on;
    
    % Pause to view each plot
    pause(0.5);  % adjust or remove for faster plotting
end

disp('All files loaded and plotted.');
