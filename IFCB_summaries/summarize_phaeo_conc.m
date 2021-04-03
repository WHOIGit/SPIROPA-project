load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2018.mat')
load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2018lists.mat')

%%
warning off
meta_data_full = meta_data; mdate_full = mdate;
cruisestr = 'AR29';
cc = strmatch('Phaeo', class2use);
fi1 = strmatch('ESD', classFeaList_variables);
fi2 = strmatch('numBlobs', classFeaList_variables);
numfiles = length(filelist);
count_table = table;
bv_table = table;

for ii = 1:numfiles
    if ~rem(ii,20), disp(filelist(ii)), end
    if ~meta_data.skip(ii)
        temp = cat(1,classFeaList{ii,cc}); 
        bv = 4/3*pi*(temp(:,fi1)/2).^3;
        ind = find(temp(:,fi2)>2);
        count_table.total(ii) = size(temp,1);
        count_table.gt2blobs(ii) = length(ind);
        bv_table.total(ii) = sum(bv);
        bv_table.gt2blobs(ii) = sum(bv(ind));
    end
end
%%

uwii = find(strcmp(meta_data_full.sample_type, 'underway') & strcmp(meta_data_full.cruise, cruisestr) & ~meta_data_full.skip);
meta_data = meta_data_full(uwii,:);
%Phaeocystis_colony_CNN_predicted_concentration_per_ml = classcount(uwii,cc)./meta_data.ml_analyzed;
Phaeocystis_colony_CNN_predicted_concentration_per_ml = count_table.gt2blobs(uwii)./meta_data.ml_analyzed;
mdate = mdate(uwii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_gt2_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

castii = find(strcmp(meta_data_full.sample_type, 'cast') & strcmp(meta_data_full.cruise, cruisestr) & ~meta_data_full.skip);
meta_data = meta_data_full(castii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = count_table.gt2blobs(castii)./meta_data.ml_analyzed;
mdate = mdate_full(castii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_cast_samples_gt2_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')


%%
clear

load('\\sosiknas1\IFCB_products\NESLTER_transect\summary\summary_biovol_allHDF_min20_2018.mat');
load('\\sosiknas1\IFCB_products\NESLTER_transect\summary\summary_biovol_allHDF_min20_2018lists.mat');

cc = strmatch('Phaeo', class2use);
fi1 = strmatch('ESD', classFeaList_variables);
fi2 = strmatch('numBlobs', classFeaList_variables);
numfiles = length(filelist);
count_table = table;
bv_table = table;
for ii = 1:numfiles
    if ~rem(ii,20), disp(filelist(ii)), end
    if ~meta_data.skip(ii)
        temp = cat(1,classFeaList{ii,cc}); 
        bv = 4/3*pi*(temp(:,fi1)/2).^3;
        ind = find(temp(:,fi2)>2);
        count_table.total(ii) = size(temp,1);
        count_table.gt2blobs(ii) = length(ind);
        bv_table.total(ii) = sum(bv);
        bv_table.gt2blobs(ii) = sum(bv(ind));
    end
end

meta_data_full = meta_data; mdate_full = mdate;
cruisestr = 'AR28A';
cc = strmatch('Phaeo', class2use);
uwii = find(strcmp(meta_data_full.sample_type, 'underway') & strcmp(meta_data_full.cruise, cruisestr) & ~meta_data_full.skip);
meta_data = meta_data_full(uwii,:);
%Phaeocystis_colony_CNN_predicted_concentration_per_ml = classcount(uwii,cc)./meta_data.ml_analyzed;
Phaeocystis_colony_CNN_predicted_concentration_per_ml = count_table.gt2blobs(uwii)./meta_data.ml_analyzed;
mdate = mdate_full(uwii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_gt2_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

cruisestr = 'AR28B';
cc = strmatch('Phaeo', class2use);
uwii = find(strcmp(meta_data_full.sample_type, 'underway') & strcmp(meta_data_full.cruise, cruisestr) & ~meta_data_full.skip);
meta_data = meta_data_full(uwii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = count_table.gt2blobs(uwii)./meta_data.ml_analyzed;
mdate = mdate_full(uwii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_gt2_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

castii = find(strcmp(meta_data_full.sample_type, 'cast') & strcmp(meta_data_full.cruise, cruisestr) & ~meta_data_full.skip);
meta_data = meta_data_full(castii,:);
Phaeocystis_colony_CNN_predicted_concentration_per_ml = count_table.gt2blobs(castii)./meta_data.ml_analyzed;
mdate = mdate_full(castii);
save(['\\sosiknas1\IFCB_products\SPIROPA\summary\phaeo_colony_cast_samples_gt2_' cruisestr], 'meta_data', 'Phaeocystis_colony_CNN_predicted_concentration_per_ml', 'classpath_generic', 'mdate', 'cruisestr')

