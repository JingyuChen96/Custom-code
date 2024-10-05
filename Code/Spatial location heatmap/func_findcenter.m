function [center_x,center_y,img_out]=func_findcenter(img)

matrix = (img(:,:,1)<30)&(img(:,:,2)<30)&(img(:,:,3)<30);
img2=imfill(~matrix,'holes');          
img3=img2&matrix;                     


imLabel = bwlabel(img3);              
stats = regionprops(img3,'Area');     
area = cat(1,stats.Area);
index = find(area == max(area));      
img4 = ismember(imLabel,index);       


sum_x=0;sum_y=0;area=0;
[height,width]=size(img4);
for ii=1:height
    for j=1:width
        if img4(ii,j)==1
            sum_x=sum_x+ii;
            sum_y=sum_y+j;
            area=area+1;
        end
    end
end

center_x=fix(sum_x/area);
center_y=fix(sum_y/area);
if center_x>3&&center_y>3&&center_x+3<height&&center_y+3<width
    img(center_x-3:center_x+3,center_y-3:center_y+3,1)=0;
    img(center_x-3:center_x+3,center_y-3:center_y+3,2)=255;
    img(center_x-3:center_x+3,center_y-3:center_y+3,3)=0;
else
    img(1,1,1)=0;
    img(1,1,2)=255;
    img(1,1,3)=0;
end;
img_out=img;

end