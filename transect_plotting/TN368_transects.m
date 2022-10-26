%S19 = load("\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2019.mat");
S19 = load("c:\work\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2019.mat");
L19 = load("c:\work\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2019lists.mat");

TNuwind = find(strcmp(S19.meta_data.cruise, 'TN368') & strcmp(S19.meta_data.sample_type, 'underway') & ~(S19.meta_data.skip));

run("\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\scripts\tn368_transect_startime.m")
trnum = 1:length(tstime);
S19.meta_data.transect(TNuwind) = floor(interp1(tstime,trnum, S19.mdate(TNuwind)));
ii1 = (S19.meta_data.transect(TNuwind)==1);
ii5_7 = (ismember(S19.meta_data.transect(TNuwind),[5 6 7]));
ii8 = (S19.meta_data.transect(TNuwind)==8);
ii3_7 = (ismember(S19.meta_data.transect(TNuwind),[3 4 5 6 7]));

%%
class2use = S19.class2use;
group_table = readtable('\\sosiknas1\training_sets\IFCB\config\IFCB_classlist_type.csv');
[~,ia,ib] = intersect(group_table.CNN_classlist, class2use);
diatom_ind = ib(find(group_table.Diatom(ia)));
dino_ind = ib(find(group_table.Dinoflagellate(ia)));
nano_ind = ib(find(group_table.Nano(ia) | group_table.flagellate(ia) | group_table.Coccolithophore(ia)));
ciliate_ind = ib(find(group_table.Ciliate(ia)));
artifact_ind = ib(find(group_table.IFCBArtifact(ia)));
otherPhyto_ind = [strmatch('Pseudochattonella_farcimen', class2use); strmatch('Phaeocystis', class2use, 'exact')];
phyto_ind = [diatom_ind; dino_ind; nano_ind; otherPhyto_ind];
particle_ind = setdiff(1:length(class2use), artifact_ind);
%%
load \\sosiknas1\Lab_data\Attune\cruise_data\20190705_TN368\bead_calibrated\Attune_uw_match
Attune_mdate = datenum(Attune_uw_match.StartDate_Atable);

%%
phytoCconc = table;
Twin = 12/60/24; %12 minutes as days
for count = 1:length(TNuwind)
    temp = array2table(cat(1,L19.classFeaList{TNuwind(count),[phyto_ind]}), 'VariableNames', L19.classFeaList_variables);
    ind = (temp.ESD>=10 & temp.score<20);
    phytoCconc.IFCB_C10_20(count) = sum(temp.cellC(ind))./S19.meta_data.ml_analyzed(TNuwind(count))/1000;
    ind = (temp.ESD>=20 & temp.score<100);
    phytoCconc.IFCB_C20_100(count) = sum(temp.cellC(ind))./S19.meta_data.ml_analyzed(TNuwind(count))/1000;
    attune_ind = find(Attune_mdate>S19.mdate(TNuwind(count))-Twin & Attune_mdate<S19.mdate(TNuwind(count))+Twin);  
    phytoCconc.FCM_C0to2(count) = sum(Attune_uw_match.carbon0to2(attune_ind))./sum(Attune_uw_match.VolAnalyzed_ml(attune_ind))/1000;
    phytoCconc.FCM_C2to10(count) = sum(Attune_uw_match.carbon2to5(attune_ind)+Attune_uw_match.carbon5to10(attune_ind))./sum(Attune_uw_match.VolAnalyzed_ml(attune_ind))/1000;
    phytoCconc.FCM_C10to20(count) = sum(Attune_uw_match.carbon10to20(attune_ind))./sum(Attune_uw_match.VolAnalyzed_ml(attune_ind))/1000;
end
phytoCarbonConcentration_underway.longitude = S19.meta_data.longitude(TNuwind);
phytoCarbonConcentration_underway.latitude = S19.meta_data.latitude(TNuwind);
phytoCarbonConcentration_underway.transect = S19.meta_data.transect(TNuwind);

