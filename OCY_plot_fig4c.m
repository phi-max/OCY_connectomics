function OCY_plot_fig4c(d,k)

skel = Graph2Skel3D(d(k).node,d(k).link,512,512,51);
figure();clf;col_c_proj(skel,flipud(bone),flipud(bone));
hold on;

w = 512;
l = 512;
h = 51;

x = round([d(k).node.comx]);
y = round([d(k).node.comy]);
z = round([d(k).node.comz]);
c=[0.8 0.8 0.8];
plot(y,x,'o','Color',c,'MarkerFaceColor',c,'MarkerSize',8);
drawnow;

hbw = find(d(k).bw>quantile(d(k).bw,0.85));
x = round([d(k).node(hbw).comx]);
y = round([d(k).node(hbw).comy]);
z = round([d(k).node(hbw).comz]);
c = [0.4 0.8 0.4];
plot(y,x,'o','Color',c,'MarkerFaceColor',c,'MarkerSize',8);
drawnow;

hbw = find(d(k).bw>quantile(d(k).bw,0.95));
x = round([d(k).node(hbw).comx]);
y = round([d(k).node(hbw).comy]);
z = round([d(k).node(hbw).comz]);
c = [0.1 0.4 0.1];
plot(y,x,'o','Color',c,'MarkerFaceColor',c,'MarkerSize',8);
drawnow;

set(gcf,'PaperPositionMode','auto');
fname = sprintf('F_04_c%0.0d',k);
print('-dpng',fname);
