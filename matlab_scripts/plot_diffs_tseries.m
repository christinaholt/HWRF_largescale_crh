clear
close all






fid = fopen('allDiffs.txt');

fmtstring = ['%s %u %u ' repmat('%f ',1,6)];

contents = textscan(fid, fmtstring);


data = cell2mat(contents(:,4:end)); 

fhrs=cell2mat(contents(:,3));
LEV=cell2mat(contents(:,2));

stdlevs= [1000 850 700 500 250];
colormap(colorcube)
cmap = colormap;

% Green spectrum is 57 45-49
%orange=cmap(8,:);
%purple=cmap(34,:);
%blue=cmap(30,:);

shade = [57 45 46 47 48 49];
pvars = {'HGT' 'TMP' 'RH' 'WIND'};
unitlabs = {'Height (gpm)' 'Temp (K)' 'RH (kg/kg)' 'Speed (m/s)'};
fhrs= [0 24 48 72 96 120];
%1. VAR
%2. LEV
%3. FHR
%4. Whole AVE
%5. Whole Std. Dev.
%6. EP ave
%7. EP SD
%8. ATL ave
%9. ATL SD


j=1
figure(1)
set(figure(1),'Units','inches','Position',[6 6 8.5 11],'PaperPosition',[0 0 8.5 11],'PaperSize',[8.5 11])
for j=1:length(pvars)-1
subplot(3,1,j)
for i=1:length(stdlevs)
HGTLEVS(:,:,i)=data((LEV==stdlevs(i) & strcmp(contents{:,1},pvars{j})),[1 3 5]);
end




%h2 = plot(squeeze(HGTLEVS(:,2,:)))
%grid on
%hold on
%for p=1:length(h2)
%set(h2(p), 'color',cmap(shade(p),:),'LineWidth',2,'LineStyle','--')
%end
%
%h3 = plot(squeeze(HGTLEVS(:,3,:)))
%for p=1:length(h3)
%set(h3(p), 'color',cmap(shade(p),:),'LineWidth',2,'LineStyle','-')
%end

h = plot(squeeze(HGTLEVS(:,1,:)))
grid on
for p=1:length(h)
set(h(p), 'color',cmap(shade(p),:),'LineWidth',5)
end

set(gca, 'XTick', 1:1:6)
set(gca, 'XLim', [1 6])
set(gca, 'XTickLabel',fhrs)
xlabel(unitlabs(j))
title(pvars(j))

if j==1; legend(h(:),'1000', '850', '700', '500', '250','Location','northwest'); end
clear HGTLEVS
end
stdlevs_str=['1000', '850', '700', '500', '250'];
%ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 ...
%1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

%text(0.5, 1,{'\bf HDGF-HDRF Bias ' pvars{j}},'HorizontalAlignment' ...
%,'center','VerticalAlignment', 'top')

fn=['BiasDiff_tser_justmega.pdf']
print(figure(1),'-dpdf',fn)
%j=j+1