phytoCarbonConcentration_underway = table;
phytoCarbonConcentration_underway.datetime = datetime(S19.mdate(TNuwind), 'ConvertFrom', 'datenum');
phytoCarbonConcentration_underway.latitude = S19.meta_data.latitude(TNuwind);
phytoCarbonConcentration_underway.longitude = S19.meta_data.longitude(TNuwind);
phytoCarbonConcentration_underway.transect = S19.meta_data.transect(TNuwind);
phytoCarbonConcentration_underway.IFCBfilename = S19.meta_data.pid(TNuwind);
phytoCarbonConcentration_underway.ESD_less_than2micron = phytoCconc.FCM_C0to2;
phytoCarbonConcentration_underway.ESD_2to10micron = phytoCconc.FCM_C2to10;
phytoCarbonConcentration_underway.ESD_10to20micron = phytoCconc.IFCB_C10_20;
phytoCarbonConcentration_underway.ESD_20to100micron = phytoCconc.IFCB_C20_100;
phytoCarbonConcentration_underway.ESD_less_than_100micron = phytoCconc.FCM_C0to2+phytoCconc.FCM_C2to10+phytoCconc.IFCB_C10_20+phytoCconc.IFCB_C20_100;

notes = {'Phytoplankton carbon concentration, units milligrams per cubic meter'; 'Less than 10 microns from Attune; Greater than 10 microns from IFCB'; 'Produced from TN368_transects.m'};
save('\\sosiknas1\IFCB_products\SPIROPA\summary\TN368_phytoCarbonConcentration_underway', 'notes', 'phytoCarbonConcentration_underway')




%%
iA8 = (Attune_uw_match.transect==8);
iA1 = (Attune_uw_match.transect==1);
iA5_7 = (ismember(Attune_uw_match.transect,[5 6 7]));
iA3_7 = (ismember(Attune_uw_match.transect,[3 4 5 6 7]));

%%
figure, set(gcf, 'position', [350 50 550 580])
th = tiledlayout(4,1);
nexttile
yyaxis left
plot(Attune_uw_match.lon_flr(iA8), Attune_uw_match.flr(iA8), '-', 'linewidth', 2)
ylabel('Chl fluor')
yyaxis right
plot(Attune_uw_match.lon_flr(iA8), Attune_uw_match.T(iA8), '-', 'linewidth', 2)
ylabel('Temperature (\circC)')
title(th, 'TN368 Transect 8')
grid on

nexttile
yyaxis left
plot(Attune_uw_match.longitude_fullres(iA8), Attune_uw_match.(" Syn_count ")(iA8)./Attune_uw_match.VolAnalyzed_ml(iA8), '.-', 'linewidth', 2)
ylabel('Syn (ml^{-1})')
ylim([0 inf])
yyaxis right
plot(Attune_uw_match.longitude_fullres(iA8), Attune_uw_match.(" Euk_count ")(iA8)./Attune_uw_match.VolAnalyzed_ml(iA8), '.-', 'linewidth', 2)
ylabel('Picoeukaryotes (ml^{-1})')
grid on

nexttile
yyaxis left
plot(S19.meta_data.longitude(TNuwind(ii8)), sum(S19.classcount(TNuwind(ii8),nano_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii8)), '.-', 'linewidth', 2)
ylabel('Misc. nanoplankton (ml^{-1})')
grid on

nexttile
yyaxis left
plot(S19.meta_data.longitude(TNuwind(ii8)), sum(S19.classcount(TNuwind(ii8),diatom_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii8)), '.-', 'linewidth', 2)
hold on
ylabel('Diatoms (ml^{-1})')
yyaxis right
plot(S19.meta_data.longitude(TNuwind(ii8)), sum(S19.classcount(TNuwind(ii8),dino_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii8)), '.-', 'linewidth', 2)
ylabel('Dinoflagellates (ml^{-1})')
grid on

%%
figure, set(gcf, 'position', [350 50 550 580])
th = tiledlayout(4,1);
nexttile
yyaxis left
plot(Attune_uw_match.lat_flr(iA1), Attune_uw_match.flr(iA1), '-', 'linewidth', 2)
set(gca, 'xdir', 'rev')
ylabel('Chl fluor')
yyaxis right
plot(Attune_uw_match.lat_flr(iA1), Attune_uw_match.T(iA1), '-', 'linewidth', 2)
set(gca, 'xdir', 'rev')
ylabel('Temperature (\circC)')
title(th, 'TN368 Transect 1')
grid on

nexttile
yyaxis left
plot(Attune_uw_match.latitude_fullres(iA1), Attune_uw_match.(" Syn_count ")(iA1)./Attune_uw_match.VolAnalyzed_ml(iA1), '.-', 'linewidth', 2)
set(gca, 'xdir', 'rev')
ylabel('Syn (ml^{-1})')
ylim([0 inf])
yyaxis right
plot(Attune_uw_match.latitude_fullres(iA1), Attune_uw_match.(" Euk_count ")(iA1)./Attune_uw_match.VolAnalyzed_ml(iA1), '.-', 'linewidth', 2)
ylabel('Picoeukaryotes (ml^{-1})')
grid on

