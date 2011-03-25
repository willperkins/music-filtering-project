
function plotSpectrum(x,ni,nf,HzD,figNum)

nn=length(ni); %number of samples
if nargin<5
    figNum = 2;
end
if nargin<4
    HzD = 10000;
end
if nargin<1
    disp('Must specify piece to analyze!');
end

figure(figNum)
%plot here in the time domain
for k=1:nn
    plot(k+x(ni(k):nf(k))), hold on
end
hold off
N=8192; % N for DFT (form sample lengths in spreadsheet)
%get DFT of each sample and display spectrum
fs = 44100;
Nyq=fs/2; %Nyquist frequency
fHz=(fs/N)*[0:N/2-1]; %frequency in Hertz given sampling rate and N
AllF=[];
for k=1:nn
    xk=x(ni(k):nf(k));
    fxk=fft(xk,N);
    AllF=[AllF; fxk(:)']; %store as row
end
ok=1;
figure(figNum+1)
nHzD=fix((HzD/fs)*N);
c=['b';'c';'g';'m';'r';'y';'k'];legtex=cell(1,nn);
        for k=1:nn
            kk=mod(k-1,7)+1;
            plot(fHz(1:nHzD),abs(AllF(k,1:nHzD)),c(kk)), hold on
            legtex{k}=['sample No. ' num2str(k)];
        end
        legend(legtex)
        xlabel('Frequency (Hz)'), ylabel('Intensity'),
        title('Noise Spectral Power Distribution')
        hold off

        c=['b';'c';'g';'m';'r';'y';'k'];legtex=cell(1,nn);
        figure(figNum+1)
        for k=1:nn
            kk=mod(k-1,7)+1;
            plot(fHz(1:nHzD),abs(AllF(k,1:nHzD)),c(kk)), hold on
            legtex{k}=['sample No. ' num2str(k)];
        end
        legend(legtex)
        xlabel('Frequency (Hz)'), ylabel('Intensity'),
        title('Noise Spectral Power Distribution')
        hold off


end

