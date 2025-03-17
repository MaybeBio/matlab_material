%% 第一个数据集
load('weight_lung_dataset.mat');
plot(Weight,Lung,'o');
xlabel('weight');
ylabel('lung');

%% 第二个数据集
load('height_weight_lung_dataset.mat');
scatter3(Height,Weight,Lung);
xlabel('Height');
ylabel('Weight'); 
zlabel('Lung Capacity'); 
%% 第三个数据集
load('plasma_tracer_dataset.mat');
plot(Time,Plasma,'o');
xlabel('time');
ylabel("plasma");


