%% Pseudo-real-time EMG data extraction from Myo to MATLAB
% Extracts EMG data from a MYO to MATLAB via C++
% Requires MYO Connect to be running
% Runs a C++ executable in a command prompt

clear; clc; close all % House keep
addpath('lib');
% a = arduino('COM8','Nano3','Libraries','Servo')
% s1 = servo(a, 'D6', 'MinPulseDuration', 5.4400e-04, 'MaxPulseDuration', 2.4e-3);
% s2 = servo(a, 'D5', 'MinPulseDuration', 5.4400e-04, 'MaxPulseDuration', 2.4e-3);
% writePosition(s1, 0.8);
% writePosition(s2, 0.2);

%% Genmeral Setup
lineLength = 54;
numChannels = 8;
sampMax = 1000;
windowLength = 100;
curPosition = 0;

fprintf('Loading data...\n');
testData = load('dataset/All_Feature_Extraction_3_2Class.mat');  % hold and release

nnOptions = {};                             % using the default options

nnOptions = {'lambda', 0,...            % Alternative options
            'maxIter', 10000,...
            'hiddenLayers', [50],...
            'activationFn', 'sigm',...
            'validPercent', 20,...
            'doNormalize', 1};

%% Learning
modelNN = learnNN(testData.X, testData.y, nnOptions); 

%%
emgData = NaN([sampMax numChannels]); % Matrix for EMG data
mavData = NaN([(sampMax - windowLength) numChannels]); % Matrix for MAV feature

fileNameEMG = 'emg.txt'; % File for data transmission; again stop judging ^^
cmdWindowName = 'EMG Gather';

FileEMG = fopen(fileNameEMG,'w'); % Reset file
fclose(FileEMG); 

system(['start /realtime "' cmdWindowName '" getMyoEmg.exe & exit &']) % Start (non-blocking) C thread
figure(1) % Do after cmd call to bring to foreground
set(gcf,'currentchar',']') % Used for exit on button press

%% Pause for handshake with myo connect and for data collection to begin
pause(1);

%% Pseudo-realtime extraction
% Get first timestamp from file (and check data gathering is working)
FileEMG = fopen(fileNameEMG,'r'); 
fseek(FileEMG, curPosition, -1); 
fileDataRaw = fgetl(FileEMG);
if fileDataRaw == -1 
    system(['taskkill /f /fi "WindowTitle eq' cmdWindowName '" /T & exit']) 
    close(gcf)
    disp('Data acquisition not active')
    return;
end
fileDataStrArray = strsplit(fileDataRaw, ',');
startTime = str2double(fileDataStrArray(end));
fclose(FileEMG);

curSample = 1;
lastSample = 1;
while get(gcf,'currentchar')==']' % While no button has been pressed
    FileEMG = fopen(fileNameEMG, 'r'); 
    fseek(FileEMG, curPosition, -1); 

    fileDataRaw = ' ';
    while ischar(fileDataRaw) % Extract new data from file
        fileDataRaw = fgetl(FileEMG);
        if numel(fileDataRaw) ~= lineLength % Break if last line incomplete (and seek back to start of that line
            fseek(FileEMG, -numel(fileDataRaw), 0);
            break;
        end
        
        fileDataStrArray = strsplit(fileDataRaw,',');
        curTime = str2double(fileDataStrArray(end));
        emgData(curSample,:) = str2double(fileDataStrArray(1:numChannels));
        
        if curSample >= windowLength % MAV feature extraction
            mavData(curSample - windowLength + 1,:) = mean(abs(emgData(curSample - windowLength + 1:curSample,:)));
        end
        
        curSample = curSample + 1;
    end
    curPosition = ftell(FileEMG);
    fclose(FileEMG); 
    
    if curSample - lastSample == 0 % Don't waste time drawing if no new data
        continue;
    else
        lastSample = curSample;  
    end
    
   
    %% Plots
    
    figure(1)
    subplot(2,1,2)
    plotConfMat(modelNN.confusion_valid)
    
    subplot(2,1,1)
    plot(emgData)
    ylim([-128 127])
    xlim([1 sampMax])
    title(['Sample frequency: ' num2str(curSample/(curTime - startTime))])
    xlabel('Samples')
    ylabel('Amplitude')
    
    drawnow
    
    %% feature extraction rms kurtosis skewness...
    EMG_featured = [rms(emgData) kurtosis(emgData) skewness(emgData)...
        mean(periodogram(emgData)) mean(abs(emgData))...
        (1/1000)*(mean(abs(emgData))) mean((abs(emgData)).^2)...
        (1/(1000-1))*(mean((emgData).^2))];
    
    % classification predicting on a EMG featured data
    p = predictNN(EMG_featured, modelNN); % the prediction
    p = p - 1;
    
    if curSample > sampMax % Clear arrays when large
        fprintf('Predicted: %d ', mod(p, 3));    
        curSample = 1;
        lastSample = 1;
        emgData = NaN([sampMax numChannels]);
        mavData = NaN([(sampMax - windowLength) numChannels]);
        startTime = curTime;
        switch p
            case 0
                fprintf('adalah tangan Terbuka\n')
            case 1
                fprintf('adalah tangan Menggenggam\n')
        end
    end
    
end

%% CLean up - target specific window made for this script
system(['taskkill /f /fi "WindowTitle eq  ' cmdWindowName '" /T & exit']) 
close(gcf)

