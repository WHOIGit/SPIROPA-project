function [selectedNum]=f_menu_of_numbers_title(menu_title,v)
% Set Menu of numbers in the vector v with a title 'menu_title';
% USE: 
%leg=f_menu_of_numbers_title('Survey#',[1:4]);
%if isempty(leg), return; end
% Olga Kosnyreva, AOPE/WHOI, 5/5/2006

selectedNum=[];
if nargin==1        % number_start can be a vector in this case
   disp('Not enought input arguments');
   return;
elseif nargin==2        % number_start can be a vector in this case
   if ~isstr(menu_title)
      disp('First argument must be a string');
      return;
   end 
   if ~isnumeric(v)
      disp('Second argument must be a scalar or vector of numbers');
      return;
   end 
   st=v;
   if size(st,1)==1, st=st'; end % vector must be a column
else
   disp('Incorrect input');
   return;
end
%*******************************************************************************
%***********************************    MENU of ##    **************************
%*******************************************************************************
% Convert vector of numbers to vector of strings.
st_str=num2str(st);
% Add one more element to vector of strings ('CANCEL').
st_str=strvcat(st_str,'CANCEL');
% Convert vector of strings to cell array.
st_cell=cellstr(st_str);
% Set Menu.
st_num = menu(menu_title, st_cell);
% If Menu item is 'CANCEL' terminate program.
if (st_num > size(st_cell,1)-1), return; end
% Get Leg number (string).
stNum_str=st_cell{st_num};
% Get Leg number (number).
selectedNum=str2num(stNum_str);




































































































