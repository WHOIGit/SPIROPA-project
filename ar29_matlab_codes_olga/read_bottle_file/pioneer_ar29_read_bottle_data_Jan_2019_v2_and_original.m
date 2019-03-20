% pioneer_ar29_read_bottle_data_Jan_2019_v2_and_original.m

clear;

%data_location='your_path';
data_location='olgas_path';
%
show_original='yes';
%show_original='no';
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  DATA PATHS   @@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if strcmp(data_location,'your_path')
    % If all data files are located in the same directory as your Matlab code,
    % use this:
    path_name='';
    path_btl='';
    path_data_original='';
elseif strcmp(data_location,'olgas_path')
    path_name='~/OOI_pioneer/p_11/leg_1/bottle_data/';
    path_name_btl='~/OOI_pioneer/BTL_data/';
    path_name_poc='~/OOI_pioneer/p_11/leg_1/bottle_data/original_data/';
    path_name_nuts=['~/OOI_pioneer/p_11/leg_1/bottle_data/original_data/nuts/'];
    path_name_chl=['~/OOI_pioneer/p_11/leg_1/bottle_data/original_data/chl/'];
    path_name_toi=['~/OOI_pioneer/p_11/leg_1/bottle_data/original_data/toi/'];
end
path_name_txt=strrep(path_name,'_','\_');
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  FILE NAMES   @@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% --- Bottle file.
fname='ar29_bottle_data_Jan_2019_v2';
fname_txt=strrep(fname,'_','\_');
fname_ext='txt';
fname_data_ext='txt';
% --- Original data files.
fname_btl='p_11_ar29_BTL_data_v2'; % with Fluor corrected
fname_nuts='McGillicudy_AR29_2018_client_w_with_depth';
%fname_chl='spiropa_chl_replicates_w';
fname_chl='spiropa_chl_replicates_w_with_depth';
%#########################
% Primary Production, BSi,POC,PON data - NEW data file from Walker.
%#########################
fname_poc='bottle_file_data_wos_12_7_w'; % size 714x21
% CORRECTIONS from Meredithupdated data file "bottle file data wos
% 1-7.xlsx" 01/07/2019:
% (1) Cast 130 (7 points, all from 28m) was marked as Experiment in "bottle
% file data wos 12-7.xlsx". This data is from cast 131 (plus to other depths already available);
% this is corrected by the current program;
% (2) added 2 new lines:
% cast 131 depth 100m and
% cast 153 depth 0m
% For my convenience separate file with those two lines was created
% (same format as the previous versin "bottle file data wos 12-7.xlsx")'
% and data is added by the current program. File name:
fname_poc_corr='corrections_from_bottle_file_data_wos_1_7';
%#########################
fname_toi='TOI_data_for_sharing_w';
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% Cruise ID, date.
cr_id='ar29';
crName='AR29';
date_cr_str='April 17-29, 2018';
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
%******** LOAD Bottle file (MATFILE) ***************
%***************************************************
p=['load ' path_name fname ';'];
eval(p);
% MATFILE variables:
% (1) numeric matrix "data", size: 1055x73;
% (2) 7 string variables:
% --- quantities names and corresponding columns:
% CTD_casts_info_columns
% CTD_BTL_data_columns
% POC_PP_IntProd_columns
% nuts_columns
% chl_columns;
% toi_columns;
% --- Station name codes and example:
% station_name_note.
d=data;
clear data;
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
colDepT_m=10;
colDep_m=11;
colPres_m=12;
colNiskenUsed_m=13;
%******************************
% Data groups columns.
%******************************
cols_info=1:13;  % 13 columns
cols_btl=14:36;  % 23 columns
cols_poc=37:49;  % 13 columns
cols_nuts=50:54; % 5 columns
cols_chl=55:66;  % 12 columns
cols_toi=67:73;  % 7 columns
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@  MENU: Parameter Group  @@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
group_list=strvcat('CTD casts info (cols 1:13)','CTD BTL data (cols 14:36)','POC, PP, IntProd (cols 37:49)','Nuts (cols 50:54)','Chl (cols 55:66)','TOI (cols 67:73)','CANCEL');
% Convert vector of strings to cell array.
group_list_cell=cellstr(group_list);
group_num=menu('Quantity Group',group_list_cell);
if group_num>6, return; end
cast_ID='CTD';
switch group_num
    case 1
        columns_list=CTD_casts_info_columns;
        group_name='CTD casts info';
        jn='info';
    case 2
        columns_list=CTD_BTL_data_columns;
        group_name='CTD BTL data';
        jn='btl';
    case 3
        columns_list=POC_PP_IntProd_columns;
        group_name='POC, PP, IntProd';
        jn='poc';
    case 4
        columns_list=nuts_columns;
        group_name='Nuts data';
        jn='nuts';
    case 5
        columns_list=chl_columns;
        group_name='Chl data';
        jn='chl';
    case 6
        columns_list=toi_columns;
        group_name='TOI data';
        jn='toi';
