import numpy as np
import os
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications.vgg16 import VGG16
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Flatten, Dense, Dropout
from sklearn.svm import SVC
from sklearn.metrics import confusion_matrix, classification_report
import tkinter as tk
from tkinter import filedialog
# # 加载数据集




train_dir = r"E:\ChestXRay2017\chest_xray\train"
test_dir = r"E:\ChestXRay2017\chest_xray\test"

train_datagen = ImageDataGenerator(rescale=1./255)#像素值归一化[0,255]-》[0,1]降低数据尺度,加快收敛,提高效率
test_datagen = ImageDataGenerator(rescale=1./255)

train_data = train_datagen.flow_from_directory(train_dir, target_size=(224, 224), batch_size=2, classes=['NORMAL', 'PNEUMONIA'], class_mode='binary')
test_data = test_datagen.flow_from_directory(test_dir, target_size=(224, 224), batch_size=2, classes=['NORMAL', 'PNEUMONIA'], class_mode='binary')

# 构建模型
vgg_model = VGG16(weights='imagenet', include_top=False, input_shape=(224, 224, 3))#构建VGG,权重为开源网站提供权重
model = Sequential()#Sequential()函数创建顺序模型
model.add(vgg_model)#将VGG16模型添加到顺序模型中
model.add(Flatten())#将卷积层输出的特征图矩阵展开成一维的向量
# model.add(Dense(128, activation='relu'))#使用Dense()函数在模型中添加一个256个神经元的全连接层，并指定激活函数为ReLU
# model.add(Dropout(0.5)) #使用Dropout()函数添加一个50%的 Dropout 正则化层，以防止过拟合
model.add(Dense(1, activation='sigmoid'))#使用Dense()函数再添加一个神经元为1的输出层，并指定激活函数为Sigmoid
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy', tf.keras.metrics.Precision(), tf.keras.metrics.Recall(), tf.keras.metrics.AUC()])

print("模型构造完成")
#使用model.compile()方法进行模型的配置，ptimizer：优化器，使用Adam。loss：损失函数，使用二进制交叉熵。metrics：评估模型的指标
model.summary()#使用model.summary()函数来输出模型的结构信息，包括每一层的输出形状和参数数量等。
# 训练模型
history = model.fit(train_data, epochs=1, validation_data=test_data)
print("VGG网络训练模型完成")
# 提取特征
train_features = model.predict(train_data, verbose=1)#返回模型的预测结果
test_features = model.predict(test_data, verbose=1)

train_labels = np.where(train_data.classes == 0, -1, 1)
test_labels = np.where(test_data.classes == 0, -1, 1)


print("特征提取完成")
# 将特征输入SVM分类器
svm_model = SVC(kernel='linear', random_state=10)
svm_model.fit(train_features, train_labels)
print("SVM分类器训练")
# 预测测试数据
test_pred = svm_model.predict(test_features)

# 计算准确率、精确率、召回率等参数
# acc = svm_model.score(test_features, test_labels)
# cm = confusion_matrix(test_labels, test_pred)
# cf_report = classification_report(test_labels, test_pred)
# print("Accuracy: {:.2f}%".format(acc*100))
# print("Confusion matrix:\n", cm)
# print("Classification report:\n", cf_report)


#选择图像打开并且判断图像类型
while True:
    root = tk.Tk()
    root.withdraw() # 隐藏主窗口

    new_dir = filedialog.askdirectory() # 打开文件夹对话框
    if not new_dir: # 如果点击取消，则退出循环
        break

    new_data = test_datagen.flow_from_directory(os.path.join(new_dir, "test_new"), target_size=(224, 224), batch_size=1, shuffle=False, class_mode=None)

    new_features = model.predict(new_data, verbose=1)
    new_pred = svm_model.predict(new_features)

    for filename, pred in zip(new_data.filenames, new_pred):
        print("File name:", filename)
        if pred == -1:
            print("This is a NORMAL chest X-ray.")
        else:
            print("This is a PNEUMONIA chest X-ray.")
