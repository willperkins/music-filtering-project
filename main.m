song = noiseAnalysis;
prob = .76;

%noiseAnalysis(song,44100);
ni = [4762172 3575617 2414909 1886529 643806]';
nf = [4767914 3581628 2418882 1889736 646916]';

sig = createSignature(song,ni,nf);

si = [177 349 520 552]';
sf = [221 406 535 562]';
nL = findNoise(song,sig,si,sf,prob);

n2i = ((nL-2)-1)*2048;
n2f = ((nL+2)-1)*2048;
plotSpectrum(song,n2i',n2f',10000,6);
figure(6);
title('Identified noise segments');
figure(7);
title('Identified noise segments');
filtSong = filterSegments(song,nL);

plotSpectrum(filtSong,n2i',n2f',10000,8);
figure(8);
title('Identified noise segments after filtering');
figure(9);
title('Identified noise segments after filtering');

disp('to play original piece type wavplay(song,44100)');
disp('to play filtered piece type wavplay(filtSong,44100)');
