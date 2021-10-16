function atlas_image_show
allinfo=get(gcf,'UserData');
[X,Y]=meshgrid(1:1140,1:900);
a=allinfo.atlas_adjust(1);
d=allinfo.atlas_adjust(2);
page_num=get(allinfo.atlas_page_eh,'UserData');
if d~=0
    page_offset=min(max(round((sind(a)*(Y-450.5)-cosd(a)*(X-570.5))*d)+page_num,1),1320);%d为俯仰角tan值
else
    page_offset=zeros(900,1140)+page_num;
end
pic=zeros(900,1140,'uint16');
pic_region_all=get(allinfo.atlas_ah,'UserData');
pic(:)=pic_region_all(Y(:)+(X(:)-1)*900+(page_offset(:)-1)*900*1140);
pic=atlas_add_boundary(pic);
set(allinfo.atlas_ah,'XLim',[0.5,1140.5],'YLim',[0.5,900.5])
set(allinfo.atlas_ih,'CData',pic)
set(allinfo.atlas_ph,'XData',[],'YData',[])