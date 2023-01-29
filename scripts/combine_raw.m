% Combine data from raw channel data, not statistics
% Combine raw data
clc;

batteryNum = 93;
cycleStart = 200;

T = S4;

% Check for cycle change
currentCycle = T.Cycle_Index(1);

counter = 0;
out = {};

continueCond = true;
while continueCond

    counter = counter + 1;
    continueCond = true;
    while T.Cycle_Index(counter) == currentCycle
        counter = counter + 1;
        if counter > length(T.Cycle_Index)
            continueCond = false;
            break;
        end
    end
    
    counterMinus1 = counter - 1;
    if continueCond
        currentCycle = T.Cycle_Index(counter);
        addData = table(cycleStart+T.Cycle_Index(counterMinus1), ...
                        T.Charge_EnergyWh(counterMinus1), ...
                        T.Discharge_EnergyWh(counterMinus1), ...
                        T.Charge_CapacityAh(counterMinus1), ...
                        T.Discharge_CapacityAh(counterMinus1), ...
                        'VariableNames',["Cycle", ...
                        "Charge Wh", ...
                        "Discharge Wh", ...
                        "Charge Ah", ...
                        "Discharge Ah"]);
        
        
        if batteryNum <= width(out)
            currentData = out{batteryNum};
        else
            currentData = [];
        end
        
        out{batteryNum} = [currentData; addData];
    end
end

%% Copy to batteries

if batteryNum <= width(batteries)
    currentData = batteries{batteryNum};
else
    currentData = [];
end

batteries{batteryNum} = [currentData; out{batteryNum}];