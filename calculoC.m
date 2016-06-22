%%calculo de Capacitancia
clear all
close all

%open sample dir
path = uigetdir('D:\Documents\My Gamry Data','Open sample folder');
splitPath = strsplit(path,'\');
samplename = splitPath(end);
%files in dir
D = dir(path);

%masa de electrodos combinados (active material mass)
input = inputdlg('Ingrese masa combinada de los electrodos [mg]','Masa'); %miligramos
m = str2double(input{1}) / 1000; %mg to g
%%
%which curve to use
curve = 'curve3';

for i = 3:length(D)  % empieza en 3 porque 1 y 2 son . y .. respectivamente
    A = dtaImport(fullfile(path, D(i).name));
    data = retriveData(A,'Vf','Im');
    settings = retriveSettings(A,'SCANRATE','VLIMIT1','VLIMIT2');
    
    I = trapz(data.Vf.(curve),data.Im.(curve));
    C = I / (2 * abs(settings.VLIMIT1 - settings.VLIMIT2) * m * ...
        settings.SCANRATE / 1000); %scanrate is in mv, has to be in V
    DATA.(['sample' num2str(i-2)]).data = data;
    DATA.(['sample' num2str(i-2)]).settings = settings;
    DATA.(['sample' num2str(i-2)]).data.CAPACITANCE = C;
end

%%
%plots

figure
hold on
fnames = fieldnames(DATA);  %sample names
cc = hsv(length(fnames));   %color scheme
c = {};
capSr = [];

for i=1:length(fnames)
    plot(DATA.(fnames{i}).data.Vf.(curve),...
         DATA.(fnames{i}).data.Im.(curve),'color',cc(i,:))
     
    c = cat(1,c,[num2str(round(DATA.(fnames{i}).settings.SCANRATE)) ' mV/s']);
    capSr = cat(1,capSr,[DATA.(fnames{i}).settings.SCANRATE ...
                         DATA.(fnames{i}).data.CAPACITANCE]);
end
title(strrep(samplename, '_', '\_'))
legend(c,'Location','NorthWest')
xlabel('Voltage [V]')
ylabel('Current [A]')

figure
plot(capSr(:,1),capSr(:,2),'*')
title(samplename)
xlabel('Scan Rate [mV/s]')
ylabel('Specific capacitance [F/g]')
