a1=0.5;
a2=0.01;
a3=0.015;
a4=0.7;
t=0.1;
X=zeros(1,500);
Y=zeros(1,500);
X(1)=100;
Y(1)=100;
for i=1:499
   Kx1=a1*X(i)-a2*X(i)*Y(i);
   Ky1=a3*X(i)*Y(i)-a4*Y(i);
   Kx2=a1*(X(i)+t*Kx1/2)-a2*(Y(i)+t*Ky1/2)*(X(i)+t*Kx1/2);
   Ky2=a3*(Y(i)+t*Ky1/2)*(X(i)+t*Kx1/2)-a4*(Y(i)+t*Ky1/2);
   Kx3=a1*(X(i)+t*Kx2/2)-a2*(Y(i)+t*Ky2/2)*(X(i)+t*Kx2/2);
   Ky3=a3*(Y(i)+t*Ky2/2)*(X(i)+t*Kx2/2)-a4*(Y(i)+t*Ky2/2);
   Kx4=a1*(X(i)+t*Kx3)-a2*(Y(i)+t*Ky3)*(X(i)+t*Kx3);
   Ky4=a3*(Y(i)+t*Ky3)*(X(i)+t*Kx3)-a4*(Y(i)+t*Ky3);
   
   X(i+1)=X(i)+t*(Kx1+2*Kx2+2*Kx3+Kx4)/6;
   Y(i+1)=Y(i)+t*(Ky1+2*Ky2+2*Ky3+Ky4)/6;
end
x=linspace(0.1,50,500);
plot(x,X,x,Y);
legend('金枪鱼','鲨鱼')
xlabel('年')
ylabel('数量')