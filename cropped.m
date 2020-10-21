%Andrew Rossi
clear all
close all
clc

% Size of each picture
m = 100;
n = 75;

avg = zeros(m*n,1);  % the average face
A = [];

count=0;
D = 'CroppedYale';
P=dir(fullfile(D,'yale*'));
for ii=1:numel(P)
S=dir(fullfile(D,P(ii).name,'yale*.pgm'));
for k = 1:numel(S)
    figure(1)
    ff = fullfile(D,P(ii).name,S(k).name);
    u = imread(ff);
    u = imresize(u,[m,n]);
    imshow(u)
    if(size(u,3)==1)
        M=double(u);
    else
        M=double(rgb2gray(u)); 
    end
    pause(0.01);
    R = reshape(M,m*n,1);
    A = [A,R];
    avg = avg + R;
    count = count + 1;
end
end

%SVD Analysis and Single Value Spectrum 
[U,S,V] = svd(A);
rank(A)
rank(S)
figure(2)
phi=diag(S);
subplot(1,1,1), semilogy(phi,'ko')

%% Calculate the "averaged" face
avg= avg/count;
avgTS = uint8(reshape(avg,m,n));
figure(3), imshow(avgTS);

% Most Prominent Eigenfaces
figure(4)
for i = 1:5
    ax(i)=subplot(1,5,i);
    imshow(mat2gray( reshape( -U(:,i),[m n]) ) )
end

% Reconstruction based on Rank
image=111;
figure(5)
f=[1 5 10 20 50 100 200 500 1000];
for h=1:9
    reface = U(:,1:f(h))*S(1:f(h),1:f(h))*V(:,1:f(h)).';
    ax(h) = subplot(3,3,h);
    imshow( mat2gray( reshape( reface(:,image),[m n])));
    position = ['Rank: ' num2str(f(h))];
    xlabel(position);
end





