load RostSanderDataset.mat

N = numel(allSeq);

id = allSeq(7).Header            % 给定蛋白质序列的注释
seq = int2aa(allSeq(7).Sequence) % 蛋白质序列
str = allSeq(7).Structure        % 结构分配

%%

rng(savedState);

%% 定义网络架构

W = 17; % 滑动窗口大小

% === 输入的二值化
for i = 1:N
	seq = double(allSeq(i).Sequence);   % 当前序列
	win = hankel(seq(1:W),seq(W:end));  % 所有可能的滑动窗口
	myP = zeros(20*W,size(win,2));      % 对于当前序列的输入矩阵
	for k = 1:size(win, 2)
		index = 20*(0:W-1)' + win(:,k); % 每个位置k的输入数组
		myP(index,k) = 1;
	end
	allSeq(i).P = myP;
end

%% 

cr = ceil(W/2); % 中心残馀位置

% === 目标二值化
for i = 1:N
	str = double(allSeq(i).Structure); % 当前结构分配
    win = hankel(str(1:W),str(W:end)); % 所有可能的滑动窗口
	myT = false(3,size(win,2));
	myT(1,:) = win(cr,:) == double('C');
	myT(2,:) = win(cr,:) == double('E');
	myT(3,:) = win(cr,:) == double('H');
	allSeq(i).T = myT;
end

%%

% === 输入和目标的简明二值化
for i = 1:N
	seq = double(allSeq(i).Sequence);
    win = hankel(seq(1:W),seq(W:end)); % 并发输入(滑动窗口)
	
	% === 输入矩阵的二值化
	allSeq(i).P = kron(win,ones(20,1)) == kron(ones(size(win)),(1:20)');
	
	% === 目标矩阵的二值化
	allSeq(i).T = allSeq(i).Structure(repmat((W+1)/2:end-(W-1)/2,3,1)) == ...
		 repmat(('CEH')',1,length(allSeq(i).Structure)-W+1);
end

%%

% === 构造输入矩阵和目标矩阵
P = double([allSeq.P]); % 输入矩阵
T = double([allSeq.T]); % 目标矩阵

%% 创建神经网络

hsize = 3;
net = patternnet(hsize);
net.layers{1} % 隐藏层
net.layers{2} % 输出层

%% 训练神经网络

% === 使用log sigmoid作为传递函数
net.layers{1}.transferFcn = 'logsig';

% === 训练网络
[net,tr] = train(net,P,T);

%%
view(net)

%% 

[i,j] = find(T(:,tr.trainInd));
Ctrain = sum(i == 1)/length(i);
Etrain = sum(i == 2)/length(i);
Htrain = sum(i == 3)/length(i);

[i,j] = find(T(:,tr.valInd));
Cval = sum(i == 1)/length(i);
Eval = sum(i == 2)/length(i);
Hval = sum(i == 3)/length(i);

[i,j] = find(T(:,tr.testInd));
Ctest = sum(i == 1)/length(i);
Etest = sum(i == 2)/length(i);
Htest = sum(i == 3)/length(i);

figure()
pie([Ctrain; Etrain; Htrain]);
title('训练数据集的结构赋值');
legend('C', 'E', 'H')

figure()
pie([Cval; Eval; Hval]);
title('验证数据集中的结构赋值');
legend('C', 'E', 'H')

figure()
pie([Ctest; Etest; Htest]);
title('测试数据集的结构分配');
legend('C', 'E', 'H')


%%

figure()
plotperform(tr)

%%

% === 显示训练参数
net.trainParam

% === 图像验证检查和梯度
figure()
plottrainstate(tr)

%% 分析网络响应

O = sim(net,P);
figure()
plotconfusion(T,O);

%%
figure()
plotroc(T,O);

%%

hsize = [3 4 2];
net3 = patternnet(hsize);

hsize = 20;
net20 = patternnet(hsize);

%%

% === 给权重分配-.1和.1范围内的随机值
net20.IW{1} = -.1 + (.1 + .1) .* rand(size(net20.IW{1}));
net20.LW{2} = -.1 + (.1 + .1) .* rand(size(net20.LW{2}));

%%

net20 = train(net20,P,T);

O20 = sim(net20,P);
numWeightsAndBiases = length(getx(net20))

%% 评估网络性能

[i,j] = find(compet(O));
[u,v] = find(T);

% === 当观察到给定状态时，计算正确预测的分数
pcObs(1) = sum(i == 1 & u == 1)/sum (u == 1); % 状态 C 
pcObs(2) = sum(i == 2 & u == 2)/sum (u == 2); % 状态 E
pcObs(3) = sum(i == 3 & u == 3)/sum (u == 3); % 状态 H

% === 当预测给定状态时，计算正确预测的分数
pcPred(1) = sum(i == 1 & u == 1)/sum (i == 1); % 状态 C
pcPred(2) = sum(i == 2 & u == 2)/sum (i == 2); % 状态 E
pcPred(3) = sum(i == 3 & u == 3)/sum (i == 3); % 状态 H 

% === 比较预测质量指标
figure()
bar([pcObs' pcPred'] * 100);
ylabel('正确预测位置 (%)');
ax = gca;
ax.XTickLabel = {'C';'E';'H'};
legend({'观察值','预测值'});
