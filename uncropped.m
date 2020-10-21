% Size of each picture
m = 100;
n = 75;

avg = zeros(m*n,1);  % the average face
A = [];

count=0;
D = 'yalefaces_uncropped/yalefaces';
S=dir(fullfile(D,'subject*.*'));
for k = 1:numel(S)
    figure(1)
    ff = fullfile(D,S(k).name);
    %ff = fullfile(D,S(k).pgm);
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
%plot(phi,'ko','Linewidth',[1.5])

%G=(A')*(A);
%[V,A]=eigs(G,20,'lm');
[U,S,V] = svd(A);
rank(A)
rank(S)
figure(2)
phi=diag(S);
%subplot(2,1,1), plot(phi)
subplot(1,1,1), semilogy(phi,'ko')
axis([0 155 10^(0) 10^(6)])

%plot(S,x(:,1),'red','linewidth',2 )
%xlabel('Time (s)');
%ylabel('X_1');



%% Calculate the "averaged" face
avg= avg/count;
avgTS = uint8(reshape(avg,m,n));
figure(3), imshow(avgTS);



