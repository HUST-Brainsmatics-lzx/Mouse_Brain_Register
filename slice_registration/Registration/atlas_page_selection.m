function atlas_page_selection
allinfo=get(gcf,'UserData');
button_string=get(gco,'String');
image_num=round(str2double(get(allinfo.atlas_page_eh,'String')));
step_num=round(str2double(get(allinfo.atlas_step_eh,'String')));
if ~(image_num>0 && step_num>0)
    warndlg('Illegal Text!','Warning')
    return
end
if strcmp(button_string,'<')
    image_num=image_num-1;
elseif strcmp(button_string,'>')
    image_num=image_num+1;
elseif strcmp(button_string,'<<')
    image_num=image_num-step_num;
elseif strcmp(button_string,'>>')
    image_num=image_num+step_num;
end
image_num=min(max(image_num,1),1320);
last_num=allinfo.atlas_page_eh.UserData;
set(allinfo.atlas_page_eh,'String',num2str(image_num),'UserData',image_num)
if strcmp(button_string,'Go') && (image_num==last_num)
    set(allinfo.atlas_lh,'XData',[],'YData',[])
    set(allinfo.atlas_ph,'XData',[],'YData',[])
    delete(findobj(allchild(allinfo.atlas_ah),'Type','Text'))
else
    atlas_default_point_load;
end
atlas_image_show