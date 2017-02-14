function img = OCY_read_stack(mask)
% OCY_read_stack - load a stack of TIFF image files in current directory
%
% This MATLAB function loads all images matching the pattern 'mask' in
% their filename and returns the resulting stack in 'img'.
%
% img = OCY_read_stack(mask)

files=dir(sprintf(mask));
num_img = length(files);

if(num_img>0)
    img=[];
    for i=1:num_img
        img(:,:,i)=imread(files(i).name);
    end;
end;