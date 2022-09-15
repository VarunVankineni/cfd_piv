clear all;
clc;
close all;

%A = rgb2gray(imread('snap1.png'));%image 1 
%B = rgb2gray(imread('Snap2.png'));%image 2

A = imread('exp1_001_b.bmp');%image 1 
B = imread('exp1_001_a.bmp');%image 2

%SE = strel('square',9);
%A = imdilate(A,SE);
%B = imdilate(B,SE);




[Xs,Ys] = size(A);%X size, Y size of images
wsize = [32,32];
wsizex = wsize(1);
wsizey = wsize(2);

winhx = wsizex/2;
winhy = wsizey/2;
%xgrid = (2*wsizex):winhx: (Xs- 2*wsizex);
%ygrid = (2*wsizey) :winhy: (Ys - 2*wsizey);

xgrid = 20:winhx: Xs -20;
ygrid = 20 :winhy: Ys-20;

xcount = length(xgrid);
ycount = length(ygrid);

basewin(wsize, wsize) = 0;
testwin(wsize + 2*winhx,wsize + 2*winhy) = 0;

dx(xcount,ycount) = 0;
dy(xcount,ycount) = 0;

xpeak1 =0;
ypeak1 = 0;


for i = 1:(xcount)
    for j = 1:(ycount)
        maxcor = 0;
        xdisp =0;
        ydisp =0;
        
        testxo = xgrid(i)-winhx;
        testxe = xgrid(i)+winhx;
        
        testyo = ygrid(j)-winhy;
        testye = ygrid(j)+winhy;
        
        basewin = A(testxo:testxe,testyo:testye);
        testwin = B(testxo-winhx:testxe+winhx,testyo-winhy:testye+winhy);
        try
            corr = normxcorr2(basewin, testwin);
            [ypeak,xpeak] = find(corr==max(corr(:)));
            xpeak1 = testxo + xpeak - 2*winhx;
            ypeak1 = testyo + ypeak - 2*winhy;
            dx(i,j) = xpeak1 -xgrid(i);
            dy(i,j) = ypeak1 - ygrid(j);
        catch
            dx(i,j) = 0;
            dy(i,j) = 0;
        end
    end
end
quiver(dy,-dx)

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        








