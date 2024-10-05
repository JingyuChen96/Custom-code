clear all
close all

GuangXian_Name='D:\Code\Fiber\MGB-pre-example.xlsx';
Select_GuangXian_Channel=1;
GuangXian_time=3; %分钟为单位

GuangXian_Data=xlsread(GuangXian_Name);
GuangXian_Data=GuangXian_Data(:,Select_GuangXian_Channel+1);
k=GuangXian_Data;
m=mean(k);
s=std(k,0);
plot(k,'LineWidth',1.5);
ylabel('deltaF/F');
xlabel('Time(s)');
axis([0,length(k),min(k)-1,max(k)+2]);
hold on;
plot([0,length(k)],[m,m],'k');
hold on;
t=m+s;
plot([0,length(k)],[t,t],'k--');
hold on;
[amp,dec,firerate]=func_calculate_spike(k,m,s,GuangXian_time);
