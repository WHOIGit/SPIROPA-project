% Import SPIROPAchl spreadsheet
% Import CTD-only bottle summary file for each SPIROPA cruise
% Produce BTLmatch with same number of rows as SPIROPAchl
% Plot extracted Chl vs BTL_chl_fluorescence for each cruise
%
% Heidi M. Sosik, Woods Hole Oceanographic Institution; November 2019

%AR29
load('\\sosiknas1\Lab_data\SPIROPA\20180414_AR29\fromOlga\p_11_ar29_BTL_data_v2.mat');
AR29_BTL = p_11_ar29_BTL_data_v2; clear p_11_ar29_BTL_data_v2
ARcolnum = [1 2 19 25]; %cast, niskin, pressure, FL-chl?

%RB1904
load('\\sosiknas1\Lab_data\SPIROPA\20180503_RB1904\fromOlga\rb1904_BTL_data.mat');
RB1904_BTL = rb1904_BTL_data; clear rb1904_BTL_data
RBcolnum = [1 2 20 26 36]; %cast, niskin, depth, FL-chl, FL-V

%TN368
load('\\sosiknas1\Lab_data\SPIROPA\20190705_TN368\fromOlga\tn368_BTL_data.mat')
TN368_BTL = tn368_BTL_data; clear tn368_BTL_data
TNcolnum = [1 2 20 26 36]; %cast, niskin, depth, FL-chl, FL-V

SPIROPAchl = SPIROPAchl_importfile("\\sosiknas1\Lab_data\SPIROPA\CHL\SPIROPAchl.xlsx", "chl", [2, 3887]);

ARrow = find(SPIROPAchl.Cruise == 'AR29');
RBrow = find(SPIROPAchl.Cruise == 'RB1904');
TNrow = find(SPIROPAchl.Cruise == 'TN368');

BTLmatch = NaN(size(SPIROPAchl,1),5);
indmatch = NaN(size(ARrow));
for ii = 1:length(ARrow)
    indmatch(ii) = find(AR29_BTL(:,ARcolnum(1)) == SPIROPAchl.Cast(ARrow(ii)) & AR29_BTL(:,ARcolnum(2)) == SPIROPAchl.Niskin(ARrow(ii)));
end
BTLmatch(ARrow,1:4) = AR29_BTL(indmatch,ARcolnum);

indmatch = NaN(size(RBrow));
for ii = 1:length(RBrow)
    indmatch(ii) = find(RB1904_BTL(:,ARcolnum(1)) == SPIROPAchl.Cast(RBrow(ii)) & RB1904_BTL(:,RBcolnum(2)) == SPIROPAchl.Niskin(RBrow(ii)));
end
BTLmatch(RBrow,:) = RB1904_BTL(indmatch,RBcolnum);

indmatch = NaN(size(TNrow));
for ii = 1:length(TNrow)
    indmatch(ii) = find(TN368_BTL(:,TNcolnum(1)) == SPIROPAchl.Cast(TNrow(ii)) & TN368_BTL(:,TNcolnum(2)) == SPIROPAchl.Niskin(TNrow(ii)));
end
BTLmatch(TNrow,:) = TN368_BTL(indmatch,TNcolnum);

ARrow = find(SPIROPAchl.Cruise == 'AR29' & SPIROPAchl.FilterSize == 0);
RBrow = find(SPIROPAchl.Cruise == 'RB1904' & SPIROPAchl.FilterSize == 0);
TNrow = find(SPIROPAchl.Cruise == 'TN368' & SPIROPAchl.FilterSize == 0);

figure
plot(BTLmatch(ARrow,4), SPIROPAchl.Chlugl(ARrow), '.')
title('AR29')

figure
plot(BTLmatch(RBrow,4), SPIROPAchl.Chlugl(RBrow), '.')
title('RB1904')

figure
plot(BTLmatch(TNrow,4), SPIROPAchl.Chlugl(TNrow), '.')
title('TN368')
