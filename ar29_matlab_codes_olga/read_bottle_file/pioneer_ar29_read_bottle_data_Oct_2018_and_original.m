% pioneer_ar29_read_bottle_data_Oct_2018_and_original.m
% From: pioneer_ar29_read_bottle_data_Sep_2018_and_original.m

clear;

data_location='your_path';
%data_location='olgas_path';
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  DATA PATHS   @@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if strcmp(data_location,'your_path')
    % If all data files are located in the same directory as the Matlab code,
    % use this:
    path_name='';
    path_name_data='';
    path_btl='';
    path_data_original='';
    path_name_nuts='';
path_name_txt='';
path_name_data_txt='';
elseif strcmp(data_location,'olgas_path')
    path_name='~/OOI_pioneer/p_11/leg_1/bottle_data/';
    path_name_data='~/OOI_pioneer/p_11/leg_1/bottle_data/original_data/';
    path_btl='~/OOI_pioneer/BTL_data/';
    path_name_nuts=['~/OOI_pioneer/p_11/leg_1/bottle_data/original_data/nuts/'];
path_name_txt=strrep(path_name,'_','\_');
path_name_data_txt=strrep(path_name_data,'_','\_');
end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  FILE NAMES   @@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fname='ar29_bottle_data_Oct_2018';
fname_txt=strrep(fname,'_','\_');
fname_ext='txt';
fname_data_ext='txt';
fname_POC_PP='AR29_POC_plus_Productivity_7_25_values_copy_w_with_cast_number';
fname_POC_PP_ext='mat';% and .txt is available
fname_IntProd='AR_29_Integrated_Productivity_Values_w';
fname_nuts='McGillicudy_AR29_2018_client_w_with_depth';
fname_btl='p_11_ar29_BTL_data';
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
show_st_color_separate=[0 1 0];
show_st_TM_merged_depth_color=[0 0 1];
color_orig=[0 0 1];
line_width=0.8;
marker_size=2;
%***************************************************
%******** LOAD Bottle file  Version Apr_2017 *******
%*****************    MATFILE   ********************
%***************************************************
p=['load ' path_name fname ';'];
eval(p);
% MATFILE variables:
% (1) numeric matrix "data", size: 1054x51;
% (2) 2 variables:
% --- parameters nadmes and corresponding columns:
% CTD_casts_info_columns
% CTD_BTL_data_columns
% POC_PP_IntProd_columns
% --- Station name codes and example:
% station_name_note.
d=data;
clear data;
%******************************
% CTD and TMCTD casts info columns
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
colDepT_m=10;
colDep_m=11; % !!! added - calculated real depth
colPres_m=12;
colNiskenUsed_m=13;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@  MENU: Parameter Group  @@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
group_list=strvcat('CTD casts info (cols 1:13)','CTD BTL data (cols 14:36)','POC and PP (cols 37:49)','IntProd (cols 50:51)','Nuts (cols 52:56)','CANCEL');
% Convert vector of strings to cell array.
group_list_cell=cellstr(group_list);
group_num=menu('Parameter Group',group_list_cell);
if group_num>5, return; end
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
end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@  MENU: Parameter  @@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
column_name=f_menu_of_strings('Column # and Parameter',columns_list);
if isempty(column_name), return; end
column_name=deblank(column_name);
[T,R]=strtok(column_name,' - ');
% Parameter - column #.
colNum=str2num(T);
% Parameter - name.
R(1:3)='';
par_name=R;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@  MENU: Show Casts @@@@@@@
%@@@@ ALL and ONE or ONE  @@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
show_stations_options=f_menu_of_strings('Show stations',strvcat('All and One','One'));
if isempty(show_stations_options), return; end
%###############################################################
%###############################################################
%###############################################################
%**************************
% Change lower depth (less for chl data and particles).
%**************************
leg_location=3;
if group_num==3 | group_num==4 % POC,PP,IntProd
    lowerDepth=200;
    leg_location=4;
else
    lowerDepth=800;
end
%**************************
% For Y-axis use Pressure
%**************************
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
%label_depth_use='Pressure (db)';
%col_depth_use=colPres_m;
%**************************
% Replace minus (below detection) values with zeros.
% For now: I did not do this, want to see real data presented in the file.
%**************************
%    r_minus=find(d(:,colNum)<0);
%    d(r_minus,colNum)=0;
%**************************
% Casts list.
%**************************
r_nan=find(isnan(d(:,colNum)));
d_for_list=d;
d_for_list(r_nan,:)=[];
if isempty(d_for_list)
    disp(['Column # ' num2str(colNum) ' ' par_name ': Data is not available']); % columns 73 and 74
    return;
