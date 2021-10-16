function slice_image_show
allinfo=get(gcf,'UserData');
%载入图像
image_num=get(allinfo.slice_page_eh,'UserData');
image_file=[allinfo.slice_filepath,allinfo.slice_filename(image_num).name];
pic=uint8(double(imread(image_file))/225*255+30);%增加亮度
%pic=imread(image_file);
set(allinfo.slice_ih,'CData',pic,'UserData',pic)
set(allinfo.slice_ah,'XLim',[0.5,size(pic,2)],'YLim',[0.5,size(pic,1)])
set(allinfo.slice_path_th,'String',image_file)
%清除旋转裁剪参数及特征点
allinfo.trimming=[0,0,0,0];
allinfo.rotation=0;
set(gcf,'UserData',allinfo)
set(allinfo.slice_lh,'XData',[],'YData',[])
set(allinfo.slice_rh,'XData',[],'YData',[],'UserData',[])
delete(findobj(allchild(allinfo.slice_ah),'Type','Text'))
%载入mat文件
[~,~,filetype]=fileparts(image_file);
path_filename=strrep(image_file,filetype,'.mat');
if exist(path_filename,'file')
    load(path_filename)
else
    return
end
%标记胞体信息
if exist('cell_info','var')&&~isempty(cell_info)
    cell_position=cat(1,cell_info.Centroid)*parameter.zoom_rate;
    set(allinfo.slice_sh,'XData',cell_position(:,1),'YData',cell_position(:,2),'UserData',cell_position')
end
%标记脑区名
if exist('cell_region_name','var')
    region_frequency=tabulate(cell_region_name);%统计各脑区信号个数
    for i=1:length(region_frequency)
        id=find(ismember(cell_region_name,region_frequency{i,1}));%任意脑区胞体索引
        for j=1:round(region_frequency{i,2}^0.5):region_frequency{i,2}
            text(allinfo.slice_ah,cell_point(id(j),1),cell_point(id(j),2),cell_region_name{id(j)},...
                'Color','c','Tag','Signal','Clipping','on','Visible',get(allinfo.slice_sh,'Visible'))
        end
    end
%配准信息
elseif exist('atlas_num','var') && ~strcmp(get(gco,'String'),'Go')
    slice_result_load
end