%% Read an ASCII ppm image
directory_content = dir; % contains everything of the current directory
mfilePath = directory_content(1).folder; % returns the path that is currently open
%save_img_full_path_name    =fullfile(mfilePath,'colorchecker_8b_36x24.ppm');
save_img_full_path_name    =fullfile(mfilePath,'04Effel_tower_1280x800_8b.ppm');
save_reg_full_path_name     =fullfile(mfilePath,'reg_degamma_setting_128.txt');
save_degamma_full_path_name=fullfile(mfilePath,'reg_128_lut.txt');

num_max_out=4095;

[inputImage originalWidth originalHeight num_max] =read_ppm(save_img_full_path_name);
inputImage = uint16(inputImage);

[originalHeight, originalWidth, numChannels] = size(inputImage);
outputimage=uint16(zeros(originalHeight,originalWidth,numChannels));

dispImage1 = double(inputImage)/double(num_max);
figure;
subplot(1, 2, 1);
imshow(dispImage1);
title('Input image');

%% fix LUT and read register setting

reg_degamma_setting = struct;
reg_degamma_setting.reg_degma_en              = int32(0);
reg_degamma_setting.reg_degma_253             = int32(0);
reg_degamma_setting.reg_degma_254             = int32(0);
reg_degamma_setting.degamma_lut = zeros(128,1);
total_degamma_lut= zeros(130,1);
gamma_256table= uint16(zeros(130,1));

reg_degamma_setting=read_degamma_setting(save_reg_full_path_name, reg_degamma_setting);
[total_degamma_lut reg_degamma_setting]=read_degamma_lut_setting(save_degamma_full_path_name, reg_degamma_setting, total_degamma_lut);

[gamma_256table]=generate_degamma_table_256LUT(total_degamma_lut, 12);

%% apply contrast
outputimage=degamma_8b_to_12b(inputImage, gamma_256table, originalWidth, originalHeight, numChannels);

dispImage2 = double(outputimage)/double(num_max_out);
subplot(1, 2, 2);
imshow(dispImage2);
title('Output image');

%% save an ASCII ppm image
%save_img_full_path_name=fullfile(mfilePath,'colorchecker_12b_out_36x24.ppm');
save_img_full_path_name=fullfile(mfilePath,'04Effel_tower_1280x800_12b_out.ppm');

save_ppm(save_img_full_path_name, outputimage, num_max_out);


