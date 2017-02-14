function bin = OCY_thr_stack(img,THR)
% OCY_thr_stack - apply threshold and optional background filtering

num_img = size(img,3);

if(median(img(:))>20)
    se = strel('disk',25);
        
    for i=1:num_img
        img(:,:,i) = imtophat(img(:,:,i),se);
    end;    
    
    [h,~]=hist(img(:)./max(img(:)),256);
    h(200:end)=0;
    h(1)=0;
    
    [~,max_idx]=max(h);  
    img = img - max_idx;    
    img(img<0) = 0;
    
end;

img = img ./ max(img(:));

bin = reshape(im2bw(img(:),THR),size(img,1),size(img,2),size(img,3));


