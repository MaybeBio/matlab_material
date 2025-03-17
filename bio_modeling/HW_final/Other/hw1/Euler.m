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
    X(i+1)=X(i)+(a1*X(i)-a2*X(i)*Y(i))*t;
    Y(i+1)=Y(i)+(a3*X(i)*Y(i)-a4*Y(i))*t;
end
x=linspace(0.1,50,500);
plot(x,X,x,Y);
legend('金枪鱼','鲨鱼')
xlabel('年')
ylabel('数量')