nexttile
yyaxis left
plot(S19.meta_data.latitude(TNuwind(ii1)), sum(S19.classcount(TNuwind(ii1),nano_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii1)), '.-', 'linewidth', 2)
ylabel('Misc. nanoplankton (ml^{-1})')
grid on
set(gca, 'xdir', 'rev')

nexttile
yyaxis left
plot(S19.meta_data.latitude(TNuwind(ii1)), sum(S19.classcount(TNuwind(ii1),diatom_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii1)), '.-', 'linewidth', 2)
hold on
ylabel('Diatoms (ml^{-1})')
yyaxis right
plot(S19.meta_data.latitude(TNuwind(ii1)), sum(S19.classcount(TNuwind(ii1),dino_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii1)), '.-', 'linewidth', 2)
ylabel('Dinoflagellates (ml^{-1})')
grid on
set(gca, 'xdir', 'rev')
%%
figure, set(gcf, 'position', [350 50 550 580])
th = tiledlayout(2,4);
nexttile
scatter(Attune_uw_match.lon_flr(iA5_7), Attune_uw_match.lat_flr(iA5_7), 20, Attune_uw_match.T(iA5_7), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'Temperature (\circC)')
grid on
nexttile
scatter(Attune_uw_match.lon_flr(iA5_7), Attune_uw_match.lat_flr(iA5_7), 20, Attune_uw_match.flr(iA5_7), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb, 'Chl fluor')
title(th, 'TN368 Transects 5-7')
grid on

nexttile
scatter(Attune_uw_match.longitude_fullres(iA5_7),Attune_uw_match.latitude_fullres(iA5_7), 20, log10(Attune_uw_match.(" Syn_count ")(iA5_7)./Attune_uw_match.VolAnalyzed_ml(iA5_7)), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb, 'log10 Syn (ml^{-1})')
grid on

nexttile
scatter(Attune_uw_match.longitude_fullres(iA5_7), Attune_uw_match.latitude_fullres(iA5_7), 20, log10(Attune_uw_match.(" Euk_count ")(iA5_7)./Attune_uw_match.VolAnalyzed_ml(iA5_7)), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'log10 Picoeukaryotes (ml^{-1})')
grid on

nexttile
scatter(S19.meta_data.longitude(TNuwind(ii5_7)), S19.meta_data.latitude(TNuwind(ii5_7)), 20, log10(sum(S19.classcount(TNuwind(ii5_7),nano_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii5_7))), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'log10 Misc. nanoplankton (ml^{-1})')
grid on

nexttile
scatter(S19.meta_data.longitude(TNuwind(ii5_7)), S19.meta_data.latitude(TNuwind(ii5_7)), 20, sum(S19.classcount(TNuwind(ii5_7),dino_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii5_7)), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'log10 Dinoflagellates (ml^{-1})')
grid on

nexttile
scatter(S19.meta_data.longitude(TNuwind(ii5_7)), S19.meta_data.latitude(TNuwind(ii5_7)), 20, log10(sum(S19.classcount(TNuwind(ii5_7),diatom_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii5_7))), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'log10 Diatoms (ml^{-1})')
grid on
%%

figure, set(gcf, 'position', [350 50 550 580])
th = tiledlayout(2,4);
nexttile
Z = (Attune_uw_match.biovolume0to2(iA3_7) + Attune_uw_match.biovolume2to5(iA3_7))./Attune_uw_match.VolAnalyzed_ml(iA3_7);
scatter(Attune_uw_match.longitude_fullres(iA3_7),Attune_uw_match.latitude_fullres(iA3_7), 20, Z, 'filled')
cb = colorbar('Location', 'northoutside'); title(cb, 'Phyto 1-5 \mum ESD (\mum^{3} ml^{-1})')
grid on

nexttile
Z = sum(S19.classbiovol(TNuwind(ii4_7),[diatom_ind; nano_ind; dino_ind]),2)./S19.meta_data.ml_analyzed(TNuwind(ii4_7));
scatter(S19.meta_data.longitude(TNuwind(ii4_7)), S19.meta_data.latitude(TNuwind(ii4_7)), 20, Z, 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'Phyto ~5-100 \mum ESD (\mum^{3} ml^{-1})')
grid on

