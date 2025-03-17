% 定义微分方程组和参数
A1 = 0.015; A2 = 0.7; A3 = 0.5; A4 = 0.01;
f = @(t, y) [A1*y(1)*y(2)-A2*y(1); A3*y(2)-A4*y(1)*y(2)];
tspan = [0, 50];
y0 = [100; 100];
h = 0.1;%步长
t=0.1:h:50;

% 初始化变量
n = length(tspan(1):h:tspan(2));%迭代步数
S = zeros(n, 1);
T = zeros(n, 1);
%S,T用n行1列的全0初始化向量来接住
S(1) = y0(1);
T(1) = y0(2);
% 迭代计算并存储结果，用欧拉式迭代
for i = 1:(n-1)
   y = [S(i), T(i)] + h*f(t(i), [S(i), T(i)])';
   S(i+1) = y(1);
   T(i+1) = y(2);
end
% 绘制每一步长上的具体值
t = tspan(1):h:tspan(2);
plot(t, S,'-o',t,T,'-o');
legend('Shark', 'Tuna');
xlabel('时间');
ylabel('鱼的数目');
title('显式欧拉法');

