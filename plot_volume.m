function plot_volume(vol,col,a)

hiso = patch(isosurface(vol,0),'FaceColor',col,'EdgeColor','none');
hiso2 = patch(isocaps(vol,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lightangle(100,20); 
view(108,40);
lighting gouraud;
isonormals(vol,hiso);
alpha(a);
set(gca,'DataAspectRatio',[1 1 1])
