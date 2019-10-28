close all;
clear ;
clc;

a = 0.1; %x �����ϵ����ٶ�
b = 0.1; %y�����ϵ����ٶ�
T = 1; % ����ʱ��
syms i;


i = imread("mypic1.png");
i =rgb2gray(i);
Fi = fft2(i);
[h,w]=size(Fi);
H=[];

for u=1:h
    for v =1:w
        A =pi.*(u.*a+v.*b);
        H(u,v) = (T./A).*sin(A).*exp(-1i.*A);%�˻�����
    end
end
Gi=Fi.*H; %Ƶ���˻�

gi = ifft2(Gi); %��任

figure,
subplot(1,2,1),imshow(i),title("ԭͼ");

subplot(1,2,2),imshow(uint8(gi)),title("��ģ���� �˶�ģ��");

Gi1 = fft2(double(gi)); 
%sign =uint8(Gi1-Gi)

noise = imnoise(zeros(h,w),'gaussian',0,0.00005);%gaussian noise 
Fnoise = fft2(noise);%����������
Gnoise = Gi+Fnoise;%����ͼ����

gnoise = ifft2(Gnoise);%����ͼ��
figure,
imshow(uint8(gnoise)),title("gaussian");

Fhat = Gnoise ./H; %ȫ�����˲�
fhat = ifft2(Fhat); 
figure,subplot(1,2,1),imshow(uint8(fhat)),title("ȫ�����˲� ");

Fhat2 =(Gnoise -Fnoise)./H; %����ͼ����-������
fhat2 = ifft2(Fhat2);
subplot(1,2,2),imshow(uint8(fhat2)),title("����֪�����׵���������˲�");

%�����˲�
%��ʵ��


%ά���˲� 
%k=(Fnoise.*conj(Fnoise))./(Gi.*conj(Gi));
k=0;
W = (1./H).*(H.*conj(H))./(H.*conj(H)+k);
Fhat3 = Gnoise .*W; %ȫ�����˲�
fhat3 = ifft2(Fhat3); 
figure,imshow(uint8(fhat3)),title("ά���˲� ");