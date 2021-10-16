function slice_draw_ROI
allinfo=get(gcf,'UserData');
slice_rh=allinfo.slice_rh;
all_point=[slice_rh.XData;slice_rh.YData]';
if strcmp(get(gcf,'currentcharacter'),'q')
    if ~isempty(all_point)
        %ROI以外变暗
        pic=get(allinfo.slice_ih,'UserData');
        pic=imrotate(pic,allinfo.rotation,'crop');
        pic=pic(1+allinfo.trimming(3):end-allinfo.trimming(4),1+allinfo.trimming(1):end-allinfo.trimming(2));
        [X,Y]=meshgrid(1:size(pic,2),1:size(pic,1));
        id=inpolygon(X(:),Y(:),all_point(:,1),all_point(:,2));
        pic(~id)=pic(~id)-30;%降低暗度
        set(allinfo.slice_ih,'CData',pic)
        %删除ROI以外胞体
        sh=allinfo.slice_sh;
        id=inpolygon(sh.XData,sh.YData,slice_rh.XData,slice_rh.YData);
        set(sh,'XData',sh.XData(id),'YData',sh.YData(id))
    end
    set(slice_rh,'Visible','off','UserData',[slice_rh.XData;slice_rh.YData;])
else
    current_point=get(gca,'CurrentPoint');
    if strcmp(get(gcf,'SelectionType'),'normal')
        all_point=[all_point;current_point(1),current_point(3)];
    elseif strcmp(get(gcf,'SelectionType'),'alt')||strcmp(get(gcf,'SelectionType'),'open')
        if ~isempty(all_point)
            all_point(end,:)=[];
        end
    end
    set(slice_rh,'XData',all_point(:,1),'YData',all_point(:,2))
end
