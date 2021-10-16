function slice_image_export
answer=questdlg('Deform slice or atlas?','Selete Mode','Atlas','Slice','Atlas');
if isempty(answer)
    return
end
false_color=inputdlg({'Red Channel','Green Channel','Blue Channel'},'False Color',[1,50],{'0','0','0'});
if isempty(false_color)
    return
else
    for i=1:3
        if str2double(false_color{i})>1 || str2double(false_color{i})<0
            return
        end
    end
end
line_color=inputdlg({'Red Channel','Green Channel','Blue Channel'},'Line Color',[1,50],{'1','1','1'});
if isempty(line_color)
    return
else
    for i=1:3
        if str2double(line_color{i})>1 || str2double(line_color{i})<0
            return
        end
    end
end
register_info=get(gcf,'UserData');
[~,filename,~]=fileparts(register_info.slicename);
[filename,filepath,indx]=uiputfile([filename,'_merge.tif']);
if indx==0
    return
end
%% 输出图像
Xa=register_info.Xa;
Ya=register_info.Ya;
Xs=register_info.Xs;
Ys=register_info.Ys;
atlas_image=register_info.atlas==2^16-1;
slice_image=get(findobj(allchild(gca),'Type','Image'),'CData');
if get(findobj(allchild(gcf),'String','Show Left Atlas'),'Value')==0
    atlas_image(:,1:570)=0;
elseif get(findobj(allchild(gcf),'String','Show Right Atlas'),'Value')==0
    atlas_image(:,571:end)=0;
end
if strcmp(answer,'Atlas')
    atlas_image=tpswarp(atlas_image,[size(slice_image,2),size(slice_image,1)],[Ya',Xa'],[Ys',Xs']);
elseif strcmp(answer,'Slice')
    slice_image=uint8(tpswarp(slice_image,[size(atlas_image,2),size(atlas_image,1)],[Ys',Xs'],[Ya',Xa']));
end
export_image=zeros([size(slice_image),3],'uint8');
for i=1:3
    temp=slice_image*str2double(false_color{i});
    temp(atlas_image==1)=255*str2double(line_color{i});
    export_image(:,:,i)=temp;
end
imwrite(export_image,[filepath,filename])