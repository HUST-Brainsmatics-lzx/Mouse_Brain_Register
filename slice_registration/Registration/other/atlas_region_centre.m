%% 合并脑区，计算中心点
load('Atlas.mat')
pic_region_all=pic_region_all(1:2:end,1:2:570,1:2:end);%降采样、取半脑
id=[];
position=zeros(length(id),3);
for i=id
    temp=zeros(size(pic_region_all));
    for j=1:length(region_parent{i},1)
        temp=temp+(pic_region_all==region_parent{i}(j));
    end
    temp_d=bwdist(~temp);
    [x,y]=find(temp_d==max(temp_d(:)));
    z=ceil(y/size(pic_region_all,2));
    y=y-(z-1)*size(pic_region_all,2);
    position(i,:)=[x(1),y(1),z(1)];
end