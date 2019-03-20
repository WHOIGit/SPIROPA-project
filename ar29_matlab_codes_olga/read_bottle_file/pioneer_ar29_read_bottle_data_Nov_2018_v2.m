% pioneer_ar29_read_bottle_data_Nov_2018_v2.m
% From: pioneer_ar29_read_bottle_data_Nov_2018.m
% !!!
% NOTE: _v2 means reprocessed CTD data was used (with Fluor correction)
% !!!

clear;

%data_location='your_path';
data_location='olgas_path';
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  DATA PATHS   @@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if strcmp(data_location,'your_path')
    % If all data files are located in the same directory as the Matlab code,
    % use this:
    path_name='';
elseif strcmp(data_location,'olgas_path')
    path_name='~/OOI_pioneer/p_11/leg_1/bottle_data/';
end
path_name_txt=strrep(path_name,'_','\_');
%path_name_data_txt=strrep(path_name_data,'_','\_');
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  FILE NAMES   @@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fname='ar29_bottle_data_Nov_2018_v2';
fname_txt=strrep(fname,'_','\_');
fname_ext='txt';
flag_bad=-9.990e-29;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% Cruise ID, date.
cr_id='ar29';
crName='Pioneer 11 Leg 1 AR29';
cruise_title='Pioneer 11 Leg 1 AR29';
date_str='April 17-29, 2018';
% Fonts, markers, color.
fnt_axes=10;
fnt_label=10;
fnt_title=10;
plot_id='o';
plot_color_all=[0.6 0.6 0.6];
show_st_color=[1 0 0];
line_width=0.8;
marker_size=2;
%***************************************************
%******** LOAD Bottle file  Version Nov_2018_v2 *******
%*****************    MATFILE   ********************
%***************************************************
p=['load ' path_name fname ';'];
eval(p);
% MATFILE variables:
% (1) numeric matrix "data", size: 1054x51;
% (2) 5 string variables:
% --- parameters names and corresponding columns:
% CTD_casts_info_columns
% CTD_BTL_data_columns
% POC_PP_columns
% IntProd_columns
% --- Station name codes and example:
% station_name_note.
d=data;
clear data;
size(d)
%r_neg=find(d(:,32)<0);
%r_flag=find(d(:,32)==flag_bad);
%%r_nan=find(isnan(dd(:,colChla_0_m)) | isnan(dd(:,colPhaeoa_0_m)) | isnan(dd(:,colFluor_m)) | dd(:,colFluor_m)==flag_bad);
%******************************
% CTD casts info columns
%******************************
% CTD casts:
colCast_m=1;
colStNum_m=2;
colStId_m=3;
colYear_m=4;
colMon_m=5;
colDay_m=6;
colTime_m=7;
colLat_m=8;
colLon_m=9;
colDepT_m=10; % Target depth
colDep_m=11;  % Calculated real depth
colPres_m=12;
colNiskenUsed_m=13;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@  MENU: Parameter Group  @@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
group_list=strvcat('CTD casts info (cols 1:13)','CTD BTL data (cols 14:36)','POC and PP (cols 37:49)','IntProd (cols 50:51)','Nuts (cols 52:56)','Chl (cols 57:68)','CANCEL');
% Convert vector of strings to cell array.
group_list_cell=cellstr(group_list);
group_num=menu('Parameter Group',group_list_cell);
if group_num>6, return; end
cast_ID='CTD';
switch group_num
    case 1
        columns_list=CTD_casts_info_columns;
        group_name='CTD casts info';
    case 2
        columns_list=CTD_BTL_data_columns;
        group_name='CTD BTL data';
    case 3
        columns_list=POC_PP_columns;
        group_name='POC and PP';
    case 4
        columns_list=IntProd_columns;
        group_name='IntProd data';
    case 5
        columns_list=nuts_columns;
        group_name='Nuts data';
    case 6
        columns_list=chl_columns;
        group_name='Chl data';
