function processing_image_threshold
allinfo=get(gcf,'UserData');
if ~isfield(allinfo,'filepath')
    return
end
tag=get(gco,'Tag');
edit_handle=findobj(allchild(gcf),'Tag',tag,'Style','Edit');
value=round(str2double(get(edit_handle,'String')));
if ~isempty(edit_handle)&&isnan(value)
    warndlg('Illegal Parameter!','Warning')
    return
end
if strcmp(get(gco,'Style'),'pushbutton') || strcmp(get(gco,'Style'),'checkbox') || strcmp(get(gcf,'CurrentCharacter'),char(13))
    if strcmp(get(gco,'String'),'-')
        value=value-10;
    elseif strcmp(get(gco,'String'),'+')
        value=value+10;
    end
    set(edit_handle,'String',num2str(value),'UserData',value);
    %设置colormap
    bright_num=get(allinfo.bright_eh,'UserData');
    contrast_num=get(allinfo.contrast_eh,'UserData');
    light_num=get(allinfo.light_eh,'UserData');
    dark_num=get(allinfo.dark_eh,'UserData');
    fore_state=get(allinfo.fore_ch,'Value');
    back_state=get(allinfo.back_ch,'Value');
    color_map=gray(256);
    if 0>dark_num||dark_num>light_num||light_num>255
        warndlg('Illegal Threshold Parameter!','Warning')
        return
    end
    if back_state
        color_map(1:dark_num+1,:)=repmat([0,0,1],dark_num+1,1);
    end
    if fore_state
        color_map(light_num+1:256,:)=repmat([1,0,0],255-light_num+1,1);
    end
    set(allinfo.main_ah,'Colormap',color_map)
    if strcmp(tag,'Brightness') || strcmp(tag,'Contrast')
        set(allinfo.image_ih,'CData',(get(allinfo.image_ih,'UserData')+bright_num)*(contrast_num/100))
    end
    %绘制灰度直方图
    axes(findobj(allchild(gcf),'Type','Axes','Tag',''))
    pic=imresize(allinfo.image_ih.CData,0.1,'nearest');
    histogram(pic(((pic>=dark_num).*(pic<=light_num))>0),'BinWidth',5);
    set(gca,'XLim',[0,255],'XTick',0:50:255,'YTick',[])
end