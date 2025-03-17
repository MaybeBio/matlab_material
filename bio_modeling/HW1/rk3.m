% 定义参数
A1 = 0.015; A2 = 0.7; A3 = 0.5; A4 = 0.01;
tspan = [0, 50];
h = 0.1;%步长

% 初始化变量
n = length(tspan(1):h:tspan(2));%迭代步数
S = zeros(n, 1);
T = zeros(n, 1);
%S,T用n行1列的全0初始化向量来接住
S(1) = 100;
T(1) = 100;

% 迭代计算并存储结果，用欧拉式迭代
for i = 1:(n-1)
    S(i+1) = S(i) + h*(A1*S(i)*T(i) - A2*S(i));
    T(i+1) = T(i) + h*(A3*T(i) - A4*S(i)*T(i));
end

% 绘制每一步长上的具体值
t = tspan(1):h:tspan(2);
plot(t, S,'-o',t,T,'-o');
legend('Shark', 'Tuna');
xlabel('时间');
ylabel('鱼的数目');
title('显式欧拉法');
