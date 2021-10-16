function slice_path_selection
allinfo=get(gcf,'UserData');
if ~isempty(allinfo.slice_filepath)
    default_path=allinfo.slice_filepath;
else
    default_path='';
end
[filename,filepath]=uigetfile([default_path,'*.tif;*.jpg'],'Select the folder');
if filepath
    [~,~,filetype]=fileparts([filepath,filename]);
    allinfo.slice_filename=dir([filepath,'*',filetype]);
    %allinfo.slice_filename(1).atlas_num=[];
    allinfo.slice_filepath=filepath;
    page_num=find(strcmp({allinfo.slice_filename.name},filename));
    set(allinfo.slice_page_eh,'String',num2str(page_num),'UserData',page_num)
    set(gcf,'UserData',allinfo);
    slice_image_show
end