%filterSegements filters the segments of the piece
%given to it
%   filteredSignal = filterSegments(piece,segments)
%segments - center frame of noise location 
%(will filter two frames before and after center frame)
function y = filterSegments(song,nL)

b=[ 0.9930   -1.9632    0.9930];
a=[1.0000   -1.9632    0.9859];
b2=[0.9897   -1.8919    0.9897];
a2=[1.0000   -1.8919    0.9793];
b3=[0.9956   -1.8335    0.9956];
a3=[ 1.0000   -1.8335    0.9911];
b4 =[0.9928   -1.8141    0.9928];
a4=[1.0000   -1.8141    0.9855];
b5=[0.9105   -1.4225    0.9105];
a5=[1.0000   -1.4225    0.8209];

bn = conv(b,b2);
an = conv(a,a2);
bf= conv(bn,b3);
af =conv(an,a3);
bf2 = conv(bf,b4);
af2 = conv(af,a4);
B = conv(bf2,b5);
A = conv(af2,a5);

figure;
plotResponse(B,A,10000);
title('Response of filter');
y = song;
    for i = 1:length(nL), 
        
        for k = 1:5,
         frame = nL(i)+k-3;
         Segi = (frame-1)*2048;
         Segf = Segi+4096;
         y(Segi:Segf) = filter(B,A,y(Segi:Segf));
        end

    end
end