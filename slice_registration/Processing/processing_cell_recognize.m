function processing_cell_recognize
allinfo=get(gcf,'UserData');
if ~isfield(allinfo,'filepath')
    return
end
if ~exist([allinfo.filepath,'\result'],'dir')
    mkdir([allinfo.filepath,'\result'])
end
mode=strcmp(get(gco,'String'),'Cell Recognition Export');
if mode
    file_id=1:length(allinfo.filename);
else
    file_id=get(allinfo.page_eh,'UserData');
end
%输入参数
if isfield(allinfo,'cell_parameter')
    for i=1:4
        cell_parameter{i}=num2str(allinfo.cell_parameter{i});
    end
else
    cell_parameter={'9','5','100','0.1'};
end
cell_parameter=inputdlg({'Gray SE Radius (positive integer)',...
    'Binary SE Radius (positive integer)',...
    'Singal Threshold (positive integer)',...
    'Image Zoom Rate (0-1)'},...
    'Cell Recognition Parameters',[1,50],cell_parameter);
if isempty(cell_parameter)
    return
else
    %参数检查
    for i=1:3
        cell_parameter{i}=round(str2double(cell_parameter{i}));
    end
    cell_parameter{4}=str2double(cell_parameter{4});
    for i=1:4
        if cell_parameter{i}<=0
            warndlg('Illegal Parameter!','Warning')
            return
        end
    end
    allinfo.cell_parameter=cell_parameter;
    set(gcf,'UserData',allinfo)
end
%胞体识别
bright_num=get(allinfo.bright_eh,'UserData');
contrast_num=get(allinfo.contrast_eh,'UserData');
dark_num=get(allinfo.dark_eh,'UserData');
for i=1:length(file_id)
    set(allinfo.path_filename_th,'String',['Processing ... ',num2str(i),'/',num2str(length(file_id))]);drawnow
    if mode
        path_filename=[allinfo.filepath,allinfo.filename(file_id(i)).name];
        pic=imread(path_filename);
        if size(pic,3)==3
            pic=rgb2gray(pic);
        elseif size(pic,3)>1
            warndlg(['Illegal Image Format! ',path_filename],'Warning')
            return
        end
    else
        pic=get(allinfo.image_ih,'UserData');
    end
    %胞体识别
    pic_cell=pic-imreconstruct(imerode(pic,strel('disk',cell_parameter{1})),pic);
    pic_cell=imfill(pic_cell>cell_parameter{3},'holes');
    pic_cell=imopen(pic_cell,strel('disk',cell_parameter{2}));
    if mode
        cell_info=regionprops(pic_cell);
        cell_info=rmfield(cell_info,{'Area','BoundingBox'});
        parameter.bright_num=bright_num;
        parameter.contrast_num=contrast_num;
        parameter.zoom_rate=cell_parameter{4};
        parameter.cell_recognition.Gray_SE=cell_parameter{1};
        parameter.cell_recognition.BW_SE=cell_parameter{2};
        parameter.cell_recognition.Gray_Threshold=cell_parameter{3};
        [filepath,filename,~]=fileparts(path_filename);
        if ~exist([filepath,'\result\',filename],'file')
            save([filepath,'\result\',filename],'cell_info','parameter')
        else
            save([filepath,'\result\',filename],'cell_info','parameter','-append')
        end
        pic(pic<dark_num)=0;
        pic=uint8((pic+bright_num)*(contrast_num/100));
        imwrite(imresize(pic,cell_parameter{4}),[filepath,'\result\',filename,'.jpg'])
    else
        picshow=uint8((pic+bright_num)*(contrast_num/100))+uint8((imdilate(pic_cell,strel('disk',2))-pic_cell)*256);
        set(allinfo.image_ih,'CData',picshow)
    end
end
allinfo.path_filename_th.String=[allinfo.filepath,allinfo.selected_filename];