clear all;
close all;
clc;

% Read in Files

%Training Images Set
train_images=fopen('train-images-idx3-ubyte');
A=fread(train_images,inf,'uint8');
A2=A(17:end,:);

train_images_close=fclose(train_images);
A_train=reshape(A2,28*28,60000);

%Training Labels
train_labels=fopen('train-labels.idx1-ubyte');
B=fread(train_labels,inf,'uint8');
B2=B(9:end,:);

train_labels_close=fclose(train_labels);

%Change 0 to 10
B2(B2==0)=10;

% Change to 10x60000 Vector of 1s and 0s
for i=1:60000
    position=B2(i,1);
    vec=[zeros(10,1)];
    vec(position)=1;
    B_train(:,i)=vec;
end

%Testing Images Set
test_images=fopen('t10k-images.idx3-ubyte');
A3=fread(test_images,inf,'uint8');
A4=A3(17:end,:);


test_images_close=fclose(test_images);
A_test=reshape(A4,28*28,10000);

%Testing Labels
test_labels=fopen('t10k-labels.idx1-ubyte');
B3=fread(test_labels,inf,'uint8');
B4=B3(9:end,:);

test_labels_close=fclose(test_labels);

%Change 0 to 10
B4(B4==0)=10;

% Change to 10x60000 Vector of 1s and 0s
for i=1:10000
    position=B4(i,1);
    vec=[zeros(10,1)];
    vec(position)=1;
    B_test(:,i)=vec;
end

figure(1)                                       
colormap(gray)   
for i = 1:25                                    
    subplot(5,5,i)                              
    number = reshape(A_train(:,i), [28,28,]);    
    imagesc(number')                              
end


% Now solve AX=B with different methods
 
%Pseudoinverse 
x1 = B_train*pinv(A_train);

% x=B/A
x2=B_train/A_train;

%Lasso(Lambda=0.01) - must do each row individually 
lambda=0.01;
for i=1:10
x3= lasso(A_train',B_train(i,:),'lambda',lambda);
x3_save(:,i)=x3;
end
x3=x3_save';

lambda=0.0;
for i=1:10
x4= lasso(A_train',B_train(i,:),'lambda',lambda);
x4_save(:,i)=x4;
end
x4=x4_save';

lambda=0.1;
for i=1:10
x5= lasso(A_train',B_train(i,:),'lambda',lambda);
x5_save(:,i)=x5;
end
x5=x5_save';

%Evaluate relative errors
b1_eval=x1*A_train;
b2_eval=x2*A_train;
b3_eval=x3*A_train;
b4_eval=x4*A_train;

error1=norm(b1_eval-B_train,2)/norm(B_train,2);
error2=norm(b2_eval-B_train,2)/norm(B_train,2);
error3=norm(b3_eval-B_train,2)/norm(B_train,2);
error4=norm(b4_eval-B_train,2)/norm(B_train,2);

figure(2)
y=[error1 error2 error3 error4];
bar(y);
methods_labels={'Pseudoinverse';'MATLAB "Backslash"';'Lasso (Lambda=0.01)';...
    'Lasso (Lambda=0)'};
xlabel('Method');
ylabel('Relative Error');
set(gca,'xticklabels',methods_labels)

for j=1:784
   X1(j)=x1(1,j);
   X2(j)=x2(1,j);
   X3(j)=x3(1,j);
   X4(j)=x4(1,j);
   X5(j)=x5(1,j);
   
end


figure(2)
subplot(2,3,1), bar(1:784,X1),title('Pseudoinverse');
subplot(2,3,2), bar(1:784,X2),title('MATLAB "Backslash"');
subplot(2,3,3), bar(1:784,X3),title('Lasso (Lambda=0.01)');
subplot(2,3,4), bar(1:784,X4),title('Lasso (Lambda=0)');
subplot(2,3,5), bar(1:784,X5),title('Lasso (Lambda=0.1)');



% (2)Determine and rank which pixels in the MNIST set are 
% most informative for correctly labeling the digits.

for i=1:784
   x3_norm_temp=norm(x3(:,i),2);
   x3_norm(:,i)=x3_norm_temp;
end
image_x3=reshape(x3_norm.',28,28);
figure(3);
imagesc(image_x3);
colorbar;


% (3)Apply your most important pixels to the test data set 
% to see how accurate you are with as few pixels as possible.

B_evaltest=x4*A_test;
[max_value,max_index]=max(B_evaltest);
max_index(max_index==10)=0;
B4(B4==10)=0; % Change Testing Labels back to 0 from 10
bool=max_index'==B4; % Determine if they are equal or not

sum_bool=sum(bool);
accuracy=(sum_bool/length(max_index))*100; % Percent Accuracy (81.15%);

% (4)Redo the analysis with each digit individually 
% to find the most important pixels for each digit.

for m=1:10 
B4(B4==0)=10;
B4_iter=B4;
for i=1:10000   %Change number to 1 when m=i, set to 0 otherwise
 if B4_iter(i)==m
    B4_iter(i)=1;
 else
   B4_iter(i)=0;
end
end

for i=1:784
   x3_norm_temp=norm(x3(m,i),2);
   x3_norm(m,i)=x3_norm_temp;
end 
image_x3=reshape(x3_norm(m,:).',28,28);
figure(4);
subplot(4,3,m),imagesc(image_x3);
colorbar;

B_evaltest2=x4*A_test;
[max_value2,max_index2]=max(B_evaltest2);

max_index2_iter=max_index2;
for i=1:10000
if max_index2_iter(i)==m
    max_index2_iter(i)=1;
else
   max_index2_iter(i)=0;
end
end

max_index2_iter(max_index2_iter==10)=0;
B4_iter(B4_iter==10)=0; % Change Testing Labels back to 0 from 10

sum_max_index2_iter(:,m)=sum(max_index2_iter);
sum_B4_iter(:,m)=sum(B4_iter);
accuracy2(:,m)=sum_max_index2_iter(:,m)/sum_B4_iter(:,m);
end












