%AR29_TransectSegments_startingtime

%AR29_TransectSegments_startingtime %get tstime from Gordon's summary of transect start times
%run('C:\work\SPIROPA\RB1904\rb1904_transect_startime')
%run('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\Gordon_scriptsRB1904\rb1904_transect_startime')
run('C:\work\GitHub_repositories\SPIROPA-project\transect_plotting\tn368_transect_startime.m')
trnum = 1:length(tstime);

tn368ind = find(strcmp(IFCBsum.meta_data.cruise, 'TN368'));
IFCBsum.transect(tn368ind) = floor(interp1(tstime,trnum, IFCBsum.mdate(tn368ind)));

%%
figure, set(gcf,'position', [100 250 1200 500])
tr2plot = 4;
subplot(1,2,1)
ind = find(IFCBsum.transect == tr2plot & strcmp(IFCBsum.meta_data.cruise, 'TN368') & strcmp(IFCBsum.meta_data.sample_type, 'underway'));
scatter(IFCBsum.meta_data.longitude(ind), IFCBsum.meta_data.latitude(ind), 60, alivebv_gt10(ind)./IFCBsum.meta_data.ml_analyzed(ind), 'filled'), set(gca,'ydir', 'rev')
caxis([1e5 5e5])
colorbar
title(['TN368 biovolume concentration (>10 \mum); ' datestr(min(IFCBsum.mdate(ind)), 'dd-mmm')])
subplot(1,2,2)
ind = find(IFCBsum.transect == tr2plot & strcmp(IFCBsum.meta_data.cruise, 'TN368') & strcmp(IFCBsum.meta_data.sample_type, 'underway'));
scatter(IFCBsum.meta_data.longitude(ind), IFCBsum.meta_data.latitude(ind), 60, diatombv_gt10(ind)./IFCBsum.meta_data.ml_analyzed(ind), 'filled'), set(gca,'ydir', 'rev')
caxis([.1e5 1e5])
colorbar
title(['TN368 Diatom biovolume concentration; ' datestr(min(IFCBsum.mdate(ind)), 'dd-mmm')])

%%
figure, set(gcf,'position', [100 250 1200 500])
tr2plot = 3;
subplot(1,2,1)
ind = find(IFCBsum.transect == tr2plot & strcmp(IFCBsum.meta_data.cruise, 'TN368') & strcmp(IFCBsum.meta_data.sample_type, 'underway'));
scatter(IFCBsum.meta_data.longitude(ind), IFCBsum.meta_data.latitude(ind), 60, alivebv_gt10(ind)./IFCBsum.meta_data.ml_analyzed(ind), 'filled'), set(gca,'ydir', 'rev')
caxis([1e5 5e5])
colorbar
title(['TN368 biovolume concentration (>10 \mum); ' datestr(min(IFCBsum.mdate(ind)), 'dd-mmm')])
xlim([-70.87 -70.81])
subplot(1,2,2)
ind = find(IFCBsum.transect == tr2plot & strcmp(IFCBsum.meta_data.cruise, 'TN368') & strcmp(IFCBsum.meta_data.sample_type, 'underway'));
scatter(IFCBsum.meta_data.longitude(ind), IFCBsum.meta_data.latitude(ind), 60, diatombv_gt10(ind)./IFCBsum.meta_data.ml_analyzed(ind), 'filled'), set(gca,'ydir', 'rev')
caxis([.1e5 1e5])
colorbar
title(['TN368 Diatom biovolume concentration; ' datestr(min(IFCBsum.mdate(ind)), 'dd-mmm')])
xlim([-70.87 -70.81])



