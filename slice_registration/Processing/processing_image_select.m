function processing_image_select
allinfo=get(gcf,'UserData');
if strcmp(get(gco,'Style'),'pushbutton')||strcmp(get(gcf,'CurrentCharacter'),char(13))
    button_string=get(gco,'String');
    button_tag=get(gco,'Tag');
    if strcmp(button_string,'Open') %选择文件夹、文件
        if isfield(allinfo,'filepath')
            default_path=allinfo.filepath;
        else
            default_path='';
        end
        [filename,filepath]=uigetfile([default_path,'*.tif;*.jpg'],'Select the folder');
        if filename
            [~,~,filetype]=fileparts([filepath,filename]);
            allinfo.filepath=filepath;
            allinfo.filename=dir([filepath,'*',filetype]);%仅导入所选文件类型
            allinfo.selected_filename=filename;
            image_num=find(strcmp({allinfo.filename.name},allinfo.selected_filename));
        else
            return
        end
    elseif strcmp(button_tag,'Page')%翻页
        if ~isfield(allinfo,'filepath')
            return
        end
        image_num=round(str2double(get(allinfo.page_eh,'String')));
        if strcmp(button_string,'<')
            image_num=image_num-1;
        elseif strcmp(button_string,'>')
            image_num=image_num+1;
        end
        image_num=min(max(image_num,1),length(allinfo.filename));
        allinfo.selected_filename=allinfo.filename(image_num).name;
    end
    set(allinfo.page_eh,'String',num2str(image_num),'UserData',image_num)
    set(gcf,'UserData',allinfo)
    %读取、显示图片
    processing_image_show
end