%% 读取光纤数据
clear all; clc; close all;
Pool_FileName='D:\Code\Fiber-ROI\NaSal-OA-CA.xlsx';
[num_pool, txt_pool, raw_pool]=xlsread(Pool_FileName);
cut_GuangXian_pool = num_pool;
GuangXian_rate=15;
X=2;Y=5;


%% 以进入ROI前X秒的光线数据为baseline进行校准，同时计算后Y秒的曲线下面积
% --------------------------------计算并绘图--------------------------------
deltaF_cut_GuangXian_pool=[];
deltaF_cut_GuangXian_postAUC_pool=[];
for i = 1:size(cut_GuangXian_pool,1)
    pre_GuangXian = cut_GuangXian_pool(i,1:X*GuangXian_rate);
    baseline = mean(pre_GuangXian);
    baseline_SD = std(pre_GuangXian);
    deltaF_cut_GuangXian = (cut_GuangXian_pool(i,:) - baseline)/baseline_SD;
    deltaF_cut_GuangXian = deltaF_cut_GuangXian/2;
    deltaF_cut_GuangXian_pool = [deltaF_cut_GuangXian_pool;deltaF_cut_GuangXian];
    deltaF_cut_GuangXian_post = deltaF_cut_GuangXian(X*GuangXian_rate+1:end);
    deltaF_cut_GuangXian_postAUC = sum((deltaF_cut_GuangXian_post(1:end-1) + deltaF_cut_GuangXian_post(2:end)) / GuangXian_rate / 2);
    deltaF_cut_GuangXian_postAUC_pool = [deltaF_cut_GuangXian_postAUC_pool;deltaF_cut_GuangXian_postAUC];
end

figure(3)
imagesc(deltaF_cut_GuangXian_pool);
caxis([-5 5]);
colormap(jet);
colorbar;

figure(2)
means = mean(deltaF_cut_GuangXian_pool, 1);
SEM = std(deltaF_cut_GuangXian_pool, 0, 1)/ sqrt(size(deltaF_cut_GuangXian_pool,1));
upper_bound = means + SEM;
lower_bound = means - SEM;
x = 1:size(deltaF_cut_GuangXian_pool, 2);
plot(x, means, '-', 'Color',[0.1 0.1 0.1], 'LineWidth', 2);
hold on;
% fill([x fliplr(x)], [upper_bound' fliplr(lower_bound')], [0.1 0.1 0.1], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
fill([x fliplr(x)], [upper_bound fliplr(lower_bound)], [0.1 0.1 0.1], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
ylim([-7 7]);

