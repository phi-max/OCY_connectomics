function img=col_proj(vol,mycm,d)

switch d
    case 1,
        i=2;j=3;
    case 2,
        i=1;j=3;
    case 3,
        i=1;j=2;
end;
img=zeros(size(vol,i),size(vol,j));
mx=max(vol(:));
for i=1:size(vol,d)
    switch d
        case 1,
            img(find(vol(i,:,:)))=i;
        case 2,
            img(find(vol(:,i,:)))=i;
        case 3,
            img(find(vol(:,:,i)))=i;
    end;
end;

imshow(img./max(img(:)),'Border','tight','InitialMagnification',100,'Colormap',mycm);