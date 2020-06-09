clear; clc;
load ("D:\Kuliah\Tugas Akhir\Project\Realtime dan NN\data\Feature_Extraction_Force.mat")
load ("D:\Kuliah\Tugas Akhir\Project\Realtime dan NN\data\Feature_Extraction_ReleaseOnly.mat")

EMG_F1(:,1:8)   = iemg_EMG_F1;
EMG_F1(:,9:16)  = kurtosis_EMG_F1;
EMG_F1(:,17:24) = skewness_EMG_F1;
EMG_F1(:,25:32) = mean_pdg_EMG_F1;
EMG_F1(:,33:40) = iemg_EMG_F1;
EMG_F1(:,41:48) = mav_EMG_F1;
EMG_F1(:,49:56) = ssi_EMG_F1;
EMG_F1(:,57:64) = var_EMG_F1;

EMG_F2(:,1:8)   = iemg_EMG_F2;
EMG_F2(:,9:16)  = kurtosis_EMG_F2;
EMG_F2(:,17:24) = skewness_EMG_F2;
EMG_F2(:,25:32) = mean_pdg_EMG_F2;
EMG_F2(:,33:40) = iemg_EMG_F2;
EMG_F2(:,41:48) = mav_EMG_F2;
EMG_F2(:,49:56) = ssi_EMG_F2;
EMG_F2(:,57:64) = var_EMG_F2;

EMG_F3(:,1:8)   = iemg_EMG_F3;
EMG_F3(:,9:16)  = kurtosis_EMG_F3;
EMG_F3(:,17:24) = skewness_EMG_F3;
EMG_F3(:,25:32) = mean_pdg_EMG_F3;
EMG_F3(:,33:40) = iemg_EMG_F3;
EMG_F3(:,41:48) = mav_EMG_F3;
EMG_F3(:,49:56) = ssi_EMG_F3;
EMG_F3(:,57:64) = var_EMG_F3;

EMG_F4(:,1:8)   = iemg_EMG_F4;
EMG_F4(:,9:16)  = kurtosis_EMG_F4;
EMG_F4(:,17:24) = skewness_EMG_F4;
EMG_F4(:,25:32) = mean_pdg_EMG_F4;
EMG_F4(:,33:40) = iemg_EMG_F4;
EMG_F4(:,41:48) = mav_EMG_F4;
EMG_F4(:,49:56) = ssi_EMG_F4;
EMG_F4(:,57:64) = var_EMG_F4;

EMG_R(:,1:8)   = iemg_EMG_Release;
EMG_R(:,9:16)  = kurtosis_EMG_Release;
EMG_R(:,17:24) = skewness_EMG_Release;
EMG_R(:,25:32) = mean_pdg_EMG_Release;
EMG_R(:,33:40) = iemg_EMG_Release;
EMG_R(:,41:48) = mav_EMG_Release;
EMG_R(:,49:56) = ssi_EMG_Release;
EMG_R(:,57:64) = var_EMG_Release;

X(1:30,:) = EMG_F1;
X(31:60,:) = EMG_F2;
X(61:90,:) = EMG_F3;
X(91:120,:) = EMG_F4;
X(121:180,:) = EMG_R;

y(1:30,:) = 1;
y(31:60,:) = 1;
y(61:90,:) = 1;
y(91:120,:) = 1;
y(121:180,:) = 0;
