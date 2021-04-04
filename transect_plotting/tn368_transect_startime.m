% TN368 transect start time
% Note the sub-transects are commented out here for my own code
% Weifeng Gordon Zhang

tstime(1) = datenum([2019 07 05 22 10 00]);  % Transect 1 (southward) starts with the underway science seawater diaphragm turned on, then CTD stations from A5 to A18
tstime(2) = datenum([2019 07 06 18 36 00]);  % Transect 2 (northward) starts at A18 with REMUS launch (Mission 1), VPR Tow-1, and then transit to A5
tstime(3) = datenum([2019 07 07 02 00 00]);  % Transect 3 (southward) starts with CTD cast 017 at A5 and finishes with CTD cast 029 at A17
tstime(4) = datenum([2019 07 07 15 01 01]);  % Transect 4 (northward) starts with transit to A12 to pick up REMUS, Cast 030, then MOC2, and then cast 031 at A12 (Z-grazing)
tstime(5) = datenum([2019 07 07 20 53 00]);  % Transect 5 (southward) VPR tow-2 leg-1
tstime(6) = datenum([2019 07 07 23 00 01]);  % Transect 6 (southeastward) VPR tow-2 leg-2
tstime(7) = datenum([2019 07 08 02 50 06]);  % Transect 7 (westward) VPR tow-2 leg-3 crossing the shelf water streamer
tstime(8) = datenum([2019 07 08 08 55 00]);  % Transect 8 (eastward) starts with eastward transit to S1, CTD Cast 32 and ends with CTD cast 40 at S8
tstime(9) = datenum([2019 07 09 01 40 00]);  % Transect 9 (southwestward) transit to pick up REMUS after Mission 2
tstime(10) = datenum([2019 07 09 02 40 00]);  % Transect 10 (northwestward) transit to A5 
tstime(11) = datenum([2019 07 09 09 45 00]);  % Transect 11 (southward) starts with CTD cast 41 at A5,... CTD cast 52 at A14 and then VPR Tow-3 Leg-1
tstime(12) = datenum([2019 07 09 23 12 00]);  % Transect 12 (eastward) VPR Tow-3 Leg 2
tstime(13) = datenum([2019 07 10 01 47 00]);  % Transect 13 (southward) VPR Tow-3 Leg 3
tstime(14) = datenum([2019 07 10 02 25 00]);  % Transect 14 (westward) VPR Tow-3 Leg 4
tstime(15) = datenum([2019 07 10 04 10 00]);  % Transect 15 (northwestward) transit to OOI REMUS intercalibration station AC2
tstime(16) = datenum([2019 07 10 09 00 00]);  % Transect 16 (southeastward) starts with CTD Casts 53 and 54 at AC2 and transit to AL2
tstime(17) = datenum([2019 07 10 16 02 00]);  % Transect 17 (eastward) starts with CTD Cast 56 at SSF2
tstime(18) = datenum([2019 07 10 18 45 00]);  % Transect 18 (westward) starts with CTD Cast 58 at SSF1, Cast 59 at SSF3, Cast 60 at SSF4 
tstime(19) = datenum([2019 07 10 23 15 00]);  % Transect 19 (eastward) starts with CTD Cast 61 at SSF5 and ends with CTD Cast 62 at SSF6 over the diatom patch
tstime(20) = datenum([2019 07 11 01 10 00]);  % Transect 20 (westward) VPR Tow-4 Leg-1 and Leg-2
tstime(21) = datenum([2019 07 11 02 08 00]);  % Transect 21 (eastward) VPR Tow-4 Leg-2, Leg 3, half Leg-4
tstime(22) = datenum([2019 07 11 03 20 00]);  % Transect 22 (westward) VPR Tow-4 half Leg-4, Leg 5, half Leg-6
tstime(23) = datenum([2019 07 11 04 42 00]);  % Transect 23 (eastward) VPR Tow-4 half Leg-6, Leg 7
tstime(24) = datenum([2019 07 11 06 30 00]);  % Transect 24 (northwestward) Transit to AL3 (CTD cast 63) and then AC2 (CTD cast 64)
tstime(25) = datenum([2019 07 11 14 25 00]);  % Transect 25 (southward) transit to A18 for REMUS deployment
tstime(26) = datenum([2019 07 11 18 21 00]);  % Transect 26 (northward) starts with CTD Cast 65 at A18 and ends with Cast 80 at A5
tstime(27) = datenum([2019 07 12 14 10 00]);  % Transect 27 (southward) transit to A13 to launch REMUS
tstime(28) = datenum([2019 07 12 18 40 00]);  % Transect 28 (eastward) VPR Tow-5 in zig-zag pattern along the northern edge of the ring limb
tstime(29) = datenum([2019 07 13 01 35 00]);  % Transect 29 (westward) transit to pick up aborted REMUS and then westward underway EIMS_W2 survey
tstime(30) = datenum([2019 07 13 06 39 00]);  % Transect 30 (southward) EMIS_W3 survey
tstime(31) = datenum([2019 07 13 07 24 00]);  % Transect 31 (eastward) EMIS_E3 survey
tstime(32) = datenum([2019 07 13 09 01 00]);  % Transect 32 (northeastward) Transit to HS1 and then CTD cast 82
tstime(33) = datenum([2019 07 13 10 45 00]);  % Transect 33 (northwestward) transit to pickup REMUS
tstime(34) = datenum([2019 07 13 13 56 00]);  % Transect 34 (Southward) starts with CTD cast 83 at A12 and then casts 84 and 85 at A13 (CP1)
tstime(35) = datenum([2019 07 13 18 20 00]);  % Transect 35 (Southwestward) VPR Tow-6 Leg-1
tstime(36) = datenum([2019 07 13 22 18 00]);  % Transect 36 (Eastward) VPR Tow-6 Leg-2 
tstime(37) = datenum([2019 07 14 02 10 00]);  % Transect 37 (northward) start with VPR Tow-6 Leg-3, then CTD Cast 86 at A17 to Cast 99 at A6, BBQ and then REMUS recovery
tstime(38) = datenum([2019 07 14 22 30 00]);  % Transect 38 (northwestward) EIMS survey to EIMS_W1
tstime(39) = datenum([2019 07 14 23 21 00]);  % Transect 39 (eastward) EIMS survey to EIMS_E1
tstime(40) = datenum([2019 07 15 00 48 00]);  % Transect 40 (southeastward) EIMS survey to EIMS_E4 and VPR Tow-7 Leg-1
tstime(41) = datenum([2019 07 15 05 13 00]);  % Transect 41 (southward) VPR Tow-7 Leg-2 deep into the slope sea
tstime(42) = datenum([2019 07 15 10 45 00]);  % Transect 42 (northwestward) return to the slope sea diatom hotspot and then VPR Tow-8 back to A13
tstime(43) = datenum([2019 07 15 24 15 00]);  % Transect 43 (southward) starts with transit from A13 to A18
tstime(44) = datenum([2019 07 16 00 37 00]);  % Transect 44 (northward) starts with Cast 103 at A18
tstime(45) = datenum([2019 07 16 13 50 00]);  % Transect 45 (southeastward) to pick up REMUS
tstime(46) = datenum([2019 07 16 15 41 00]);  % Transect 46 (westward) to transit to A13 for Cast 114
tstime(47) = datenum([2019 07 16 16 35 00]);  % Transect 47 (eastward) along-front short transect
tstime(48) = datenum([2019 07 16 21 45 00]);  % Transect 48 (northwestward) VPR Tow-9 from ALF3 to A5
tstime(49) = datenum([2019 07 17 01 17 00]);  % Transect 49 (southward) starts with CTD Cast 119 at A5 and ends with REMUS KHBillow deployment at A9
tstime(50) = datenum([2019 07 17 05 33 00]);  % Transect 50 (northward) transit to A5 for grazing experiment
tstime(51) = datenum([2019 07 17 08 11 00]);  % Transect 51 (southward) transit to A16 for the final transect
tstime(52) = datenum([2019 07 17 12 35 00]);  % Transect 52 (northward) starts with CTD cast 125 at A16
tstime(53) = datenum([2019 07 17 22 10 00]);  % Transect 53 (southward) transit back to A11 after REMUS search and recovery
tstime(54) = datenum([2019 07 17 23 38 00]);  % Transect 54 (northward) starts with Cast 130 at A11
tstime(55) = datenum([2019 07 18 13 27 00]);  % Transect 54 (pump off) end of cruise


% temporary place holder (the estimated start of the future transects, needed for my plotting package




