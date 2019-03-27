function [s]=f_menu_of_strings(header,S)
% f_menu_of_strings 
% GENERATES menu of choises for user input.
% Displays  the HEADER string followed in sequence by
% the menu-item strings which are the rows of a string matrix S
%  (as returned by  STRVCAT).
% RETURNS a string - menu-item name

s='';
if nargin==1        % number_start can be a vector in this case
   disp('Not enought input arguments');
   return;
elseif nargin==2        % number_start can be a vector in this case
   if ~isstr(header)
      disp('First argument must be a string');
      return;
   end 
   if ~isstr(S)
      disp('Second argument must be a matrix of strings as returned by STRVCAT');
      return;
   end 
   %st_str=S;
else
   disp('Incorrect input');
   return;
end
%*******************************************************************************
%***********************************    MENU of ##    **************************
%*******************************************************************************
% Add one more element to vector of strings ('CANCEL').
s_str=strvcat(S,'CANCEL');
% Convert vector of strings to cell array.
s_cell=cellstr(s_str);
% Set Menu.
s_num = menu(header,s_cell);
% If Menu item is 'CANCEL' terminate program.
if (s_num > size(s_cell,1)-1), return; end
% Get string as menu-item choice (string).
s=s_cell{s_num};
