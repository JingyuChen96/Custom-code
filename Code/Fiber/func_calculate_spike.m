function [amp,dec,firerate,high_threshold]=func_calculate_spike(k,m,s,time)
% %% 画曲线及均值线、阈值线
% plot(k);
% ylabel('deltaF/F');
% xlabel('Time(s)');
% axis([0,length(k),min(k)-1,max(k)+2]);
% hold on;
% plot([0,length(k)],[m,m]);
% hold on;
% t=m+s;
% plot([0,length(k)],[t,t],'--');
% hold on;
%% 计算阈上时间
t=m+s;
high_threshold=length(find(k>t));
%% 找到峰值位置
t=m+s;
p=0;
q=0;
i=[];
j=[];
%取峰的终点
for x=1:length(k)-1;
    if (k(x)>t & k(x+1)<t);
        p=p+1;
        i(p)=x;
    end
end
%取峰的起点
for x=1:length(k)-1;
    if (k(x)<t&k(x+1)>t);
        q=q+1;
        j(q)=x;
    end
end
if isempty(i)==0 & isempty(j)==0
    
%如果对应第一个点没有起点
if i(1)<j(1);
    for q=1:length(j)
    jj(q+1)=j(q);%jj暂时的起点矩阵jj(2)=j(1)
    end
    jj(1)=1;%把空着的jj（1）补上，把第一个点当成起点
    j=jj(1,:);
end

%如果对应最后一给点没有终点
if j(end)>i(end);%在这段中把最后一个点设置成最后一个终点
    a=length(i);
    i(a+1)=x(end);
end
%取起点和终点的最大值
b=length(j);
o=0;
spike_x=[];
for p=1:b
    w=find(k(j(p):i(p))==max(k(j(p):i(p))))+j(p)-1;
    w=w(1);
    spike_x=[spike_x w];
    y=repelem(max(k)+0.1,length(w));
    scatter(w,y,50,'.','k');
    hold on;
    o=o+1;
    ww(o)=max(k(j(p):i(p)));
end

%% 求spike amplitude和decay
v=0;
dec=[];
amp=[];
for e=1:b
    v=v+1;
    amp(v)=ww(e)-m;
    
    halfdec_amp=(ww(e)+m)/2;
    half_n=0;
    for x=1:length(k)-1;
       if (k(x)>halfdec_amp & k(x+1)<halfdec_amp);
           half_n=half_n+1;
           halfdec_x1(half_n)=x;
       end
    end
    half_n=0;
    for x=1:length(k)-1;
       if (k(x)<halfdec_amp & k(x+1)>halfdec_amp);
           half_n=half_n+1;
           halfdec_x2(half_n)=x;
       end
    end
    
    if exist('halfdec_x1','var')==1 && exist('halfdec_x2','var')==1 && length(halfdec_x1)>=1 && length(halfdec_x2)>=1
       if halfdec_x2(1)>halfdec_x1(1)
           if e==1
               dec(v)=0;
           else
               halfdec_x1(1)=[];
           end
       end
    else
        dec(v)=0;
    end
    
    if exist('halfdec_x1','var')==1 && exist('halfdec_x2','var')==1 && length(halfdec_x1)>=1 && length(halfdec_x2)>=1
        if halfdec_x2(length(halfdec_x2))>halfdec_x1(length(halfdec_x1))
            if e==b
                dec(v)=0;
            else
                halfdec_x2(length(halfdec_x2))=[];
            end
        end
    else
        dec(v)=0;
    end
    
    if exist('halfdec_x1','var')==1 && exist('halfdec_x2','var')==1 && length(halfdec_x1)>=1 && length(halfdec_x2)>=1
        halfdec_xx1=halfdec_x1-spike_x(e);
        [x1_m,x1_n]=find(halfdec_xx1>=0);
        halfdec_x1=halfdec_xx1(min(x1_n));
    
        halfdec_xx2=halfdec_x2-spike_x(e);
        [x2_m,x2_n]=find(halfdec_xx2<=0);
        halfdec_x2=abs(halfdec_xx2(max(x2_n)));
        if length(dec)<v
            if length(halfdec_x1)>0 && length(halfdec_x2)>0
                dec(v)=halfdec_x1+halfdec_x2;
            else
                dec(v)=0;
            end
        end
    end   
    clear x1_m x1_n x2_m x2_n halfdec_x1 halfdec_x2 halfdec_xx1 halfdec_xx2
end

dec(find(dec==0))=[];

meanamp=mean(amp);
firerate=length(ww)/time;
title(strcat('meanamp=',num2str(meanamp),'    firerate=',num2str(firerate)));

else
    amp=[];
    dec=[];
    firerate=0;
    title(strcat('meanamp=0    firerate=0'));
end