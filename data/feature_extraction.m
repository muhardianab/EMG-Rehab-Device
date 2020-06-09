% load 'D:\Kuliah\Tugas Akhir\Database EMG\ItSelf using MyoArmband\Basic\Feature_Extraction.mat'
% plot(feature_extraction, '-o')

% variable X
column 1 = rms
column 2 = kurtosis            adjusted = .*0.001
column 3 = skewness            adjusted = .*0.01
column 4 = mean_pdg                         % PSD menggunakan estimasi periodogram, cek myoelectric control system hal 283
column 5 = iemg(integrated EMG)
column 6 = MAV(mean absolute value)
column 7 = SSI(simple square integral)
column 8 = VAR(variance of EMG)
column 9 = WL(Waveform Length)              % sample data ke-30 F1-F4 dan ke-60 Release dibuat dari mean

rms()
kurtosis()
skewness()
mean(periodogram())
mean(abs())
(1/1000)*(mean(abs()));
mean((abs()).^2)
(1/(1000-1))*(mean(().^2))








----------------------


% Blm dibuat
standar deviasi
crest factor
shape factor
impluse factor
sample standar deviasi
sample variancetheki
Wavelet transfom
wavelet packet transform
continuous wavelet transform (CWT)
short time fourier transform (STFT)

zero crossing
mean absolute value slope (MAVS)
modified Mean absolute value) (MMAV)

--------------------
column 11 = MYOP
column 12 = 

--------------------
% not used
slope sign change, malah memperburuk,jurnal myoelectric control system hal 283
average amplitude change, sama saja dengan waveform length, hanya tinggal dibagi nilai n
log detector, error nilai ada yang jadi inf, jadi hasilnya selalu 0 ketika di exp