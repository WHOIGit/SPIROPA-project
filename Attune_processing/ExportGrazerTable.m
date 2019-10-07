%load D:\SPIROPA\20190511_RB1904\Attune\\Summary\\AttuneTable
%filetype2include = {'SPIROPA_RB1904_Grazer'}; smpl_pos = 35; expt_pos = 22;
load E:\SPIROPA\Attune_Export\Thompson_SPIROPA_export\\Summary\\AttuneTable
filetype2include = {'SPIROPA_TN368_Grazer'}; smpl_pos = 34; expt_pos = 21;

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
    if isequal(temp(expt_pos+1), '_')
        SampleLabel(cc,1) = {temp(smpl_pos:end-4)};
        %ExptLabel(cc,1) = {temp(16:22)};
        ExptLabel(cc,1) = {str2num(temp(expt_pos))};
    else
        smpl_pos = smpl_pos+1;
        SampleLabel(cc,1) = {temp(smpl_pos:end-4)};
        ExptLabel(cc,1) = {str2num(temp(expt_pos:expt_pos+1))};
    end
end
AttuneTable = addvars(AttuneTable, SampleLabel, 'After', 'Filename');
AttuneTable = addvars(AttuneTable, ExptLabel, 'After', 'Filename');

AttuneTable = sortrows(AttuneTable,{'ExptLabel','StartDate'});

writetable(AttuneTable, ['\\rvtgt.uw.edu\cruiseshare\grazer\grazer' date 'B.xlsx'])
