function slice_result_save
allinfo=get(gcf,'UserData');
atlas_lh=allinfo.atlas_lh;
slice_lh=allinfo.slice_lh;
ROI_lh=allinfo.slice_rh;
if length(atlas_lh.XData)~=length(slice_lh.XData)
    warndlg('Unpaired Feature Points!','Warning');
    return
elseif isempty(atlas_lh.XData)
    warndlg('No Feature Point Detected!','Warning');
    return
end
atlas_point=[get(atlas_lh,'XData');get(atlas_lh,'YData')];
slice_point=[get(slice_lh,'XData');get(slice_lh,'YData')];
ROI_point=get(ROI_lh,'UserData');
atlas_num=get(allinfo.atlas_page_eh,'UserData');
pic_size=size(allinfo.slice_ih.UserData);
atlas_adjust=allinfo.atlas_adjust;
slice_trim=allinfo.trimming;
slice_rotate=allinfo.rotation;
path_filename=[allinfo.slice_filepath,allinfo.slice_filename(allinfo.slice_page_eh.UserData).name];
[~,~,filetype]=fileparts(path_filename);
path_filename=strrep(path_filename,filetype,'.mat');
if exist(path_filename,'file')
    save(path_filename,'atlas_point','slice_point','ROI_point','atlas_num','atlas_adjust','slice_trim','slice_rotate','pic_size','-append')
else
    save(path_filename,'atlas_point','slice_point','ROI_point','atlas_num','atlas_adjust','slice_trim','slice_rotate','pic_size')
end