else
    cast_list=(unique(d_for_list(:,colCast_m)))';
end
clear d_for_list;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@  MENU STATION #  @@@@@@@
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
%flag_bad=-999.999;
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
first_col_nuts=52;
last_col_nuts=56;
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
end
%*****************************************************
%**** SELECTED STATION INFO (date, time, cast) *******
%*****************************************************
r_st=find(d(:,colCast_m)==cast_num);
d_st_for_info=d(r_st,:);
if ~isempty(d_st_for_info)
    cast_num=d_st_for_info(1,colCast_m);
    if floor(cast_num)~=cast_num
        cast_num_str=[num2str(floor(cast_num)) 'upcast'];
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
    % --- DATE.
    %r_st=find(c_list(:,col_st)==stNum);
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

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@   ORIGINAL DATA  @@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
leg_location=3; % unless indicated otherwise below
show_original='no';
if colNum>=first_col_btl & colNum<=last_col_btl
    show_original='yes';
    %@@@@@@@@@@@@@@@@@@@@@@@@@@
    % BTL Summary Data
    %@@@@@@@@@@@@@@@@@@@@@@@@@@
    path_btl_txt=strrep(path_btl,'_','\_');
    fname_btl_txt=strrep(fname_btl,'_','\_');
    str_text(2)={'Original data: '};
    str_text(3)={[path_btl_txt fname_btl_txt '.txt']};
    p=['load ' path_btl fname_btl ';'];
    eval(p);
    p=['d_orig=' fname_btl ';'];
    eval(p);
    % --- Summary BTL columns:
    colCast_btl=1;       % CTD cast
    colBot_btl=2;        % Bottle
    colMon_btl=3;        % Month
    colDay_btl=4;        % Day
    colYear_btl=5;       % Year
    colSig_btl=6;        % Sigma-é00
    colSig_s_btl=7;      % Sigma-é00
    colOxy_btl=8;        % Sbeox0ML/L
    colOxySat_btl=9;     % OxsolMm/Kg
    colOxyM_btl=10;      % Sbeox0Mm/Kg
    colPotTemp_btl=11;   % Potemp090C
    colPotTemp_s_btl=12; % Potemp190C
    colSal_btl=13;       % Sal00
    colSal_s_btl=14;     % Sal11
    colDens_btl=15;      % Density00
    colDens_s_btl=16;    % Density11
    colSoundVel_btl=17;  % SvCM
    colSoundVel_s_btl=18;% SvCM1
    colPres_btl=19;      % PrDM
    colTemp_btl=20;      % T090C
    colTemp_s_btl=21;    % T190C
    colCnd_btl=22;       % C0S/m
    colCnd_s_btl=23;     % C1S/m
    colOxyV_btl=24;      % Sbeox0V
    colFluor_btl=25;     % FlECO-AFL
    colTurb_btl=26;      % TurbWETntu0
    colSalD_btl=27;      % Sal fron DATCNV
    colSpar_btl=28;      % Spar
    colPar_btl=29;       % Par
    colCpar_btl=30;      % Cpar
    colScan_btl=31;      % Scan
    %btl_columns_use=[6:18 20:26 28:30];
    % BTL file columns vs BTL data from MERGED file columns.
    cols_merged_btl=[14:36;6:18 20:26 28:30];
    r_m=find(cols_merged_btl(1,:)==colNum);
    col_par_orig=cols_merged_btl(2,r_m);
    colDep_orig=colPres_btl;
    % Find Selected station ORIGINAL data.
    rr_orig=find(d_orig(:,colCast_btl)==cast_num);
