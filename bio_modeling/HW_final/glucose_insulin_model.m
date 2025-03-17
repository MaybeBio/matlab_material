


function dYdt = glucose_insulin_model(t, Y)
% 常数
k1 = 0.1; % 葡萄糖消耗速率常数 (1/min)
k2 = 0.05; % 胰岛素释放速率常数 (1/min)
k3 = 0.05; % 胰高血糖素释放速率常数 (1/min)
k4 = 0.01; % 胰岛素抑制胰高血糖素的速率常数 (1/min)
k5 = 0.01; % 胰高血糖素抑制胰岛素的速率常数 (1/min)
k6 = 0.005; % 胰岛素促使葡萄糖进入细胞的速率常数 (1/min)
k7 = 0.02; % 胰高血糖素促使葡萄糖释放到血液的速率常数 (1/min)


    G = Y(1);
    I = Y(2);
    H = Y(3);

    dGdt = k7 * H - k1 * G - k6 * I * G;
    dIdt = k2 * G - k3 * I - k5 * H * I;
    dHdt = k4 * G - k3 * H - k4 * H * I;

    dYdt = [dGdt; dIdt; dHdt];
end
