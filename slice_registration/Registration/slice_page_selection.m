function slice_page_selection
allinfo=get(gcf,'UserData');
if isempty(allinfo.slice_filename)
    slice_path_selection
    allinfo=get(gcf,'UserData');
end
button_string=get(gco,'String');
image_num=round(str2double(get(allinfo.slice_page_eh,'String')));
step_num=round(str2double(get(allinfo.slice_step_eh,'String')));
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
image_num=min(max(image_num,1),length(allinfo.slice_filename));
last_num=allinfo.slice_page_eh.UserData;
set(allinfo.slice_page_eh,'String',num2str(image_num),'UserData',image_num)
if isfield(allinfo.slice_filename,'atlas_num')&&~isempty(allinfo.slice_filename(image_num).atlas_num)&&(image_num~=last_num)
    atlas_num=allinfo.slice_filename(image_num).atlas_num;
    set(allinfo.atlas_page_eh,'String',num2str(atlas_num),'UserData',atlas_num)
    atlas_image_show
    atlas_default_point_load;
end
slice_image_show