%% Kalau & Emma

% Instructions: Follow through this code step by step, while also referring
% to the overall instructions and questions from the lab assignment sheet.

%% 1. Read in the monthly gridded CO2 data from the .csv file
% The data file is included in your repository as �LDEO_GriddedCO2_month_flux_2006c.csv�
% Your task is to write code to read this in to MATLAB
% Hint: you can again use the function �readtable�, and use your first data lab code as an example.
filename = 'LDEO_GriddedCO2_month_flux_2006c.csv'; 
CO2data = readtable(filename);

%% 2a. Create new 3-dimensional arrays to hold reshaped data
%Find each unique longitude, latitude, and month value that will define
%your 3-dimensional grid
longrid = unique(CO2data.LON); %finds all unique longitude values
latgrid = unique(CO2data.LAT); %<-- following the same approach, find all unique latitude values
monthgrid = unique(CO2data.MONTH); %<-- following the same approach, find all unique months

%Create empty 3-dimensional arrays of NaN values to hold your reshaped data
 %You can make these for any variables you want to extract - for this
    %lab you will need PCO2_SW (seawater pCO2) and SST (sea surface
    %temperature)
CO2_SWgrid = NaN*zeros(length(longrid), length(latgrid), length(monthgrid));    
SSTgrid = NaN*zeros(length(longrid), length(latgrid), length(monthgrid)); 

%% 2b. Pull out the seawater pCO2 (PCO2_SW) and sea surface temperature (SST)
%data and reshape it into your new 3-dimensional arrays
 for i = 1:21084
     indLON = find(CO2data.LON(i) == longrid);
     indLAT = find(CO2data.LAT(i) == latgrid);
     indM = find(CO2data.MONTH(i) == monthgrid);
     CO2_SWgrid(indLON, indLAT, indM) = CO2data.PCO2_SW(i);
     SSTgrid(indLON, indLAT, indM) = CO2data.SST(i);
 end

%% 3a. Make a quick plot to check that your reshaped data looks reasonable
%Use the imagesc plotting function, which will show a different color for
%each grid cell in your map. Since you can't plot all months at once, you
%will have to pick one at a time to check - i.e. this example is just for
%January

imagesc(SSTgrid(:,:,9))
imagesc(CO2_SWgrid(:,:,9))
%% 3b. Now pretty global maps of one month of each of SST and pCO2 data.
%I have provided example code for plotting January sea surface temperature
%(though you may need to make modifications based on differences in how you
%set up or named your variables above).

figure(1); clf
subplot(2,1,1);
worldmap world
contourfm(latgrid, longrid, SSTgrid(:,:,1)','linecolor','none');
colorbar
geoshow('landareas.shp','FaceColor','black')
title('January Sea Surface Temperature (^oC)')

%Check that you can make a similar type of global map for another month
%and/or for pCO2 using this approach. Check the documentation and see
%whether you can modify features of this map such as the contouring
%interval, color of the contour lines, labels, etc.

subplot(2,1,2)
worldmap world
contourfm(latgrid, longrid, CO2_SWgrid(:,:,1)','linecolor','none');
colorbar
geoshow('landareas.shp','FaceColor','black')
title('January pCO_2 ')


%% 4. Calculate and plot a global map of annual mean pCO2
Annmean = mean(CO2_SWgrid,3);
figure(2); clf;
worldmap world
contourfm(latgrid, longrid, Annmean','linecolor','none');
colorbar
geoshow('landareas.shp','FaceColor','black')
title('Annual Mean')

%% 5. Calculate and plot a global map of the difference between the annual mean seawater and atmosphere pCO2
% diffmeanCO2 = Annmean-'atm pCO2 that we find' ;
% figure(3); clf;
% worldmap world
% contourfm(latgrid, longrid, diffmeanCO2','linecolor','none');
% colormap(cmocean('balance')); caxis([###]); colorbar
% geoshow('landareas.shp','FaceColor','black')
% title('Difference between annual mean SW and pCO2atm')



%% 6. Calculate relative roles of temperature and of biology/physics in controlling seasonal cycle
pCO2_T = repmat(CO2_SWgrid, 1);
pCO2_BP = repmat(CO2_SWgrid, 1);
pCO2_BP =(CO2_SWgrid).^(0.0423*(mean(CO2data.SST)-SSTgrid));
pCO2_T = (Annmean).^(0.0423*(SSTgrid-mean(CO2data.SST)));

%% 7. Pull out and plot the seasonal cycle data from stations of interest
%Do for BATS, Station P, and Ross Sea (note that Ross Sea is along a
%section of 14 degrees longitude - I picked the middle point)
vars = {SSTgrid CO2_SWgrid pCO2_T pCO2_BP};
for i=1:12
    for x = 1:4
    BATS(i,x) = vars{x}(60,28,i);
    StP(i,x) = vars{x}(44,32,i);
    ROSS(i,x) = vars{x}(35,1,i);
    end
end

%% Figures
figure(4)
subplot(2,1,1)
plot(monthgrid, BATS(:,1));
subplot(2,1,2)
plot(monthgrid, BATS(:,2:4));

%<--

%% 8. Reproduce your own versions of the maps in figures 7-9 in Takahashi et al. 2002
% But please use better colormaps!!!
% Mark on thesese maps the locations of the three stations for which you plotted the
% seasonal cycle above

%<--
