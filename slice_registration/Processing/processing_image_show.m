function processing_image_show
allinfo=get(gcf,'UserData');
allinfo.path_filename_th.String='Loading...';drawnow
%¶ÁÈ¡Í¼Æ¬
path_filename=[allinfo.filepath,allinfo.selected_filename];
set(allinfo.path_filename_th,'String',path_filename)
pic=imread(path_filename);
pic_info=imfinfo(path_filename);
allinfo.pic_depth=pic_info.BitDepth;
set(gcf,'UserData',allinfo)
if size(pic,3)==3
    pic=rgb2gray(pic);
elseif size(pic,3)>1
    warndlg('Illegal Image Format!','Warning')
    return
end
bright_num=get(allinfo.bright_eh,'UserData');
contrast_num=get(allinfo.contrast_eh,'UserData');
set(allinfo.image_ih,'UserData',pic,'CData',(pic+bright_num)*(contrast_num/100));
set(allinfo.main_ah,'Xlim',[0.5,pic_info(1).Width+0.5],'Ylim',[0.5,pic_info(1).Height+0.5])
%Ç°¾°±³¾°
processing_image_threshold