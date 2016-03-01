






fid = fopen('allDiffs.txt');

fmtstring = ['%s %u %u ' repmat('%f ',1,6)];

contents = textscan(fid, fmtstring);


data = cell2mat(contents(:,4:end)); 

fhrs=cell2mat(contents(:,3));
LEV=cell2mat(contents(:,2));

stdlevs= [1000 850 700 500 250];
colormap(colorcube)
cmap = colormap;
orange=cmap(8,:);
purple=cmap(34,:);
blue=cmap(30,:);


pvars = {'HGT' 'TMP' 'WIND' 'RH'};
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

for j=1:length(pvars)
figure(j)
set(figure(j),'Units','inches','Position',[6 6 8.5 11],'PaperPosition',[0 0 11 8.5],'PaperSize',[11 8.5])
i=1
for fhr=0:24:120

subplot(1,6,i)

HGTLEVS=data(fhrs(strcmp(contents{:,1},pvars(j)))==fhr,1:end);

h = barh(flipdim(HGTLEVS(:,[1 3 5]),1))

set(h(1), 'FaceColor',blue)
set(h(2), 'FaceColor',orange)
set(h(3), 'FaceColor',purple)

set(gca, 'YLim', [0.5 5.5])
set(gca, 'YTickLabel',stdlevs)
xlabel(unitlabs(j))
title({fhr ' Hrs'})

i=i+1
clear HGTLEVS
end
legend ('MEGA', 'EP', 'ATL','Location','eastoutside')
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 ...
1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.5, 1,{'\bf HDGF-HDRF Bias ' pvars{j}},'HorizontalAlignment' ...
,'center','VerticalAlignment', 'top')

fn=['BiasDiff_barh_' pvars{j} '.pdf']
print(figure(j),'-dpdf',fn)
end

