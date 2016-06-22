x = 0:.1:1;
A = [x; exp(x)];
c = clock;
c(5) = 30;
fileID = fopen(['TempLog ' date '-' num2str(c(4)) ';' num2str(c(5),'%02i') '.txt'],'w');
fprintf(fileID,'%6s %12s\n','x','exp(x)');
fprintf(fileID,'%6.2f %12.2f\n',A);
fclose(fileID);