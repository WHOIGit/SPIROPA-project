cruise = 'TN368';
switch cruise
   case 'RB1904'
       gps = load('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\gps_Gordon\tsg_with_gps_all.mat'); % compiled from ship's raw by Gordon
       ncpath = '\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\samos_download_15861823961188250\samos\netcdf\';
       outfile = '\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\compiled_underway\rb1904_uw_compiled';
    case 'TN368'
       gps = load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\gps\tsg_with_gps.mat');
       ncpath = '\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\samos_download_15867189101404870\samos\netcdf\';
       outfile = '\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\compiled_underway\tn368_uw_compiled';
end

ncfiles = dir([ncpath '*.nc']);
ncfiles = {ncfiles.name}';
info = ncinfo([ncpath ncfiles{1}]);
varname = {info.Variables.Name};
varname = setdiff(varname,{'flag', 'history'});
Tall = table;
for count = 1:length(ncfiles)
    T = table;
    for vcount = 1:length(varname)
        T.(varname{vcount})  = ncread([ncpath ncfiles{count}],varname{vcount});
        T.Properties.VariableUnits{varname{vcount}} = ncreadatt([ncpath ncfiles{count}],varname{vcount}, 'units');
        T.Properties.VariableDescriptions{varname{vcount}} = ncreadatt([ncpath ncfiles{count}],varname{vcount}, 'long_name');   
    end
    Tall = [Tall; T];
end
Tall.matdate = datenum(datenum('1-1-1980') + double(Tall.time)/60/24);

if exist('gps', 'var')
    ind = NaN(size(Tall.matdate));
    mdate_gps = datenum(gps.date_tsg);
    for count = 1:length(Tall.matdate)
        [dd,tt] = min(abs(Tall.matdate(count)-mdate_gps));
        if dd < 2/60/24 %2 minutes as days
            ind(count) = tt;
        end
    end

    temp = NaN(size(ind));
    Tall.latitude_fullres = temp;
    Tall.longitude_fullres = temp;
    Tall.mdate_fullres = temp;
    nind = find(~isnan(ind));
    Tall.latitude_fullres(nind) = gps.lat_tsg(ind(nind));
    Tall.longitude_fullres(nind) = gps.lon_tsg(ind(nind));
    Tall.mdate_fullres(nind) = mdate_gps(ind(nind));
    Tall = movevars(Tall,{'latitude_fullres', 'longitude_fullres'},'Before',1);
    Tall.Properties.VariableNames{'lat'} = 'lat_SAMOS';
    Tall.Properties.VariableNames{'lon'} = 'lon_SAMOS';
else
    Tall = movevars(Tall,{'lat', 'lon'},'Before',1);    
end
uw = Tall;
notes = {'Heidi Sosik, WHOI, produced with compile_SAMOS_withGPSfullres.m from downloaded SAMOS netcdf files and appended higher resolution lat, lon from GPS compilation by Gordon'};
save(outfile, 'uw', 'notes')
disp(['results saved: ' outfile])

