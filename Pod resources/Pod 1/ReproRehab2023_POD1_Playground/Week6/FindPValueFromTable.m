% --------
% Devin Austin code
function pValue = FindPValueFromTable(table, groupID, timeOneID,timeTwoID)
    
    %1. find the rows of the table with the correct group number
    groupIndex = table.group == strcat('Group', num2str(groupID));
    %2. find the rows of the table with the correct timeOneID
    timeOneIndex = table.Time_1 == timeOneID;
    %3. find the rows of the table with the correct timeTwoID
    timeTwoIndex = table.Time_2 == timeTwoID;
    %4. find the row of the pvalue column of the table that satisfies step
    %1,2, & 3. 
    compoundIndex = groupIndex & timeOneIndex & timeTwoIndex;
    pValue = table.pValue(compoundIndex);

end