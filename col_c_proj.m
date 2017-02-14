function img=col_c_proj(vol,cm1,cm2)

img=zeros(size(vol,1),size(vol,2),3)-1;
img1=zeros(size(vol,1),size(vol,2));
img2=zeros(size(vol,1),size(vol,2));
for i=1:size(vol,3)
    img1(vol(:,:,i)==1)=i;
    img2(vol(:,:,i)>1)=i;
end;
img1=ind2rgb(round(63*img1./max(img1(:))),cm1);
img2=ind2rgb(round(63*img2./max(img2(:))),cm2);
if(~isempty(find(img2(:), 1)))
    img(img<0)=(~img2).*img1+(img1).*img2;
    
else
    img=img1;
end;

imshow(img,'Border','tight','InitialMagnification',100);
