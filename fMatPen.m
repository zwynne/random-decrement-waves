function [f, delta, R,ratio] = fMatPen(signal,K,rate)

% This code is an expansion on the MATLAB code for the Matrix Pencil method 
% taken from Zielinski, T. P., & Krzysztof, D. (2011). Frequency and Damping 
% Estimation Methods – An Overview. Metrology and Measurement Systems, XVIII(4), 505–528. https://doi.org/10.2478/v10178-011-0051-y
% The original MATLAB code can be found in Appendix B (Program 3) of the
% above paper.

% Users are directed to the journal paper above for a full description of the
% method

% Any use of the marked section of code should cite the journal paper
% paper. For the original MATLAB scripts used for the Matrix Pencil Method 
% please see http://www.kt.agh.edu.pl/~tzielin/papers/M&MS-2011/.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SECTION OF CODE TAKEN FROM:
% Zielinski, T. P., & Krzysztof, D. (2011). 
% Frequency and Damping Estimation Methods – An Overview. Metrology and 
% Measurement Systems, XVIII(4), 505–528. https://doi.org/10.2478/v10178-011-0051-y

% For the original MATLAB scripts used for the Matrix Pencil Method please
% see http://www.kt.agh.edu.pl/~tzielin/papers/M&MS-2011/.

% signal - analyzed signal – sum of real damped sinusoids
% K - assumed number of real damped sine components
% rate - sampling rate in Hz

M = 2*K;                        % Number of complex components
N = length(signal);             % Number of signal samples
ls = floor(N/3);                % Linear prediction order L = N/3
X = hankel(signal(1:N-ls),signal(N-ls:N));
[U,S,V] = svd(X(:,2:ls+1), 0);  % Singular Value Decomposition of X1
S = diag(S); 
p = log( eig( diag(1./S(1:M)) * ((U(:,1:M)'*X(:,1:ls))*V(:,1:M)) ) );
Om = imag(p);                   % Angular frequencies of decomposed signal
[Om, indx] = sort( Om, 'descend' );
Om = Om(1:K);                   % Take the K largest dominant frequencys
D = real(p(indx(1:K)));         % The damping ratios associated with the K 
                                % frequencies above

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For a description of the use of this MATLAB script please refer to Wynne, Z, Reynolds,
% R, Bouffard, D, Schladow, G, & Wain, D (2019). A novel technique for
% experimental modal analysis of barotropic seiches for assessing lake
% energetics. Environmental Fluid Mechanics.

f=Om*rate/2/pi;                 % Convert the angular frequencies to Hz
delta=D*rate/2/pi./f;           % Covert the values of damping back to the frequency domain
                                % and multiply them by their corresponding frequency to get the damped
                                % ratio
                                
% Create the matrix of exponential decays in each mode and solve to find
% the contribution of each mode

Z=zeros(N,K);
% N equals the length of the signal, K equals the
% number of dominant modes which the signal has been reduced to 
for c=1:N
    for k=1:K
        Z(c,k)=exp(-D(k)*c-1i*Om(k)*c);
    end
end

R=Z\signal';
% Find the array of the magnitude of each exponentially decaying sinusoid
% in the original signal (this is a curve fitting operation)

% Use that array to reconstruct the original signal as a sum of
% exponentially decaying sinusoids
y=Z*R;

y=real(y);      % Keep only the real part

ls=length(y);

% Apply an exponential window and scale the signal
time=zeros(1,ls);
we=zeros(1,ls);
yw=zeros(1,ls);
xw=zeros(1,ls);
a=0.00005;
xw(1)=signal(1);
yw(1)=y(1);

for k=2:ls
    time(k)=time(k-1)+1/rate;
    we(k)=exp(-a*time(k));
    yw(k)=we(k)*y(k);
    xw(k)=we(k)*signal(k);
end

NFFT = 2^nextpow2(ls); 
ftY = fft(yw,NFFT)/ls;
ftX = fft(xw,NFFT)/ls;
ratio=max(abs(ftX))/max(abs(ftY));
y=y*ratio;
R=R*ratio;

% Plot the reconstructed signal and the original random decrement signature
% signal
figure
xdata=(1/rate:1/rate:N/rate);
plot(xdata,y,'--r',xdata,signal);

xlabel('Time (seconds)')
ylabel('Amplitude')
legend('Modal curve fit','Measured response')
end