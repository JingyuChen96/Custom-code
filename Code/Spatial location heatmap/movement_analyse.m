clc;
clear;
close all;
load('F:\movementdata.mat');
frame_rate=15;

%% 视频分析
% 输出旷场视频中心区域时间百分比、边缘区域时间百分比、总距离
    position_x(1)=[];
    position_y(1)=[];
    xmin=75;
    xmax=570;
    ymin=65;
    ymax=430;
    length_x=xmax-xmin;
    length_y=ymax-ymin;
    x1=xmin+length_x/4;
    y1=ymin+length_y/4;

    total_distance=sum(distance_a(1:frame_rate*60*30),'omitnan');
 
    p=0;
    for i=1:frame_rate*60*30;
        if position_x(i)>=xmin+0.25*(xmax-xmin)&position_x(i)<=xmax-0.25*(xmax-xmin)&position_y(i)>=ymin+0.25*(ymax-ymin)&position_y(i)<=ymax-0.25*(ymax-ymin);
            p=p+1;
        end
    end
    time_center=p/(frame_rate*60*30);
    time_around=(i-p)/(frame_rate*60*30);
    
% 输出热图
    figure(1)
    p=640/100;
    q=480/100;
    for i=1:100
       for k=1:100
          a=find(position_x>(i-1)*p&position_x<=p*i);
          b=find(position_y(a)>(k-1)*q&position_y(a)<=k*q);
          d(k,i)=length(b);
       end
    end
    h=[1,2,3,4,5,4,3,2,1];
    for i=1:length(d)
         d(i,:)=func_smooth(d(i,:),h) ; 
         d(:,i)=func_smooth(d(:,i),h);
    end
    imagesc(d,'CDataMapping','scaled');
    colormap(jet);
    colorbar;
    axis xy
    set(gca,'CLim',[0 15],'TickDir','out');
