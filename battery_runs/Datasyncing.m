% Load your categorical data (6389x1)


yourCategoricalData1 = kW();
categoryToReplace = 'N/A'; 
modifiedData1 = yourCategoricalData1; 
modifiedData1(modifiedData1 == categoryToReplace) = '0';
modifiedData1 = str2double(cellstr(modifiedData1));
if any(isnan(modifiedData1))
    warning('There are still NaN values in the data. Please review and handle them.');
end
kW_filtered = modifiedData1;

yourCategoricalData1 = km_hr();
categoryToReplace = 'N/A'; 
modifiedData1 = yourCategoricalData1; 
modifiedData1(modifiedData1 == categoryToReplace) = '0';
modifiedData1 = str2double(cellstr(modifiedData1));
if any(isnan(modifiedData1))
    warning('There are still NaN values in the data. Please review and handle them.');
end
km_hr_filtered = modifiedData1;


tiledlayout(2,1)
ax1 = nexttile;
plot(seconds, kW_filtered)

ax2 = nexttile;
plot(seconds, km_hr_filtered)