end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@  MENU: Quantity  @@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
column_name=f_menu_of_strings('Column # and Quantity',columns_list);
if isempty(column_name), return; end
column_name=deblank(column_name);
[T,R]=strtok(column_name,' - ');
% Quantity - column #.
colNum=str2num(T);
% Quantity - name.
R(1:3)='';
par_name=R;
par_name_txt=strrep(par_name,'_','\_');
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@  MENU: Show Casts @@@@@@@
%@@@ "ALL and ONE" or "ONE" @@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
show_stations_options=f_menu_of_strings('Show stations',strvcat('All and One','One'));
if isempty(show_stations_options), return; end
%**************************
% Lower depth.
%**************************
if group_num==3 % POC,PP, IntProd
    lowerDepth=120;
    leg_location=4;
elseif group_num==5 | group_num==6 % Chl, TOI
    lowerDepth=320;
    leg_location=4;
else
    lowerDepth=800;
end
%**************************
% Depth type for Y-axis
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
% Remove NaNs for plots (NaN makes a break in the profile line)
% and keep them for display.
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
d_with_flag=d; % with NaNs -for display
r_nan=find(isnan(d(:,colNum)));
d(r_nan,:)=[];
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
clear r_st;
%*****************************************************
%**** SELECTED STATION INFO (date, time, cast) *******
%*****************************************************
r_st=find(d(:,colCast_m)==cast_num);
if ~isempty(r_st)
    d_st_for_info=d(r_st,:);
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
%*****************************************************
%******** SELECTED STATION DATA (for display) ********
%*****************************************************
r_st_d=find(d_with_flag(:,colCast_m)==cast_num); % with NaNs -for display
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
str_text(1)={['Bottle file: ' strrep(path_name,'_','\_') fname_txt '.mat (' fname_ext ')']};
leg_location=3;
if strcmp(show_original,'yes')
    str_text(2)={'Original data: '};
    %**************************
    % Load ORIGINAL data file.
    %**************************
    p=['path_name_d=path_name_' jn ';'];
    eval(p);
    p=['fname_d=fname_' jn ';'];
    eval(p);
    p=['load ' path_name_d fname_d '.' fname_data_ext ';'];
    eval(p);
    p=['d_p=' fname_d ';'];
    eval(p);
    %size(d_p)
    str_text(3)={[strrep(path_name_d,'_','\_') strrep(fname_d,'_','\_') '.txt']};
    %**************************
    % ORIGINAL data columns.
    %**************************
    if strcmp(jn,'btl')
        %size(d_p) % ANS: 1578x31
        % --- Summary BTL columns:
        colCast_n=1;       % CTD cast
        colBot_n=2;        % Bottle
        colMon_n=3;        % Month
        colDay_n=4;        % Day
        colYear_n=5;       % Year
        colSig_n=6;        % Sigma-é00
        colSig_s_n=7;      % Sigma-é00
        colOxy_n=8;        % Sbeox0ML/L
        colOxySat_n=9;     % OxsolMm/Kg
        colOxyM_n=10;      % Sbeox0Mm/Kg
        colPotTemp_n=11;   % Potemp090C
        colPotTemp_s_n=12; % Potemp190C
        colSal_n=13;       % Sal00
        colSal_s_n=14;     % Sal11
        colDens_n=15;      % Density00
        colDens_s_n=16;    % Density11
        colSoundVel_n=17;  % SvCM
        colSoundVel_s_n=18;% SvCM1
        colPres_n=19;      % PrDM
        colTemp_n=20;      % T090C
        colTemp_s_n=21;    % T190C
        colCnd_n=22;       % C0S/m
        colCnd_s_n=23;     % C1S/m
        colOxyV_n=24;      % Sbeox0V
        colFluor_n=25;     % UserPoly
        colTurb_n=26;      % TurbWETntu0
        colSalD_n=27;      % Sal fron DATCNV
        colSpar_n=28;      % Spar
        colPar_n=29;       % Par
        colCpar_n=30;      % Cpar
        colScan_n=31;      % Scan
        btl_columns_use=[6:18 20:26 28:30];
        colDep_orig=colPres_n;
    elseif strcmp(jn,'poc')
        %size(d_p); % ANS: 714x21
        %**************************
        % POC: Load ORIGINAL data correction file.
        %**************************
        p=['fname_d_corr=fname_' jn '_corr;'];
        eval(p);
        p=['load ' path_name_d fname_d_corr '.' fname_data_ext ';'];
        eval(p);
        p=['d_p_corr=' fname_d_corr ';'];
        eval(p);
        str_text(4)={[strrep(path_name_d,'_','\_') strrep(fname_d_corr,'_','\_')]};
        %size(d_p_corr); % ANS: 2x21
        %d_p_corr =
        %  Columns 1 through 8
        %        131.00          1.00         16.00          4.00         26.00       2018.00         39.75        -70.83
        %        153.00          1.00          9.00          4.00         27.00       2018.00         40.20        -70.83
        %  Columns 9 through 16
        %           NaN        101.53           NaN           NaN           NaN           NaN           NaN           NaN
        %           NaN          3.97           NaN           NaN           NaN           NaN           NaN           NaN
        %  Columns 17 through 21
        %           NaN          3.76           NaN           NaN           NaN
        %           NaN          5.78           NaN           NaN           NaN
        % --- POC/PP/... columns:
        colCast_n=1;
        colStId_n=2;
        colStNum_n=3;
        colMon_n=4;
        colDay_n=5;
        colYear_n=6;
        colLat_n=7;
        colLon_n=8;% Lon minus
        colLight_n=9;
        colDep_n=10;
        colProd_n=11;
        colProd_chl_n=12;
        colAN_n=13;
        colProd_20um_n=14;
        colPOC_n=15;
        colPON_n=16;
        colBSi_n=17;
        colCN_ratio_n=18;
        colIntProd_n=19;
        colIntProd_20um_n=20;
        colRatio_n=21;
        % Use columns:
        poc_columns_use=9:21;
        colDep_orig=colDep_n;
        %---------------------------------------------------------
        %---------- POC/PP/... C O R R E C T I O N S  ------------
        %---------------------------------------------------------
        % --- (1) Cast 115 failed and was repeated with the name 115upcast (115.2 in the list)
        r_115=find(d_p(:,colCast_n)==115);
        d_p(r_115,colCast_n)=115.2;
        % NEW CORRECTIONS:
        % --- (2) Add 2 lines: cast 131 depth 100m and cast 153 depth 0m:
        d_p=[d_p;d_p_corr];
        % --- (3) Replace cast 130 28.0m (corrected by Meredith - should be 26.8, target 25m) with cast 131:
        % 3.1. Find cast 130 28m:
        r_130_28=find(d_p(:,colCast_n)==130 & d_p(:,colDep_n)==28.0);
        d_p(r_130_28,colDep_n)=26.8;
        % 3.2. Cast 131 info data:
        r_131=find(d_p(:,colCast_n)==131);
        c_131_info=d_p(r_131(1),colCast_n:colLon_n);
        c_131_info_for_130=repmat(c_131_info,length(r_130_28),1);
        % 3.3. Replace old info in cast 130 with new from cast 131:
        d_p(r_130_28,colCast_n:colLon_n)=c_131_info_for_130;
        % 3.4. Sort the matrix:
        d_p=sortrows(d_p,[colCast_n colDep_n]);
        %-------  POC/PP/... C O R R E C T I O N S END --------------
    elseif strcmp(jn,'nuts')
        %size(d_p); % ANS: 996x7
        % --- Nuts columns:
        colCast_n=1;
        colBot_n=2;
        colNO3_n=3;
        colNH4_n=41;
        colPO4_n=5;
        colSi_n=6;
        colDepT_n=7; % added by program
        % Use columns:
        nuts_columns_use=2:6;
        colDep_orig=colDepT_n;
       %----------------------------------------------------------
        %------------   NUTS C O R R E C T I O N   ----------------
        %----------------------------------------------------------
        % (1) There are two CTD casts #115:
        % ar29115.* (cast #115 in CTD list ) - failed btl (one depth only), file
        % stopped;
        % ar29115upcast.* (cast #115.2 in CTD list ) - new file started and it is final.
        % The second cast was sampled. Correct cast name:
        r_cast115=find(d_p(:,colCast_n)==115);
        d_p(r_cast115,colCast_n)=115.2;
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
        rn_5_19=find(d_p(:,colCast_n)==5 & d_p(:,colBot_n)==19);
        d_p(rn_5_19,colBot_n)=20;
        clear rn_5_19;
        %
        % (3) Cast 161 - no bottles fired; cast 162 with sampling followed.
        % Correct cast name is 162:
        r_cast161=find(d_p(:,colCast_n)==161);
        d_p(r_cast161,colCast_n)=162;
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
        r_151_n3=find(d_p(:,colCast_n)==151 & d_p(:,colBot_n)==3);
        d_p(r_151_n3,colBot_n)=2;
        % (4.2) Casts 119(100m) and 121(30m) seem to be duplicates.
        % I'll use data average. Nisken # for averaged points will be indicated with #.5
        % (e.g. 3.5 for cast 119).
        %
        % (5) Cast 117 Nisken #1: two samples indicated with "A" and"B" (300m):
        % C117 N1 "A" 117	1	18.310	0.269	1.035	10.511
        % C117 N1 "B" 117	1	22.064	<0.015	1.250	12.404
        % For now I'll use averaging but have to ask Paul.
        %------------   NUTS C O R R E C T I O N  END ----------------
    elseif strcmp(jn,'chl')
        %size(d_p); % ANS: 707x16
        % --- Chl columns:
        colCast_n=1;
        colBot_n=2;
        colDep_n=3;
        colLat_n=4;
        colLon_n=5;
        colFilter_0_n=6;
        colChla_0_n=7;
        colChlb_0_n=8;
        colPhaeoa_0_n=9;
        colPhaeob_0_n=10;
        % Columns added to the original file for the data from 10L filter:
        colFilter_10_n=11;
        colChla_10_n=12;
        colChlb_10_n=13;
        colPhaeoa_10_n=14;
        colPhaeob_10_n=15;
        % Column added for Target depth.
        colDepT_n=16;
        % Use columns:
        chl_columns_use=[2 3 6:15];
        colDep_orig=colDepT_n;
        %***************************
        % NOTE for file format change:
        %***************************
        % There are two filters 0 and 10L with their own data;
        % samples were taken from the same Nisken, so at the same depth.
        % Bottle file has one row for each depth (except several significant POC data points) and I'd better do not change
        % this. 5 additional columns were added with filter 10L measuremens
        %***************************
    elseif strcmp(jn,'toi')
        %size(d_p); % ANS: 289x16
        % --- TOI columns:
        colCast_n=1;
        colBot_n=2;
        colMon_n=3;
        colDay_n=4;
        colYear_n=5;
        colDepT_n=6;
        colD17_n=7;
        colLittled17_n=8;
        colLittled18_0_n=9;
        colO2Ar_n=10;
        colSamp_n=11;
        colTOIbottle_n=12;
        colDepT_R_n=13;
        colStId_n=14;
        colStNum_n=15;
        colCast_R_n=16;
        % Use columns:
        toi_columns_use=[2 7:12];
        colDep_orig=colDepT_n;
        % Correct what is known:
        %--------------- C O R R E C T I O N  TOI (1) --------
        % Correct mistakes found in Target depth column:
        % change cast 115 to cast 115.2
        % (115.2 is cast with bottles and used for bottle file)
        r_115=find(d_p(:,colCast_n)==115);
        d_p(r_115,colCast_n)=115.2;
        d_p(r_115,colCast_R_n)=115.2;
        % 5m in the file is surface - Bottle file surface is 0m
        % (if check with bottle/depth list shows otherwise, depth will be corrected):
        r_surf=find(d_p(:,colDepT_n)==5);
        d_p(r_surf,colDepT_n)=0;
        %--------------- C O R R E C T I O N  TOI (1) END --------
        % BEFORE CORRECTIONS:
        % check_bot_dep
        %    5.0000   19.0000         0    4.5000
        %    5.0000    1.0000   95.0000   92.0000
        %    8.0000    9.0000         0   40.0000 ???
        %   29.0000   15.0000   15.0000         0 ???
        %   70.0000   15.0000    3.0000         0
        %   77.0000   22.0000    3.0000         0
        %   79.0000    8.0000    3.0000         0
        %   87.0000   15.0000   42.0000         0 ???
        %  102.0000    1.0000  202.0000  203.0000
        %  112.0000   10.0000   49.0000   40.0000
        %  114.0000    8.0000   84.0000   83.0000
        %  148.0000   16.0000   20.0000   18.0000
        %  148.0000   12.0000   40.0000   39.0000
        %  152.0000    2.0000  150.0000  127.0000
        %  153.0000    2.0000  118.0000  120.0000
        %  155.0000    1.0000  100.0000   90.0000
        %
        %--------------- C O R R E C T I O N  TOI (2) --------
        % Correct mistakes found in Target depth column:
        % (cast sheet shows this is one of surface bottles).
        r_5_0=find(d_p(:,colCast_n)==5 & d_p(:,colBot_n)==19);
        d_p(r_5_0,colDepT_n)=4.5;
        % cast5 92m not 95m
        r_5_95=find(d_p(:,colCast_n)==5 & d_p(:,colDepT_n)==95);
        d_p(r_5_95,colDepT_n)=92;
        % c70:
        r_70=find(d_p(:,colCast_n)==70 & d_p(:,colDepT_n)==3);
        d_p(r_70,colDepT_n)=0;
        % c77:
        r_77=find(d_p(:,colCast_n)==77 & d_p(:,colDepT_n)==3);
        d_p(r_77,colDepT_n)=0;
        % c79:
        r_79=find(d_p(:,colCast_n)==79 & d_p(:,colDepT_n)==3);
        d_p(r_79,colDepT_n)=0;
        % c102:
        r_102=find(d_p(:,colCast_n)==102 & d_p(:,colDepT_n)==202);
        d_p(r_102,colDepT_n)=203;
        % c112:
        r_112=find(d_p(:,colCast_n)==112 & d_p(:,colDepT_n)==49);
        d_p(r_112,colDepT_n)=40;
        % c114:
        r_114=find(d_p(:,colCast_n)==114 & d_p(:,colDepT_n)==84);
        d_p(r_114,colDepT_n)=83;
        % c148:
        r_148_20=find(d_p(:,colCast_n)==148 & d_p(:,colDepT_n)==20);
        d_p(r_148_20,colDepT_n)=18;
        r_148_40=find(d_p(:,colCast_n)==148 & d_p(:,colDepT_n)==40);
        d_p(r_148_40,colDepT_n)=39;
        % c152:
        r_152=find(d_p(:,colCast_n)==152 & d_p(:,colDepT_n)==150);
        d_p(r_152,colDepT_n)=127;
        % c153:
        r_153=find(d_p(:,colCast_n)==153 & d_p(:,colDepT_n)==118);
        d_p(r_153,colDepT_n)=120;
        % c155:
        r_155=find(d_p(:,colCast_n)==155 & d_p(:,colDepT_n)==100);
        d_p(r_155,colDepT_n)=90;
        %--------------- C O R R E C T I O N  TOI (2) END --------
    else
        disp('ORIGINAL data - not concidered case');
        return;
    end
    %**************************
    % Find Selected station ORIGINAL data.
    %**************************
    % Data.
    d_orig=d_p;
    % Data columns: BOTTLE file vs Original file.
    p=['cols_merged=[cols_' jn ';' jn '_columns_use];'];
    eval(p);
    % Selected station data.
    r_m=find(cols_merged(1,:)==colNum);
    col_par_orig=cols_merged(2,r_m);
    rr_orig=find(d_orig(:,colCast_n)==cast_num);
    %**************************
    % Plot Selected station - data from ORIGINAL file.
    %**************************
    hold on;
    par_st_orig=d_orig(rr_orig,col_par_orig);
    if ~isempty(colDep_orig) % case - one depth data, e.g. Surface only
        dep_st_orig=d_orig(rr_orig,colDep_orig);
    else
        dep_st_orig=0;
    end
    hh(length(hh)+1)=plot(par_st_orig,dep_st_orig,'o','markersize',marker_size+6,...
        'markerFaceColor',color_orig,'markerEdgeColor',color_orig,...
        'linewidth',line_width+0.8);
    leg_text=strvcat(leg_text,['Original data c' cast_str ' st ' st_name]);
    hold off;
end % For if strcmp(show_original,'yes')
%**************************
% Plot Selected station - data from Bottle file.
%**************************
hold on;
hh(length(hh)+1)=plot(par_st,pres_st,'o-',...
    'color',show_st_color,'linewidth',line_width+0.5,...
    'markerFaceColor',show_st_color,'markerEdgeColor',show_st_color,...
    'markersize',marker_size+3);
leg_text=strvcat(leg_text,['Bottle file c' cast_str ' st ' st_name]);
hold off;
%*****************************************************
%**************  SET AXES PROPERTIES  ****************
%*****************************************************
ah=get(gca,'position');
set(gca,'position',[ah(1)-ah(3)*0.03 ah(2)+ah(4)*0.13 ah(3)*1.1 ah(4)*0.80]);
x_lim=get(gca,'xlim');
y_lim=[0-0.00001 lowerDepth];
%NOTE: -0.00001 used to have markers plotted at target depth=0m
axis([x_lim y_lim]);
grid on;
set(gca,'ydir','reverse','fontsize',fnt_axes,'box','on');
xlabel([par_name_txt ' (column #' num2str(colNum) ', ' group_name ')'],'fontsize',fnt_label);
ylabel(label_depth_use,'fontsize',fnt_label);
str_title(1)={[crName ' ' date_cr_str]};
str_title(2)={[' CTD cast #' cast_num_str ' Station ' st_name ': ' date_str ' UTC']};
title(str_title,'fontsize',fnt_title,'color','b');
%**************************
% Legend.
%**************************
if size(leg_text,1)>1, legend(hh,leg_text,leg_location); end
%*********************
% Text - file names.
%*********************
x_t=x_lim(1)-0.1*range(x_lim);
text(x_t,y_lim(2)+0.2*range(y_lim),str_text,'color',[0 0 0],'horizontalAlignment','left','fontsize',8);
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% FYI: Bottle data file columns
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% --- Set #1: INFO columns.
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
% --- Set #2: BTL data columns.
colSig_m=14;       % Sigma-é00
colSig_s_m=15;     % Sigma-é00
colOxy_m=16;       % Sbeox0ML/L
colOxySat_m=17;    % OxsolMm/Kg
colOxyM_m=18;      % Sbeox0Mm/Kg
colPotTemp_m=19;   % Potemp090C
colPotTemp_s_m=20; % Potemp190C
colSal_m=21;       % Sal00
colSal_s_m=22;     % Sal11
colDens_m=23;      % Density00
colDens_s_m=24;    % Density11
colSoundVel_m=25;  % SvCM
colSoundVel_s_m=26;% SvCM1
colTemp_m=27;      % T090C
colTemp_s_m=28;    % T190C
colCnd_m=29;       % C0S/m
colCnd_s_m=30;     % C1S/m
colOxyV_m=31;      % Sbeox0V
colFluor_m=32;     % UpolyFluor
colTurb_m=33;      % TurbWETntu0
colSpar_m=34;      % Spar
colPar_m=35;       % Par
colCpar_m=36;      % Cpar
% --- Set #3: POC/PP/IntProductivity columns.
colLight_m=37;
colDepPP_m=38;     % depth from WOS data
colProd_m=39;
colChlPP_m=40;
colAN_m=41;
colProd_20um_m=42;
colPOC_m=43;
colPON_m=44;
colBSi_m=45;
colCN_ratio_m=46;
colIntProd_m=47;
colIntProd_20um_m=48;
colRatio_m=49;
% --- Set #4: Nutrients columns.
colBotNuts_m=50;
colNO3_m=51;
colNH4_m=52;
colPO4_m=53;
colSi_m=54;
% --- Set #5: Chl columns.
colBotChl_m=55;
colDepChl_m=56;
colFilter_0_m=57;
colChla_0_m=58;
colChlb_0_m=59;
colPhaeoa_0_m=60;
colPhaeob_0_m=61;
colFilter_10_m=62;
colChla_10_m=63;
colChlb_10_m=64;
colPhaeoa_10_m=65;
colPhaeob_10_m=66;
% --- Set #6: TOI columns.
colNisk_toi_m=67;
colD17_m=68;
colLittled17_m=69;
colLittled18_m=70;
colO2Ar_m=71;
colSamp_toi_m=72;
colBottle_toi_m=73;
%
%cols_info=1:13;  % 13 columns
%cols_btl=14:36;  % 23 columns
%cols_poc=37:49;  % 13 columns
%cols_nuts=50:54; % 5 columns
%cols_chl=55:66;  % 12 columns
%cols_toi=67:73;  % 7 columns

