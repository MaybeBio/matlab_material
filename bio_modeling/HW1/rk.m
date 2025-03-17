f = @(t, y) [0.015*y(1)*y(2)-0.7*y(1); 0.5*y(2)-0.01*y(1)*y(2)];
tspan=[0:0.1:50];
y0=[100;100];
[t, y] = ode45(f, tspan, y0);
plot(t, y(:, 1),'-o', t, y(:, 2),'-o');
title('ode45求解+离散');
legend('Shark', 'Tuna');
xlabel('时间');
ylabel('鱼的数目');