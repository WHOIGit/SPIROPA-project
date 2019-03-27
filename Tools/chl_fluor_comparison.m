% script chl_fluor_comparison
% SPIROPA-project
% Heidi M. Sosik, Woods Hole Oceanographic Institution, March 2019
%
%chl_fluor_comparison - script for AR29 to evaluate relationships between
%extracted values of chl concentration and estimates from the fluorometer
%on the CTD-rosette
%Proposes a vicarious "calibration" function to adjust fluorometer values
%

load \\sosiknas1\Lab_data\SPIROPA\ar29_bottle_data_Jan_2019_v2_table.mat  %file as saved from btlmat2table.m

a = BTL.Par;
%bubsizes = [min(a) quantile(a,[0.25, 0.5, 0.75]) max(a)];
bubsizes = [1 5 10 50 100 500 1000];
legentry=cell(size(bubsizes));
figure,%subplot(2,2,1), 
hold on
for ind = 1:numel(bubsizes)
   bubleg(ind) = plot(-1,-1,'.b','markersize',sqrt(bubsizes(ind)));
  % set(bubleg(ind),'visible','off')
   legentry{ind} = num2str(bubsizes(ind));
end

X = nanmean([BTL.Chla_0_mugLsup_neg_sup1 BTL.Chlb_0_mugLsup_neg_sup1],2);
Y =  BTL.UpolyFluor_mugLsup_neg_sup1;
h = scatter(X, Y, a, '.b');
l = legend(legentry, 'location' ,'southeast')
%delete(bubleg)
title(l, 'PAR')
axis([0 15 0 15])
axis square
line(xlim, xlim)
ylabel('Fluorometer chl (\mug l^{-1})')
xlabel('Extracted chl (\mug l^{-1})')

%subplot(2,2,2)
figure
tt = find(BTL.Par < 200 & ~isnan(X) & ~isnan(Y));
tt2 = find(BTL.Par >= 200 & ~isnan(X) & ~isnan(Y));
%scatter(X(tt), Y(tt), a(tt), '.b');
plot(X(tt), Y(tt), '.b');
axis([0 15 0 15])
axis square
line(xlim, xlim)
ylabel('Fluorometer chl (\mug l^{-1})')
xlabel('Extracted chl (\mug l^{-1})')
title('PAR < 200')

%subplot(2,2,3)
figure
%plot(X,Y, '.k'), hold on
[fitmodel, gof, fitoutput] = fit(X(tt), Y(tt), 'poly2');
ph = plot(fitmodel,X(tt),Y(tt),'predfunc')
axis([0 15 0 15])
axis square
ylabel('Fluorometer chl (\mug l^{-1})')
xlabel('Extracted chl (\mug l^{-1})')
title('PAR < 200')


%subplot(2,2,4)
figure
plot(fitmodel,X(tt),Y(tt), 'residuals')
ylabel('Residual fluor chl (\mug l^{-1})')
%xlabel('Extracted chl (\mug l^{-1})')

figure
subplot(2,1,1)
plot(BTL.Par(tt), fitoutput.residuals, '.')
line(xlim, [0 0],'color', 'r')
xlabel('PAR')
ylabel('Residual fluor chl (\mug l^{-1})')
title('PAR < 200 (fit to same data)')
ylim([-2 2])
subplot(2,1,2)
Yest = feval(fitmodel,X(tt2));
plot(BTL.Par(tt2), Y(tt2)-Yest, '.')
line(xlim, [0 0 ],'color', 'r')
xlabel('PAR')
ylabel('Residual fluor chl (\mug l^{-1})')
title('PAR > 200 (fit to PAR < 200)')
ylim([-2 2])

figure
hist(BTL.Depth_m(tt2))
ylabel('Frequency')
xlabel('Chl sample depth (m)')
title('PAR > 200')
