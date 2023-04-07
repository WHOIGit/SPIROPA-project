%compile_IFCB_metadata_SPIROPA
%ToTag_xlsFile = '\\sosiknas1\IFCB_data\SPIROPA\to_tag\SPIROPA_AR29_to_tag_IFCB127underway.xls';%
cruise = 'AR29';
switch cruise
   case 'AR29'
       %ToTag_xlsFile = '\\sosiknas1\IFCB_data\SPIROPA\to_tag\SPIROPA_AR29_to_tag_newdashboard_USEME.xls';
       %%ToTag_xlsFile = '\\sosiknas1\IFCB_data\SPIROPA\to_tag\SPIROPA_AR29_to_tag_IFCB14staining_USME.csv';
       ToTag_xlsFile = '\\sosiknas1\IFCB_data\SPIROPA\to_tag\SPIROPA_AR29_to_tag_IFCB14staining_needsSTAININGediting.xls';
       load('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\AR29_underway_all') %AR29
       bottle_data = load('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\fromOlga\ar29_bottle_data_Apr_2019_table'); %produced by btlmat2table.m
       load('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\fromOlga\ar29_bottle_depth_niskens_v2')
       bottle_depth = ar29_bottle_depth_niskens_v2; clear ar29_bottle_depth_niskens_v2
       ctd_meta = readtable('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\fromOlga\p_11_ar29_ctd_list.txt');
       ctd_meta.mdate = datenum(ctd_meta.Var2,ctd_meta.Var3,ctd_meta.Var4,ctd_meta.Var5,ctd_meta.Var6,ctd_meta.Var7)
       ctd_meta.Properties.VariableNames{'Var8'} = 'latitude';
       ctd_meta.Properties.VariableNames{'Var9'} = 'longitude';
       ctd_meta.longitude = -1*ctd_meta.longitude; %fix missing negative in Olga's files
    case 'RB1904'
        ToTag_xlsFile = '\\sosiknas1\IFCB_data\SPIROPA\to_tag\SPIROPA_RB1904_to_tag_newdashboard_USEME.xls';
        load('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\compiled_underway\rb1904_uw_compiled')
        bottle_data = load('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\fromOlga\rb1904_bottle_data_Apr_2020_table');
        temp = importdata('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\fromOlga\rb1904_niskin_pressure_depth.txt');
        bottle_depth = temp.data; bottle_depth(:,4) = []; clear temp 
    case 'TN368'
        %ToTag_xlsFile = '\\sosiknas1\IFCB_data\SPIROPA\to_tag\SPIROPA_TN368_to_tag_newdashboard_USEME.xls';
        ToTag_xlsFile = '\\sosiknas1\IFCB_data\SPIROPA\to_tag\SPIROPA_TN368_to_tag_newdashboard_USEME.xls';
        load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\compiled_underway\tn368_uw_compiled')
        %bottle_data = load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\fromOlga\tn368_bottle_data_Apr_2020_table.mat');
        bottle_data = load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\fromOlga\tn368_bottle_data_Jul_2022_table.mat');
        temp = importdata('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\fromOlga\tn368_niskin_pressure_depth.txt');    
        bottle_depth = temp.data; bottle_depth(:,4) = []; clear temp
end 

[~,f] = fileparts(ToTag_xlsFile);

totag = readtable(ToTag_xlsFile);
%avoid case mis-matches
totag.Properties.VariableNames = lower(totag.Properties.VariableNames);
%initialize the new numbers
t = NaN(size(totag(:,1)));
totag = addvars(totag,t,t,t, 'NewVariableNames', {'lat' 'lon' 'depth'});
tagstr = 'sample_type';

%% find the underway matchups
%find the underway rows
uwind = strmatch('underway', totag.(tagstr), 'exact');

