clear all;
clc;
close all;
%A = mat2gray(imread('exp1_001_a.bmp'));%image 1 
%B = mat2gray(imread('exp1_001_b.bmp'));%image 2

A = rgb2gray(imread('pp.jpg'));%image 1 
histA = imhist(A);