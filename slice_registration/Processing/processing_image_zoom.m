function processing_image_zoom
allinfo=get(gcf,'UserData');
if ~isfield(allinfo,'filepath')
    return
end
zoomrate=2;
location=get(gca,'CurrentPoint');
location=[location(1),location(3)];
if strcmp(get(gcf,'SelectionType'),'normal')
    state=1;%�������
elseif strcmp(get(gcf,'SelectionType'),'alt')
    state=-1;%�����Ҽ�
else
    state=0;%˫��
end
image_h=findobj(allchild(gca),'Type','Image');
image_size=size(image_h.CData);
if state~=0
    w=diff(get(gca,'XLim'))/zoomrate^state;
    if w<=image_size(2)
        h=diff(get(gca,'YLim'))/zoomrate^state;
        xlim=[location(1)-w/2,location(1)+w/2];
        ylim=[location(2)-h/2,location(2)+h/2];
        if xlim(1)<0%������߽�
            xlim=xlim-xlim(1);
        elseif xlim(2)>image_size(2)%�����ұ߽�
            xlim=xlim-(xlim(2)-image_size(2));
        end
        if ylim(1)<0%������߽�
            ylim=ylim-ylim(1);
        elseif ylim(2)>image_size(1)%������߽�
            ylim=ylim-ylim(2)+image_size(1);
        end
        set(gca,'XLim',xlim,'YLim',ylim)
    end
else
    set(gca,'XLim',[0,image_size(2)],'YLim',[0,image_size(1)])
end