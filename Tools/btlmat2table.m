% script btlmat2table
% SPIROPA-project
% Heidi M. Sosik, Woods Hole Oceanographic Institution, March 2019
%
%btlmat2table - script to reformat AR29 compiled bottle file (from Olga K.)
%to handle highly non-standard column labels, create and save a table data
%type for easier handling in MATLAB

%file2load = 'C:\work\SPIROPA\ar29_bottle_data_Apr_2019.mat';
%file2load = 'C:\work\SPIROPA\RB1904\rb1904_bottle_data_Jul_2019.mat';
%file2load = '\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\fromOlga\ar29_bottle_data_Apr_2019.mat';
%file2load = '\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\fromOlga\rb1904_bottle_data_Apr_2020.mat';
%file2load = '\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\fromOlga\tn368_bottle_data_Apr_2020.mat';
file2load = '\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\fromOlga\tn368_bottle_data_Jul_2022.mat';
CTDlist = readtable("C:\work\SPIROPA\TN368\tn368_ctd_list.txt");
if ~exist(file2load,'file')
    [FileName,PathName] = uigetfile('*.mat','Select BTL mat file');
    file2load = fullfilename(PathName, FileName);
end
temp = load(file2load);

n = [];
s = [];
f = fields(temp);
t = regexp(f,'columns'); 
for ii = 1:length(t)
    if ~isempty(t{ii})
        n = [n str2num( temp.(f{ii})(:,1:2))']; %build the list of column numbers
        s = [s cellstr( temp.(f{ii})(:,6:end))';]; %build the list of column titles
    end
end

%sort by column number
[n,ii] = sort(n);
original_column_titles = s(ii);

%%
% regularize the column titles to work as variable names
c = regexptranslate('escape', original_column_titles);
t = ' #)^]'; %characters to remove
for ii = 1:length(t)
    c = regexprep(c, t(ii), '');
end
t = '([:,'; %characters to swap out
s = '____'; %characters to swap in
for ii = 1:length(t)
    c = regexprep(c, t(ii), s(ii));
end

c = regexprep(c, '\', ''); %remove literal \ symbol after others
c = regexprep(c, '-é', '_e'); %remove literal \ symbol after others
c = regexprep(c, '/', '_per_'); %special replacement
c = regexprep(c, '%', 'percent'); %special replacement
c = regexprep(c, '>', '_gt'); %special replacement
c = regexprep(c, '-', '_neg_'); %special replacement
c = regexprep(c, 'Ã©', 'Ac'); %special replacement
c = strrep(c, '^', 'sup');


%c = matlab.lang.makeValidName(c);
c = matlab.lang.makeUniqueStrings(c);
%%

BTL = array2table(temp.data, 'VariableNames',c);
%Olga's longitudes are missing the negative sign
BTL.Longitude_decimalDeg = -1*BTL.Longitude_decimalDeg;

%fix messed up times in Olga's BTL files
[ii,ia] = ismember(BTL.Cast, CTDlist.Var1);
BTL.hour = CTDlist.Var5(ia); BTL.minute = CTDlist.Var6(ia); BTL.second = CTDlist.Var7(ia);
%
BTL.datetime = datetime(BTL.Year, BTL.Month, BTL.Day, BTL.hour, BTL.minute, BTL.second);

clear ii s t f n

[p,n,e] = fileparts(file2load);
n = [n '_table'];
file2save = fullfile(p,[n e]);
save(file2save, 'BTL', 'original_column_titles')
disp(['Results saved: ' file2save])

clear

