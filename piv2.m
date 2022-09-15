clear all;
clc;
close all;
%A = mat2gray(imread('exp1_001_a.bmp'));%image 1 
%B = mat2gray(imread('exp1_001_b.bmp'));%image 2

A = imread('im1.tif');%mat2gray(imread('im1.tif'));%image 1 
B = imread('im2.tif');%mat2gray(imread('im2.tif'));%image 2



% F = 128;
% A(A<F)=0;
% B(B<F)=0;

% A = ordfilt2(A,9,ones(3,3));
% B = ordfilt2(B,9,ones(3,3));

% A = imsharpen(A);
% B = imsharpen(B);


% A= histeq(A);
% B = histeq(B);



[Xmax,Ymax] = size(A);
%window despcription
winsize = 24;
wins = [winsize,winsize];%16,24,32
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
        try
            c = normxcorr2(win0,win);
            [peakx, peaky] = find(c==max(c(:)));
            peakx = peakx -winx+1;
            peaky = peaky -winy+1;
            peakx = peakx(1);
            peaky = peaky(1);
            dx(countx-i+1,j)=peakx-winx;
            dy(countx-i+1,j)=peaky-winy;
        catch
            dx(countx-i+1,j)=0;
            dy(countx-i+1,j)=0;
        end
    end
end



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

   

Ix(Ix>=avgIx+stdIx |Ix<=avgIx-stdIx ) = avgIx;
Iy(Iy>=avgIy+stdIy |Iy<=avgIy-stdIy ) = avgIy;  
I.UData = Ix;
I.VData = Iy;
I = quiver(Ix,Iy);
I.Color = 'black';

%outlier % calculation and interpolation of outliers with averaged values
logicalIx =  bsxfun(@gt, Ix, avgIx+0.95*stdIx)| bsxfun(@lt, Ix, avgIx- 0.95*stdIx);
logicalIy =  bsxfun(@gt, Iy, avgIy+0.95*stdIy)| bsxfun(@lt, Iy, avgIy- 0.95*stdIy);
logicalI = logicalIx|logicalIy;
logiclenI = length(logicalI(logicalI==1));
outlier_percent = 100*logiclenI/(countx*county);
Ix(Ix>=avgIx+stdIx |Ix<=avgIx-stdIx ) = avgIx;
Iy(Iy>=avgIy+stdIy |Iy<=avgIy-stdIy ) = avgIy;  


%command window inputs for filtered/enhanced images and their respective
%intensity histograms
%imshow(A)
%imshow(B)
%ax = gca,plot(histA),ax.FontWeight = 'bold',ax.XLabel.String = 'Intensity Bins',ax.YLabel.String = 'No.of Pixels';
%ax = gca,plot(histB),ax.FontWeight = 'bold',ax.XLabel.String = 'Intensity Bins',ax.YLabel.String = 'No.of Pixels';

%Vector field window configuration
ax = gca;
ax.XLabel.String = 'Interrogation box abscissa';
ax.YLabel.String = 'Interrogation box ordinate';
ax.FontWeight = 'bold';