%get the underway match up
IFCB_mdate = IFCB_file2date(cellstr(totag.filename(uwind)));
IFCB_match_uw_results = IFCB_match_uw(totag.filename(uwind), IFCB_mdate, uw);
IFCB_match_uw_results.cruise = repmat(cellstr(cruise),size(IFCB_match_uw_results,1),1);

totag.lat(uwind) = IFCB_match_uw_results.lat;
totag.lon(uwind) = IFCB_match_uw_results.lon;
totag.depth(uwind) = NaN;
totag.datetime(uwind) = {''};
totag.cast(uwind) = {''};
%totag.cast(uwind) = NaN;
%totag.niskin(uwind) = {''};
totag.niskin(uwind) = NaN;

%% find the cast data matchups

bottle_data = bottle_data.BTL;
time_tmp = num2str(bottle_data.UTCTimehhmm);
ind = strmatch('  ', time_tmp(:,1:2));
time_tmp(ind,1:2) = repmat('00',length(ind),1);
hh = str2num(time_tmp(:,1:2));
mm = str2num(time_tmp(:,3:4));
bottle_data.mdate = datenum(bottle_data.Year, bottle_data.Month, bottle_data.Day, hh, mm,0);
iso8601format = 'yyyy-mm-dd hh:MM:ss+00:00';
bottle_data.datetime = cellstr(datestr(bottle_data.mdate, iso8601format));

%find the cast rows in totag
castind = strmatch('cast', totag.(tagstr));
%now do the match up and assign cast and niskin in totag
if ~isempty(castind)
    %find the "target depths" to match up with Olga's manipulated bottle files that don't map directly to Niskin numbers
    for count = 1:length(castind)
        ind = find(str2num(totag.cast{castind(count)}) == bottle_depth(:,1) & totag.niskin(castind(count)) == bottle_depth(:,2));
        if ~isempty(ind)
            target_depth(count) = bottle_depth(ind,3);
        end
    end
        
    % Find the cast matchup data
    IFCB_match_btl_results = IFCB_match_btl_spiropa(totag.filename(castind),str2num(char(totag.cast(castind))), target_depth, bottle_data);
    IFCB_match_btl_results.cruise = repmat(cellstr(cruise),size(IFCB_match_btl_results,1),1);
    totag.lat(castind) = IFCB_match_btl_results.lat;
    totag.lon(castind) = IFCB_match_btl_results.lon;
    totag.datetime(castind) = IFCB_match_btl_results.datetime;
    totag.depth(castind) = IFCB_match_btl_results.depth;
end

%check for casts with no info in bottle file
ind = find(isnan(totag.lat(castind)));
if ~isempty(ind)
    unqcast = unique(totag.cast(castind(ind)));
    for count = 1:length(unqcast)
        %iii = find(totag.cast(castind(ind)) == unqcast(count));
        %cind = find(ctd_meta.cast == unqcast(count)));
        iii = strmatch(unqcast(count), totag.cast(castind(ind)));
        cind = find(ctd_meta.Var1 == str2num(unqcast{count}));
        totag.lat(castind(ind(iii))) = ctd_meta.latitude(cind);
        totag.lon(castind(ind(iii))) = ctd_meta.longitude(cind);
        totag.datetime(castind(ind(iii))) = cellstr(datestr(ctd_meta.mdate(cind)));
    end
    disp('No match up with bottle file info for samples listed below. Lat/Lon from CTD metadata, depth from IFCB_log')
    disp(totag(castind(ind),:))
    disp('No match up with bottle file info for samples listed above. Lat/Lon from CTD metadata, depth from IFCB_log')
    disp('Hit any key to continue')
    pause
