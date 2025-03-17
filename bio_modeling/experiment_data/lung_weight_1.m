function [fitresult, gof] = createFit(Weight, Lung)
%CREATEFIT(WEIGHT,LUNG)
%  创建一个拟合。
%
%  要进行 '肺活量-体重' 拟合的数据:
%      X 输入: Weight
%      Y 输出: Lung
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 06-Apr-2023 20:41:14 自动生成


%% 拟合: '肺活量-体重'。
[xData, yData] = prepareCurveData( Weight, Lung );

% 设置 fittype 和选项。
ft = fittype( 'poly1' );

% 对数据进行模型拟合。
[fitresult, gof] = fit( xData, yData, ft );

% 绘制数据拟合图。
figure( 'Name', '肺活量-体重' );
h = plot( fitresult, xData, yData );
legend( h, 'Lung vs. Weight', '肺活量-体重', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
xlabel( 'Weight', 'Interpreter', 'none' );
ylabel( 'Lung', 'Interpreter', 'none' );
grid on


