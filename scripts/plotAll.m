%% Plot all batteries separately
clc; clear; close all;


for indice=1:6
    for counter=0:255 % Limite max : 255
        filename = sprintf("csv/batteries%02d_%d.csv", indice, counter);
        imagename = sprintf("img/bat%02d_%d.png", indice, counter);
        figname = sprintf("img/fig/bat%02d_%d.fig", indice, counter);
        
        if isfile(filename)
            % Charger les données du fichier
            data = loadCsv(filename);
            
            % Plot de discharge_ah
            plot(data.Cycle, data.Discharge_Ah);
            title(sprintf("%02d - %d", indice, counter));
            
            % Ligne de la capacité initiale
            initialCapacity = data.Discharge_Ah(1);
            yline(initialCapacity);
            % Ligne de la capacité 80%
            yline(0.8*initialCapacity);

            saveas(gcf, imagename);
            saveas(gcf, figname);

            % Affichage des capacités finales
            fprintf("80%% at : %f\n", 0.8*initialCapacity);
%             plot(0.8*initialCapacity, 'o'); hold on;
        end
    end
end

disp("Complete !");

function out=loadCsv(filename)
    out = readtable(filename);
end