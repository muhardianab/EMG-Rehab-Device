clc; clear; close all;
addpath('lib')

% Setting up 
fprintf('Loading data...\n');
testData = load('dataset\All_Feature_Extraction_3_2Class.mat');

nnOptions = {};                              % using the default options
% a = arduino('COM8','Nano3','Libraries','Servo')
% s1 = servo(a, 'D6', 'MinPulseDuration', 5.4400e-04, 'MaxPulseDuration', 2.4e-3);
% s2 = servo(a, 'D5', 'MinPulseDuration', 5.4400e-04, 'MaxPulseDuration', 2.4e-3);
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
load('Result\HasilNN_2Class_2.mat')

% plotting the confusion matrix for the validation set
figure(1);
subplot(1,2,1);
plotConfMat(modelNN.confusion_valid);

load('Result\TrainRegLearner_4Reg_2345.mat')
load('dataset\All_Feature_Extraction_3_Testing_2Class.mat')

DT = 36;                                    % each data train

while(1)
    rI = randi(size(X, 1));                 % a random index
    p = predictNN(X(rI,:), modelNN);        % the prediction
    yfit = trainedModelLinear.predictFcn(X);
    suduts1 = ((yfit(rI) / 5) * 90) + 90;
    suduts2 = -((yfit(rI) / 5) * 90) + 90;
    sudutservo1 = suduts1 / 180; % fprintf('%.2f\n', sudutservo1)
    sudutservo2 = suduts2 / 180; % fprintf('%.2f\n', sudutservo2)
    
    opsi = menu('Coba lagi?(Y/N) ', 'Yes', 'No');

    if opsi == 1
        switch p
            case 1
                fprintf('Data %d adalah tangan terbuka\n', rI)
                pause(1); 
%                 writePosition(s1, 1); 
%                 writePosition(s2, 0); 
                fprintf('Servo Atas 0 deg, ')
                fprintf('Servo Bawah 180 deg\n')

            case 2
                if suduts1 > 180
                    pause(1); 
%                     writePosition(s1, 1);
%                     writePosition(s2, 0);
                    fprintf('Data %d adalah tangan menggenggam %.2f kg\n', rI, yfit(rI))
                    fprintf('Servo Atas 180 deg, ')
                    fprintf('Servo Bawah 0 deg\n')
                else
                    pause(1);
%                     writePosition(s1, sudutservo1);
%                     writePosition(s2, sudutservo2);
                    fprintf('Data %d adalah tangan menggenggam %.2f kg\n', rI, yfit(rI))
                    fprintf('Servo Atas %.2f deg, ', suduts1)
                    fprintf('Servo Bawah %.2f deg\n', suduts2)
%                     fprintf('%.2f deg\n', suduts1 + suduts2)
                end
        end
        
        %data sebenarnya
        if rI <= DT
            fprintf('Data %d sebenarnya adalah tangan terbuka\n\n', rI)
        elseif rI <= 2 * DT
            fprintf('Data %d sebenarnya adalah tangan menggenggam sekitar 2kg\n\n', rI)
        elseif rI <= 3 * DT
            fprintf('Data %d sebenarnya adalah tangan menggenggam sekitar 3kg\n\n', rI)
        elseif rI <= 4 * DT
            fprintf('Data %d sebenarnya adalah tangan menggenggam sekitar 4kg\n\n', rI)
        else
            fprintf('Data %d sebenarnya adalah tangan menggenggam sekitar 5kg\n\n', rI)
        end
        continue
    else
        break
    end
end