%load \\sosiknas1\Lab_data\Attune\cruise_data\20180414_AR29\Summary\Attune_uw_match
load E:\SPIROPA\Attune_Export\Thompson_SPIROPA_export\Summary\Attune_uw_match

good = find(Attune_uw_match.QC_flowrate_std<2 & Attune_uw_match.QC_flowrate_median<1.5); whos good
trnum = 26;
T1=find(Attune_uw_match.transect(good)==trnum);
Attune_uw_match.lat = Attune_uw_match.lat_tsg;


if 1
figure, clf
subplot(2,1,1)
%set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.Syn_count(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
hold on
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.Euk_count(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8], 'ylim', [0 1e5])
legend('Syn', 'Eukaryotes', 'location', 'northwest')
ylabel('Cell concentration (mL^{-1})')
t = title({['Transect ' num2str(trnum)];  datestr(floor(datenum(Attune_uw_match.StartDate(good(T1(1))))))}, 'fontsize', 14);
set(t, 'position', [39.8 6e4 0])
subplot(2,1,2)
%set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.count_0to2(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
hold on
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.count_2to5(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.count_5to10(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.count_10to20(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)
%plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.count_20to50(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1)), '+-', 'linewidth', 1)

set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])
legend('<2 \mum', '2-5 \mum', '5-10 \mum', '10-20 \mum','20-50 \mum', 'location', 'northwest')
ylabel('Cell concentration (mL^{-1})')
set(gca, 'yscale', 'log', 'ytick', [1e1 1e2 1e3 1e4 1e5])
%%
figure
subplot(2,1,1)
%set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.Syn_carbon(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
hold on
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.Euk_carbon(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])
legend('Syn', 'Eukaryotes', 'location', 'northwest')
ylabel('Carbon (\mug L^{-1})')
title(['Transect ' num2str(trnum)])

subplot(2,1,2)
%set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.carbon0to2(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
hold on
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.carbon2to5(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.carbon5to10(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.carbon10to20(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
%plot(Attune_uw_match.lat(good(T1)), Attune_uw_match.carbon20to50(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, '+-', 'linewidth', 1)
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])
legend('<2 \mum', '2-5 \mum', '5-10 \mum', '10-20 \mum','20-50 \mum', 'location', 'northwest')
ylabel('Carbon (\mug L^{-1})')
set(gca, 'yscale', 'log')
%%

%pg/mL 10-12 g/10-3 L
%pg/mL*1e-6 = ug/ml
%ug/mL*1e3 = ug/L
%pg/mL*1e-3 = ug/L
%%
%scatter(Attune_uw_match.lon_tsg, Attune_uw_match.lat_tsg, 20, Attune_uw_match.Syn_count./Attune_uw_match.VolAnalyzed_ml, 'filled')
%scatter(Attune_uw_match.lon_tsg, Attune_uw_match.lat_tsg, 20, Attune_uw_match.t1, 'filled')
%scatter(Attune_uw_match.StartDate, Attune_uw_match.lat_tsg, 20, Attune_uw_match.t1, 'filled')

%main line
trnum_set = [1:5,11,26,27,34,37,43,44,49,50,51];
Tset = find(ismember(Attune_uw_match.transect(good), trnum_set));
%T1=find(Attune_uw_match.transect(good)==trnum);
Attune_uw_match.lat = Attune_uw_match.lat_tsg;

figure
set(gcf, 'position', [490 42 700 750])
subplot(4,1,1)
scatter(Attune_uw_match.StartDate(good(Tset)), Attune_uw_match.lat_tsg(good(Tset)), 20, log10(Attune_uw_match.Syn_count(good(Tset))./Attune_uw_match.VolAnalyzed_ml(good(Tset))), 'filled')
caxis([3.4 5.1]), colormap jet, colorbar
title('Log Syn (ml^{-1})')
subplot(4,1,2)
scatter(Attune_uw_match.StartDate(good(Tset)), Attune_uw_match.lat_tsg(good(Tset)), 20, log10(Attune_uw_match.Euk_count(good(Tset))./Attune_uw_match.VolAnalyzed_ml(good(Tset))), 'filled')
caxis([3 4.6]), colormap jet, colorbar
title('Log Eukaryotes (ml^{-1})')
subplot(4,1,3)
scatter(Attune_uw_match.StartDate(good(Tset)), Attune_uw_match.lat_tsg(good(Tset)), 20, Attune_uw_match.t1(good(Tset)), 'filled')
caxis([15 25]), colormap jet, colorbar
title('Temperature (\circC)')
subplot(4,1,4)
scatter(Attune_uw_match.StartDate(good(Tset)), Attune_uw_match.lat_tsg(good(Tset)), 20, Attune_uw_match.s(good(Tset)), 'filled')
caxis([31.5 35.5]), colormap jet, colorbar
title('Salinity')


figure
totalC = Attune_uw_match.carbon0to2+Attune_uw_match.carbon2to5+Attune_uw_match.carbon5to10+Attune_uw_match.carbon10to20;
%scatter(Attune_uw_match.StartDate, Attune_uw_match.lat_tsg, 20, (Attune_uw_match.carbon0to2+Attune_uw_match.carbon2to5+Attune_uw_match.carbon5to10)./totalC, 'filled')
scatter(Attune_uw_match.StartDate, Attune_uw_match.lat_tsg, 20, (Attune_uw_match.carbon0to2+Attune_uw_match.carbon2to5+Attune_uw_match.carbon5to10), 'filled')
caxis([0 1]), colormap jet, colorbar
title('Fraction C <10 \mum')

figure

end
return

T1all=find(Attune_uw_match.transect==trnum);
figure(2), clf
subplot(2,1,1)
%   set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(T1all), Attune_uw_match.flr(T1all), '-', 'linewidth', 2)
ylabel('Chl fluorecence (au), underway')
title(['Transect ' num2str(trnum)])
%ylim([60 100])
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])

subplot(2,1,2)
%   set(gcf, 'position', [400    450    840    300])
plot(Attune_uw_match.lat(T1all), Attune_uw_match.t1(T1all), '-', 'linewidth', 2)
ylabel('Temperature (\circC), underway')
title(['Transect ' num2str(trnum)])
%ylim([60 100])
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8])

%figure
subplot(2,1,2)
%set(gcf, 'position', [400    450    840    300])
TotalCarbon = Attune_uw_match.SynCarbonTotal+Attune_uw_match.EukCarbonlt2+Attune_uw_match.EukCarbon2_5+Attune_uw_match.EukCarbon5_10+Attune_uw_match.EukCarbon10_20+Attune_uw_match.EukCarbon20_50;
plot(Attune_uw_match.lat(good(T1)), TotalCarbon(good(T1))./Attune_uw_match.VolAnalyzed_ml(good(T1))/1000, ' - ', 'linewidth', 2)
ylabel('Carbon (\mug L^{-1}), <20 \mum')
title(['Transect ' num2str(trnum)])
set(gca, 'xdir', 'rev', 'xlim', [39.6 40.8], 'xgrid', 'on')


