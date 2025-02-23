function [img_data width height num_max]=read_ppm(img_filepath);
fid = fopen(img_filepath, 'r');

width = -1;
height = -1;
num_max = -1;

%% read header
tline = fgetl(fid);
%disp(tline);
sub_str = split(tline, ' ');

width = str2double(sub_str(2));
height = str2double(sub_str(3));
num_max = str2double(sub_str(4));

%% read data
img_data = zeros([height, width, 3]);

j = 1;
i = 1;
while(feof(fid)==0)
    tline = fgetl(fid);
    sub_str = split(tline, ' ');

    img_data(j,i,1) = str2double(sub_str(1));
    img_data(j,i,2) = str2double(sub_str(2));
    img_data(j,i,3) = str2double(sub_str(3));

    if(i==width)
        j = j + 1;
        if(j == height+1)
            break;
        end
        i = 1;
    else
        i = i + 1;
    end
end

fclose(fid);

end