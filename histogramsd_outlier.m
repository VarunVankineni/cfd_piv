clear all;
clc;
close all;
%A = mat2gray(imread('exp1_001_a.bmp'));%image 1 
%B = mat2gray(imread('exp1_001_b.bmp'));%image 2

A = imread('im1.tif');%mat2gray(imread('im1.tif'));%image 1 
B = imread('im2.tif');%mat2gray(imread('im2.tif'));%image 2

[Xmax,Ymax] = size(A);
%window despcription
wins = [24,24];%16,24,32
winx = wins(1);
winy = wins(2);

gridx = 2*winx:winx:Xmax-2*winx;
gridy = 2*winy:winy:Ymax-2*winy;

countx = length(gridx);
county = length(gridy);

dx(countx,county) = 0;
dy(countx,county) = 0;

for i = 1:countx
    for j = 1:county
        x0 = gridx(i);
        y0 = gridy(j);
        win0 = A(x0:x0+winx-1,y0:y0+winy-1);
        win = B(x0-(winx):x0+(2*winx)-1,y0-(winy):y0+(2*winy)-1);
        c = normxcorr2(win0,win);
        [peakx, peaky] = find(c==max(c(:)));
        peakx = peakx -winx+1;
        peaky = peaky -winy+1;
        dx(countx-i+1,j)=peakx-winx;
        dy(countx-i+1,j)=peaky-winy;
             
    end
end

ax = gca;
ax.XLabel.String = 'Interrogation box abscissa';
ax.YLabel.String = 'Interrogation box ordinate';
ax.FontWeight = 'bold';

%coordinate gets changed 

I = quiver(dy,-dx);
I.Color = 'black';


histA = imhist(A);
histB = imhist(B);
stdhA = std(histA);
stdhB = std(histB);


Ix =I.UData;
Iy =I.VData;
avgIx = mean(mean(Ix));
stdIx = std(std(Ix));
avgIy = mean(mean(Iy));  
stdIy = std(std(Iy));    

   

% Ix(Ix>=avgIx+stdIx |Ix<=avgIx-stdIx ) = avgIx;
% Iy(Iy>=avgIy+stdIy |Iy<=avgIy-stdIy ) = avgIy;                     
% I.UData = Ix;
% I.VData = Iy;
% I = quiver(Ix,Iy);

%outlier %calculation
logicalIx =  bsxfun(@gt, Ix, avgIx+stdIx)| bsxfun(@lt, Ix, avgIx- stdIx);
logicalIy =  bsxfun(@gt, Iy, avgIy+stdIy)| bsxfun(@lt, Iy, avgIy- stdIy);
logicalI = logicalIx|logicalIy;
logiclenI = length(logicalI(logicalI==1));
outlier_percent = 100*logiclenI/(countx*county);
Ix(Ix>=avgIx+stdIx |Ix<=avgIx-stdIx ) = avgIx;
Iy(Iy>=avgIy+stdIy |Iy<=avgIy-stdIy ) = avgIy;  