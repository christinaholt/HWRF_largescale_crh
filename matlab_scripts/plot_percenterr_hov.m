clear
close all



stat='RMSE'
%stat='ME'


% Read in Experiment File
fid = fopen(['singles_stats.txt']);
fmtstring = ['%s %u %s %s %u ' repmat('%f ',1,6)];
contents = textscan(fid, fmtstring);
data = cell2mat(contents(:,6:end)); 
fhrs=zeros(size(data,1)+1,1);
fhrs=cell2mat(contents(:,5));
LEV=cell2mat(contents(:,2));

clear fmtstring 

% Read in Diff File
fid = fopen(['allDiffs_' stat '.txt']);
fmtstring = ['%s %u %u ' repmat('%f ',1,6)];
Dcontents = textscan(fid, fmtstring);
Ddata = cell2mat(Dcontents(:,4:end));
Dfhrs=zeros(size(data,1)+1,1);
Dfhrs=cell2mat(Dcontents(:,3));
DLEV=cell2mat(Dcontents(:,2));


stdlevs= [1000 850 700 500 250 0];


pvars = {'HGT' 'TMP' 'RH'};
unitlabs = {'Height (gpm)' 'Temp (K)' 'Speed (m/s)' 'RH (kg/kg)'};

%1. VAR
%2. LEV
%3. FHR
%4. Whole AVE
%5. Whole Std. Dev.
%6. EP ave
%7. EP SD
%8. ATL ave
%9. ATL SD
c=1
expt='HDGF'
for p=1:length(pvars) %Loop through variables

% X is fhr
% Y is height

fhr=[0 24 48 72 96 120 144];
for j=1:3 % basin
figure(c)
set(figure(c),'Units','inches','Position',[1 8 8.5 11],'PaperPosition',[0 0 11 8.5],'PaperSize',[11 8.5])

area=[3 1 5];
basin={'EP' 'MEGA' 'ATL'};

HGTLEVS=zeros(6,7)
DHGTLEVS=zeros(6,7)

for i=1:length(fhr)-1
HGTLEVS(1:5,i)=data((fhrs==fhr(i) & strcmp(contents{:,1},pvars{p}) & ...
               strcmp(contents{:,3},expt) & strcmp(contents{:,4},stat)) ,area(j))

DHGTLEVS(1:5,i)=Ddata((Dfhrs==fhr(i) & strcmp(Dcontents{:,1},pvars{p})),area(j))


end
PERR=DHGTLEVS./HGTLEVS
PERR(isnan(PERR))=0;
h = surf(fhr,flipdim(stdlevs,2),PERR*100)


view([0 90])
box on
cm=	[-15,15; 
	 -15,15; 
	 -15,15];
colormap(darkb2r(cm(p,1),cm(p,2)))
colorbar
shading flat

set(gca, 'LineWidth', 2)
set(gca, 'FontSize', 20)
set(gca, 'XTick',1:24:144)
set(gca, 'XLim', [1 144])
set(gca, 'XTickLabel',fhr)
set(gca, 'YDir','reverse')
set(gca, 'YTick',flipdim(stdlevs(1:6),2))
set(gca, 'YLim', [0 1000])
set(gca, 'YTickLabel',flipdim(stdlevs(1:6),2))
xlabel('Forecast Hour')
ylabel('Pressure Level (hPa)')
title(['Percent Error for ',pvars{p},' in ',basin{j}])

fn=['PE_hov_' pvars{p} '_' basin{j} '.pdf']
print(figure(c),'-dpdf',fn)
c=c+1
clear HGTLEVS
end
%legend ('MEGA', 'EP', 'ATL','Location','eastoutside')
%ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 ...
%1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%
%text(0.5, 1,{'\bf HDGF-HDRF Bias for' pvars{j}},'HorizontalAlignment' ...
%,'center','VerticalAlignment', 'top')

end
