function slice_result_load
allinfo=get(gcf,'UserData');
image_num=allinfo.slice_page_eh.UserData;
path_filename=[allinfo.slice_filepath,allinfo.slice_filename(image_num).name];
[~,~,filetype]=fileparts(path_filename);
path_filename=strrep(path_filename,filetype,'.mat');
if ~exist(path_filename,'file')
    warndlg('No Existing Result File!','Warning');
    return
end
%载入配准结果
load(path_filename)
if ~exist('atlas_num','var')
    warndlg('No Existing Registration!','Warning');
    return
end
allinfo.atlas_adjust=atlas_adjust;
allinfo.rotation=slice_rotate;
allinfo.trimming=slice_trim;
set(gcf,'UserData',allinfo);
%更新atlas
set(allinfo.atlas_rh,'XData',[570.5,570.5+atlas_adjust(2)*1000*cosd(atlas_adjust(1))],...
    'YData',[450.5,450.5-atlas_adjust(2)*1000*sind(atlas_adjust(1))])
set(allinfo.atlas_page_eh,'String',num2str(atlas_num),'UserData',atlas_num);
atlas_image_show
%旋转、裁剪Slice
slice_ih=allinfo.slice_ih;
slice_ih.CData=imrotate(slice_ih.UserData,slice_rotate,'crop');
slice_ih.CData=slice_ih.CData(1+slice_trim(3):end-slice_trim(4),1+slice_trim(1):end-slice_trim(2),:);
set(allinfo.slice_ah,'Xlim',[0.5,size(slice_ih.CData,2)+0.5],'Ylim',[0.5,size(slice_ih.CData,1)+0.5])
%载入特征点
set(allinfo.atlas_lh,'XData',atlas_point(1,:),'YData',atlas_point(2,:))
set(allinfo.slice_lh,'XData',slice_point(1,:),'YData',slice_point(2,:))
registration_print_number('Atlas')
registration_print_number('Slice')
%标记胞体
slice_sh=allinfo.slice_sh;
if ~isempty(slice_sh.XData)
    h=size(slice_ih.UserData,1);
    w=size(slice_ih.UserData,2);
    x=slice_sh.XData-w/2;
    y=slice_sh.YData-h/2;
    a=allinfo.rotation;
    set(slice_sh,'XData',x.*cosd(-a)-y.*sind(-a)+w/2-allinfo.trimming(1),...
        'YData',x.*sind(-a)+y.*cosd(-a)+h/2-allinfo.trimming(3))
end
%标记ROI
if ~isempty(ROI_point)
    set(allinfo.slice_rh,'XData',[ROI_point(1,:),ROI_point(1,1)],'YData',[ROI_point(2,:),ROI_point(2,1)])
end