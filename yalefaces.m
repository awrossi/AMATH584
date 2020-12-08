clear all;
close all;
clc;

% Size of each picture
m = 100;
n = 75;

A = [];
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
end
end

%SVD Analysis and Single Value Spectrum 
R=corrcoef(A);
[U,S,V] = svd(R);

% Power Iteration Method
v=randn(2414,1);
n=20;
lambda=[n,1];

for k=1:n
    omega=R*v;
    v=omega/norm(omega);
    lambda(k)=v'*R*v;
end

% Plot Power Iteration VS largest SVD Mode
figure(2)
plot(1:n,lambda,':r','linewidth',[2]);
hold on
yline(S(1,1),'k','linewidth',[2]);
hold off;
xlabel('Number of Iterations');
ylabel('Largest Eigenvalue');
ax=gca;
ax.FontSize=12;
title('Power Iteration Versus SVD');
legend('Power Iteration','Largest Order SVD Mode')


[U1,S1,V1] = svd(A);

%Randomized Sampling
K=200;
S2=[K,1];
for a=1:K
Omega=randn(2414,a);
Y=A*Omega;

[Q,R]=qr(Y,0);
B=Q'*A;
[U2t,S2t,V2t]=svd(B);
U2=Q*U2t;
S2(a)=S2t(1,1);
end

figure(3)
yline(S1(1,1),'k','linewidth',[3]);
hold on
plot(1:K,S2,':r','linewidth',[2]);
hold off
xlabel('Number of Randomized Samples');
ylabel('Largest Mode');
ax=gca;
ax.FontSize=12;
title('Largest SVD Mode');
legend('True Mode','Randomized Sampling Mode')

% Effect of Sample Size on Singular Value Decay
figure(4)
semilogy(diag(S1),'ko');
hold on
for a=[10,100,1000,2000,2414]
Omega=randn(2414,a);
Y=A*Omega;

[Q,R]=qr(Y,0);
B=Q'*A;
[U2t,S2t,V2t]=svd(B);
U2=Q*U2t;
S2(a)=S2t(1,1);

semilogy(diag(S2t),'.');
end
hold off
legend('True Singular Values','10 Randomized Samples','100 Randomized Samples',...
    '1000 Randomized Samples','2000 Randomized Samples','2414 Randomized Samples');
xlabel('Index');
ylabel('Singular Value');
ax=gca;
ax.FontSize=12;
title('Singular Value Decay');



