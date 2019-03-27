function [time_vector] = f_hhmm2timevec(hhmm)
% Convert time representation hhmm to time vector
% E.g.
% If hhmm=[2205 2350 0 103 230] then 
% f_hhmm2timevec(hhmm) returns:
%    [22     5
%     23    50
%      0     0
%      1     3
%      2    30]

if size(hhmm,1)>1 & size(hhmm,2)>1
    disp('Input must be a scalar or vector');
    return;
elseif size(hhmm,2)>1
    hhmm=hhmm';
end
hh = floor(hhmm/1e2);
mm = hhmm - floor(hhmm/1e2)*1e2;
time_vector=[hh mm];   
