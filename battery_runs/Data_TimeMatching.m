clear all
close all

% [filename, path] = uigetfile('*.csv', 'Select the SEVCON CSV file');
% if isequal(filename, 0)
%     disp('File selection canceled.');
% else
%     filepath = fullfile(path, filename);
%     data = readtable(filepath);
%     var_names = data.Properties.VariableNames;
%     for i = 1:length(var_names)
%         variable_name = var_names{i};
%         assignin('base', variable_name, data.(variable_name));
%     end
%     disp(['CSV file "', filename, '" has been successfully imported.']);
% end


[filename, path] = uigetfile('*.csv', 'Select a CSV file');
if isequal(filename, 0)
    disp('File selection canceled.');
else
    filepath = fullfile(path, filename);
    column_names = {'seconds', 'kWatts', 'km_hr'};
    data = readtable(filepath, 'VariableNames', column_names);
    var_names = data.Properties.VariableNames;
    for i = 1:length(var_names)
        variable_name = var_names{i};
        assignin('base', variable_name, data.(variable_name));
    end
    disp(['CSV file "', filename, '" has been successfully imported.']);
end



