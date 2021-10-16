function registration_hotkey
allinfo=get(gcf,'UserData');
if isempty(allinfo)
    %窗口切换时
    return
end
Current_Character=get(gcf,'currentcharacter');
slice_ih=allinfo.slice_ih;
if strcmp(Current_Character,'s')||strcmp(Current_Character,'S')
    lh=allinfo.slice_sh;
    th=findobj(allchild(allinfo.slice_ah),'Tag','Signal','Type','Text');
    if strcmp(lh.Visible,'on')
        set(lh,'Visible','off')
        set(th(:),'Visible','off')
    else
        set(lh,'Visible','on')
        set(th(:),'Visible','on')
    end
elseif strcmp(Current_Character,'d')||strcmp(Current_Character,'D')
    pic=get(allinfo.slice_ih,'UserData');
    pic=imrotate(pic,allinfo.rotation,'crop');
    pic=pic(1+allinfo.trimming(3):end-allinfo.trimming(4),1+allinfo.trimming(1):end-allinfo.trimming(2));
    set(allinfo.slice_ih,'CData',pic)
    set(slice_ih,'ButtonDownFcn','slice_draw_ROI')
    set(allinfo.slice_rh,'XData',[],'YData',[],'Visible','on')
    set(findobj(allchild(allinfo.slice_ah),'Tag','Signal'),'Visible','off')
elseif strcmp(Current_Character,'q')||strcmp(Current_Character,'Q')
    slice_draw_ROI
    set(slice_ih,'ButtonDownFcn','slice_image_buttondown')
elseif strcmp(Current_Character,'n')||strcmp(Current_Character,'N')
    slice_num=get(allinfo.slice_page_eh,'UserData');
    path_filename=[allinfo.slice_filepath,allinfo.slice_filename(slice_num).name];
    [~,~,filetype]=fileparts(path_filename);
    path_filename=strrep(path_filename,filetype,'');
    copyfile([path_filename,filetype],[path_filename,'c',filetype])
    copyfile([path_filename,'.mat'],[path_filename,'c.mat'])
    allinfo.slice_filename=allinfo.slice_filename([1:slice_num,slice_num:length(allinfo.slice_filename)]);
    allinfo.slice_filename(slice_num+1).name=[path_filename,'c',filetype];
    set(gcf,'UserData',allinfo);
    %{
elseif strcmp(Current_Character,'r')||strcmp(Current_Character,'t')
    slice_image_adjust('hotkey')
    %}
elseif strcmp(Current_Character,'1')
    allinfo.atlas_add_rh.Value=1;
    allinfo.slice_add_rh.Value=1;
elseif strcmp(Current_Character,'2')
    allinfo.atlas_mov_rh.Value=1;
    allinfo.slice_mov_rh.Value=1;
elseif strcmp(Current_Character,'3')
    allinfo.atlas_del_rh.Value=1;
    allinfo.slice_del_rh.Value=1;
elseif strcmp(Current_Character,'4')
    allinfo.atlas_rot_rh.Value=1;
elseif strcmp(Current_Character,'5')
    allinfo.atlas_ch.Value=1-allinfo.atlas_ch.Value;
elseif strcmp(Current_Character,char(28))||strcmp(Current_Character,char(29))||strcmp(Current_Character,char(30))||strcmp(Current_Character,char(31))||strcmp(Current_Character,char(13))
    slice_ah=allinfo.slice_ah;
    x=get(allinfo.slice_ah,'Xlim');
    y=get(allinfo.slice_ah,'Ylim');
    h=size(allinfo.slice_ih.CData,1);
    w=size(allinfo.slice_ih.CData,2);
    if strcmp(Current_Character,char(13))
        set(slice_ah,'XLim',[0,w]+0.5,'YLim',[0,h]+0.5)
    elseif strcmp(Current_Character,char(28))
        set(slice_ah,'XLim',[x(1)-0.05*w,x(2)])
    elseif strcmp(Current_Character,char(29))
        set(slice_ah,'XLim',[x(1),x(2)+0.05*w])
    elseif strcmp(Current_Character,char(30))
        set(slice_ah,'YLim',[y(1)-0.05*h,y(2)])
    elseif strcmp(Current_Character,char(31))
        set(slice_ah,'YLim',[y(1),y(2)+0.05*h])
    end
end