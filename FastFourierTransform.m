function []=FastFourierTransform(zt_filt,RDS,Fs)
%% Calculate PSD for filtered data

L3=length(zt_filt);
NFFT3 = 2^nextpow2(L3); % Next power of 2 from length of p
Y3 = fft(zt_filt,NFFT3)/L3;
f3 = Fs/2*linspace(0,1,NFFT3/2+1);

%% Calculate PSD for RDS

L1=length(RDS);
NFFT1 = 2^nextpow2(L1); % Next power of 2 from length of p
Y1 = fft(RDS,NFFT1)/L1;
f1 = Fs/2*linspace(0,1,NFFT1/2+1);


%% Blank PSD plots
fig=figure();
sub11=subplot(2,1,1,'Parent',fig,'Yscale','log');
hold on
sub12=subplot(2,1,2,'Parent',fig);
hold on
%% Plotting power spectral density for filtered data
plot(f3,2*abs(Y3(1:NFFT3/2+1)),'-r','Parent',sub11);
plot(f3,angle(Y3(1:NFFT3/2+1)),'-r','Parent',sub12);
%% Plotting power spectral density for RDS
plot(f1,2*abs(Y1(1:NFFT1/2+1)),'-k','Parent',sub11);
plot(f1,angle(Y1(1:NFFT1/2+1)),'-k','Parent',sub12);

%% Formatting created plots
xlabel(sub11,'Frequency (Hz)')
ylabel(sub11,['Free Decay Spectrum' 10 'Magnitude (m/s^2)'])
xlabel(sub12,'Frequency (Hz)')
ylabel(sub12,['Free Decay Spectrum' 10 'Spectrum Phase (rad)'])
legend(sub11,'Filtered data','RDS')
legend(sub12,'Filtered data','RDS')

end