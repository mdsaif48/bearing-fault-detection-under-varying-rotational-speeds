dataDir = 'C:\Users\saif\OneDrive\Documents\Desktop\MIN_PROJECT\ML\v43hmbwxpm-1';
files = dir(fullfile(dataDir, '*.mat'));

for k = 1:length(files)
    fullPath = fullfile(dataDir, files(k).name);
    data = load(fullPath);
    fprintf('Loaded %s successfully\n', files(k).name);
end

