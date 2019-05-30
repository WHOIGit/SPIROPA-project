load D:\SPIROPA\20190511_RB1904\Attune\\Summary\\AttuneTable

filetype2include = {'SPIROPA_RB1904_Grazer'};
t = strmatch(filetype2include, AttuneTable.Filename);
AttuneTable = AttuneTable(t,:);

t = (contains(AttuneTable.Properties.VariableNames, 'biovolume')); 
AttuneTable(:,t) = [];
t = (contains(AttuneTable.Properties.VariableNames, 'carbon')); 
AttuneTable(:,t) = [];

t = (contains(AttuneTable.Properties.VariableNames, 'count')); 
conc = AttuneTable{:,t}./repmat(AttuneTable.VolAnalyzed_ml, 1, length(find(t)));
varNames = regexprep(AttuneTable.Properties.VariableNames(t), 'count', 'conc');
AttuneTable = [AttuneTable, array2table(conc,'VariableNames', varNames)];

for cc = 1:size(AttuneTable,1)
    temp = char(AttuneTable.Filename{cc});
    if isequal(temp(23), '_')
        SampleLabel(cc,1) = {temp(35:end-4)};
        %ExptLabel(cc,1) = {temp(16:22)};
        ExptLabel(cc,1) = {str2num(temp(22))};
    else
        SampleLabel(cc,1) = {temp(36:end-4)};
        %ExptLabel(cc,1) = {temp(16:23)};
        ExptLabel(cc,1) = {str2num(temp(22:23))};
    end
end
AttuneTable = addvars(AttuneTable, SampleLabel, 'After', 'Filename');
AttuneTable = addvars(AttuneTable, ExptLabel, 'After', 'Filename');

AttuneTable = sortrows(AttuneTable,{'ExptLabel','StartDate'});

writetable(AttuneTable, 'c:\work\spiropa\rb1904\grazer.xlsx')
