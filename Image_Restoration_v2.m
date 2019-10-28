close all;
clear ;
clc;

a = 0.1; %x 方向上的秒速度
b = 0.1; %y方向上的秒速度
T = 1; % 快门时间
syms i;


i = imread("mypic1.png");
i =rgb2gray(i);
Fi = fft2(i);
[h,w]=size(Fi);
H=[];

for u=1:h
    for v =1:w
        A =pi.*(u.*a+v.*b);
        H(u,v) = (T./A).*sin(A).*exp(-1i.*A);%退化函数
    end
end
Gi=Fi.*H; %频域退化

gi = ifft2(Gi); %逆变换

figure,
subplot(1,2,1),imshow(i),title("原图");

subplot(1,2,2),imshow(uint8(gi)),title("建模估计 运动模糊");

Gi1 = fft2(double(gi)); 
%sign =uint8(Gi1-Gi)

noise = imnoise(zeros(h,w),'gaussian',0,0.00005);%gaussian noise 
Fnoise = fft2(noise);%加性噪声谱
Gnoise = Gi+Fnoise;%噪声图像谱

gnoise = ifft2(Gnoise);%噪声图像
figure,
imshow(uint8(gnoise)),title("gaussian");

Fhat = Gnoise ./H; %全域逆滤波
fhat = ifft2(Fhat); 
figure,subplot(1,2,1),imshow(uint8(fhat)),title("全域逆滤波 ");

Fhat2 =(Gnoise -Fnoise)./H; %噪声图像谱-噪声谱
fhat2 = ifft2(Fhat2);
subplot(1,2,2),imshow(uint8(fhat2)),title("在已知噪声谱的情况下逆滤波");

%窗口滤波
%待实现


%维纳滤波 
%k=(Fnoise.*conj(Fnoise))./(Gi.*conj(Gi));
k=0;
W = (1./H).*(H.*conj(H))./(H.*conj(H)+k);
Fhat3 = Gnoise .*W; %全域逆滤波
fhat3 = ifft2(Fhat3); 
figure,imshow(uint8(fhat3)),title("维纳滤波 ");