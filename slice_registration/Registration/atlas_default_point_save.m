function atlas_default_point_save
allinfo=get(gcf,'UserData');
load([fileparts(mfilename('fullpath')),'\Atlas.mat'],'atlas_default_point')
if allinfo.atlas_adjust(2)~=0
    warndlg('The default point for rotated atlas is not suggested!','Warning')
end
atlas_point=[get(allinfo.atlas_lh,'XData');get(allinfo.atlas_lh,'YData')];
page_num=get(allinfo.atlas_page_eh,'UserData');
atlas_default_point{page_num}=atlas_point;
save([fileparts(mfilename('fullpath')),'\Atlas.mat'],'atlas_default_point','-append')