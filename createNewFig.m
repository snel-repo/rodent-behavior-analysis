function createNewFig(cb,~)
newFig = figure;
hh = copyobj(cb,newFig);
set(hh,'ButtonDownFcn',[]);
set(hh,'Position',get(0,'DefaultAxesPosition'));
end