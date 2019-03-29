function [y] = bandpass_filter(x,fpasshigh,fpasslow,rate,pole)
% BETTERFILTER Bandpass filter
% x is the signal to be filtered
% fpasshigh is the upper frequency in the passband
% fpasslow is the lower frequency of the passband
% rate is the sampling rate of x
% pole is the number of poles in the filter (higher number gives sharper
% cutoff, but more phase lag between y and x
% y is the filtered signal

% set default number of poles to 5

if nargin<5
    pole=5;
end

if fpasshigh>0
    [z,p,k] = butter(pole,fpasshigh/rate*2,'low');
    [sos,g] = zp2sos(z,p,k);	     % Convert to SOS form
    Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
    y = filter(Hd,x);
else
    y=x;
end

if fpasslow>0 
    [z,p,k] = butter(pole,fpasslow/rate*2,'high');
    [sos,g] = zp2sos(z,p,k);	     % Convert to SOS form
    Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
    y = filter(Hd,y);
end

n=1:1:length(x);
figure
plot((n/rate)/(60*60*24),x,(n/rate)/(60*60*24),y);
title('Filtered and unfiltered water depth variation from mean')
legend('Unfiltered & Detrended','Filtered & Detrended')
ylabel('Amplitude')
xlabel('Time (days)')

end