bvall = load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2019.mat');
%cruisestr = 'RB1904';
cruisestr = 'TN368';

%bvall = load('\\sosiknas1\IFCB_products\SPIROPA\summary\summary_biovol_allHDF_min20_2018.mat');
%cruisestr = 'AR29';

castii = find(strcmp(bvall.meta_data.sample_type, 'cast') & strcmp(bvall.meta_data.cruise, cruisestr) & ~bvall.meta_data.skip);
%datcol1 = size(bvall.meta_data,2)+1;
%cast_table_all = [bvall.meta_data(castii,:) array2table(bvall.classcount(castii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use))];
cast_table_all = bvall.meta_data(castii,:);
%cast_table_all.count = array2table(bvall.classcount(castii,:));
cast_table_all.count = array2table(bvall.classcount(castii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
cast_table_all.biovol = array2table(bvall.classbiovol(castii,:), 'VariableNames', matlab.lang.makeValidName(bvall.class2use));
cast_table_all.pid_all = cast_table_all.pid; %initialize
ci = unique(cast_table_all.cast);
cast_niskin = unique(cast_table_all(:,10:11), 'rows');
cast_table_binned = table;

for ii = 1:size(cast_niskin,1)
    a = find(ismember(cast_table_all(:,10:11),cast_niskin(ii,:)));
    cast_table_binned(ii,:) = cast_table_all(a(1),:);
    if length(a) > 1
        cast_table_binned.pid{ii} = cast_table_all.pid{a(1)};
        cast_table_binned.pid_all{ii} = cast_table_all.pid(a);
        cast_table_binned.ml_analyzed(ii) = sum(cast_table_all.ml_analyzed(a));
        cast_table_binned.n_images(ii) = sum(cast_table_all.n_images(a));
        cast_table_binned.tag1{ii} = cast_table_all.tag1(a);
        cast_table_binned.tag1{ii} = cast_table_all.tag2(a);
        cast_table_binned.tag1{ii} = cast_table_all.tag3(a);
        cast_table_binned.tag1{ii} = cast_table_all.tag4(a);
        cast_table_binned.count(ii,:) = array2table(sum(cast_table_all.count{a,:},1));
        cast_table_binned.biovol(ii,:) = array2table(sum(cast_table_all.biovol{a,:},1));
    end
end

clear ii a castii ci cast_niskin 


f = ['\\sosiknas1\IFCB_products\SPIROPA\summary\' cruisestr 'cast_mean_count_biovol_byclass'];
clear cast_table_all bvall cruisestr

save(f, 'cast_table_binned')
disp(['Results saved: ' f])
