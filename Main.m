clc
clear
 
%% Load Data
Img=LoadData_Slices();
I1=(Img{100});
subplot(1,5,1); imshow(I1); title('original');
H1 = fspecial('motion',10,30);
H2 = fspecial('motion',15,45);
H3 = fspecial('motion',20,60);
H4 = fspecial('motion',30,90);

MotionBlur1 = imfilter(I1,H1,'replicate');
MotionBlur1=imrotate(MotionBlur1,5,'bilinear','crop');
subplot(1,5,2); imshow(MotionBlur1); title('10 30');

MotionBlur2 = imfilter(I1,H2,'replicate');
MotionBlur2=imrotate(MotionBlur2,5,'bilinear','crop');
subplot(1,5,3); imshow(MotionBlur2); title('15 45');

MotionBlur3 = imfilter(I1,H3,'replicate');
MotionBlur3=imrotate(MotionBlur3,10,'bilinear','crop');
subplot(1,5,4); imshow(MotionBlur3); title('20 60');

MotionBlur4 = imfilter(I1,H4,'replicate');
MotionBlur4=imrotate(MotionBlur4,-12,'bilinear','crop');
subplot(1,5,5); imshow(MotionBlur4); title('30 90');