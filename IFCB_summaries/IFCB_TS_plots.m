AR29cast = load('\\sosiknas1\IFCB_products\SPIROPA\summary\AR29cast_mean_count_biovol_byclass'); %from bin_samples
AR29cast = AR29cast.cast_table_binned;
bvall = load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2018.mat');
load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_AR29__newdashboard_USEMEcast_match.mat')
load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_AR29__newdashboard_USEMEuw_match.mat')
%%
uwii = find(strcmp(bvall.meta_data.sample_type, 'underway') & strcmp(bvall.meta_data.cruise, 'AR29') & bvall.meta_data.ifcb == 127 & ~bvall.meta_data.skip);
AR29uw = bvall.meta_data(uwii,:);
AR29uw.count = array2table(bvall.classcount(uwii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
AR29uw.biovol = array2table(bvall.classbiovol(uwii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
[~,a,b] = intersect(bvall.filelist(uwii), IFCB_match_uw_results.pid);
AR29uw.T(a) = IFCB_match_uw_results.SBE48T(b);
AR29uw.S(a) = IFCB_match_uw_results.SBE45S(b);
[~,a,b] = intersect(AR29cast.pid, IFCB_match_btl_results.pid);
AR29cast.T(a) = IFCB_match_btl_results.T090C(b);
AR29cast.S(a) = IFCB_match_btl_results.Sal00(b);
class2use = AR29cast.biovol.Properties.VariableNames;
mlmat = repmat(AR29cast.ml_analyzed,1,length(class2use));
AR29cast.biovolconc = AR29cast.biovol;
AR29cast.biovolconc{:,:} = AR29cast.biovolconc{:,:}./mlmat;
mlmat = repmat(AR29uw.ml_analyzed,1,length(class2use));
AR29uw.biovolconc = AR29uw.biovol;
AR29uw.biovolconc{:,:} = AR29uw.biovolconc{:,:}./mlmat;

clear a b IFCB* uwii bvall mlmat
%%
RB1904cast = load('\\sosiknas1\IFCB_products\SPIROPA\summary\RB1904cast_mean_count_biovol_byclass'); %from bin_samples
RB1904cast = RB1904cast.cast_table_binned;
bvall = load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2019.mat');
load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_RB1904__newdashboard_USEMEcast_match.mat')
load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_RB1904__newdashboard_USEMEuw_match.mat')
%%
uwii = find(strcmp(bvall.meta_data.sample_type, 'underway') & strcmp(bvall.meta_data.cruise, 'RB1904') & ~bvall.meta_data.skip);
RB1904uw = bvall.meta_data(uwii,:);
RB1904uw.count = array2table(bvall.classcount(uwii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
RB1904uw.biovol = array2table(bvall.classbiovol(uwii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
[~,a,b] = intersect(bvall.filelist(uwii), IFCB_match_uw_results.pid);
RB1904uw.T(a) = IFCB_match_uw_results.TS(b);
RB1904uw.S(a) = IFCB_match_uw_results.SSPS(b);
[~,a,b] = intersect(RB1904cast.pid, IFCB_match_btl_results.pid);
RB1904cast.T(a) = IFCB_match_btl_results.T090C(b);
RB1904cast.S(a) = IFCB_match_btl_results.Sal00(b);
class2use = RB1904cast.biovol.Properties.VariableNames;
mlmat = repmat(RB1904cast.ml_analyzed,1,length(class2use));
RB1904cast.biovolconc = RB1904cast.biovol;
RB1904cast.biovolconc{:,:} = RB1904cast.biovolconc{:,:}./mlmat;
mlmat = repmat(RB1904uw.ml_analyzed,1,length(class2use));
RB1904uw.biovolconc = RB1904uw.biovol;
RB1904uw.biovolconc{:,:} = RB1904uw.biovolconc{:,:}./mlmat;

clear a b IFCB* uwii bvall mlmat
%%
TN368cast = load('\\sosiknas1\IFCB_products\SPIROPA\summary\TN368cast_mean_count_biovol_byclass'); %from bin_samples
TN368cast = TN368cast.cast_table_binned;
bvall = load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2019.mat');
load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_TN368__newdashboard_USEMEcast_match.mat')
load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_TN368__newdashboard_USEMEuw_match.mat')
%%
uwii = find(strcmp(bvall.meta_data.sample_type, 'underway') & strcmp(bvall.meta_data.cruise, 'TN368') & ~bvall.meta_data.skip);
TN368uw = bvall.meta_data(uwii,:);
TN368uw.count = array2table(bvall.classcount(uwii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
TN368uw.biovol = array2table(bvall.classbiovol(uwii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
[~,a,b] = intersect(bvall.filelist(uwii), IFCB_match_uw_results.pid);
TN368uw.T(a) = IFCB_match_uw_results.TS(b);
TN368uw.S(a) = IFCB_match_uw_results.SSPS(b);
[~,a,b] = intersect(TN368cast.pid, IFCB_match_btl_results.pid);
TN368cast.T(a) = IFCB_match_btl_results.T090C(b);
TN368cast.S(a) = IFCB_match_btl_results.Sal00(b);
class2use = TN368cast.biovol.Properties.VariableNames;
mlmat = repmat(TN368cast.ml_analyzed,1,length(class2use));
TN368cast.biovolconc = TN368cast.biovol;
TN368cast.biovolconc{:,:} = TN368cast.biovolconc{:,:}./mlmat;
mlmat = repmat(TN368uw.ml_analyzed,1,length(class2use));
TN368uw.biovolconc = TN368uw.biovol;
TN368uw.biovolconc{:,:} = TN368uw.biovolconc{:,:}./mlmat;

clear a b IFCB* uwii bvall mlmat
%%
clim = [0 5];
fh = figure('units','normalized','outerposition',[0 0 1 1]);
for cind = 1:length(class2use)
    figure(fh), clf
    subplot(2,3,1)
    tsdiagram([30 37], [-2 28], 10)
    hold on
    scatter(AR29cast.S, AR29cast.T, 10, [.5 .5 .5])
    hold on
    scatter(AR29cast.S, AR29cast.T, 20, log10(AR29cast.biovolconc.(class2use{cind})), 'filled');
    title('AR29 CTD casts')
    text(28,32,class2use(cind), 'interpreter', 'none', 'fontsize', 16, 'color', 'b')
    caxis(clim)
    subplot(2,3,4)
    tsdiagram([30 37], [-2 28], 10)
    hold on
    scatter(AR29uw.S, AR29uw.T, 10, [.5 .5 .5]);
    scatter(AR29uw.S, AR29uw.T, 20, log10(AR29uw.biovolconc.(class2use{cind})), 'filled');
    title('AR29 underway')
    caxis(clim)
    
    subplot(2,3,2)
    tsdiagram([30 37], [-2 28], 10)
    hold on
    scatter(RB1904cast.S, RB1904cast.T, 10, [.5 .5 .5])
    scatter(RB1904cast.S, RB1904cast.T, 20, log10(RB1904cast.biovolconc.(class2use{cind})), 'filled');
    title('RB1904 CTD casts')
    caxis(clim)
    subplot(2,3,5)
    tsdiagram([30 37], [-2 28], 10)
    hold on
    scatter(RB1904uw.S, RB1904uw.T, 10, [.5 .5 .5]);
    scatter(RB1904uw.S, RB1904uw.T, 20, log10(RB1904uw.biovolconc.(class2use{cind})), 'filled');
    title('RB1904 underway')
    caxis(clim)
    
    subplot(2,3,3)
    tsdiagram([30 37], [-2 28], 10)
    hold on
    scatter(TN368cast.S, TN368cast.T, 10, [.5 .5 .5])
    scatter(TN368cast.S, TN368cast.T, 20, log10(TN368cast.biovolconc.(class2use{cind})), 'filled');
    title('TN368 CTD casts')
    caxis(clim)    
    subplot(2,3,6)
    tsdiagram([30 37], [-2 28], 10)
    hold on
    scatter(TN368uw.S, TN368uw.T, 10, [.5 .5 .5]);
    scatter(TN368uw.S, TN368uw.T, 20, log10(TN368uw.biovolconc.(class2use{cind})), 'filled');
    title('TN368 underway')
    caxis(clim)
    cbh = colorbar;
    set(cbh, 'position', [.9 .11 .014 .33]);
    title(cbh, {'log10 Biovolume'; '\mum^{-3} ml^{-1}'})

    print(['\\sosiknas1\ifcb_products\spiropa\summary\TS_plots\TS_biovolconc_' class2use{cind}], '-dpng')
    %pause (.5) 
end
%%

load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_TN368__newdashboard_USEMEcast_match.mat')
load('\\sosiknas1\IFCB_data\SPIROPA\match_up\SPIROPA_TN368__newdashboard_USEMEuw_match.mat')