function OCY_plot_xy(x,y,d)

set(gcf,'Color','white');hold all;
set(gca,'LineWidth',2);
set(gca,'FontSize',20);
set(gca,'TickLength',[0.05 0.02]);
set(gca,'TickLabelInterpreter','latex');
set(gcf,'PaperPositionMode','auto')

x = reshape(x,[5 4]);
y = reshape(y,[5 4]);

xm=mean(x);
ym=mean(y);

xe=std(x);
ye=std(y);

for k=0:3
    plot(x(:,k+1),y(:,k+1),d(5*k+1).linespec,'Color',d(5*k+1).idclr,'MarkerFaceColor',d(5*k+1).idclr,'MarkerSize',12);
end;

legend1 = legend('Mouse 1','Mouse 2','Sheep 1','Sheep 2');

set(legend1,...
    'Position',[0.7 0.7 0.25 0.23],'FontSize',16,'EdgeColor',[.8 .8 .8],'interpreter','latex');

for k=0:3
    line([xm(k+1)-xe(k+1) xm(k+1)+xe(k+1)],[ym(k+1) ym(k+1)],'Color',d(5*k+1).idclr,'LineWidth',1);
    line([xm(k+1) xm(k+1)],[ym(k+1)-ye(k+1) ym(k+1)+ye(k+1)],'Color',d(5*k+1).idclr,'LineWidth',1);
end;

