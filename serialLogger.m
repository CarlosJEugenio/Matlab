%Serial logger
clear all

serialPort = 'COM4';
plotTitle = 'Temperature log';
xLabel = 'Time (s)';
yLabel = 'Temperature (°C)';
plotGrid = 'on';
yMin = 0;
yMax = 100;

%variables
time = 0;
data = 0;
i = 0;

%create serial object on port serialPort
if(isempty(instrfindall('Name',['Serial-' serialPort])))
    s = serial(serialPort);
else
    s = instrfindall('Name',['Serial-' serialPort]);
end

%crete file to save data
c = clock;
fileID = fopen(['TempLog ' date '-' num2str(c(4)) ';' num2str(c(5),'%02i') '.txt'],'w');
fprintf(fileID,'%s\r\n', plotTitle);
fprintf(fileID,'%6s %12s\r\n', 'time (s)', 'Temperature (°C)');

%serial object settings
s.Terminator = 'CR';

%set up plot
plotGraph = plot(time, data,'XDataSource','time','YDataSource','data'); %plot handle
title(plotTitle);
xlabel(xLabel);
ylabel(yLabel);
xlim('auto');
ylim([yMin yMax]);
grid(plotGrid);

%open serial port
if(strcmp(s.Status,'closed'))
    fopen(s);
end

tic

while ishandle(plotGraph)
    
    dat = fscanf(s, '%f');
    if(~isempty(dat) && isfloat(dat))
        fprintf(fileID,'%6.2f %12.2f\r\n',toc, dat);
        i = i + 1;
        time(i) = toc;
        data(i) = dat;
        refreshdata(plotGraph, 'caller');
        drawnow;
        pause(0.01);
        
    end
end

if(strcmp(s.Status,'open'))
    fclose(s);
end



