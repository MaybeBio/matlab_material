% 定义微分方程组和参数
A1 = 0.015; A2 = 0.7; A3 = 0.5; A4 = 0.01;
f = @(t,y) [A1*y(1)*y(2)-A2*y(1); A3*y(2)-A4*y(1)*y(2)];
tspan = [0, 50];
y0 = [100; 100];
h = 0.1;%步长
t = 0.1:h:50;

% 初始化变量
n = length(tspan(1):h:tspan(2));%迭代步数
S = zeros(n, 1);
T = zeros(n, 1);
%S,T用n行1列的全0初始化向量来接住
S(1) = y0(1);
T(1) = y0(2);

% 迭代计算并存储结果，用4阶runge-kutta法迭代
for i = 1:(n-1)
% 第一步
    k1 = f(t(i), [S(i), T(i)])';
    k2 = f(t(i) + 0.5*h, [S(i)+0.5*h*k1(1), T(i)+0.5*h*k1(2)])';
    k3 = f(t(i) + 0.5*h, [S(i)+0.5*h*k2(1), T(i)+0.5*h*k2(2)])';
    k4 = f(t(i) + h, [S(i)+h*k3(1), T(i)+h*k3(2)])';

    S(i+1) = S(i) + h*(1/6)*(k1(1) + 2*k2(1) + 2*k3(1) + k4(1));
    T(i+1) = T(i) + h*(1/6)*(k1(2) + 2*k2(2) + 2*k3(2) + k4(2));
end

% 绘制每一步长上的具体值
t= tspan(1):h:tspan(2);
plot(t, S,'-o',t,T,'-o');
legend('Shark', 'Tuna');
xlabel('时间');
ylabel('鱼的数目');
title('4阶runge-kutta法');