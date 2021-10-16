function atlas_default_point_load
allinfo=get(gcf,'UserData');
load([fileparts(mfilename('fullpath')),'\Atlas.mat'],'atlas_default_point')
page_num=get(allinfo.atlas_page_eh,'UserData');
default_num=zeros(1320,1);
for i=1:1320
    default_num(i)=~isempty(atlas_default_point{i});
end
default_num=find(default_num>0);
default_dist=abs(default_num-page_num);
[dist,id]=sort(default_dist);
if dist(1)>10
    if strcmp(get(gco,'String'),'Load')
        warndlg('No suggested default point detected!','Warning')
    end
    return
else
    page_num=default_num(id(1));
end
atlas_point=atlas_default_point{page_num};
set(allinfo.atlas_lh,'XData',atlas_point(1,:),'YData',atlas_point(2,:))
registration_print_number('Atlas')
%默认模式
%set(allinfo.atlas_mov_rh,'Value',1)
%set(allinfo.atlas_ch,'Value',1)