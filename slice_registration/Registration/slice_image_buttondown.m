function slice_image_buttondown
allinfo=get(gcf,'UserData');
slice_lh=allinfo.slice_lh;
atlas_lh=allinfo.atlas_lh;
set(allinfo.slice_sh,'Visible','off')
if isempty(slice_lh.XData) && (allinfo.slice_ch.Value==1) && ~isempty(atlas_lh.XData)
    % copy
    pic_atlas=allinfo.atlas_ih.CData;
    x=[find(sum(pic_atlas,1)>0,1)-10,find(sum(pic_atlas,1)>0,1,'last')+10];
    y=[find(sum(pic_atlas,2)>0,1)-10,find(sum(pic_atlas,2)>0,1,'last')+10];
    slice_lh.XData=(atlas_lh.XData-x(1))/diff(x)*diff(allinfo.slice_ah.XLim)+allinfo.slice_ah.XLim(1);
    slice_lh.YData=(atlas_lh.YData-y(1))/diff(y)*diff(allinfo.slice_ah.YLim)+allinfo.slice_ah.YLim(1);
    slice_lh.XData=max(1,min(size(allinfo.slice_ih.CData,2),slice_lh.XData));
    slice_lh.YData=max(1,min(size(allinfo.slice_ih.CData,1),slice_lh.YData));
    atlas_lh.XData=max(x(1),min(x(2),atlas_lh.XData));
    atlas_lh.YData=max(y(1),min(y(2),atlas_lh.YData));
    set(allinfo.atlas_ah,'Xlim',x,'Ylim',y)
    set(allinfo.slice_ah,'Xlim',[0,size(allinfo.slice_ih.CData,2)]+0.5,'Ylim',[0,size(allinfo.slice_ih.CData,1)]+0.5)
    set(allinfo.slice_mov_rh,'Value',1)
    set(allinfo.atlas_mov_rh,'Value',1)
else
    mode=get(findobj(allchild(allinfo.slice_bgh),'Style','RadioButton','Value',1),'String');
    if strcmp(get(gcf,'SelectionType'),'alt')
        mode='Delete';
    end
    location=get(gca,'CurrentPoint');
    location=[location(1),location(3)];
    if strcmp(mode,'Add')
        slice_lh.XData(end+1)=location(1);
        slice_lh.YData(end+1)=location(2);
    elseif strcmp(mode,'Insert')
        point_num=inputdlg('Please enter the number as the order of insert point','Insert Feature Point',[1,50]);
        if ~isempty(point_num)&&~isnan(str2double(point_num{1}))
            point_num=min(max(round(str2double(point_num)),1),length(slice_lh.XData)+1);
            slice_lh.XData=[slice_lh.XData(1:point_num-1),location(1),slice_lh.XData(point_num:end)];
            slice_lh.YData=[slice_lh.YData(1:point_num-1),location(2),slice_lh.YData(point_num:end)];
            set(allinfo.slice_mov_rh,'Value',1)
        end
    elseif ~isempty(slice_lh.XData)            
        [~,sort_id]=sort((slice_lh.XData-location(1)).^2+(slice_lh.YData-location(2)).^2);
        id=sort_id(1);
        if strcmp(mode,'Delete')
            slice_lh.XData(id)=[];
            slice_lh.YData(id)=[];
        elseif strcmp(mode,'Move')
            slice_lh.XData(id)=location(1);
            slice_lh.YData(id)=location(2);
            set(gcf,'WindowButtonMotionFcn','slice_image_buttondown')
        end
    end
    %提示下一个特征点
    if length(atlas_lh.XData)>length(slice_lh.XData)
        location(1)=atlas_lh.XData(length(slice_lh.XData)+1);
        location(2)=atlas_lh.YData(length(slice_lh.XData)+1);
        set(allinfo.atlas_ph,'XData',location(1),'YData',location(2))
    else
        set(allinfo.atlas_ph,'XData',[],'YData',[])
    end
end
registration_print_number('Slice')
registration_print_number('Atlas')