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


function [ RDS,n ] = RDT_level_crossing(y,ls, t,animate,fs)

ls = round (ls);      % Make sure the length of the RDS is an integer  
samples=zeros(1,ls);  % A temporary array used to store segments of data prior to averaging
RDS=zeros(1,ls);      % The RDS array
n = 0;                % Number of segments which make up the RDS

if animate==1
    % Setup the plot to animate the averaging process
    time = linspace(1,ls/fs,ls);
    hf=figure;
    ht=plot(time,RDS);
    xlabel('Time (seconds)')
    ylabel('Amplitude')
    
    set(ht,'YDataSource','RDS');
end

% Identify crossing points, and extract a sample of ls points beginning
% at each crossing point

for k=1:length(y)-ls
    % If the data has up-crossed the trigger value take a sample
    if y(k)<=t
        if y(k+1)>t
            c=1;
            while c<=ls
                samples(c)=y(k+c);
                c=c+1;
            end
            RDS=(RDS*(n)+((samples)))/(n+1);
            if animate==1
                refreshdata(hf,'caller')
                drawnow
            end
            n = n+1 ;
        end
    end
    
    % If the data has down-crossed the trigger value take a sample
    if y(k)>=t
        if y(k+1)<t
            c=1;
            while c<=ls
                samples(c)=y(k+c);
                c=c+1;
            end
            RDS=(RDS*(n)+samples)/(n+1);
            if animate==1
                refreshdata(hf,'caller')
                drawnow
            end
            n = n+1;
        end
    end
end
end
