load \\sosiknas1\Lab_data\Attune\cruise_data\20180414_AR29\Summary\Attune_uw_match
good = find(Attune_uw_match.QC_flowrate_std<2 & Attune_uw_match.QC_flowrate_median<1.5); whos good
trnum = 1;
T1=find(Attune_uw_match.transect(good)==trnum);

if 1
figure(1), clf
subplot(2,1,1)
%set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.SynCountTotal(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
hold on
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCountlt2(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount2_5(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount5_10(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount10_20(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount20_50(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)

set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])
legend('Syn', 'Euk <2 \mum', 'Euk 2-5 \mum', 'Euk 5-10 \mum', 'Euk 10-20 \mum','Euk 20-50 \mum', 'location', 'northwest')
ylabel('Cell concentration (mL^{-1})')
title(['Transect ' num2str(trnum)])

%figure
subplot(2,1,2)
%set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.SynCarbonTotal(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
hold on
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCarbonlt2(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCarbon2_5(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCarbon5_10(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCarbon10_20(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCarbon20_50(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)

set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8], 'xgrid', 'on')
legend('Syn', 'Euk <2 \mum', 'Euk 2-5 \mum', 'Euk 5-10 \mum', 'Euk 10-20 \mum', 'Euk 20-50 \mum', 'location', 'northwest')
ylabel('Carbon (\mug L^{-1})')
title(['Transect ' num2str(trnum)])

%pg/mL 10-12 g/10-3 L
%pg/mL*1e-6 = ug/ml
%ug/mL*1e3 = ug/L
%pg/mL*1e-3 = ug/L

T1all=find(Attune_uw_match.transect==trnum);
figure(2), clf
subplot(2,1,1)
%   set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(T1all), Attune_uw_match.flr(T1all), '-', 'linewidth', 2)
ylabel('Chl fluorecence (au), underway')
title(['Transect ' num2str(trnum)])
ylim([60 100])
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])
end

%figure
subplot(2,1,2)
%set(gcf, 'position', [400    450    840    300])
TotalCarbon = Attune_uw_match.SynCarbonTotal+Attune_uw_match.EukCarbonlt2+Attune_uw_match.EukCarbon2_5+Attune_uw_match.EukCarbon5_10+Attune_uw_match.EukCarbon10_20+Attune_uw_match.EukCarbon20_50;
plot(Attune_uw_match.lat(good(T1)), TotalCarbon(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, ' - ', 'linewidth', 2)
ylabel('Carbon (\mug L^{-1}), <20 \mum')
title(['Transect ' num2str(trnum)])
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8], 'xgrid', 'on')

%%
load C:\work\SPIROPA\ifcb127_uw
T = find(ifcb_bv_uw.transect==trnum);

figure(3), clf
subplot(2,1,1)
%set(gcf, 'position', [400    450    840    300])
%plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.SynCountTotal(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
%hold on
%plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCountlt2(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount2_5(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
hold on
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount5_10(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount10_20(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.EukCount20_50(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(datenum(ifcb_bv_uw.lat(T)), ifcb_bv_uw.phytoCountlt5(T)./ifcb_bv_uw.ml_analyzed(T))
plot(datenum(ifcb_bv_uw.lat(T)), ifcb_bv_uw.phytoCount5_10(T)./ifcb_bv_uw.ml_analyzed(T))
plot(datenum(ifcb_bv_uw.lat(T)), ifcb_bv_uw.phytoCount10_20(T)./ifcb_bv_uw.ml_analyzed(T))
plot(datenum(ifcb_bv_uw.lat(T)), ifcb_bv_uw.phytoCount20_50(T)./ifcb_bv_uw.ml_analyzed(T))


set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])
legend('Attune Euk 2-5 \mum', 'Attune Euk 5-10 \mum', 'Attune Euk 10-20 \mum','Attune Euk 20-50 \mum', 'IFCB <5 \mum','IFCB 5-10 \mum', 'IFCB 10-20 \mum', 'IFCB 20-50 \mum', 'location', 'northwest')
ylabel('Cell concentration (mL^{-1})')
title(['Transect ' num2str(trnum)])

%return

matchii=NaN(size(T));
match_diff = matchii;
for ii = 1:length(T)
   [match_diff(ii),matchii(ii)] =  min(abs(ifcb_bv_uw.matdate(T(ii))-datenum(Attune_uw_match.StartDate)));
end

diam_edges = 0:50;

%%
for n = 1:1:length(T)

%n = 15;
diamlist = [];
class = [];
ml_sum = 0;
for ii = -4:4
    %f = regexprep(Attune_uw_match.Filename{matchii(n)}, '25', num2str(25+ii));
    disp(Attune_uw_match.Filename{matchii(n)+ii})
    t = load(['\\sosiknas1\Lab_data\Attune\cruise_data\20180414_AR29\Summary\class\' regexprep(Attune_uw_match.Filename{matchii(n)+ii},'fcs', 'mat')]);
    diamlist = [diamlist; (t.volume/4*3/pi).^(1/3)*2];
    class = [class; t.class];
    ml_sum = ml_sum+Attune_uw_match.VolAnalyzed_ml(matchii(n)+ii);
end

%countdist= histcounts(diamlist(find(t.class)),diam_edges);
countdist= histcounts(diamlist(find(class)),diam_edges);

figure(99), clf
%plot(diam_edges(2:end),countdist./Attune_uw_match.VolAnalyzed_ml(matchii(n)),'*-', 'linewidth', 2)
plot(diam_edges(2:end),countdist./ml_sum,'*-', 'linewidth', 2)
hold on
plot(ifcb_bv_uw_dist.diam_edges(2:end), squeeze(sum(ifcb_bv_uw_dist.classcountdist(T(n),:,:),2))./ifcb_bv_uw.ml_analyzed(T(n)), '.-', 'linewidth', 2)
ylabel('Cells ml^{-1} \mum^{-1}')
xlabel('Estimated diameter (\mum)')
legend('Attune', 'IFCB')
set(gca, 'yscale', 'log')
xlim([0 50])
title(datestr(Attune_uw_match.StartDate(matchii(n))))
pause
end