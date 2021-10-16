function atlas_image_buttondown
allinfo=get(gcf,'UserData');
mode=get(findobj(allchild(allinfo.atlas_bgh),'Style','RadioButton','Value',1),'String');
if (strcmp(mode,'Add')||strcmp(mode,'Move')) && strcmp(get(gcf,'SelectionType'),'alt')
    mode='Delete';
end
symmetry=allinfo.atlas_ch.Value;
location=get(gca,'CurrentPoint');
location=[location(1),location(3)];
if symmetry
    location=[location(1),location(2);1140-location(1)+1,location(2)];
end
atlas_lh=allinfo.atlas_lh;
if strcmp(mode,'Add')
    atlas_lh.XData=[atlas_lh.XData,location(:,1)'];
    atlas_lh.YData=[atlas_lh.YData,location(:,2)'];
elseif strcmp(mode,'Rotate')
    a=atand((450.5-location(1,2))/(location(1,1)-570.5))+180*(location(1,1)<570.5);
    d=((450.5-location(1,2))^2+(location(1,1)-570.5)^2)^0.5/1000;
    if isnan(a)
        a=0;
    end
    if d<=0.01%避免微调
        d=0;
        location=[570.5,450.5];
    end
    allinfo.atlas_adjust=[a,d];
    set(allinfo.atlas_rh,'XData',[570.5,location(1,1)],'YData',[450.5,location(1,2)])
    set(gcf,'UserData',allinfo,'WindowButtonMotionFcn','atlas_image_buttondown')
    atlas_image_show
elseif ~isempty(atlas_lh.XData)
    id=zeros(1,1+symmetry);
    for i=1:1+symmetry
        [~,sort_id]=sort((atlas_lh.XData-location(i,1)).^2+(atlas_lh.YData-location(i,2)).^2);
        id(i)=sort_id(1);
    end
    if strcmp(mode,'Delete')
        if  strcmp(get(gcf,'SelectionType'),'normal')
            id=1;
            for i=1:1+symmetry
                id=id.*(((atlas_lh.XData-location(i,1)).^2+(atlas_lh.YData-location(i,2)).^2)>1000);
            end
            id=find(id==0);
            set(gcf,'WindowButtonMotionFcn','atlas_image_buttondown')
        end
        atlas_lh.XData(id)=[];
        atlas_lh.YData(id)=[];
    elseif strcmp(mode,'Move')
        atlas_lh.XData(id)=location(:,1);
        atlas_lh.YData(id)=location(:,2);
        set(gcf,'WindowButtonMotionFcn','atlas_image_buttondown')
    end
end
registration_print_number('Atlas')