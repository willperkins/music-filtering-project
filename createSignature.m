%CreateSignature creates a frequency domain signature
%   signature = createSignature(piece,ni,nf)
%
%simply input the piece (Greensleeves audio), start and end indexes of 
%noise segments and it will take the mean of the spectrums of all of the
%noise segments and return it as the signature (which consists of 8192 pts)
%ni - start index of noise segments (column vector)
%nf - end index of noise segments (column vector)

function xfm = createSignature(song,ni,nf)
Fs = 44100;
N = 8192;
c=['b';'c';'g';'m';'r';'y';'k'];
%HzD = fix(10000*8192/44100);
HzD = 10000;
fHz=(Fs/N)*[0:N/2-1];
nHzD=fix((HzD/Fs)*N);
for i = 1:length(ni),
    x = fft(song(ni(i):nf(i)),8192);
    x = abs(x);
    x = x(1:4096);
    x = x/sum(x);
    xf(i,:) = x;
    plot(fHz(1:nHzD),x(1:nHzD),c(i));
    title('All noise samples');
    xlabel('DFT sample No.');
    ylabel('Normalized power intensity');
    hold on;
end
xfm = sum(xf,1);
hold off;
figure;

plot(fHz(1:nHzD),xfm(1:nHzD));
title('Mean of noise samples');
xlabel('DFT sample No.');
ylabel('Normalized power intensity');