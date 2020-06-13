plot_planview('AR29')
plot_planview('AR28A')
plot_planview('AR28B')

plot_timeseries('AR29')
plot_timeseries('AR28A')
plot_timeseries('AR28B')

function plot_planview(cruisestr_in)
    mypath = '\\sosiknas1\IFCB_products\SPIROPA\summary\';
    load(fullfile(mypath, ['phaeo_colony_' cruisestr_in]));
    figure, set(gcf, 'position', [290 75 450 320])
    scatter(meta_data.longitude, meta_data.latitude, 20, Phaeocystis_colony_CNN_predicted_concentration_per_ml, 'filled')
    title([cruisestr ' Phaeocystis colonies (ml^{-1})'])
    xlim([-72 -70])
    ylim([39.5 41.5])
    caxis([0 20])
    colorbar
end

function plot_timeseries(cruisestr_in)
    mypath = '\\sosiknas1\IFCB_products\SPIROPA\summary\';
    load(fullfile(mypath, ['phaeo_colony_' cruisestr_in]));
    figure, set(gcf, 'position', [290 75 800 320])
    plot(mdate, Phaeocystis_colony_CNN_predicted_concentration_per_ml, '.--')
    title(cruisestr)
    ylabel('Phaeocystis colonies (ml^{-1})')
    datetick
end