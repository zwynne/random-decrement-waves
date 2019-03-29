%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 2019 Zachariah Wynne, Thomas Reynolds, Damien Bouffard, Geoffrey
% Schladow, Danielle Wain

% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files (the "Software"),
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, distribute, sublicense, 
%and/or sell copies of the Software, and to permit persons to whom the Software
% is furnished to do so, subject to the following conditions:

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
% IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For a full description of this MATLAB script please refer to Wynne, Z., 
% Reynolds, T., Bouffard, D., Schladow, G., & Wain, D. (2019). A novel 
% technique for experimental modal analysis of barotropic seiches for 
% assessing lake energetics. Environmental Fluid Mechanics. Springer Netherlands. 
% https://doi.org/10.1007/s10652-019-09677-x

% Introduction

% This code is to apply the level crossing Random Decrement Technique (RDT) to a
% set of data.

% An estimation of the free response of a dynamic system is calculated by 
% averaging together segments of the system reponse due to exciation which 
% is assumed to be "white noise" (stationary, broadband, gaussian and
% random)

% For a comprehensive introduction to the level crossing Random Decrement Technique
% refer to Asmussen, J. C. (1997). Modal analysis based on the random decrement 
% technique. Denmark: University of Aalborg. Ph. D. Dissertation. Available
% at http://vbn.aau.dk/files/99609/asmussen-john.pdf

% The response of the system which is obtained; known as the Random
% Decrement Signature (RDS), is then decomposed into a series of damped sinusoids 
% using the Matrix Pencil Method. 

% The MATLAB code used for the Matrix-Pencil Method is an expansion
% to MATLAB code provided in Appendix B of "Zielinski, T. P., & Krzysztof, D. 
% (2011). Frequency and Damping Estimation Methods – An Overview. Metrology 
% and Measurement Systems, XVIII(4), 505–528.
% https://doi.org/10.2478/v10178-011-0051-y"

% Any use of the MATLAB code for the matrix-pencil method should cite the
% above reference as the original source.

%% User controlled variables 

fs=1/(60*10);                   % Sampling rate at which the data was acquired in Hz

% Filtering parameters
low = 1/(12*60*60);             % low frequency cutoff in Hertz
high = 0;                       % High frequency cutoff in Hertz
poles= 10;                      % Number of poles for the bandpass filter 

% RDT Parameters
RDT_trigger = 5;                % Set the value of the trigger value to be used

RDS_length = 24*60*60;          % RDS length in seconds

animated = 0;                   % Should random decrement analysis be animated? 
                                % This allows the RDT averaging to be viewed in realtime.
                                % This is slower but is advised for early
                                % results to check for convergance
                                % Closing the window will stop the code

% Matrix pencil method parameters
K=3;                        % Number of modes to fit to the RDS using the Matrix-Pencil Method

%% Organising data
disp('Loading water elevation data...')

load('water_elevation_2028_2018.mat')
zt = table2array(water_elevation_2028);

%% Filter
% Filter to desired frequency range and plot filtered and unfiltered
% signals.
disp('Filtering data...')

zt = detrend(zt);                                   % Detrend the data
zt_filt = bandpass_filter(zt,high,low,fs,poles);    % Filter the data using a bandpass filter
 
%% Apply random decrement 
disp('Applying random decrement technique...')

% This applies the level-crossing random decrement method, with the level
% set as a multiple of the standard deviation of the data.

RDT_trigger= RDT_trigger*std(zt_filt);              % To enable data comparision it can be useful to specify the random decrement trigger value
                                                    % as a multiple of the standard deviation
ls= RDS_length*fs;                                  % Convert RDS length from hours to samples 
[RDS, Number_signatures ] = RDT_level_crossing( zt_filt,ls,RDT_trigger,animated,fs); % Function applies the level crossing random decrement technique

% Plot the resulting random decrement signature
disp('Plotting random decrement data triggering location...')
figure
time=linspace(0,RDS_length/(60*60),ls);             % Create a time variable for the RDS 
plot(time,RDS);
legend('Random decrement signature')
xlabel('Time (seconds)')
ylabel('Amplitude')

%% Move to frequency domain using a Fast Fourier Transform
disp('Plotting Power Spectral Densities...')
FastFourierTransform(zt_filt,RDS,fs);               % This function will calculate and plot the frequency spectra 
                                                    % for the filtered data and RDS
                                        
%% Decompose the RDS into it's dominant frequencies and damping ratios
% using the matrix pencil algorithm
disp('Calculating dominant frequencies of filtered RDSs using matrix pencil method...')
[freqs, dmp_ratios] = fMatPen(RDS,K,fs);

disp('Dominant frequencies (Hz) are: ')
disp(freqs)

disp('Dominant Periods (hours) are: ')
disp((1./freqs)/(60*60))

disp('The associated damping rations (%) are: ')
disp(dmp_ratios*100)
