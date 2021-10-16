function slice_result_preview_button
if strcmp(get(gco,'Style'),'checkbox')
    %œ‘ æ◊Û”“≤‡Õº∆◊
    side=get(gco,'Tag');
    state=get(gco,'Value');
    if state
        set(findobj(allchild(gca),'Tag',side),'Visible','on')
    else
        set(findobj(allchild(gca),'Tag',side),'Visible','off')
    end
elseif strcmp(get(gco,'Tag'),'Line_Color')
    %…Ë÷√œﬂÃı—’…´
    if strcmp(get(gco,'Style'),'radiobutton')
        color_str=get(gco,'String');
        if ~strcmp(color_str,'...')
            all_color=[1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0;1,1,1];
            all_color_str={'R','G','B','Y','M','C','K','W'};
            select_color=all_color(ismember(all_color_str,color_str),:);
        else
            select_color=uisetcolor();
            if length(select_color)==1
                select_color=[0,1,1];
                set(findobj(allchild(get(gco,'Parent')),'String','C'),'Value',1)
            end
        end
        set(findobj(allchild(gca),'Type','Line'),'MarkerEdgeColor',select_color)
    end
elseif strcmp(get(gco,'Tag'),'Custom_Line_Width')
    %…Ë÷√œﬂøÌ
    line_width=inputdlg('Please enter a positive integer','Custom Line Width',[1,50],{'+5'});
    if ~isempty(line_width) &&~isempty(line_width{1})
        set(gco,'String',['+',num2str(str2double(line_width{1}))])
    end
elseif strcmp(get(gco,'String'),'Save Image')
    %±£¥ÊÕºœÒ
    default_filename=[datestr(now),'.tif'];
    default_filename=strrep(default_filename,'-','_');
    default_filename=strrep(default_filename,' ','_');
    default_filename=strrep(default_filename,':','_');
    [filename,filepath,indx] = uiputfile(default_filename);
    if indx
        %—°‘Ò◊Û”“¬÷¿™
        left_lh=findobj(allchild(gca),'Tag','Left');
        right_lh=findobj(allchild(gca),'Tag','Right');
        point=[];
        if strcmp(get(left_lh,'Visible'),'on')
            point=[point,[left_lh.XData;left_lh.YData]];
        end
        if strcmp(get(right_lh,'Visible'),'on')
            point=[point,[right_lh.XData;right_lh.YData]];
        end
        point=round(point);
        %ª≠¬÷¿™
        pic_show=get(findobj(gca,'Type','Image'),'CData');
        id=(point(1,:)<1)+(point(1,:)>size(pic_show,2))+(point(2,:)<1)+(point(2,:)>size(pic_show,1));
        point(:,id>0)=[];
        point(1,:)=min(max(point(1,:),1),size(pic_show,2));
        point(2,:)=min(max(point(2,:),1),size(pic_show,1));
        outline=zeros(size(pic_show));
        outline(point(2,:)+(point(1,:)-1)*size(pic_show,1))=1;
        line_width=str2double(get(findobj(allchild(findobj(allchild(gcf),'Title','Line Width')),'Value',1),'String'));
        if line_width
            if line_width==1
                outline=imdilate(outline,strel('disk',1));
            elseif line_width==2
                outline=imdilate(outline,strel('square',3));
            elseif line_width==3
                outline=imdilate(outline,strel('disk',2));
            elseif line_width==4
                se=ones(5);se([1,end],[1,end])=0;
                outline=imdilate(outline,strel(se));
            else
                outline=imdilate(outline,strel('disk',line_width-1));
            end
        end
        false_color=zeros(1,3);
        if size(pic_show,3)==1
            answer=inputdlg({'Red Channel','Green Channel','Blue Channel'},'False Color Setting (0/1)',[1,50],{'0','0','0'});
            if ~isempty(answer)
                for i=1:3
                    if strcmp(answer{i},'1')
                        false_color(i)=1;
                    else
                        false_color(i)=0;
                    end
                end
                if sum(false_color)==3
                    false_color=zeros(1,3);
                end
                for i=3:-1:1
                    pic_show(:,:,i)=pic_show(:,:,1)*false_color(i);
                end
            end
        end
        select_color=get(left_lh,'MarkerEdgeColor');
        for i=1:size(pic_show,3)
            pic_temp=pic_show(:,:,i);
            pic_temp(outline==1)=select_color(i)*255;
            pic_show(:,:,i)=pic_temp;
        end
        imwrite(pic_show,[filepath,filename])
    end
end