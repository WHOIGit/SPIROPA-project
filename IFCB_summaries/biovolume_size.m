load('\\sosiknas1\Lab_data\SPIROPA\IFCB\spiropaifcbmetadata')
%p = '\\sosiknas1\IFCB_products\SPIROPA\features\features2019_v4\';

%f = dir([p 'D201907*_fea_v4.csv']);
%output = '\\sosiknas1\IFCB_products\SPIROPA\summary\TN368_biovolume_size';
%uw = load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\gps\tsg_with_gps');
%run('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\scripts\tn368_transect_startime')

%f = dir([p 'D201905*_fea_v4.csv']);
%output = '\\sosiknas1\IFCB_products\SPIROPA\summary\RB1904_biovolume_size';
%uw = load('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\gps_Gordon\tsg_with_gps_all');
%run('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\Gordon_scriptsRB1904\rb1904_transect_startime')

p = '\\sosiknas1\IFCB_products\SPIROPA\features\features2018_v4\';
f = dir([p 'D2018*_fea_v4.csv']);
output = '\\sosiknas1\IFCB_products\SPIROPA\summary\AR29_biovolume_size';
uw = load('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\AR29_underway');
%uw.date_tsg = uw.mdate; uw.t1 = uw.sbe45T; uw.s = uw.sbe45S; uw.lat_tsg = uw.lat; uw.lon_tsg = uw.lon;

trnum = 1:length(tstime);


pid = regexprep({f.name}', '_fea_v4.csv', '');
ii = find(diff(uw.date_tsg)==0);
uwf = fields(uw);
for iii = 1:length(uwf)
    uw.(uwf{iii})(ii) = [];
end


f = {f.name}';
mdate = IFCB_file2date(f);
ml_analyzed = IFCB_volume_analyzed(regexprep(regexprep(f, 'D', 'http://ifcbdb.whoi.edu:8000/SPIROPA/D'),'_fea_v4.csv', '.hdr'));
%ml_analyzed = IFCB_volume_analyzed(regexprep(regexprep(f, 'D', 'http://ifcbdb.whoi.edu:8000/data/D'),'_fea_v4.csv', '.hdr'));

micron_factor = 1/2.77; %microns per pixel

for ii = 1:length(f)
    disp(ii);
    fea_all{ii} = importdata([p f{ii}], ',');
end

%bins = 1:150;
bins = logspace(0.5,2.6,30);
hbv = NaN(length(f), length(bins));
hcounts = hbv;
rbv = NaN(length(f),5);
rc = rbv;
for ii = 1:length(f)
    disp(ii)
    %fea_all(ii} = importdata([p f{ii}], ',');
    fea = fea_all{ii};
    ind = strmatch('Biovolume', fea.colheaders);
    bv = fea.data(:,ind)*micron_factor.^3;
    diam = (bv*3/4/pi).^(1/3)*2; 
    ind = strmatch('maxFeretDiameter', fea.colheaders);
    len = fea.data(:,ind).*micron_factor;
    b = discretize(len, bins);
    hcounts(ii,1:end-1) = histcounts(len, bins);
    for bi = 1:length(bins)
        hbv(ii,bi) = sum(bv(b==bi));    
        %h2(ii,bi) = numel(find(b==bi));
    end   
    ind = find(len<10);
    rbv(ii,1) = sum(bv(ind));
    rc(ii,1) = numel(ind);
    ind = find(len>=10 & len<20);
    rbv(ii,2) = sum(bv(ind));
    rc(ii,2) = numel(ind);
    ind = find(len>=20 & len<50);
    rbv(ii,3) = sum(bv(ind));
    rc(ii,3) = numel(ind);
    ind = find(len>=50 & len<100);
    rbv(ii,4) = sum(bv(ind));
    rc(ii,4) = numel(ind);
    ind = find(len>=100);
    rbv(ii,5) = sum(bv(ind));
    rc(ii,5) = numel(ind);   
end

save(output, 'ml_analyzed', 'mdate', 'micron_factor', 'hcounts', 'hbv', 'rc', 'rbv', 'bins', 'pid')
save([output '_fea_all'], 'fea_all')

%uw = load('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\AR29_underway');
%IFCB_match.lat = interp1(uw.mdate, uw.lat, mdate);
%IFCB_match.lon = interp1(uw.mdate, uw.lon, mdate);
%IFCB_match.saln = interp1(uw.mdate, uw.sbe45S, mdate);

IFCB_match.lat = interp1(datenum(uw.date_tsg), uw.lat_tsg, mdate);
IFCB_match.lon = interp1(datenum(uw.date_tsg), uw.lon_tsg, mdate);
IFCB_match.saln = interp1(datenum(uw.date_tsg), uw.s, mdate);
IFCB_match.temp = interp1(datenum(uw.date_tsg), uw.t1, mdate);
save(output, 'IFCB_match', '-append')

it = find(contains(pid, 'IFCB127'));
metadata = table(pid, 'VariableNames', {'pid'});
metadata.pid = pid;
metadata.mdate(it) = mdate(it);
metadata.lat(it) = IFCB_match.lat(it);
metadata.lon(it) = IFCB_match.lon(it);
metadata.depth(it) = 0; 
[~,ia, ib] = intersect(pid, spiropaifcbmetadata.filename);
metadata.mdate(ia) = datenum(spiropaifcbmetadata.date(ib));
metadata.lat(ia) = datenum(spiropaifcbmetadata.latitude(ib));
metadata.lon(ia) = datenum(spiropaifcbmetadata.longitude(ib));
metadata.depth(ia) = datenum(spiropaifcbmetadata.depth(ib));
metadata.cast(ia) = datenum(spiropaifcbmetadata.cast(ib));
metadata.niskin(ia) = datenum(spiropaifcbmetadata.niskin(ib));
metadata{metadata.mdate == 0,2:end} = NaN; %samples without match up, mainly incubations
metadata{metadata.depth == 0,6:7} = NaN; %samples without match up, mainly incubations
metadata.transect = floor(interp1(tstime, trnum, metadata.mdate));

save(output, 'IFCB_match', 'metadata', '-append')

return

i127 = contains(pid, 'IFCB127');
it = find(IFCB_match.lon > -70.84 & IFCB_match.lon < -70.82 & IFCB_match.lat < 41 & contains(pid, 'IFCB127'));

%it = find(IFCB_match.lon > -70.84 & IFCB_match.lon < -70.82 & IFCB_match.lat < 41);
%it = find(IFCB_match.lon > -70.84 & IFCB_match.lon < -70.82);

c = 'brgmck'
t = 0; 
figure
for l = 39.6:.2:40.6
    t = t + 1;
    jj = find(IFCB_match.lat(it)>l & IFCB_match.lat(it)<l+.2);
    %loglog(bins, nanmean(hcounts(it(jj),:)./repmat(ml_analyzed(it(jj)),1,30)), 'color', c(t))
    loglog(bins, mean(hbv(it(jj),:)./repmat(ml_analyzed(it(jj)),1,30)), 'color', c(t))
    hold on
    pause
end
