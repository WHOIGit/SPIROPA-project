fpath = '\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\'
flist = dir([fpath 'AR1804*.csv']);

uw = readtable([fpath char(flist(1).name)]);
for ii = 2:length(flist)
    disp(flist(ii).name)
    T = readtable([fpath char(flist(ii).name)]);
    uw = [uw; T];
end
uw.matdate = datenum(uw.DATE_GMT, 'YYYY/mm/DD') + datenum(uw.TIME_GMT);

save('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\AR29_underway_all', 'uw')
