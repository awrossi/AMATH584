% Matrix Conditioning 

m=50;
n=45;

S=randn([m-50 n-50]);
A=randn([m n]);
B=randn([m+50 n+50]);
C=randn([m+100 n+100]);

% As the size of the matrix increases, the condition number increases. 

condA=cond(A);
condB=cond(B);
condC=cond(C);
condS=cond(S);

A(:,n+1)=A(:,1);  % append column equal to the first column.

condA2=cond(A);

noise=1E-15; 
%can also change order of magnitude. For example, noise=1E-5 would have a
%smaller condition number than noise=1E-15

for i=1:10
    
    A(:,n+1)=A(:,n+1)+ i*noise*rand(m,1);
    condA3(i)=cond(A);
end    

%Condition number decreases as i increases.
