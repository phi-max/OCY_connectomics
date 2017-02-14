function OCY_plot_fig1b(d,k)

skel = Graph2Skel3D(d(k).node,d(k).link,512,512,51);
cm=bone;
cm=cm.*0;
cm(1,:)=[0.5,0.5,0.5];
cm(end,:)=1;
figure();clf;imshow(max(skel,'',3));colormap(flipud(bone));
hold on;

set(gcf,'PaperPositionMode','auto');
fname = sprintf('F_01_b%0.0d',k);
print('-dpng',fname);
