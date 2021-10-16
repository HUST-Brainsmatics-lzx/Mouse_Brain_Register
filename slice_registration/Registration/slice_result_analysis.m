function slice_result_analysis
allinfo=get(gcf,'UserData');
slice_path=get(allinfo.slice_path_th,'String');
%检查是否全部配准
set(allinfo.slice_path_th,'String','Checking Result...');drawnow
for i=1:length(allinfo.slice_filename)
    path_filename=[allinfo.slice_filepath,allinfo.slice_filename(i).name];
    [~,~,filetype]=fileparts(path_filename);
    path_filename=strrep(path_filename,filetype,'.mat');
    load(path_filename)
    if ~exist('cell_info','var') || ~exist('atlas_num','var')
        warmdlg('Unregistered image detected.','Warming!')
        break
    end
end
%载入图谱
set(allinfo.slice_path_th,'String','Loading atlas file...');drawnow
load([fileparts(mfilename('fullpath')),'\Atlas.mat'])
all_cell_region_name=[];%统计结果
%单张脑片分析
for i=1:length(allinfo.slice_filename)
    set(allinfo.slice_path_th,'String',[num2str(i),'/',num2str(length(allinfo.slice_filename))]);drawnow
    path_filename=[allinfo.slice_filepath,allinfo.slice_filename(i).name];
    [~,~,filetype]=fileparts(path_filename);
    path_filename=strrep(path_filename,filetype,'.mat');
    load(path_filename)
    %胞体坐标转换
    cell_point=cat(1,cell_info.Centroid)*parameter.zoom_rate;
    x=cell_point(:,1)-pic_size(2)/2;
    y=cell_point(:,2)-pic_size(1)/2;
    a=slice_rotate;
    new_cell_point=[x.*cosd(-a)-y.*sind(-a)+pic_size(2)/2-slice_trim(1),x.*sind(-a)+y.*cosd(-a)+pic_size(1)/2-slice_trim(3)];
    if ~isempty(ROI_point)
        id=~inpolygon(new_cell_point(:,1),new_cell_point(:,2),ROI_point(1,:),ROI_point(2,:));
        cell_point(id,:)=[];
        new_cell_point(id,:)=[];
    end
    [Xc, Yc]=tpswarp_rewrite(new_cell_point,slice_point',atlas_point');
    Xc=min(max(round(Xc),1),1140);
    Yc=min(max(round(Yc),1),900);
    %图谱旋转Z轴补偿
    if atlas_adjust(2)==0
        page_offset=zeros(900,1140);
    else
        [X,Y]=meshgrid(1:1140,1:900);
        a=atlas_adjust(1);
        d=atlas_adjust(2);
        page_offset=round((sind(a)*(Y-450.5)-cosd(a)*(X-570.5))*d);
    end
    Zc=min(max(atlas_num+page_offset(Yc+(Xc-1)*900),1),1320);
    Nc=pic_region_all(Yc+900*(Xc-1)+900*1140*(Zc-1));
    Nc(Nc==0)=511;% background
    %胞体映射脑区
    new_cell_info=zeros(length(Xc),4);
    new_cell_info(:,1)=Xc;% ML
    new_cell_info(:,2)=Yc;% DV
    new_cell_info(:,3)=Zc;% AP
    new_cell_info(:,4)=Nc;% Region Number
    cell_region_name=region_name(new_cell_info(:,4));
    all_cell_region_name=[all_cell_region_name;cell_region_name];
    save(path_filename,'new_cell_info','cell_region_name','cell_point','-append')
end
set(allinfo.slice_path_th,'String',slice_path)
%全部数据汇总
final_result=zeros(840,2);
for i=1:length(all_cell_region_name)
    j=find(ismember(region_name,all_cell_region_name{i}));
    final_result(j,1)=final_result(j,1)+1;
end
for i=1:840
    final_result(i,2)=sum(final_result(region_parent{i},1));
end
csvwrite([allinfo.slice_filepath,'final_result.csv'],final_result)