nexttile
Z1 = (Attune_uw_match.biovolume0to2(iA3_7) + Attune_uw_match.biovolume2to5(iA3_7))./Attune_uw_match.VolAnalyzed_ml(iA3_7);
Z2 = sum(S19.classbiovol(TNuwind(ii4_7),[diatom_ind; nano_ind; dino_ind]),2)./S19.meta_data.ml_analyzed(TNuwind(ii4_7));
Z1int = interp1(datenum(Attune_uw_match.StartDate(iA3_7)), Z1, S19.mdate(TNuwind(ii4_7)));
Z = Z1int+Z2;
scatter(S19.meta_data.longitude(TNuwind(ii4_7)), S19.meta_data.latitude(TNuwind(ii4_7)), 20, Z, 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'Phyto 1-100 \mum ESD (\mum^{3} ml^{-1})')
grid on
%%
figure, set(gcf, 'position', [350 50 550 580])
th = tiledlayout(2,4);
nexttile
Z = (Attune_uw_match.carbon0to2(iA3_7) + Attune_uw_match.carbon2to5(iA3_7))./Attune_uw_match.VolAnalyzed_ml(iA3_7);
scatter(Attune_uw_match.longitude_fullres(iA3_7),Attune_uw_match.latitude_fullres(iA3_7), 20, Z/1000, 'filled')
cb = colorbar('Location', 'northoutside'); title(cb, 'Phyto 1-5 \mum ESD (mgC m^{-3})')
caxis([0 35])
grid on

nexttile
Z = sum(S19.classC(TNuwind(ii4_7),[diatom_ind; nano_ind; dino_ind]),2)./S19.meta_data.ml_analyzed(TNuwind(ii4_7));
scatter(S19.meta_data.longitude(TNuwind(ii4_7)), S19.meta_data.latitude(TNuwind(ii4_7)), 20, Z/1000, 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'Phyto ~5-100 \mum ESD (mgC m^{-3})')
grid on
caxis([0 35])

nexttile
Z1 = (Attune_uw_match.carbon0to2(iA3_7) + Attune_uw_match.carbon2to5(iA3_7))./Attune_uw_match.VolAnalyzed_ml(iA3_7);
Z2 = sum(S19.classC(TNuwind(ii4_7),[diatom_ind; nano_ind; dino_ind]),2)./S19.meta_data.ml_analyzed(TNuwind(ii4_7));
Z1int = interp1(datenum(Attune_uw_match.StartDate(iA3_7)), Z1, S19.mdate(TNuwind(ii4_7)));
Z = Z1int+Z2;
scatter(S19.meta_data.longitude(TNuwind(ii4_7)), S19.meta_data.latitude(TNuwind(ii4_7)), 20, Z/1000, 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'Phyto 1-100 \mum ESD (mgC m^{-3})')
grid on
caxis([0 70])

nexttile
temp = gca;

nexttile
Z = (Attune_uw_match.carbon0to2(iA3_7) + Attune_uw_match.carbon2to5(iA3_7))./Attune_uw_match.VolAnalyzed_ml(iA3_7);
scatter(Attune_uw_match.longitude_fullres(iA3_7),Attune_uw_match.latitude_fullres(iA3_7), 20, log10(Z/1000), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb, 'Phyto 1-5 \mum ESD (log10 mgC m^{-3})')
caxis(log10([5 35]))
grid on

nexttile
Z = sum(S19.classC(TNuwind(ii4_7),[diatom_ind; nano_ind; dino_ind]),2)./S19.meta_data.ml_analyzed(TNuwind(ii4_7));
scatter(S19.meta_data.longitude(TNuwind(ii4_7)), S19.meta_data.latitude(TNuwind(ii4_7)), 20, log10(Z/1000), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'Phyto ~5-100 \mum ESD (log10 mgC m^{-3})')
grid on
caxis(log10([5 35]))

nexttile
Z1 = (Attune_uw_match.carbon0to2(iA3_7) + Attune_uw_match.carbon2to5(iA3_7))./Attune_uw_match.VolAnalyzed_ml(iA3_7);
Z2 = sum(S19.classC(TNuwind(ii4_7),[diatom_ind; nano_ind; dino_ind]),2)./S19.meta_data.ml_analyzed(TNuwind(ii4_7));
Z1int = interp1(datenum(Attune_uw_match.StartDate(iA3_7)), Z1, S19.mdate(TNuwind(ii4_7)));
Z = Z1int+Z2;
scatter(S19.meta_data.longitude(TNuwind(ii4_7)), S19.meta_data.latitude(TNuwind(ii4_7)), 20, log10(Z/1000), 'filled')
cb = colorbar('Location', 'northoutside'); title(cb,'Phyto 1-100 \mum ESD (log10 mgC m^{-3})')
grid on
caxis(log10([10 70]))
delete(temp)

