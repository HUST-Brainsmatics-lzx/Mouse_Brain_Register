function slice_image_adjust
allinfo=get(gcf,'UserData');
slice_ih=allinfo.slice_ih;
slice_sh=allinfo.slice_sh;
set(slice_ih,'CData',slice_ih.UserData)
set(slice_sh,'Visible','off')
set(allinfo.slice_ah,'Xlim',[0.5,size(slice_ih.CData,2)+0.5],'Ylim',[0.5,size(slice_ih.CData,1)+0.5])
h=size(slice_ih.CData,1);
w=size(slice_ih.CData,2);
adjust_method=get(gco,'String');
if strcmp(adjust_method,'Rotate')
    [x,y]=ginput(2);
    a=atand(diff(y)/diff(x));
    a=(90-abs(a))*(-1)^(a>0);
    allinfo.rotation=a;
    allinfo.trimming=[0,0,0,0];
    slice_ih.CData=imrotate(slice_ih.CData,a,'crop');
elseif strcmp(adjust_method,'Trim')
    if allinfo.rotation~=0
        slice_ih.CData=imrotate(slice_ih.CData,allinfo.rotation,'crop');
    end
    [x,y]=ginput(2);
    x=round(x);y=round(y);
    x1=max(min(x),0);
    y1=max(min(y),0);
    x2=w-min(max(x),w);
    y2=h-min(max(y),h);
    allinfo.trimming=[x1,x2,y1,y2];
    slice_ih.CData=slice_ih.CData(1+y1:end-y2,1+x1:end-x2,:);
end
set(gca,'Xlim',[0.5,size(slice_ih.CData,2)+0.5],'Ylim',[0.5,size(slice_ih.CData,1)+0.5])
set(gcf,'UserData',allinfo);
%胞体标记坐标
if ~isempty(slice_sh.UserData)
    x=slice_sh.UserData(1,:)-w/2;
    y=slice_sh.UserData(2,:)-h/2;
    a=allinfo.rotation;
    set(slice_sh,'XData',x.*cosd(-a)-y.*sind(-a)+w/2-allinfo.trimming(1),'YData',x.*sind(-a)+y.*cosd(-a)+h/2-allinfo.trimming(3))
end
%清除标记点、ROI
set(allinfo.slice_lh,'XData',[],'YData',[]);
set(allinfo.slice_rh,'XData',[],'YData',[]);