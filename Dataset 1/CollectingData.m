% clc
% clear

% load dataset_1.mat                            %load before record

countMyos = 1;
pause(1)
mm = MyoMex(countMyos);
m1 = mm.myoData(1);

T = 5.1;                                        %seconds, time record
fprintf('Logged data for %.1f seconds,\n\t',T); 

m1.isStreaming();                               %start recording
pause(T);                                       %time record
m1.stopStreaming()                              %stop recording

fprintf('emg samples: %5d\t\n', length(m1.emg_log))
fprintf('time emg samples: %5d\t\n\n', length(m1.timeEMG_log));

     emg_1 = m1.emg_log;                        %save record in variable
time_emg_1 = m1.timeEMG_log;                    %save time every point in variable

figure(1)
plot(m1.timeEMG_log, m1.emg_log)

% save dataset_1.mat                            %save every data update

pause(1)                                        %delete after record
mm.delete
clear mm