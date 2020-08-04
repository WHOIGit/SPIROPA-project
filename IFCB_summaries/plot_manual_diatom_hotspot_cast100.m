%load('\\sosiknas1\IFCB_products\SPIROPA\summary\count_biovol_size_manual_01Jun2020.mat')
load('C:\work\IFCB_products\SPIROPA\summary\count_biovol_size_manual_23Jul2020.mat')
%group_table = readtable('\\sosiknas1\training_sets\IFCB\config\IFCB_classlist_type.csv');
group_table = readtable('C:\work\IFCB_products\SPIROPA\IFCB_classlist_type.csv');
%load('\\sosiknas1\IFCB_products\SPIROPA\summary\count_manual_current.mat')
%classes(strmatch('Pseudo__nitzschia', classes)) = {'Pseudo-nitzschia'};
classes = regexprep(classes, ' ', '_');

%group_table.CNN_classlist(strmatch('Pseudo-nitzschia',group_table.CNN_classlist)) = {'Pseudo__nitzschia'};
[~,ia,ib] = intersect(group_table.CNN_classlist, classes);
ciliate_ind = ib(find(group_table.Ciliate(ia)));
dino_ind = ib(find(group_table.Dinoflagellate(ia)));
diatom_ind = ib(find(group_table.Diatom(ia)));
cocco_ind = ib(find(group_table.Coccolithophore(ia)));
notalive_ind = [ib(find(group_table.OtherNotAlive(ia))); ib(find(group_table.IFCBArtifact(ia)))];
alive_ind = 1:length(classes); alive_ind(notalive_ind) = [];
alive_ind(strmatch( 'unclassified', classes(alive_ind))) = [];
%%
%ii = find(ismember(meta_data.cast,[71 100]));
ii = find(ismember(meta_data.cast,[100]) & strcmp(meta_data.cruise,'TN368'));

cast_meta_data = meta_data(ii,:);
cast_count_all = zeros(length(ii),length(classes));
cast_count_gt10 = cast_count_all;
cast_bv_all = cast_count_all;
cast_bv_gt10 = cast_count_all;
for count = 1:length(ii)
    for count2 = 1:length(classes)
        %bv = summary.biovol.(classes{count2}){ii(count)};
        bv = summary.biovol{ii(count), count2};
        if ~isempty(bv)
           %esd = 2*(bv*3/pi/4).^(1/3);
           esd = summary.esd{ii(count), count2};
           maxFd = summary.maxFd{ii(count), count2};
           cast_count_all(count,count2) = size(esd,1);
           cast_count_gt10(count,count2) = sum(esd>10 | maxFd>10);
           cast_count_gt5(count,count2) = sum(esd>5 | maxFd>5);
           cast_bv_all(count,count2) = sum(bv);
           cast_bv_gt10(count,count2) = sum(bv(esd>10 | maxFd>10));
           cast_bv_gt5(count,count2) = sum(bv(esd>5 | maxFd>5));
        end
    end
end

cast_niskin = unique(cast_meta_data(:,10:11), 'rows');
cast_table_binned = table;
cast_table_binned(1,:) = cast_meta_data(1,:); %just init the var names
    
for ii = 1:size(cast_niskin,1)
    a = find(ismember(cast_meta_data(:,10:11),cast_niskin(ii,:)));
    cast_table_binned(ii,1:size(cast_meta_data,2)) = cast_meta_data(a(1),:);
    % if length(a) > 1
   %     cast_table_binned.pid{ii} = cast_meta_data.pid{a(1)};
        cast_table_binned.pid_all{ii} = cast_meta_data.pid(a);
        cast_table_binned.ml_analyzed(ii) = sum(cast_meta_data.ml_analyzed(a));
        cast_table_binned.n_images(ii) = sum(cast_meta_data.n_images(a));
        cast_table_binned.tag1{ii} = cast_meta_data.tag1(a);
        cast_table_binned.tag2{ii} = cast_meta_data.tag2(a);
        cast_table_binned.tag3{ii} = cast_meta_data.tag3(a);
        %cast_table_binned.tag4{ii} = cast_meta_data.tag4(a);
        cast_table_binned.count(ii,:) = (sum(cast_count_all(a,:),1));
        cast_table_binned.count_gt10(ii,:) = (sum(cast_count_gt10(a,:),1));
        cast_table_binned.count_gt5(ii,:) = (sum(cast_count_gt5(a,:),1));
        cast_table_binned.biovol(ii,:) = (sum(cast_bv_all(a,:),1));
        cast_table_binned.biovol_gt10(ii,:) = (sum(cast_bv_gt10(a,:),1));
        cast_table_binned.biovol_gt5(ii,:) = (sum(cast_bv_gt5(a,:),1));
    %end