elseif colNum>=first_col_poc & colNum<=last_col_poc
    show_original='yes';
    %##########################################################
    %############# (2) LOAD POC and PP data file ##############
    %##########################################################
    p=['load ' path_name_data fname_POC_PP '.' fname_data_ext ';'];
    eval(p);
    p=['d_p=' fname_POC_PP ';'];
    eval(p);
    size(d_p); % ANS: 717x20
    fname_POC_PP_txt=strrep(fname_POC_PP,'_','\_');
    str_text(2)={'Original data: '};
    str_text(3)={[path_name_data_txt fname_POC_PP_txt '.txt']};
    % POC_PP columns:
    colStNum_p=1;
    colStId_p=2;
    colMon_p=3;
    colDay_p=4;
    colYear_p=5;
    colVial_p=6;
    colDep_p=7;
    colVolfilt_p=8;
    colN_mg_p=9;
    colC_mg_p=10;
    colN_umol_L_p=11;
    colC_umol_L_p=12;
    colProcN_p=13;
    colProcC_p=14;
    colCN_mm_p=15;
    colCN_ww_p=16;
    colProc_io_p=17;
    colProd_p=18;
    colProd_20um_p=19;
    colCast_p=20; % added by the previous program
    %----------------------------------------------------------
    %------------ POC/PP C O R R E C T I O N  ----------------
    %----------------------------------------------------------
    % (1) --- St A16 Apr 23 (cast 82) depth 80 indicated as 800.
    r_82_80=find(d_p(:,colCast_p)==82 & d_p(:,colDep_p)==800);
    %d_p(r_82_80,:)
    d_p(r_82_80,colDep_p)=80;
    %d_p(r_82_80,:)
    % (2) --- St A14 Apr 18 (cast 16) depth 0 indicated as 3m.
    r_16_0=find(d_p(:,colCast_p)==16 & d_p(:,colDep_p)==3);
    %d_p(r_16_0,:)
    d_p(r_16_0,colDep_p)=0;
    %d_p(r_16_0,:)
    % (3) --- St A14 Apr 20 (cast 42) depth 0 indicated as 3m.
    r_42_0=find(d_p(:,colCast_p)==42 & d_p(:,colDep_p)==3);
    %d_p(r_16_0,:)
    d_p(r_42_0,colDep_p)=0;
    %d_p(r_16_0,:)
    % (4) --- St A14 Apr 20 (cast 42) one of depths 40 indicated as 49m.
    r_42_40=find(d_p(:,colCast_p)==42 & d_p(:,colDep_p)==49);
    %d_p(r_42_40,:)
    d_p(r_42_40,colDep_p)=40;
    %d_p(r_42_40,:)
    % (5) --- St A10 Apr 26 (cast 120) depth 40 indicated as 49m.
    rr=find(d_p(:,colCast_p)==120 & d_p(:,colDep_p)==49);
    %d_p(rr,:)
    d_p(rr,colDep_p)=40;
    %d_p(rr,:)
    clear rr;
    % (6) --- St A12 Apr 27 (cast 150) depth 20 indicated as 28m.???
    rr=find(d_p(:,colCast_p)==150 & d_p(:,colDep_p)==28);
    %d_p(rr,:)
    d_p(rr,colDep_p)=20;
    %d_p(rr,:)
    clear rr;
    % (7) --- St A12 Apr 27 (cast 150) depth 30 indicated as% 50m.???
    rr=find(d_p(:,colCast_p)==150 & d_p(:,colDep_p)==50);
    %d_p(rr,:)
    d_p(rr,colDep_p)=30;
    %d_p(rr,:)
    clear rr;
    %----------------------------------------------------------
    % (8) --- St A10 Apr 21 (cast 62):
    % there are several depths related to Productivity which  are not
    % available in CTD BTL data (6, 12, 17 and 26m).
    % I'll temporarily replace them with the existing target depths respectively: 0, 10, 20 and 30m.
    %----------------------------------------------------------
    d_list_orig=[6 12 17 26];
    d_list_rep=[0 10 20 30];
    cast=62;
    for ii=1:length(d_list_orig)
        dep=d_list_orig(ii);
        rr=find(d_p(:,colCast_p)==cast & d_p(:,colDep_p)==dep);
        d_p(rr,colDep_p)=d_list_rep(ii);
    end
    %r_62=find(d_p(:,colCast_p)==62);
    %d_p(r_62,:)
    clear ii rr dep cast;
    %----------------------------------------------------------
    p=['d_orig=' fname_POC_PP ';'];
    eval(p);
    % POC/PP file columns vs POC/PP data from MERGED file columns.
    cols_merged_poc=[37:49;6 8:19];
    r_m=find(cols_merged_poc(1,:)==colNum);
    col_par_orig=cols_merged_poc(2,r_m);
    colDep_orig=colDep_p;
    % Find Selected station ORIGINAL data.
    rr_orig=find(d_orig(:,colCast_p)==cast_num);
