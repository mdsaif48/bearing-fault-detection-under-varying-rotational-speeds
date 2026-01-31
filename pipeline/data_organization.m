numFiles = length(files);
dataStruct = struct();

for k = 1:numFiles
    fullPath = fullfile(dataDir, files(k).name);
    temp = load(fullPath);
    
    % Store signals
    dataStruct(k).filename = files(k).name;
    dataStruct(k).vibration = temp.Channel_1;
    dataStruct(k).speed     = temp.Channel_2;
    
    % Assign health labels from filename
    if contains(files(k).name, 'H')
        dataStruct(k).health = 'Healthy';
    elseif contains(files(k).name, 'I')  % Inner race
        dataStruct(k).health = 'InnerFault';
    elseif contains(files(k).name, 'O')  % Outer race
        dataStruct(k).health = 'OuterFault';
    else
        dataStruct(k).health = 'Unknown';
    end
end

disp({dataStruct.filename; dataStruct.health}')  % Quick check
