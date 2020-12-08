clear all;
close all;
clc;

% Generate Matrix
m=10;
A=randn(m,m);
A=(A+A')/2; % Comment out for non-sym matrix

% Eigenvalues and Eigenvectors 
[V,D]=eigs(A,m);

% Power Iteration Method
v=randn(10,1);
n=200;
lambda=[n,1];

figure(1)
for k=1:n
    omega=A*v;
    v=omega/norm(omega);
    lambda(k)=v'*A*v;
end

% Plot Power Iteration VS eigs Function
plot(1:n,real(lambda),':r','linewidth',[2]);
hold on
yline(real(D(1,1)),'k','linewidth',[2]);
hold off;
xlabel('Number of Iterations');
ylabel('Largest Eigenvalue');
ax=gca;
ax.FontSize=12;
title('Power Iteration Method');
legend('Power Iteration','"eigs"x Function')

%Rayleigh Quotient
c=3500;

for i=1:c
    v=randn(m,1);
    v_new(:,1)=v/norm(v,2);
    
    % Find eigenvalue using RQ
    lam(1)=v_new(:,1)'*A*v_new(:,1); 
    
for j=2:200
    y=(A-lam(j-1)*eye(m,m))\(v_new(:,j-1));
    v_new(:,j)=y/norm(y);
    
    % Find eigenvalue using RQ
    lam(j)=v_new(:,j)'*A*v_new(:,j);
end
eigenvalue(i)=lam(j);
end

% Plot real and imaginery parts of eigenvalues
figure(2)
real_lam=real(eigenvalue);
imaginery_lam=imag(eigenvalue);
real_eigen=real(diag(D));
imaginery_eigen=imag(diag(D));
plot(real_lam,imaginery_lam,'k+',real_eigen,...
    imaginery_eigen,'ro','MarkerSize',15,'linewidth',[1.5]);
xlabel('Real Axis');
ylabel('Imaginery Axis');
ax=gca;
ax.FontSize=12;
title('Eigenvalues');
legend('Eigenvalues from Rayleigh Quotient','Eigenvalues from "eigs" Function')




