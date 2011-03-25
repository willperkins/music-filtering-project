%findNoise returns the time domain location of noise in a piece 
%given the original piece, frequency domain noise signature,
%start and end indexes of key features of signature, and probability
%threshold of match between signature and sample frame
%
%   function noiseLocation = findNoise(piece,noise,si,sf,probability)
%
%noise is the 8192 pt DFT of the noise signature
%si - start index of key features of the signature (column vector)
%sf - finish index of key features of the signature (column vector)
function nL = findNoise(song,noise,si,sf,prob)

    N = 8192;
    Fs = 44100;
    Ws = 4*1024;                    %window size 4k
    bin = 10;                       %bin size 10
    M = length(song) - mod(length(song),Ws);
 %figure(1);
    for i = 2:M/2048-1,
        ni = 2048*i-4096+1;
        nf = 2048*i;
        Sseg = song(ni:nf);
        fHz = Fs/N*[0:N/2-1];
        Sspec = abs(fft(Sseg,N));
        Sspec = Sspec(1:N/2);
Nspec = noise;
   %     Nspec = abs(fft(noise,N));
   %     Nspec = Sspec(1:N/2);
  %divide frequency into bins  
   %      for j = 1:fix(N/2/bin),
   %          Sspec(bin*(j-1)+1:bin*j) = sum(Sspec(bin*(j-1)+1:bin*j))/bin;
   %          Nspec(bin*(j-1)+1:bin*j) = sum(Nspec(bin*(j-1)+1:bin*j))/bin;
   %      end
  
         for k=1:N/2, 
             AndF(k) = Sspec(k)*Nspec(k); 
         end
         
         for m = 1:length(si),
            Nseg = Nspec(si(m):sf(m));
            Sseg = Sspec(si(m):sf(m));
            theta(i,m) = acos(Sseg*Nseg'/(norm(Sseg)*norm(Nseg)));
         end
         
 end
        theta = 180/pi*theta;
        tAvg = sum(theta,2)/size(theta,2);
        h = 1;
        for i = 2:length(tAvg),
            tAvg(i) = 1-.1/9*tAvg(i);
            if tAvg(i) > prob,
                nL(h) = i;
                h = h+1;
            end
                
        end
       
   %combine points within 10 frames of each other
        for i = 1:(length(nL)-1),
            if (nL(i+1)-nL(i)) < 10,
                nL(i) = fix((nL(i+1)+nL(i))/2);
                i = i+1;
                for k = i:(length(nL)-1),
                    nL(k) = nL(k+1);
                end
                nL(length(nL)) = 0;
            end
        end
        g = 1;
        for i = 1:length(nL),
            if nL(i) ~= 0;
                g = g+1;
            end
        end
        nL = nL(1:g-2);
       
        s(1:length(noise)) = 0;
        for i = 1:length(si),
            segi = si(i);
            segf = sf(i);
            for j =segi:segf,
                s(j) = s(j) + noise(j);
            end
        end
        
        figure;
        plot(fHz,s);
        title('Key points of signature used to locate noise');
        xlabel('Frequency (Hz)');
        ylabel('Normalized power intensity');

        figure; plot(tAvg);
        title('Probability that noise signature is present in sample');
        xlabel('Window sample number');
        ylabel('Probability');
end