%Dyno Parsing File 
%Miguel Talamantez
%EVT MIT 2023

% x ---> x_trimmed ----> x_filtered ----> CSV
% Insert data as column vectors (3). Watch for trim amounts and vary as
% needed. ONLY kW and kmhr needs to be filtered. Seconds only needs to be
% trimmed.


% kW ---> kW_trimmed
if length(kW) >= 2
    kW_trimmed = kW(2:end-2);
    disp(kW_trimmed);
else
    disp('The "kW" vector does not have enough elements to remove the first row.');
end

% kmhr ---> kmhr_trimmed
if length(kmhr) >= 2
    kmhr_trimmed = kmhr(2:end-2);
    disp(kmhr_trimmed);
else
    disp('The "kW" vector is too short');
end

% s ---> seconds_trimmed
if length(s) >= 2
    seconds_trimmed = s(2:end-2);
    disp(seconds_trimmed);
else
    disp('The "s" vector is too short');
end




% kW_trimmed ---> kW_filtered
yourCategoricalData1 = kW_trimmed();
categoryToReplace = 'N/A'; 
modifiedData1 = yourCategoricalData1; 
modifiedData1(modifiedData1 == categoryToReplace) = '0';
modifiedData1 = str2double(cellstr(modifiedData1));
if any(isnan(modifiedData1))
    warning('There are still NaN values in the data. Please review and handle them.');
end
kW_filtered = modifiedData1;


% kmhr_trimmed ---> kmhr_filtered
yourCategoricalData1 = kmhr_trimmed();
categoryToReplace = 'N/A'; 
modifiedData1 = yourCategoricalData1; 
modifiedData1(modifiedData1 == categoryToReplace) = '0';
modifiedData1 = str2double(cellstr(modifiedData1));
if any(isnan(modifiedData1))
    warning('There are still NaN values in the data. Please review and handle them.');
end
kmhr_filtered = modifiedData1;



%PLOT THE DATA
%Comment out if not needed
tiledlayout(2,1)
ax1 = nexttile;
plot(seconds_trimmed, kW_filtered)
title('Power (kW) vs time (s)')
ax2 = nexttile;
plot(seconds_trimmed, kmhr_filtered)
title('Speed (km/hr) vs time (s)')


%Prep Data for Export
seconds = seconds_trimmed;
kWatts = kW_filtered;
km_hr = kmhr_filtered;

%Export data to CSV
data = [seconds, kWatts, km_hr];
[outputFile, outputPath] = uiputfile('DynoParse_Export.csv', 'Save CSV File');
if isequal(outputFile, 0)
    disp('Save operation canceled.');
else
    outputPath = fullfile(outputPath, outputFile);
    writematrix(data, outputPath);
    fprintf('Data exported to %s\n', outputPath);
end

clear all