end

class_ind = diatom_ind;

%cat(1,cast_table_binned.pid)
%[temp, ss] = sort(sum(cast_table_binned.biovol(:,class_ind)), 'descend');
%[classes(diatom_ind(ss))' cellstr(num2str(temp'))]

%castset = [71 100];
castset = [100];
castii_set = find(ismember(cast_table_binned.cast, castset));
cat(1,cast_table_binned.pid{castii_set})
[temp, ss] = sort(sum(cast_table_binned.biovol(castii_set,class_ind)), 'descend');
[classes(diatom_ind(ss))' cellstr(num2str(temp'))]
cruisestr = 'TN368';
%%

%non-zero biovol for diatoms with esd>5 OR maxFd>5
diatom_ind2 = diatom_ind(find(sum(cast_table_binned.biovol_gt5(:,diatom_ind))));
diatomsum = sum(cast_table_binned.biovol_gt5(:,diatom_ind2),2); %total above 5 micron
round(cast_table_binned.biovol_gt5(:,diatom_ind2)./repmat(diatomsum,1,length(diatom_ind2))*100)
temp = cast_table_binned.biovol_gt5(:,diatom_ind2)./repmat(diatomsum,1,length(diatom_ind2));
diatom_ind2plot = diatom_ind2(sum(temp>.08)>0); %include any classes that are more than 8% of the biovol in any depth
temp = cast_table_binned.biovol_gt5(:,diatom_ind2plot)./repmat(diatomsum,1,length(diatom_ind2plot));
[a,sind] = sort(sum(temp), 'descend');
classes(diatom_ind2plot(sind))'

cellsum = sum(cast_table_binned.biovol_gt5(:,alive_ind),2);
dinosum = sum(cast_table_binned.biovol_gt5(:,dino_ind),2);
ciliatesum = sum(cast_table_binned.biovol_gt5(:,ciliate_ind),2);
sum2plot = [diatomsum dinosum ciliatesum];
sum2plot = [sum2plot cellsum-sum(sum2plot,2)]./repmat(cast_table_binned.ml_analyzed,1,4);

diatom2plot = cast_table_binned.biovol_gt5(:,diatom_ind2plot(sind));
diatom2plot = [diatom2plot diatomsum-sum(diatom2plot,2)];
frac2plot = diatom2plot./repmat(diatomsum,1,size(diatom2plot,2));

if 0
    diatom_ind2 = diatom_ind(find(sum(cast_table_binned.count_gt5(:,diatom_ind))));
    diatomsum = sum(cast_table_binned.count_gt5(:,diatom_ind2),2); %total above 5 micron
    round(cast_table_binned.count_gt5(:,diatom_ind2)./repmat(diatomsum,1,length(diatom_ind2))*100)
    temp = cast_table_binned.count_gt5(:,diatom_ind2)./repmat(diatomsum,1,length(diatom_ind2));
    diatom_ind2plot = diatom_ind2(sum(temp>.1)>0);
    temp = cast_table_binned.count_gt5(:,diatom_ind2plot)./repmat(diatomsum,1,length(diatom_ind2plot));
    [a,sind] = sort(sum(temp), 'descend');
    classes(diatom_ind2plot(sind))'

    cellsum = sum(cast_table_binned.count_gt5(:,alive_ind),2);
    dinosum = sum(cast_table_binned.count_gt5(:,dino_ind),2);
    ciliatesum = sum(cast_table_binned.count_gt5(:,ciliate_ind),2);
    sum2plot = [diatomsum dinosum ciliatesum];
    sum2plot = [sum2plot cellsum-sum(sum2plot,2)]./repmat(cast_table_binned.ml_analyzed,1,4);

    diatom2plot = cast_table_binned.count_gt5(:,diatom_ind2plot(sind));
    diatom2plot = [diatom2plot diatomsum-sum(diatom2plot,2)];
    frac2plot = diatom2plot./repmat(diatomsum,1,size(diatom2plot,2));
