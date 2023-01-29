% Extract data from all the xlsx raw data

% Combine files
clear;clc;close;

for index=21:21
    combineCsv(index);
end

return;

%% Export only

index = 9

save(sprintf("batteries_bak_%02d", index),"batteries");
% Export

counter = 0;
for unit=batteries
    counter = counter + 1;
    unit1 = unit{1};

    if isempty(unit1)
%         disp("Empty");
    else
%         disp("Not empty")
        csvFileName = sprintf("csv/batteries%02d_%d.csv", index, counter);
        writetable(unit1, csvFileName)
    end
end


%% Fonctions

function combineCsv(index)

% Import
batteries = combineIndice(index);

save(sprintf("batteries_bak_%02d", index),"batteries");
% Export

counter = 0;
for unit=batteries
    counter = counter + 1;
    unit1 = unit{1};

    if isempty(unit1)
%         disp("Empty");
    else
%         disp("Not empty")
        csvFileName = sprintf("csv/batteries%02d_%d.csv", index, counter);
        writetable(unit1, csvFileName)
    end
end

end

function filename=getFileName(indice, counter)
    % Nom du fichier
    filename = sprintf("data/%2s-%03d-%03d.xlsx", ...
        indice, ...
        counter*50+1, ...
        (counter+1)*50);
end

function out = combineIndice(index)
    indice = sprintf("%02d", index); % e.g. 01
    sheetNamePattern = "Statistics_";
    sheetNamePattern2 = "StatisticsByCycle-Chan_";

    out = {};

    % Pour chaque fichier de 50 cycles
    for counter=0:99 % Limite max : 99. Jamais atteint

        % Nom du fichier
        filename = getFileName(indice, counter);
        % Si le fichier n'existe pas, on quitte
        if not(isfile(filename))
            return;
        end
        
        fprintf("Reading ""%s""...", filename);

        % Lecture page 1
        p1 = readtable(filename);

        mapping = {};
        for counterMapping=1:height(p1)
            sampleNo = p1.SampleNo(counterMapping);
            sampleNo = str2double(erase(sampleNo, sprintf("%s-", indice)));
            channelNo = p1.Channel(counterMapping);
            mapping{channelNo} = sampleNo;
        end


        % Récupération infos du fichier
        [~,sheets] = xlsfinfo(filename);
    
        % For all sheets, select the ones starting with 'statistics'
        for sheet=sheets
            sheetName = sheet{1};
    %         fprintf("%s\n", sheet{1})
            if startsWith(sheetName, sheetNamePattern)
                sheetChannelNo = str2double(erase(sheetName, sheetNamePattern));
                fprintf("SheetChannelNo = %d\n", sheetChannelNo);
                opt = detectImportOptions("data/template.xlsx");
            elseif startsWith(sheetName, sheetNamePattern2)
                sheetChannelNo = str2double(erase(sheetName, sheetNamePattern2));
                fprintf("SheetChannelNo = %d\n", sheetChannelNo);
                opt = detectImportOptions("data/template2.xlsx");
            else
                continue;
            end
    
            opt.Sheet = sheetName;

            T = readtable(filename, opt);
            % Modify data
            % Remove unwanted rows
           T = T(1:height(T)-1, :);
            %     summary(T);
        
            destination = mapping{sheetChannelNo};

            if destination <= width(out)
                currentData = out{destination};
            else
                currentData = [];
            end

            % Save wanted data
            addData = table(counter*50+T.Cycle_Index, ...
                T.Charge_Energy_Wh_, ...
                T.Discharge_Energy_Wh_, ...
                T.Charge_Capacity_Ah_, ...
                T.Discharge_Capacity_Ah_, ...
                'VariableNames',["Cycle", ...
                "Charge_Wh", ...
                "Discharge_Wh", ...
                "Charge_Ah", ...
                "Discharge_Ah"]);
            out{destination} = [currentData; addData];
        
        end
    
        close all;
    end
end