elseif colNum>=first_col_IntProd & colNum<=last_col_IntProd
    show_original='yes';
    %##########################################################
    %###### (3) LOAD Integrated Productivity data file ########
    %##########################################################
    p=['load ' path_name_data fname_IntProd '.' fname_data_ext ';'];
    eval(p);
    p=['d_pi=' fname_IntProd ';'];
    eval(p);
    size(d_pi); % ANS: 26x8
    fname_IntProd_txt=strrep(fname_IntProd,'_','\_');
    str_text(2)={'Original data: '};
    str_text(3)={[path_name_data_txt fname_IntProd_txt '.txt']};
    % IntProd columns:
    colEvent_pi=1;
    colMon_pi=2;
    colDay_pi=3;
    colYear_pi=4;
    colStNum_pi=5;
    colStId_pi=6;
    colTime_pi=7;
    colIntProd_pi=8;
    colCast_pi=9; % !!! would be added by proram
    %----------------------------------------------------------
    %------------ IntProd C O R R E C T I O N  ----------------
    %----------------------------------------------------------
    % Station A13 (event 14) indicated as done on April 18;
    % Should be April 19 according to PP data.
    % I make correction but will contact Walker to verify this.
    r_a13=find(d_pi(:,colStNum_pi)==13 & d_pi(:,colStId_pi)==1 & d_pi(:,colDay_pi)==18);
    d_pi(r_a13,colDay_pi)=19;
    %------------- IntProd C O R R E C T I O N  END -----------
    % Add CTD cast number - after the last column, list was made by hand.
    cast_list_pi=[5 9 15 16 19 29 33 41 42 60 62 70 77 83 87 100 102 112 114 129 129 131 143 148 152 163];
    d_pi=[d_pi cast_list_pi'];
    %
    d_orig=d_pi;
    %p=['d_orig=' fname_IntProd ';'];
    %eval(p);
    % IntProd file columns vs IntProd data from MERGED file columns.
    cols_merged_IntProd=[50:51;1 8];
    r_m=find(cols_merged_IntProd(1,:)==colNum);
    col_par_orig=cols_merged_IntProd(2,r_m);
    colDep_orig=[];
    % Find Selected station ORIGINAL data.
    rr_orig=find(d_orig(:,colCast_pi)==cast_num);
elseif colNum>=first_col_nuts & colNum<=last_col_nuts
    show_original='yes';
    %##########################################################
    %################ (4) LOAD NUTS data file #################
    %##########################################################
    p=['load ' path_name_nuts fname_nuts '.' fname_data_ext ';'];
    eval(p);
    p=['d_n=' fname_nuts ';'];
    eval(p);
    size(d_n); % ANS: 996x7
    path_nuts_txt=strrep(path_name_nuts,'_','\_');
    fname_nuts_txt=strrep(fname_nuts,'_','\_');
    str_text(2)={'Original data: '};
    str_text(3)={[path_nuts_txt fname_nuts_txt '.txt']};
    % --- Nuts columns:
    colCast_n=1;
    colBot_n=2;
    colNO3_n=3;
    colNH4_n=41;
    colPO4_n=5;
    colSi_n=6;
    colDepT_n=7; % added by program
    %----------------------------------------------------------
    %------------   NUTS C O R R E C T I O N   ----------------
    %----------------------------------------------------------
    % (1) There are two CTD casts #115:
    % ar29115.* (cast #115 in CTD list ) - failed btl (one depth only), file
    % stopped;
    % ar29115upcast.* (cast #115.2 in CTD list ) - new file stated and it is final.
    % The second cast was sampled. Correct cast name:
    r_cast115=find(d_n(:,colCast_n)==115);
    d_n(r_cast115,colCast_n)=115.2;
    clear r_cast115;
    %
    % (2) Cast 5 Bottle #19 - surface or 4.5m
    % Cast 5 bottle# and pressure:
    %      18    5.469
    %      19    4.665
    %      20    3.886
    %      21    3.782
    %      22    3.513
    %      23    2.395
    %      24    2.953
    % Log sheet: bottles ## 19:24 are surface, #18 is 4.5m;
    % Merged bottle file: I use pressure from #18 and 19 for 4.5m
    % and pressure from ##20:24 for surface.
    % So Nuts samples from #19 is in fact 4.5m, i.e. 2 samples from 4.5m.
    % !!! For now:
    % I'll not use average of those two samples and show them separately -
    % one from surface (#20 instead of 19) and one from 4.5 (#18 - it is o.k.).
    rn_5_19=find(d_n(:,colCast_n)==5 & d_n(:,colBot_n)==19);
    d_n(rn_5_19,colBot_n)=20;
    clear rn_5_19;
    %
    % (3) Cast 161 - no bottles fired; cast 162 with sampling followed.
    % Correct cast name is 162:
    r_cast161=find(d_n(:,colCast_n)==161);
    d_n(r_cast161,colCast_n)=162;
    clear r_cast161;
    %
    % (4) depth_not_found in the file: Cast #, Nuts Nisken #, Target depth.
    % Depth not found: cast 119 Nisken 3  - Nisk #3 and #4* are both from 100m
    % Depth not found: cast 121 Nisken 6  - Nisk #6 and #7* are both from 30m
    % Depth not found: cast 151 Nisken 4  - Nisk #3 and #4* are both from 100m
    % #* indicates Nisken # in the merged (Cast #/Nuts Nisken #/Target depth).
    % (4.1) Cast 51(100m) seems to be incorrectly labeled, should be Nisken #2 not #3.
    % Log book and BTL:
    % Nisken #1 - 140m
    % Nisken #2 - 120m and it is absent in Nuts
    % Nisken #3 - 100m
    % Nisken #4 - 100m
    % Nuts data:
    % Nisken#, NO3, NH4, PO4, Si, target depth
    % 1.00          9.78          0.58          0.54          6.20        142.00
    % 3.00          9.67          0.69          0.56          5.94        100.00
    % 4.00          7.55          0.93          0.45          3.20        100.00
    % I'll corect this:
    r_151_n3=find(d_n(:,colCast_n)==151 & d_n(:,colBot_n)==3);
    d_n(r_151_n3,colBot_n)=2;
    % (4.2) Casts 119(100m) and 121(30m) seem to be duplicates.
    % I'll use data average. Nisken # for averaged points will be indicated with #.5
    % (e.g. 3.5 for cast 119).
    %
    % (5) Cast 117 Nisken #1: two samples indicated with "A" and"B" (300m):
    % C117 N1 "A" 117	1	18.310	0.269	1.035	10.511
    % C117 N1 "B" 117	1	22.064	<0.015	1.250	12.404
    % For now I'l use averaging but have to ask Paul.
    %------------   NUTS C O R R E C T I O N  END ----------------
    %
    d_orig=d_n;
    % Nuts file columns vs Nuts data from MERGED file columns.
    cols_merged_nuts=[52:56;2:6];
    r_m=find(cols_merged_nuts(1,:)==colNum);
    col_par_orig=cols_merged_nuts(2,r_m);
    colDep_orig=colDepT_n;
    % Find Selected station ORIGINAL data.
    rr_orig=find(d_orig(:,colCast_n)==cast_num);
end
%**************************
% Plot Selected station - ORIGINAL data.
%**************************
hold on;
if strcmp(show_original,'yes')
    par_st_orig=d_orig(rr_orig,col_par_orig);
    if ~isempty(colDep_orig)
        dep_st_orig=d_orig(rr_orig,colDep_orig);
    else
        dep_st_orig=0;
    end
    hh(length(hh)+1)=plot(par_st_orig,dep_st_orig,'o','markersize',marker_size+6,...
        'markerFaceColor',color_orig,'markerEdgeColor',color_orig,...
        'linewidth',line_width+0.8);
    %%%leg_text=strvcat(leg_text,['Original data st' st_name 'April ' num2str(dayday_st)]);
    leg_text=strvcat(leg_text,['Original data c' cast_str ' st' st_name]);
end
%**************************
% Plot Selected station.d
%**************************
hold on;
hh(length(hh)+1)=plot(par_st,pres_st,'o-',...
    'color',show_st_color,'linewidth',line_width+0.5,...
    'markerFaceColor',show_st_color,'markerEdgeColor',show_st_color,...
    'markersize',marker_size+3);
%leg_text=strvcat(leg_text,'Bottle file - selected');
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
xlabel([par_name ' (column #' num2str(colNum) ', ' group_name ')'],'fontsize',fnt_label);
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
str_text(1)={['Bottle file: ' path_name_txt fname_txt '.mat (' fname_ext ')']};
x_t=x_lim(1)-0.1*range(x_lim);
text(x_t,y_lim(2)+0.2*range(y_lim),str_text,'color',[0 0 0],'horizontalAlignment','left','fontsize',8);

