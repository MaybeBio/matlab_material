clear all;
close all;
clc;
%% 1.显式Euler法
% 初始化
delta_t = 0.1; 
t_end = 50;
t = 0: delta_t: t_end;
T_iter = zeros(size(t));
S_iter = T_iter;
S_iter(1) = 100;
T_iter(1) = 100;

% 迭代
% MATLAB下标从1开始
for i = (1: t_end / delta_t) + 1
    S_iter(i) = S_iter(i - 1) + delta_t * f_S(S_iter(i - 1), T_iter(i - 1));
    T_iter(i) = T_iter(i - 1) + delta_t * f_T(S_iter(i - 1), T_iter(i - 1));
end

% 可视化迭代结果
figure
plot(t, S_iter, '-o', t, T_iter, '-o')
title('The number of fish (explicit Euler)');
xlabel('Years') ;
ylabel('Numbers') ;
legend({'Shark','Tuna'},'Location','northwest');

% 暂存结果
S_Euler = S_iter;
T_Euler = T_iter;

%% 2.四阶Runge-Kutta法
% 初始化
delta_t = 0.1; 
t_end = 50;
t = 0: delta_t: t_end;
T_iter = zeros(size(t));
S_iter = T_iter;
S_iter(1) = 100;
T_iter(1) = 100;

% 迭代
for i = (1: t_end / delta_t) + 1
    K1_S = f_S(S_iter(i - 1), T_iter(i - 1));
    K1_T = f_T(S_iter(i - 1), T_iter(i - 1));
    K2_S = f_S(S_iter(i - 1) + 0.5*delta_t*K1_S, T_iter(i - 1) + 0.5*delta_t*K1_T);
    K2_T = f_T(S_iter(i - 1) + 0.5*delta_t*K1_S, T_iter(i - 1) + 0.5*delta_t*K1_T);
    K3_S = f_S(S_iter(i - 1) + 0.5*delta_t*K2_S, T_iter(i - 1) + 0.5*delta_t*K2_T);
    K3_T = f_T(S_iter(i - 1) + 0.5*delta_t*K2_S, T_iter(i - 1) + 0.5*delta_t*K2_T);
    K4_S = f_S(S_iter(i - 1) + delta_t*K3_S, T_iter(i - 1) + delta_t*K3_T);
    K4_T = f_T(S_iter(i - 1) + delta_t*K3_S, T_iter(i - 1) + delta_t*K3_T);
    S_iter(i) = S_iter(i - 1) + 1/6 * delta_t * (K1_S + 2*K2_S + 2*K3_S + K4_S);
    T_iter(i) = T_iter(i - 1) + 1/6 * delta_t * (K1_T + 2*K2_T + 2*K3_T + K4_T);
end

% 可视化迭代结果
figure
plot(t, S_iter, '-o', t, T_iter, '-o')
title('The number of fish (4th order Runge-Kutta)');
xlabel('Years') ;
ylabel('Numbers') ;
legend({'Shark','Tuna'},'Location','northeast');

%% 3.ODE45（五阶Runge-Kutta法）
% 初始化
delta_t = 0.1; 
t_end = 50;
t = 0: delta_t: t_end;

% 求解
[t, y] = ode45(@fcn ,t ,[100; 100]);

% 可视化迭代结果
figure
plot(t, y(:, 1), '-o', t, y(:, 2), '-o')
title('The number of fish (ODE45)');
xlabel('Years') ;
ylabel('Numbers') ;
legend({'Shark','Tuna'},'Location','northeast');

% 4th order Runge-Kutta v.s. ODE45
figure
plot(t, y(:, 1), t, y(:, 2), t, S_iter, t, T_iter, t, S_Euler, '--', t, T_Euler, '--')
title('The number of fish');
xlabel('Years') ;
ylabel('Numbers') ;
legend({'Shark(ODE45)','Tuna(ODE45)', ...
    'Shark(4th order Runge-Kutta)','Tuna(4th order Runge-Kutta)', ...
    'Shark(explicit Euler)','Tuna(explicit Euler)'}, ...
    'Location','northwest');

%% 函数定义
function dS = f_S(S, T)
    % a1 = 0.015;
    % a2 = 0.7;
    % dS = a1 * S * T - a2 * S;
    dS = 0.015 * S * T - 0.7 * S;
end

function dT = f_T(S, T)
    % a3 = 0.5;
    % a4 = 0.01;
    % dT = a3 * T - a4 * S * T;
    dT = 0.5 * T - 0.01 * S * T;
end

% 用于ode45的函数，y(1) -> S，y(2) -> T
function dy = fcn(~, y)
    dy = [0.015*y(1)*y(2) - 0.7*y(1); 0.5*y(2) - 0.01*y(1)*y(2)];
end