end

colormap parula
figColorMap = get(gcf,'colormap');
colorIndex = round(linspace(1,length(figColorMap),size(frac2plot,2)));
barColor = figColorMap(colorIndex,:);
%%

legstr = {classes{diatom_ind2plot(sind)}};
legstr = regexprep(legstr, 'Thalassiosira', '\\itThalassiosira')
legstr = regexprep(legstr, '\\itThalassiosira_sp_aff_mala', '\\itThalassiosira diporocyclus');
legstr = regexprep(legstr, 'Chaetoceros', '\\itChaetoceros')
legstr = regexprep(legstr, 'Hemiaulus', '\\itHemiaulus')
legstr = regexprep(legstr, 'Guinardia_striata', '\\itGuinardia striata')
legstr = regexprep(legstr, 'Dactyliosolen_fragilissimus', '\\itDactyliosolen fragilissimus')
legstr = regexprep(legstr, 'pennate', 'mixed small pennate')
legstr = regexprep(legstr, 'Pseudo-nitzschia', '\\itPseudo-nitzschia')
legstr = regexprep(legstr, 'Rhizosolenia', '\\itRhizosolenia')

for cc = 1:length(castset)
  %  caststr = castset(cc);
  %  castii = find(strcmp(cast_table_binned.cast, caststr) & strcmp(cast_table_binned.cruise, cruisestr));
    castii = find(cast_table_binned.cast == castset(cc));
    d = cast_table_binned.depth(castii);
    [d,ids] = sort(cast_table_binned.depth(castii));
    cut = 27;
    figure, set(gcf, 'position', [400 350 900 400])
    subplot(1,2,1)
    plotfactor = 1e5;
    barh(cast_table_binned.depth(castii(ids)), sum2plot(castii(ids),:)/plotfactor, 'stacked', 'barwidth', 4/min(diff(cast_table_binned.depth(castii(ids)))))    
    set(gca, 'ydir', 'rev')
    title([cruisestr ' Cast ' num2str(castset(cc))])
    ylabel('Depth (m)'), 
    axis([0 1.8e6/plotfactor 0 60])
    xlabel('Biovolume concentration (\mum^{-3} mL^{-1}) x 10^{-5}') %%DOUBLE CHECK MATCHES plotfactor
    legend(classes(diatom_ind(ss(1:cut))), 'interpreter', 'none', 'fontsize', 6, 'location', "northeast")
    legend('diatom', 'dinoflagellate', 'cililate', 'other', 'fontsize', 12)
    set(gca, 'position', [.13 .12 .27 .8])
    subplot(1,2,2)  
    b = barh(cast_table_binned.depth(castii(ids)), frac2plot(castii(ids),:), 'stacked', 'barwidth', 4/min(diff(cast_table_binned.depth(castii(ids)))));
    set(gca, 'ydir', 'rev')
    %title([cruisestr ' Cast ' num2str(castset(cc))])
    %ylabel('Depth (m)')
    axis([0 1 0 60])
    xlabel('Diatom biovolume fraction')
    %legend({classes{diatom_ind2plot(sind)}, 'other'}, 'interpreter', 'none', 'location', 'eastoutside')
    legend([legstr, {'other'}],'location', 'eastoutside')
    set(gca, 'position', [.13 .12 .27 .8])
    set(gca, 'position', [.45 .12 .27 .8])
%    legend(class2use(diatom_ind(ss(1:cut))), 'interpreter', 'none')
%    print(['\\sosiknas1\ifcb_products\spiropa\summary\TN368_cast' char(caststr)], '-dpng')
    for ii = 1:size(frac2plot,2)
        set(b(ii),'facecolor', barColor(ii,:));
    end
end
print('c:\work\IFCB_products\SPIROPA\summary\TN368_Cast100_23Jul2020', '-dpng')
%%

return
iii = strmatch('Thalassiosira_', classes)
[cast_table_binned.count(:,iii) cast_table_binned.count_gt5(:,iii) cast_table_binned.count_gt10(:,iii)]

tt = find(meta_data.ifcb == 109 & strcmp('TN368', meta_data.cruise));
tt2 = find(meta_data.ifcb == 129 & strcmp('TN368', meta_data.cruise));