end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@  MENU: Parameter  @@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
column_name=f_menu_of_strings('Column # and Parameter',columns_list);
if isempty(column_name), return; end
column_name=deblank(column_name);
%*******************************
% Parameter column# and name.
%*******************************
[T,R]=strtok(column_name,' - ');
% Parameter column #.
colNum=str2num(T);
% Parameter name.
R(1:3)='';
par_name=R;
par_name_txt=strrep(par_name,'_','\_');
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@  MENU: Show Casts @@@@@@@
%@@@@ ALL and ONE or ONE  @@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
show_stations_options=f_menu_of_strings('Show stations',strvcat('All and One','One'));
if isempty(show_stations_options), return; end
%**************************
% Change lower depth (less for POC,PP,IntProd).
%**************************
leg_location=3;
if group_num==3 | group_num==4  | group_num==6% POC,PP,IntProd
    lowerDepth=300;
    leg_location=4;
else
    lowerDepth=800;
end
lowerDepth=300; % !!!! TEMP

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@ MENU: Depth for Y-axis @@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%dep_option=menu('Depth for Y-axis','Target','Real','CANCEL');
dep_option=2;
if dep_option==1
    col_depth_use=colDepT_m;
    label_depth_use='Target depth (m)';
elseif dep_option==2
    col_depth_use=colDep_m;
    label_depth_use='Depth (m)';
else
    return;
end
%**************************
% Replace minus (below detection) values with zeros.
% For now: I did not do this, want to see real data presented in the file.
%**************************
    r_minus=find(d(:,colNum)<0);
    d(r_minus,colNum)=0;
%**************************
% Casts list.
%**************************
r_nan=find(isnan(d(:,colNum)));
d_for_list=d;
d_for_list(r_nan,:)=[];
if isempty(d_for_list)
    disp(['Column # ' num2str(colNum) ' ' par_name ': Data is not available']);
    return;
else
    cast_list=(unique(d_for_list(:,colCast_m)))';
end
clear d_for_list;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@  MENU CTD CAST#  @@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
cast_num=f_menu_of_numbers_title('CTD cast #',cast_list);
if isempty(cast_num), return; end
if floor(cast_num)~=cast_num
    cast_str=[num2str(floor(cast_num)) 'upcast'];
else
    cast_str=num2str(cast_num);
end
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% Replace flag_bad with NaN for plots; leave flag for display.
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
d_with_flag=d; % with flags and NaNs -for display
%flag_bad=-999.999; % !!! for now: no data marked "bad"
%r_flag=find(d(:,colNum)==flag_bad);
%if ~isempty(r_flag), ...
%        d(r_flag,colNum)=NaN; end
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% Remove NaN data for plots (NaN makes a break in the profile line).
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
r_nan=find(isnan(d(:,colNum)));
d(r_nan,:)=[];
% Groups first/last columns.
first_col_btl=13;
last_col_btl=36;
first_col_poc=37;
last_col_poc=49;
first_col_IntProd=50;
last_col_IntProd=51;
%**************************
% Figure.
%************************** 
figure;
fig_pos=[657.00        307.00        431.00        518.00];
set(gcf,'color',[1 1 1],'position',fig_pos,...
    'paperPositionMode','auto');
leg_text='';
hh=[];
%*****************************************************
%************    PLOT All stations   *****************
%*****************************************************
if strcmp(show_stations_options,'All and One')
    hold on;
    for castNum=cast_list
        r_st=find(d(:,colCast_m)==castNum);
        parSt=d(r_st,colNum);
        presSt=d(r_st,col_depth_use);
        hh(1)=plot(parSt,presSt,'o-',...
            'color',plot_color_all,'linewidth',line_width,...
            'markerFaceColor',plot_color_all,'markerEdgeColor',plot_color_all,...
            'markersize',marker_size);
        if castNum==cast_list(1), leg_text=strvcat(leg_text,'Bottle file - all'); end
    end
    hold off;
