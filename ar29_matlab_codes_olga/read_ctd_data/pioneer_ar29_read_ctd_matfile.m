% pioneer_ar29_read_ctd_matfile.m

clear;

% Cruise ID.
cr_id='ar29';
crName='Pioneer 11 Leg 1 AR29';
lowerDepth=800;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  DATA PATHS   @@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
data_location='olgas_path';
%data_location='your_path';
if strcmp(data_location,'your_path')
    % If all data files are located in the same directory as the Matlab code,
    % use this:
    path_name='';
elseif strcmp(data_location,'olgas_path')
    path_name='~/OOI_pioneer/p_11/leg_1/ctd/process_final/ctd_matfile/';
end
path_name_txt=strrep(path_name,'_','\_');
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@  FILE NAME  @@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
fname='ar29_ctd_data';
fname_txt=strrep(fname,'_','\_');
fname_ext='mat';
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%*****************************************************
%************* LOAD CTD MATFILE **********************
%*****************************************************
p=['load ' path_name fname ';'];
eval(p);
% MATFILE variables:
% --- Three  numeric matricies:
% (1) CTD data, variable name "data", size: 29810x20;
% (2) CTD casts location and date, variable name "info_ctd_casts", size: 175x9;
% (3) CTD casts ## and stations name, variable name
% "info_ctd_casts_stations", size: 175x4;
% --- Three string variables with numeric matricies columns and quantities name:
% (1) data_columns;
% (2) info_ctd_casts_columns;
% (3) info_ctd_casts_stations_columns.
% --- Numeric variable - CTD data "bad" flag:
% (1) "bad_flag" = -9.990e-29;
%
% --- From data matrix.
d=data;
clear data;
% Cast and Pressure columns.
colCast_m=1;
colPres_m=2;
%
% --- From info_ctd_casts matrix.
c_list=info_ctd_casts;
% Columns#:
col_st=1;
col_year=2;
col_mon=3;
col_day=4;
col_h=5;
col_min=6;
col_sec=7;
col_lat=8;
col_lon=9;
cast_list=(unique(c_list(:,col_st)))';
%
% --- From info_ctd_casts_stations.
d_cs=info_ctd_casts_stations;
% Columns:
cs_colCast=1;  % CTD cast
cs_colDay=2;   % day of April 2018
cs_colSt=3;    % station #
cs_colStId=4;  % Station ID: 1-A, 2-B, 3-AUV, 4-AL-CTD, 5-P
%
%*******************************
% Font, color.
%*******************************
fnt_axes=8;
fnt_label=9;
fnt_title=10;
plot_color_all=[0.6 0.6 0.6];
show_st_color=[1 0 0];
line_width=1.5;
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% MENU (1): ALL and ONE or ONE @
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% Options:
% show all casts with selected one on the top
% or
% show selected cast.
show_stations_options=f_menu_of_strings('Show stations',strvcat('All and One','One'));
if isempty(show_stations_options), return; end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@  MENU (2): CAST # @@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% Select the cast.
cast_num=f_menu_of_numbers_title('Show Station',cast_list);
if isempty(cast_num), return; end
cast_str=num2str(cast_num);
%************************************************
%***** SELECTED STATION NAME and DATE/TIME ******
%************************************************
% --- STATION NAME.
r_s=find(d_cs(:,cs_colCast)==cast_num);
st_num=d_cs(r_s,cs_colSt);
st_id=d_cs(r_s,cs_colStId);
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
r_st=find(c_list(:,col_st)==cast_num);
yyyy_st=c_list(r_st,col_year);
mm_st=c_list(r_st,col_mon);
dd_st=c_list(r_st,col_day);
% Time.
hh_st=c_list(r_st,col_h);
minmin_st=c_list(r_st,col_min);
secsec_st=c_list(r_st,col_sec);
% Date and time - string represetation.
str_date=datestr([yyyy_st mm_st dd_st hh_st minmin_st secsec_st],0);
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@  MENU (3): QUANTITY @@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
par_name_list=strvcat(data_columns,'CANCEL');
% Convert vector of strings to cell array.
par_name_list_cell=cellstr(par_name_list);
parNum = menu('Quantity',par_name_list_cell);
if parNum>length(par_name_list), return; end
column_name=deblank(par_name_list(parNum,:));
%*******************************
% Quantity name and column#.
%*******************************
[T,R]=strtok(column_name,' - ');
% Parameter column #.
colNum=str2num(T);
% Parameter name.
R(1:3)='';
par_name=R;
%**************************
% Replace Fluor minus  with zeros.
%**************************
if colNum==8
    r_minus=find(d(:,colNum)<0);
    d(r_minus,colNum)=0;
end
%##############################
%########  FIGURE #############
%##############################
figure;
fig_pos=[657.00        307.00        431.00        518.00];
set(gcf,'color',[1 1 1],'position',fig_pos,...
    'paperPositionMode','auto');
leg_text='';
hh=[];
%*****************************************************
%************    PLOT All stations   *****************
%*****************************************************
total_bad=[];
if strcmp(show_stations_options,'All and One')
    hold on;
    for castNum=cast_list
        r_st=find(d(:,colCast_m)==castNum);
        parSt=d(r_st,colNum);
        presSt=d(r_st,colPres_m);
        %--------------------------
        % Remove "bad" data.
        %--------------------------
        r_bad=find(parSt(:,1)==bad_flag);
        if ~isempty(r_bad)
            total_bad=[total_bad;castNum length(r_bad)];
            parSt(r_bad,:)=[];
            presSt(r_bad,:)=[];
        end
        %--------------------------
        hh(1)=plot(parSt,presSt,'-',...
            'color',plot_color_all,'linewidth',line_width);
        if castNum==cast_list(1), leg_text=strvcat(leg_text,'All CTD casts'); end
        clear r_st parSt presSt;
    end
    hold off;
end
%*****************************************************
%************  PLOT SELECTED station  ****************
%*****************************************************
% --- Select station data:
r_st=find(d(:,colCast_m)==cast_num);
parSt=d(r_st,colNum);
presSt=d(r_st,colPres_m);
%--------------------------
% Remove "bad" data.
%--------------------------
r_bad=find(parSt(:,1)==bad_flag);
if ~isempty(r_bad)
    parSt(r_bad,:)=[];
    presSt(r_bad,:)=[];
end
%--------------------------
% --- Plot Selected station.
hold on;
hh(length(hh)+1)=plot(parSt,presSt,'-',...
    'color',show_st_color,'linewidth',line_width+0.5);
leg_text=strvcat(leg_text,['CTD cast ' cast_str ' st ' st_name]);
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
xlabel([par_name ' (column #' num2str(colNum) ')'],'fontsize',fnt_label);
ylabel('Pressure (db)','fontsize',fnt_label);
str_title(1)={[crName]};
str_title(2)={['CTD cast #' cast_str ' Station ' st_name ': ' str_date ' UTC']};
title(str_title,'fontsize',fnt_title,'color','b');
%**************************
% Legend.
%**************************
leg_location=3;
if size(leg_text,1)>1, legend(hh,leg_text,leg_location); end
%*********************
% Text - file name.
%*********************
str_text(1)={['CTD matfile: ' path_name_txt fname_txt '.' fname_ext]};
x_t=x_lim(1)-0.1*range(x_lim);
text(x_t,y_lim(2)+0.2*range(y_lim),str_text,'color',[0 0 0],'horizontalAlignment','left','fontsize',8);


