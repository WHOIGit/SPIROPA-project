%load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2018.mat')
cruisestr = 'AR29';
cc = strmatch('Phaeo', class2use)
uwii = find(strcmp(meta_data.sample_type, 'underway') & strcmp(meta_data.cruise, cruisestr));

%AR28 = load('\\sosiknas1\IFCB_products\NESLTER_transect\summary\summary_biovol_allHDF_min20_2018.mat');
AR28uwiiA = find(strcmp(AR28.meta_data.sample_type, 'underway') & strcmp(AR28.meta_data.cruise, 'AR28A'));
AR28uwiiB = find(strcmp(AR28.meta_data.sample_type, 'underway') & strcmp(AR28.meta_data.cruise, 'AR28B'));

figure, set(gcf, 'position', [290 75 450 640])
scatter(meta_data.longitude(uwii), meta_data.latitude(uwii), 20, classcount(uwii,cc)./meta_data.ml_analyzed(uwii), 'filled')
title('AR29 Phaeocystis colonies (ml^{-1})')
xlim([-72 -70])
ylim([39.6 41.6])
caxis([0 20])
colorbar
set(gca, 'position', [.11 .11 .65 .82])
print \\sosiknas1\ifcb_products\spiropa\summary\AR29_phaeo_colony -dpng

figure, set(gcf, 'position', [290 75 450 640])
scatter(AR28.meta_data.longitude(AR28uwiiA), AR28.meta_data.latitude(AR28uwiiA), 20, AR28.classcount(AR28uwiiA,cc)./AR28.meta_data.ml_analyzed(AR28uwiiA), 'filled')
title('AR28A Phaeocystis colonies (ml^{-1})')
xlim([-72 -70])
ylim([39.6 41.6])
caxis([0 20])
colorbar
set(gca, 'position', [.11 .11 .65 .82])
print \\sosiknas1\ifcb_products\spiropa\summary\AR28A_phaeo_colony -dpng

figure, set(gcf, 'position', [290 75 450 640])
scatter(AR28.meta_data.longitude(AR28uwiiB), AR28.meta_data.latitude(AR28uwiiB), 20, AR28.classcount(AR28uwiiB,cc)./AR28.meta_data.ml_analyzed(AR28uwiiB), 'filled')
title('AR28B Phaeocystis colonies (ml^{-1})')
xlim([-72 -70])
ylim([39.6 41.6])
caxis([0 20])
colorbar
set(gca, 'position', [.11 .11 .65 .82])
print \\sosiknas1\ifcb_products\spiropa\summary\AR28B_phaeo_colony -dpng

figure, set(gcf, 'position', [290 75 450 640])
scatter(meta_data.longitude(uwii), meta_data.latitude(uwii), 20, classbiovol(uwii,cc)./meta_data.ml_analyzed(uwii), 'filled')
title('AR29 Phaeocystis colony biovolume (\mum^3 ml^{-1})')
xlim([-72 -70])
ylim([39.6 41.6])
caxis([0 1e4])
colorbar
set(gca, 'position', [.11 .11 .65 .82])
print \\sosiknas1\ifcb_products\spiropa\summary\AR29_phaeo_colony_bv -dpng

figure, set(gcf, 'position', [290 75 450 640])
scatter(AR28.meta_data.longitude(AR28uwiiA), AR28.meta_data.latitude(AR28uwiiA), 20, AR28.classbiovol(AR28uwiiA,cc)./AR28.meta_data.ml_analyzed(AR28uwiiA), 'filled')
title('AR28A Phaeocystis colony biovolume (\mum^3 ml^{-1})')
xlim([-72 -70])
ylim([39.6 41.6])
caxis([0 1e4])
colorbar
set(gca, 'position', [.11 .11 .65 .82])
print \\sosiknas1\ifcb_products\spiropa\summary\AR28A_phaeo_colony_bv -dpng

figure, set(gcf, 'position', [290 75 450 640])
scatter(AR28.meta_data.longitude(AR28uwiiB), AR28.meta_data.latitude(AR28uwiiB), 20, AR28.classbiovol(AR28uwiiB,cc)./AR28.meta_data.ml_analyzed(AR28uwiiB), 'filled')
title('AR28B Phaeocystis colony (\mum^3 ml^{-1})')
xlim([-72 -70])
ylim([39.6 41.6])
caxis([0 1e4])
colorbar
set(gca, 'position', [.11 .11 .65 .82])
print \\sosiknas1\ifcb_products\spiropa\summary\AR28B_phaeo_colony_bv -dpng
