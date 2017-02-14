function OCY_sliceplot(vol,mycm)

x = [1,size(vol,1)];
y = [1,size(vol,2)];
z = [1,size(vol,3)];
figure();
h=slice(vol,x,y,z);
set(h,'FaceColor','interp','EdgeColor','none','DiffuseStrength',0);
colormap(mycm);
axis equal;axis off;
