function atlas_image_adjust
% atlas adjust pushbutton
allinfo=get(gcf,'UserData');
a=allinfo.atlas_adjust(1);
d=allinfo.atlas_adjust(2);
answer=questdlg('Select the operation:','Atlas Rotation','Flip Horizontally','Manual Setting','Clear','Clear');
if isempty(answer)
    return
elseif strcmp(answer,'Clear')
    d=0;
elseif strcmp(answer,'Flip Horizontally')
    a=180-a;
else
    a=round(a);d=round(d*1000);
    a=a-round(a/360)*360;
    a(a==-180)=180;
    answer=inputdlg({'Orientation','Line Length'},'Rotation Parameters',[1,50],{num2str(a),num2str(d)});
    if isempty(answer)
        return
    elseif isnan(str2double(answer{1}))||isnan(str2double(answer{2}))
        warndlg('Illegal Parameter!','Warning')
        return
    else
        a=str2double(answer{1});
        d=str2double(answer{2})/1000;
    end
end
allinfo.atlas_adjust=[a,d];
set(gcf,'UserData',allinfo)
set(allinfo.atlas_rh,'XData',[570.5,570.5+d*cosd(a)*1000],'YData',[450.5,450.5-d*sind(a)*1000])
atlas_image_show