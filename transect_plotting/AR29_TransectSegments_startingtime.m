% SPIROPA AR29 (April 2018) cruise transect segment starting time (UTC) for interpretation of the ship underway data
% Each segment is a straight line in only one direction, and the main activities in each segment is provided in the end of each line
% The transect number is consistent with the old version of the transect list
% Created by Gordon Zhang on Dec 1, 2018
% Corrected the start time for Transects 15b, 16d, 16e, 18c by Gordon Zhang on Jan 20, 2019

tstime(1)   = datenum([2018 04 17 13 15 04]); % Transect 1,    Offshore CTD transect, Cast 1-14
tstime(2)   = datenum([2018 04 18 03 10 04]); % Transect 2,    Onshore EK80 transect
tstime(3)   = datenum([2018 04 18 10 30 04]); % Transect 3,    Offshore mixed transect, start with Cast 15, then towed VPR-1, and then Cast 16-21
tstime(4)   = datenum([2018 04 19 00 06 28]); % Transect 4,    Onshore CTD transect, start with a short onshore transit and then Cast 22-28
tstime(5)   = datenum([2018 04 19 07 48 43]); % Transect 5a,  Offshore CTD transect, start with a short offshore transit and then Cast 29-32
tstime(6)   = datenum([2018 04 19 14 00 57]); % Transect 5b,  Onshore CTD transect, start with a short onshore transit and then Cast 33-40
tstime(7)   = datenum([2018 04 19 23 01 49]); % Transect 6,    Offshore EK80 transect
tstime(8)   = datenum([2018 04 20 04 18 00]); % Transect 7,    Onshore EK80 transect followed by Cast 41
tstime(9)   = datenum([2018 04 20 10 19 12]); % Transect 8,    Offshore VPR transect (towed VPR-2)
tstime(10) = datenum([2018 04 20 17 18 14]); % Transect 8b,  Short onshore transit
tstime(11) = datenum([2018 04 20 20 13 55]); % Transect 9a,  Short CTD offshore transect, start with Cast 42-45
tstime(12) = datenum([2018 04 20 22 15 36]); % Transect 9b,  Onshore CTD transect, start with a short onshore transit and then Cast 46-56
tstime(13) = datenum([2018 04 21 06 40 04]); % Transect 10,  Offshore CTD transect, Cast 56-68
tstime(14) = datenum([2018 04 21 19 26 24]); % Transect 11,   Onshore VPR transect (towed VPR-3)
tstime(15) = datenum([2018 04 21 23 00 00]); % Transect 12a, Southeastward underway chemistry transect
tstime(16) = datenum([2018 04 22 01 04 48]); % Transect 12b, Westward along-shelf underway chemistry transect
tstime(17) = datenum([2018 04 22 02 47 45]); % Transect 12c, Onshore underway chemistry transect
tstime(18) = datenum([2018 04 22 05 53 31]); % Transect 12d, Eastward along-shelf underway chemistry transect
tstime(19) = datenum([2018 04 22 07 56 31]); % Transect 12e, Westward along-shelf underway chemistry transect back to the central transect
tstime(20) = datenum([2018 04 22 09 16 04]); % Transect 13;   Offshore CTD transect, Cast 69-78, followed by a short offshore transit
tstime(21) = datenum([2018 04 22 18 59 40]); % Transect 14;   Onshore VPR transect (towed VPR-4)
tstime(22) = datenum([2018 04 22 23 33 21]); % Transect 15a, Offshore transect start with Cast 79 (station B1), then Cast 80-81
tstime(23) = datenum([2018 04 23 02 40 55]); % Transect 15b, Short southeastward transit, start with Cast 81
tstime(24) = datenum([2018 04 23 05 50 33]); % Transect 16a, Westward along-shelf transect
tstime(25) = datenum([2018 04 23 08 03 23]); % Transect 16b, Short eastward along-shelf transect to return to the central line
tstime(26) = datenum([2018 04 23 09 15 04]); % Transect 16c, Short onshore transect starting with Cast 82 (A16) and ending with Cast 83 (A13)
tstime(27) = datenum([2018 04 23 12 11 33]); % Transect 16d, Short offshore transect, Cast 83-86
tstime(28) = datenum([2018 04 23 14 16 33]); % Transect 16e, Onshore transect, start with a short onshore transit and then Cast 87-97
tstime(29) = datenum([2018 04 24 00 48 49]); % Transect 17,   Offshore EK80 transect
tstime(30) = datenum([2018 04 24 06 57 36]); % Transect 18a, Westward transit with Cast 98(AUV1) in the middle, end with Cast 99 (AL-CTD1)
tstime(31) = datenum([2018 04 24 13 48 45]); % Transect 18b, Northeastward transit, start with Cast 99 (AL-CTD1) and end with Cast 100 (AUV2)
tstime(32) = datenum([2018 04 24 16 30 13]); % Transect 18c, Southeastward transit, start with Cast 100-101 (AUV2) and end with Cast 102 (AL-CTD2)
tstime(33) = datenum([2018 04 24 21 52 57]); % Transect 18d, Southwestward transit, start with Cast 102 (AL-CTD2) and end with Cast 103 (A16)
tstime(34) = datenum([2018 04 25 01 28 04]); % Transect 19,   Onshore CTD transect, Cast 103-111
tstime(35) = datenum([2018 04 25 08 15 21]); % Transect 20,   Offshore mixed transect, start with a short offshore transit, then Cast 112-113 (A11), then towed VPR-5
tstime(36) = datenum([2018 04 25 15 35 04]); % Transect 21,   Onshore CTD transect, Cast 114-129
tstime(37) = datenum([2018 04 26 10 35 04]); % Transect 22,   Offshore transect with no VPR (due to fog) and with CTD Casts 130-132 in the end
tstime(38) = datenum([2018 04 26 19 08 04]); % Transect 23,   Onshore VPR transect (towed VPR-6)
tstime(39) = datenum([2018 04 27 00 15 04]); % Transect 24,   Offshore CTD transect, Cast 133-144
tstime(40) = datenum([2018 04 27 11 35 34]); % Transect 25,   Onshore CTD transect, CTD Cast 144-162 (A1)
tstime(41) = datenum([2018 04 28 07 48 00]); % Transect 26a, Short offshore transit, end with Cast 164 (A2)
tstime(42) = datenum([2018 04 28 10 30 15]); % Transect 26b, Eastward VPR transit toward Nantucket Shoal to hunt Phaeocystis (towed VPR-7)
tstime(43) = datenum([2018 04 28 15 09 36]); % Transect 26c, Short westward VPR return transit 
tstime(44) = datenum([2018 04 28 16 12 06]); % Transect 26d, Resumed westward VPR transit 
tstime(45) = datenum([2018 04 28 18 04 36]); % Transect 26e, Northward VPR transit 
tstime(46) = datenum([2018 04 28 18 57 06]); % Transect 26f,  Southward VPR transit including CTD Cast 165-166 (P1) and ending at Cast 167 (P2)
tstime(47) = datenum([2018 04 28 20 36 42]); % Transect 26g, Northwestward VPR transit 
tstime(48) = datenum([2018 04 28 21 45 26]); % Transect 26h, Southwestward VPR transit 
tstime(49) = datenum([2018 04 28 23 58 46]); % Transect 26i,  Short northeastward VPR transit ends with CTD Cast 168 (P4)
tstime(50) = datenum([2018 04 29 01 01 15]); % Transect 26j,  Short southwestward VPR return transit 
tstime(51) = datenum([2018 04 29 02 06 04]); % Transect 27,   Offshore CTD Transect, Cast 169 (A2) - Cast 175 (A8)
tstime(52) = datenum([2018 04 29 06 30 04]); % Transect 27,   Start the final transit back to Woods Hole
