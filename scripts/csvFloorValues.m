%% CSV floor values of data
% On limite la valeur minimale des mesures à 70% de la valeur maximale
clc; clear;
close all;
% Plage des conditions à prendre

name = "T60";
ConditionRange = 19:24;
BatteriesRange = 1:255;

SkipConditionMod2Is = -1; % Skip si condition%2 == SkipIfMod2Is

output = [];

for indice=ConditionRange
%     h(indice-6) = subplot(3,2,indice-6);
    if mod(indice, 2) == SkipConditionMod2Is % Skip les conditions impaires
        continue;
    end
    for counter=BatteriesRange % Limite max : 255
        filename = sprintf("csv/batteries%02d_%d.csv", indice, counter);
        
        if isfile(filename)
            % Charger les données du fichier
            data = loadCsv(filename);
            
            valMax = max(data.Discharge_Ah);
            valMin = 0.8*valMax;
            data.Discharge_Ah(data.Discharge_Ah <= valMin) = NaN;
            data.Discharge_Ah = data.Discharge_Ah / valMax; % Normaliser
%             disp(valMin);

            addToTable = table(data.Cycle, data.Discharge_Ah, 'VariableNames',["Cycles", sprintf("DischargeAh_%d",counter)]);
            if isempty(output)
                output = addToTable;
            else
                output = outerjoin(output, addToTable, MergeKeys=true);
            end
            plot(data.Cycle, data.Discharge_Ah); hold on;
        end
    end
%     title(indice);
%     linkaxes(h, 'y');
end

csvFileName = sprintf("output/dat_%s.csv", name);
writetable(output, csvFileName);
disp("Complete !");

function out=loadCsv(filename)
    out = readtable(filename);
end