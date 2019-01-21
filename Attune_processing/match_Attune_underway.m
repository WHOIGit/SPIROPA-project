%load output from process_attune_v2 
%load output from compile_shipdata_armstrong_customcsv.m
%create and save structure with ship's data that closest time match-up to Attune sampling
%SPIROPA AR29 cruise April 2018
%
%Heidi M. Sosik, Woods Hole Oceanographic Insitution, Jan 2019

summarypath = '\\sosiknas1\Lab_data\Attune\cruise_data\20180414_AR29\Summary\';
load([summarypath 'AttuneTable'])
t = strncmpi(AttuneTable.Filename,'SFD_AR29_Grazer', 12);
AttuneTable(find(t),:) = [];
t = strncmpi(AttuneTable.Filename,'SFD_AR29_Dilution', 12);
AttuneTable(find(t),:) = [];

uw = load('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\underway\proc\AR29_underway');

tdiff = NaN(size(AttuneTable,1),1);
match_ind = tdiff;
for ii = 1:length(tdiff)
    [tdiff(ii), match_ind(ii)] = min(abs(datenum(AttuneTable.StartDate(ii))-uw.mdate));
end

uw_match = struct2table(uw);
uw_match = uw_match(match_ind,:);

AR29_TransectSegments_startingtime %get tstime from Gordon's summary of transect start times

trnum = 1:length(tstime);
uw_match.transect = floor(interp1(tstime,trnum, datenum(AttuneTable.StartDate)));

Attune_uw_match = [AttuneTable uw_match];

good = find(AttuneTable.QC_flowrate_std<2 & AttuneTable.QC_flowrate_median<1.5); whos good

save([summarypath 'Attune_uw_match'], 'Attune_uw_match', 'good')
disp(['results saved: ' [summarypath 'Attune_uw_match']])
