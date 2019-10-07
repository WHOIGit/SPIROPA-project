%load output from process_attune_v2
%load output from compile_shipdata_armstrong_customcsv.m
%create and save structure with ship's data that closest time match-up to Attune sampling
%SPIROPA AR29 cruise April 2018
%
%Heidi M. Sosik, Woods Hole Oceanographic Insitution, Jan 2019

summarypath = '\\sosiknas1\Lab_data\Attune\cruise_data\20190705_TN368\Summary\';
load([summarypath 'AttuneTable'])
t = strncmpi(AttuneTable.Filename,'SPIROPA_TN368_Grazer', 20);
AttuneTable(find(t),:) = [];
t = strncmpi(AttuneTable.Filename,'FCB', 3);
AttuneTable(find(t),:) = [];

%uw = load('C:\work\SPIROPA\RB1904\UW\tsg_with_gps');
uw = load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\gps\tsg_with_gps');

disp('matching with TSG')
tdiff = NaN(size(AttuneTable,1),1);
match_ind = tdiff;
for ii = 1:length(tdiff)
    [tdiff(ii), match_ind(ii)] = min(abs(datenum(AttuneTable.StartDate(ii)-uw.date_tsg)));
end

uw_match = struct2table(uw);
uw_match = uw_match(match_ind,:);

%AR29_TransectSegments_startingtime %get tstime from Gordon's summary of transect start times
%run('C:\work\SPIROPA\RB1904\rb1904_transect_startime')
run('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\scripts\tn368_transect_startime')

trnum = 1:length(tstime);
uw_match.transect = floor(interp1(tstime,trnum, datenum(AttuneTable.StartDate)));

Attune_uw_match = [AttuneTable uw_match];

uw = load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\gps\flr_with_gps');
% uw = [];
% for day = 12:21
%     uw_temp = load(['\\10.48.13.229\survey\RB1904\gps\flr_with_gps_' num2str(day)]);
%     if ~isempty(uw)
%         uw = merge_structs_append(uw, uw_temp);
%     else 
%         uw = uw_temp;
%     end
% end
% clear uw_temp

disp('matching with FLR')
tdiff = NaN(size(AttuneTable,1),1);
match_ind = tdiff;
for ii = 1:length(tdiff)
    [tdiff(ii), match_ind(ii)] = min(abs(datenum(AttuneTable.StartDate(ii)-uw.date_flr)));
end

uw_match = struct2table(uw);
uw_match = uw_match(match_ind,:);
Attune_uw_match = [Attune_uw_match uw_match];

good = find(AttuneTable.QC_flowrate_std<2 & AttuneTable.QC_flowrate_median<1.5); whos good

save([summarypath 'Attune_uw_match'], 'Attune_uw_match', 'good')
disp(['results saved: ' [summarypath 'Attune_uw_match']])