end
%now check if any IFCB_match_btl results need to be filled with basic meta data
if ~isempty(castind)
    ind = find(isnan(IFCB_match_btl_results.lat));
    [~,a,b] = intersect(IFCB_match_btl_results.pid(ind), totag.filename);
    %    IFCB_match_btl_results.datetime(ind(a)) = totag.datetime(b);
    IFCB_match_btl_results.depth(ind(a)) = totag.depth(b);
    IFCB_match_btl_results.lat(ind(a)) = totag.lat(b);
    IFCB_match_btl_results.lon(ind(a)) = totag.lon(b);
    IFCB_match_btl_results.Cast(ind(a)) = str2num(char(totag.cast(b)));
    %   IFCB_match_btl_restuls.mdate = datenum(IFCB_match_btl_results.datetime, 'yyyy-mm-dd hh:MM:SS+00:00');

end

%% find the underway discrete matchups
%uwdind = strmatch('underway_discrete', totag.tag2);
uwdind = find(ismember(totag.(tagstr), {'underway_discrete' 'bucket'}));

if ~isempty(uwdind)
    %[~,ia,ib] = intersect(totag.filename(uwdind), IFCBlog.filename);
    %if numel(ia) ~= numel(uwdind)
    %    disp('Missing underway_discrete match up')
    %    keyboard
    %end
    temp_mdate = IFCB_file2date(cellstr(totag.filename(uwdind)));
    IFCB_mdate = NaN(size(temp_mdate));
    
    %assume time of first file in set is approximately sample collection time
    %unquw = unique(IFCBlog.cast(ib));
    unquw = unique(totag.cast(uwdind));
    for ii = 1:length(unquw)
        ind = strmatch(unquw(ii), totag.cast(uwdind), 'exact');
        IFCB_mdate(ind) = min(temp_mdate(ind));
    end
    %these are the non-blank datetime entries from the original totag file
    if ismember('datetime_override', totag.Properties.VariableNames)
        ind = setdiff(1:length(uwdind), strmatch(' ', totag.datetime_override(uwdind)));
        IFCB_mdate(ind) = datenum(IFCBlog.datetime(ind), 'yyyy-mm-dd hh:MM:ss+00:00');
    end
    IFCB_match_uwdiscrete_results = IFCB_match_uw(totag.filename(uwdind), IFCB_mdate, uw);
    IFCB_match_uwdiscrete_results.cruise = repmat(cellstr(cruise),size(IFCB_match_uwdiscrete_results,1),1);
    totag.lat(uwdind) = IFCB_match_uwdiscrete_results.lat;
    totag.lon(uwdind) = IFCB_match_uwdiscrete_results.lon;
    totag.depth(uwdind) = NaN;
    totag.datetime(uwdind) = cellstr(datestr(IFCB_mdate,'yyyy-mm-dd hh:MM:ss+00:00'));
    %totag.cast(uwdind) = NaN;
    %totag.cast(uwdind(ia)) = IFCBlog.cast(ib);
    %totag.niskin(uwdind) = NaN;
end
totag.depth(find(ismember(totag.(tagstr), {'bucket'}))) = 0;

%% save results
%totag.Properties.VariableNames(strmatch('Tag1', totag.Properties.VariableNames)) = {'Cruise'}
%if strmatch(tagstr, 'tag2') %old case
%    totag.cruise = repmat(cellstr(cruise),size(totag,1),1);
%end
f = strsplit(ToTag_xlsFile, '.');
writetable(totag, [f{1} '_meta.csv']);
disp(['CSV file for dashboard upload: ' f{1} '_meta.csv'])
[p f] = fileparts(f{1});
p = regexprep(p, 'to_tag', 'match_up\');
f = regexprep(f, 'to_tag', '');
if ~exist(p, 'dir'), mkdir(p), end
disp('Match-up ancillary data files: ')
save([p f 'uw_match'], 'IFCB_match_uw_results')
disp([p f 'uw_match.mat'])
if ~isempty(castind)
    save([p f 'cast_match'], 'IFCB_match_btl_results')
    disp([p f 'cast_match.mat'])
end
if ~isempty(uwdind)
    save([p f 'uwdiscrete_match'], 'IFCB_match_uwdiscrete_results')
    disp([p f 'uwdiscrete_match.mat'])
end
