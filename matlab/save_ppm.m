function save_ppm(img_filepath, img_data, num_max);
tic;
[VSIZE, HSIZE, CHN] = size(img_data);
fid = fopen(img_filepath, 'w');

fprintf(fid, "P3 %d %d %d\n", HSIZE, VSIZE, num_max);

for row = 1:VSIZE
    for col = 1:HSIZE
        fprintf(fid, "%d %d %d\n", img_data(row, col, 1), img_data(row, col, 2), img_data(row, col, 3));
    end
end
fclose(fid);
%imshow(img_data);
toc;
end