%fpath = '\\multiproc\data_on_memory\underway\proc\';
%fpath = '\\multiproc\science_share\Underway_data\';
fpath = '\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\'

flist = dir([fpath 'AR29*.csv']);
%ii = strmatch('AR29_180420_1918.csv', {flist.name} );
%flist(ii) = []; 
mdate = [];
lat = [];
lon = [];
flr = [];
sbe45S = [];
sbe45T = [];
sbe48T = [];
amlT = [];
for ii = 1:length(flist)
    disp(flist(ii).name)
    t = importdata([fpath char(flist(ii).name)]);
    s = char(t.textdata(3:end,1));
    s2 = char(t.textdata(3:end,2));
    s3 = repmat(' ', size(s,1), 1);
    mdate = [mdate; datenum([s s3 s2])];
    lat = [lat; t.data(:,1)];
    lon = [lon; t.data(:,2)];
    sbe45S = [sbe45S; t.data(:,4)];
    sbe45T = [sbe45T; t.data(:,5)];
    flr = [flr; t.data(:,3)];
    sbe48T = [sbe48T; t.data(:,5)];
    amlT = [amlT; t.data(:,6)];
end

save('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\AR29_underway', 'sbe*', 'flr', 'mdate', 'lon', 'lat', 'amlT')

clear s s2 s3 t ii flist fpath