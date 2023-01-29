%% Fix cycle counter

index = 0;

%% steps
index = index + 1

if index == 16
    disp("Index is 16");
    return;
end

filename = sprintf("batteries_bak_%02d.mat", index)
load(filename);

counter = 0;
for unit=batteries
    counter = counter + 1;
    unit1 = unit{1};

    if isempty(unit1)
%         disp("Empty");
    else
%         disp("Not empty")
        len = height(unit1.Cycle);
        batteries{1, counter}.Cycle = (1:len)';
    end
end

% Export
save(sprintf("batteries_bak_%02d", index),"batteries");

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