load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2018.mat')
cruisestr = 'AR29';
cc = strmatch('Phaeo', class2use);
uwii = find(strcmp(meta_data.sample_type, 'underway') & strcmp(meta_data.cruise, cruisestr) & ~meta_data.skip);
meta_data = meta_data(uwii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = classcount(uwii,cc)./meta_data.ml_analyzed;
mdate = mdate(uwii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

clear

load('\\sosiknas1\IFCB_products\NESLTER_transect\summary\summary_biovol_allHDF_min20_2018.mat');
meta_date_full = meta_data; mdate_full = mdate;
cruisestr = 'AR28A';
cc = strmatch('Phaeo', class2use);
uwii = find(strcmp(meta_data.sample_type, 'underway') & strcmp(meta_data.cruise, cruisestr) & ~meta_data.skip);
meta_data = meta_data(uwii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = classcount(uwii,cc)./meta_data.ml_analyzed;
mdate = mdate(uwii,:);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

%clear

%load('\\sosiknas1\IFCB_products\NESLTER_transect\summary\summary_biovol_allHDF_min20_2018.mat');
meta_data = meta_data_full; mdate = mdate_full; clear *full
cruisestr = 'AR28B';
cc = strmatch('Phaeo', class2use);
uwii = find(strcmp(meta_data.sample_type, 'underway') & strcmp(meta_data.cruise, cruisestr) & ~meta_data.skip);
meta_data = meta_data(uwii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = classcount(uwii,cc)./meta_data.ml_analyzed;
mdate = mdate(uwii,:);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')



load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2018.mat')
cruisestr = 'AR29';
cc = strmatch('Phaeo', class2use);
uwii = find(strcmp(meta_data.sample_type, 'underway') & strcmp(meta_data.cruise, cruisestr) & ~meta_data.skip);
castii = find(strcmp(meta_data.sample_type, 'cast') & strcmp(meta_data.cruise, cruisestr) & ~meta_data.skip);
meta_data = meta_data(castii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = classcount(castii,cc)./meta_data.ml_analyzed;
mdate = mdate(castii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_cast_samples_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

clear


load('\\sosiknas1\IFCB_products\NESLTER_transect\summary\summary_biovol_allHDF_min20_2018.mat');
cruisestr = 'AR28B';
cc = strmatch('Phaeo', class2use);
uwii = find(strcmp(meta_data.sample_type, 'underway') & strcmp(meta_data.cruise, cruisestr) & ~meta_data.skip);
castii = find(strcmp(meta_data.sample_type, 'cast') & strcmp(meta_data.cruise, cruisestr) & ~meta_data.skip);
meta_data = meta_data(castii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = classcount(castii,cc)./meta_data.ml_analyzed;
mdate = mdate(castii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_cast_samples_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

clear
