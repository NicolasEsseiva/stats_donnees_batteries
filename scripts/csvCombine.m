%% CSV into one file
% On combine les fichiers CSV pour une température en un seul avec
% plusieurs colonnes. Nous utilisons uniquement la colonne discharge_Ah
clc; clear; close all;
% Plage des conditions à prendre

name = "C40";
ConditionRange = 1:24;
BatteriesRange = 1:255;

SkipIfMod2Is = 0; % Skip si batterie%2 == SkipIfMod2Is

output = [];

for indice=ConditionRange
    if mod(indice, 2) == SkipIfMod2Is % Skip les conditions impaires
        continue;
    end
    for counter=BatteriesRange % Limite max : 255
        filename = sprintf("csv/batteries%02d_%d.csv", indice, counter);
        
        if isfile(filename)
            % Charger les données du fichier
            data = loadCsv(filename);
            
            addToTable = table(data.Cycle, data.Discharge_Ah, 'VariableNames',["Cycles", sprintf("DischargeAh_%d",counter)]);
            if isempty(output)
                output = addToTable;
            else
                output = outerjoin(output, addToTable, MergeKeys=true);
            end
            plot(data.Cycle, data.Discharge_Ah); hold on;
        end
    end
end

csvFileName = sprintf("output/dat_%s.csv", name);
writetable(output, csvFileName);
disp("Complete !");

function out=loadCsv(filename)
    out = readtable(filename);
end