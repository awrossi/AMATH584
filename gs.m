%Gram-Schmidt Procedure

m=60;
n=45;

A=randn([m n]);
%A(:,1)=A(:,n);  % For an ill-conditioned matix
Q=zeros(m,n);
R=zeros(m,n);
Q2=zeros(m,n);
R2=zeros(m,n);
Q3=zeros(m,n);
R3=zeros(m,n);

condA=cond(A)


for j=1:n
    V=A(:,j);
    for k=1:j-1
        R(k,j)=Q(:,k)'*A(:,j);  % rjk=qj^* * ak
        V=V-R(k,j)*Q(:,k);      % qn =an-rkj*qi
    end
    R(j,j)=norm(V);
    Q(:,j)=V/R(j,j);            %qn=v/rjj
end

[Q2,R2]=qrfactor(A);
[Q3,R3]=qr(A);

condQ=cond(Q);
condQ2=cond(Q2);
condQ3=cond(Q3);
condR=cond(R);
condR2=cond(R2);
condR3=cond(R3);







