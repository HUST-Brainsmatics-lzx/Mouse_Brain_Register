function processing_image_export
allinfo=get(gcf,'UserData');
if ~isfield(allinfo,'filepath')
    return
end
if ~exist([allinfo.filepath,'\result'],'dir')
    mkdir([allinfo.filepath,'\result'])
end
bright_num=get(allinfo.bright_eh,'UserData');
contrast_num=get(allinfo.contrast_eh,'UserData');
dark_num=get(allinfo.dark_eh,'UserData');
zoom_rate=inputdlg('Please Enter the Zoom Rate.','Image Export',[1,50],{'0.1'});
if isempty(zoom_rate)||isempty(zoom_rate{1})||str2double(zoom_rate{1})<=0
    return
else
    zoom_rate=str2double(zoom_rate{1});
end
batch_state=questdlg('Export All Images in Current Folder?','Image Export','All','Single','All');
if isempty(batch_state)
    return
else
    if strcmp(batch_state,'All')
        file_id=1:length(allinfo.filename);
    else
        file_id=get(allinfo.page_eh,'UserData');
    end
end
for i=1:length(file_id)
    set(allinfo.path_filename_th,'String',['Exporting ... ',num2str(i),'/',num2str(length(file_id))]);drawnow
    path_filename=[allinfo.filepath,allinfo.filename(file_id(i)).name];
    pic=imread(path_filename);
    pic(pic<dark_num)=0;
    pic=uint8((pic+bright_num)*(contrast_num/100));
    [filepath,filename,~]=fileparts(path_filename);
    imwrite(imresize(uint8(pic),zoom_rate),[filepath,'\result\',filename,'.jpg'])
end
allinfo.path_filename_th.String=[allinfo.filepath,allinfo.selected_filename];