%%
castind = find(strcmp(S19.meta_data.cruise, 'TN368') & strcmp(S19.meta_data.sample_type, 'cast') & ~(S19.meta_data.skip));
trnum = 1:length(tstime);
S19.meta_data.transect(castind) = floor(interp1(tstime,trnum, S19.mdate(castind)));
ic1 = (S19.meta_data.transect(castind)==1);
ic5_7 = (ismember(S19.meta_data.transect(castind),[5 6 7]));
ic8 = (S19.meta_data.transect(castind)==8);

castind = find(strcmp(S19.meta_data.cruise, 'TN368') & strcmp(S19.meta_data.sample_type, 'cast') & ~(S19.meta_data.skip));
%castind = find(strcmp(S19.meta_data.cruise, 'TN368') & strcmp(S19.meta_data.sample_type, 'cast') & ~(S19.meta_data.skip) & S19.mdate < datenum('7-7-2019') );
%%
t1 = find(strcmp(S19.meta_data.cruise, 'TN368') & strcmp(S19.meta_data.sample_type, 'cast') & ~(S19.meta_data.skip) & S19.meta_data.transect==1 );
figure
tiledlayout(3,1)
nexttile
scatter( S19.meta_data.latitude(t1), S19.meta_data.depth(t1),40, log10(sum(S19.classcount(t1,diatom_ind),2)./S19.meta_data.ml_analyzed(t1)), 'filled')
set(gca, 'ydir', 'rev', 'xdir', 'rev')
nexttile
scatter( S19.meta_data.latitude(t1), S19.meta_data.depth(t1),40, log10(sum(S19.classcount(t1,dino_ind),2)./S19.meta_data.ml_analyzed(t1)), 'filled')
set(gca, 'ydir', 'rev', 'xdir', 'rev')
nexttile
scatter( S19.meta_data.latitude(t1), S19.meta_data.depth(t1),40, log10(sum(S19.classcount(t1,nano_ind),2)./S19.meta_data.ml_analyzed(t1)), 'filled')
set(gca, 'ydir', 'rev', 'xdir', 'rev')
colorbar

%%
figure
th = tiledlayout(2,4)
[~,s] = sort(sum(S19.classcount(TNuwind(ii5_7),diatom_ind),1), 'descend');
for ind = 1:8
    nexttile
    scatter(S19.meta_data.longitude(TNuwind(ii5_7)), S19.meta_data.latitude(TNuwind(ii5_7)), 20, log10(S19.classcount(TNuwind(ii5_7),diatom_ind(s(ind)))./S19.meta_data.ml_analyzed(TNuwind(ii5_7))), 'filled')
    title(class2use(diatom_ind(s(ind))), 'interpreter', 'none')
end
%%
%%
figure
th = tiledlayout(2,4)
[~,s] = sort(sum(S19.classcount(TNuwind(ii5_7),dino_ind),1), 'descend');
for ind = 1:8
    nexttile
    scatter(S19.meta_data.longitude(TNuwind(ii5_7)), S19.meta_data.latitude(TNuwind(ii5_7)), 20, (S19.classcount(TNuwind(ii5_7),dino_ind(s(ind)))./S19.meta_data.ml_analyzed(TNuwind(ii5_7))), 'filled')
    title(class2use(dino_ind(s(ind))), 'interpreter', 'none')
end
%%

return


%%
figure
[~,s] = sort(sum(S19.classC(TNuwind(ii8),diatom_ind),1), 'descend');
figure
tiledlayout(2,1)
nexttile
plot(S19.meta_data.longitude(TNuwind(ii8)), S19.classcount(TNuwind(ii8),diatom_ind(s(1:2)))./S19.meta_data.ml_analyzed(TNuwind(ii8)), '.-', 'linewidth', 2)
hold on
plot(S19.meta_data.longitude(TNuwind(ii8)), sum(S19.classcount(TNuwind(ii8),diatom_ind),2)./S19.meta_data.ml_analyzed(TNuwind(ii8)), '.-', 'linewidth', 2)

legend([class2use(diatom_ind(s(1:2))); 'all diatoms'])

cc = strmatch('Chaetoceros', class2use);

%%