end
%*****************************************************
%**** SELECTED STATION INFO (date, time, cast) *******
%*****************************************************
r_st=find(d(:,colCast_m)==cast_num);
d_st_for_info=d(r_st,:);
if ~isempty(d_st_for_info)
    cast_num=d_st_for_info(1,colCast_m);
    if floor(cast_num)~=cast_num
        cast_num_str=[num2str(floor(cast_num)) 'upcast']; % cast 115.2
    else
        cast_num_str=num2str(cast_num);
    end
    st_num=d_st_for_info(1,colStNum_m);
    st_id=d_st_for_info(1,colStId_m);
    %**************************
    % Selected station Date/Time.
    %**************************
    yyyy_st=d_st_for_info(1,colYear_m);
    mm_st=d_st_for_info(1,colMon_m);
    dayday_st=d_st_for_info(1,colDay_m);
    hhmm_st=d_st_for_info(1,colTime_m);
    [time_vector] = f_hhmm2timevec(hhmm_st);
    secsec_st=0;
    % Date and time - string represetation.
    date_str=datestr([yyyy_st mm_st dayday_st time_vector secsec_st],0);
    %**************************
    % Selected station name.
    %**************************
    % --- STATION NAME.
    % Station ID: 1-A, 2-B, 3-AUV, 4-AL-CTD, 5-P
    switch st_id
        case 1
            st_name_part='A';
        case 2
            st_name_part='B';
        case 3
            st_name_part='AUV';
        case 4
            st_name_part='AL-CTD';
        case 5
            st_name_part='P';
    end
    st_name=[st_name_part num2str(st_num)];
else
    date_str='';
    cast_num_str='';
end % For if ~isempty(d_st_for_info)
%*****************************************************
%********* SELECTED STATION DATA (for plots) *********
%*****************************************************
par_st_separate=[];
pres_st_separate=[];
par_st=d(r_st,colNum);
pres_st=d(r_st,col_depth_use);
%pres_st=d(r_st,colPres_N);
% For TMCTD - CTD depth for selected station.
%depth_st_ctd=d(r_st,colDep_m);
%*****************************************************
%******** SELECTED STATION DATA (for display) ********
%*****************************************************
r_st_d=find(d_with_flag(:,colCast_m)==cast_num); % with flags and NaNs -for display
dd_st=d_with_flag(r_st_d,:);
%*****************************************************
%**************************
% Display selected station data.
%**************************
par_name
CTDcast_stNum_stId_NiskeUsed_targetDepth_CTDpres_parameter=dd_st(:,[ colCast_m colStNum_m colStId_m colNiskenUsed_m colDepT_m colPres_m colNum])
%**************************
% Plot Selected station.
%**************************
hold on;
hh(length(hh)+1)=plot(par_st,pres_st,'o-',...
    'color',show_st_color,'linewidth',line_width+0.5,...
    'markerFaceColor',show_st_color,'markerEdgeColor',show_st_color,...
    'markersize',marker_size+3);
leg_text=strvcat(leg_text,['Bottle file c' cast_str ' st' st_name]);
hold off;
%*****************************************************
%**************  SET AXES PROPERTIES  ****************
%*****************************************************
ah=get(gca,'position');
set(gca,'position',[ah(1)-ah(3)*0.03 ah(2)+ah(4)*0.13 ah(3)*1.1 ah(4)*0.80]);
x_lim=get(gca,'xlim');
y_lim=[0 lowerDepth];
axis([x_lim y_lim]);
grid on;
set(gca,'ydir','reverse','fontsize',fnt_axes,'box','on');
xlabel([par_name_txt ' (column #' num2str(colNum) ', ' group_name ')'],'fontsize',fnt_label);
ylabel(label_depth_use,'fontsize',fnt_label);
str_title(1)={[crName]};
str_title(2)={['CTD cast #' cast_num_str ' Station ' st_name ': ' date_str ' UTC']};
title(str_title,'fontsize',fnt_title,'color','b');
%**************************
% Legend.
%**************************
if size(leg_text,1)>1, legend(hh,leg_text,leg_location); end
%*********************
% Text - file names.
%*********************
str_text(1)={['Bottle file: ' path_name_txt fname_txt '.mat (' fname_ext ')']};
x_t=x_lim(1)-0.1*range(x_lim);
text(x_t,y_lim(2)+0.2*range(y_lim),str_text,'color',[0 0 0],'horizontalAlignment','left','fontsize',8);

