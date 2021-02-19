clc; clear; close all;
addpath('lib')

% Setting up 
fprintf('Loading data...\n');
testData = load('dataset\All_Feature_Extraction_2_12345.mat');

% nnOptions = {};                              % using the default options
% a = arduino('COM8','Nano3','Libraries','Servo')
% s1 = servo(a, 'D6', 'MinPulseDuration', 5.44e-04, 'MaxPulseDuration', 2.4e-3);
% s2 = servo(a, 'D5', 'MinPulseDuration', 5.44e-04, 'MaxPulseDuration', 2.4e-3);
% writePosition(s1, 0.8);
% writePosition(s2, 0.2);

% nnOptions = {'lambda', 0,...             % Alternative options
%             'maxIter', 10000,...
%             'hiddenLayers', [50],...
%             'activationFn', 'sigm',...
%             'validPercent', 20,...
%             'doNormalize', 1};

% Learning
% modelNN = learnNN(testData.X, testData.y, nnOptions);
load('Result\TrainandTestNN_2_5Class_5.mat');

% plotting the confusion matrix for the validation set
figure(1);
subplot(1,2,1);
plotConfMat(modelNN.confusion_valid);

load('dataset\All_Feature_Extraction_2_Testing_12345.mat')

DT = 36;                                    % Each Data Train
m = 1;
n = 1;

HasilPlotTesting = zeros(5,5);
for rI = 1:180
    p = predictNN(X(rI,:), modelNN);        % the prediction
    p = p - 1;
    
    for a = 0:4
        if p == a
            predict = a;
        end
    end

    if rI <= 36
        real = 1;
    elseif rI <= 72
        real = 2;
    elseif rI <= 108
        real = 3;
    elseif rI <= 144
        real = 4;
    else
        real = 5;
    end
    
    testingalldata(rI, 1) = rI;             % data number
    testingalldata(rI, 2) = predict;        % data predict
    testingalldata(rI, 3) = real;           % data real
    
    if testingalldata(rI, 2) == testingalldata(rI, 3)
        testingalldata(rI, 4) = 1;
    else
        testingalldata(rI, 4) = 0;
    end

    for m = 0:5
        for n = 0:5
            if [predict, real] == [m, n]
                o = m + 1;
                p = n;
                HasilPlotTesting(o, p) = HasilPlotTesting(o, p) + 1;
            end
        end
    end
end

jumlah_data_salah = sum(testingalldata(:,4) == 0);
jumlah_data_benar = rI - jumlah_data_salah;
presentase_databenar = (jumlah_data_benar / rI) * 100;
subplot(1,2,2); plotConfMat(HasilPlotTesting);

while(1)
    rI = randi(size(X, 1));                 % a random index
    p = predictNN(X(rI,:), modelNN);        % the prediction
    
    opsi = menu('Coba lagi?(Y/N) ', 'Yes', 'No');
    if opsi == 1
        if p == 1
            fprintf('Data %d adalah tangan terbuka\n', rI)
            pause(1); 
%             writePosition(s1, 1); 
%             writePosition(s2, 0); 
            fprintf('Servo Atas 0 deg, ')
            fprintf('Servo Bawah 180 deg\n')
        elseif p == 2
            fprintf('Data %d adalah tangan menggenggam 2kg\n', rI)
            pause(1); 
%             writePosition(s1, 0.5); 
%             writePosition(s2, 0.5); 
            fprintf('Servo Atas 90 deg, ')
            fprintf('Servo Bawah 90 deg\n')
        elseif p == 3
            fprintf('Data %d adalah tangan menggenggam 3kg\n', rI)
            pause(1); 
%             writePosition(s1, 0.3); 
%             writePosition(s2, 0.7); 
            fprintf('Servo Atas 126 deg, ')
            fprintf('Servo Bawah 54 deg\n')
        elseif p == 4
            fprintf('Data %d adalah tangan menggenggam 4kg\n', rI)
            pause(1); 
%             writePosition(s1, 0.1); 
%             writePosition(s2, 0.9); 
            fprintf('Servo Atas 162 deg, ')
            fprintf('Servo Bawah 18 deg\n')
        elseif p == 5
            fprintf('Data %d adalah tangan menggenggam 5kg\n', rI)
            pause(1); 
%             writePosition(s1, 0); 
%             writePosition(s2, 1); 
            fprintf('Servo Atas 180 deg, ')
            fprintf('Servo Bawah 0 deg\n')
        end
        
        %data sebenarnya
        if rI <= DT
            fprintf('Data %d sebenarnya adalah tangan terbuka\n\n', rI)
        elseif rI <= 2 * DT
            fprintf('Data %d sebenarnya adalah tangan menggenggam 2kg\n\n', rI)
        elseif rI <= 3 * DT
            fprintf('Data %d sebenarnya adalah tangan menggenggam 3kg\n\n', rI)
        elseif rI <= 4 * DT
            fprintf('Data %d sebenarnya adalah tangan menggenggam 4kg\n\n', rI)
        else
            fprintf('Data %d sebenarnya adalah tangan menggenggam 5kg\n\n', rI)
        end 
        
        continue    
    else
        break
    end
end