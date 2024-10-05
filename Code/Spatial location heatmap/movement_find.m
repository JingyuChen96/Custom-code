clc; clear all; close all;
targetavi = 'H:\video.mp4';
%% 读取视频
mov = VideoReader(targetavi);
fnum = mov.NumberOfFrames;

%% 建立结果视频
abc='ccav.avi';
writerObj = VideoWriter(abc);
writerObj.FrameRate = 8.3;
open(writerObj);

t=0;
m=sin(t);
p = plot(t,m,'EraseMode','background','MarkerSize',5);
x=-1.5*pi;
diff_value=zeros(100,1); 
axis([0 250 0 200]);

position_x=zeros(fnum,1);
position_y=zeros(fnum,1);
distance_a=zeros(fnum,1);

figure(1);
for i = 2 : 1000
      img= read(mov, i-1);
      [center_x,center_y,img_out]=func_findcenter(img);
      writeVideo(writerObj,img_out);
      position_x(i)=center_x;
      position_y(i)=center_y;
      distance_a(i)=sqrt((position_x(i)-position_x(i-1))^2+(position_y(i)-position_y(i-1))^2);
end
%% 跳点数据处理
t1=0:300;
m1=0.01*sin(t1);
Len=length(distance_a);
Threshold=30;
for i=2:Len-3
    if distance_a(i)>=Threshold
     distance_a(i)=0;
     position_x(i:i+10)=position_x(i-1);
     position_y(i:i+10)=position_y(i-1);
    end
end

%% 关闭视频句柄
save('movementdata.mat','position_x','position_y','distance_a');
close(writerObj);

