% 参数
G0 = 100; % 初始血糖浓度 (mg/dL)
I0 = 10; % 初始胰岛素浓度 (μU/mL)
H0 = 100; % 初始胰高血糖素浓度 (pg/mL)
t_total = 1440; % 模拟总时间 (分钟)

% 常数
k1 = 0.1; % 葡萄糖消耗速率常数 (1/min)
k2 = 0.05; % 胰岛素释放速率常数 (1/min)
k3 = 0.05; % 胰高血糖素释放速率常数 (1/min)
k4 = 0.01; % 胰岛素抑制胰高血糖素的速率常数 (1/min)
k5 = 0.01; % 胰高血糖素抑制胰岛素的速率常数 (1/min)
k6 = 0.005; % 胰岛素促使葡萄糖进入细胞的速率常数 (1/min)
k7 = 0.02; % 胰高血糖素促使葡萄糖释放到血液的速率常数 (1/min)

init = [G0; I0; H0];
% 时间向量
t = 0:1:t_total;

% 解微分方程
[t, Y] = ode45(@glucose_insulin_model, t, init);

% 绘制结果
figure;
plot(t, Y(:,1), 'r', 'LineWidth', 2); % 葡萄糖浓度
hold on;
plot(t, Y(:,2), 'b', 'LineWidth', 2); % 胰岛素浓度
plot(t, Y(:,3), 'g', 'LineWidth', 2); % 胰高血糖素浓度
xlabel('Time (min)');
ylabel('Concentration');
legend('Glucose', 'Insulin', 'Glucagon');
title('Glucose-Insulin-Glucagon Regulation System');
grid on;
