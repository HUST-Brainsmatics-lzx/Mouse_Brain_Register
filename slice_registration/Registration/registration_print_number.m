function registration_print_number(mode)
ah=findobj(allchild(gcf),'Type','Axes','Tag',mode);
lh=findobj(allchild(ah),'Type','Line','Tag',mode);
delete(findobj(allchild(ah),'Type','Text'))
if strcmp(mode,'Atlas')
    text_color='k';
elseif strcmp(mode,'Slice')
    text_color='c';
end
for i=1:length(lh.XData)
    text(ah,lh.XData(i),lh.YData(i),num2str(i),...
        'FontSize',14,'FontWeight','bold','PickableParts','none','Color',text_color,'Clipping','on')
end