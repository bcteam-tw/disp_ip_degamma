% Read an ASCII ppm image
directory_content = dir; % contains everything of the current directory
mfilePath = directory_content(1).folder; % returns the path that is currently open

% Read an input JPEG image
addpath('JPEG/');
inputImage = imread('test_in.bmp');
inputImage = uint16(inputImage);
[originalHeight, originalWidth, numChannels] = size(inputImage);

outputimage=uint16(zeros(originalHeight,originalWidth,numChannels));
%outputimage2=uint16(zeros(originalHeight,1,1));

outputimage=bitshift(inputImage(:,:,:), 0);

num_max = 255;
 
save_img_full_path_name=fullfile(mfilePath,'test_in.ppm');
save_ppm(save_img_full_path_name, outputimage, num_max);

%outputimage2=inputImage(:,1,1);

%save_img_full_path_name=fullfile(mfilePath,'24ColorCheck_sRGB_12bit.ppm');
% save_reg_full_path_name=fullfile(mfilePath,'reg_setting_v0.txt');

% colorchecker = zeros([24,3]);
% colorchecker(1,1) = 752;   colorchecker(1,2) = 456; colorchecker(1,3) = 384;
% colorchecker(2,1) = 1997;  colorchecker(2,2) = 1044; colorchecker(2,3) = 780;
% colorchecker(3,1) = 467;   colorchecker(3,2) = 738; colorchecker(3,3) = 1274;
% 
% colorchecker(4,1) = 384; colorchecker(4,2) = 534; colorchecker(4,3) = 209;
% colorchecker(5,1) = 823; colorchecker(5,2) = 766; colorchecker(5,3) = 1593;
% colorchecker(6,1) = 414; colorchecker(6,2) = 1834; colorchecker(6,3) = 1469;
% 
% colorchecker(7,1) = 2616; colorchecker(7,2) = 697; colorchecker(7,3) = 119;
% colorchecker(8,1) = 238; colorchecker(8,2) = 365; colorchecker(8,3) = 1449;
% colorchecker(9,1) = 1974; colorchecker(9,2) = 311; colorchecker(9,3) = 435;
% 
% colorchecker(10,1) = 394; colorchecker(10,2) = 158; colorchecker(10,3) = 522;
% colorchecker(11,1) = 1219; colorchecker(11,2) = 1811; colorchecker(11,3) = 189;
% colorchecker(12,1) = 2842; colorchecker(12,2) = 1256; colorchecker(12,3) = 99;
% 
% colorchecker(13,1) = 104; colorchecker(13,2) = 182; colorchecker(13,3) = 1044;
% colorchecker(14,1) = 202; colorchecker(14,2) = 1061; colorchecker(14,3) = 254;
% colorchecker(15,1) = 1551; colorchecker(15,2) = 146; colorchecker(15,3) = 170;
% 
% colorchecker(16,1) = 3109; colorchecker(16,2) = 2094; colorchecker(16,3) = 29;
% colorchecker(17,1) = 1834; colorchecker(17,2) = 320; colorchecker(17,3) = 1112;
% colorchecker(18,1) = 0; colorchecker(18,2) = 838; colorchecker(18,3) = 1389;
% 
% colorchecker(19,1) = 3390; colorchecker(19,2) = 3358; colorchecker(19,3) = 3295;
% colorchecker(20,1) = 2119; colorchecker(20,2) = 2143; colorchecker(20,3) = 2168;
% colorchecker(21,1) = 1274; colorchecker(21,2) = 1293; colorchecker(21,3) = 1331;
% 
% colorchecker(22,1) = 683; colorchecker(22,2) = 670; colorchecker(22,3) = 697;
% colorchecker(23,1) = 320; colorchecker(23,2) = 328; colorchecker(23,3) = 347;
% colorchecker(24,1) = 124; colorchecker(24,2) = 129; colorchecker(24,3) = 140;

% colorchecker_img = zeros([24,24,3]);
% 
% for i=1:24
%     for j=1:24
%         colorchecker_img(j,i,:)=colorchecker(i,:);
%     end
% end
%imshow(colorchecker_img./4095);

% originalWidth    =uint16(zeros(1));
% originalHeight    =uint16(zeros(1));
%num_max = uint16(zeros(1));
% num_max = 4095;
% 
% save_img_full_path_name=fullfile(mfilePath,'input_colorchecker.ppm');
% save_ppm(save_img_full_path_name, colorchecker_img, num_max);

%[inputImage originalWidth originalHeight num_max] =read_ppm(save_img_full_path_name);
%inputImage = uint16(inputImage);
% inputImage = uint16(colorchecker_img);

% dispImage = double(inputImage)/double(num_max);
% figure;
% imshow(dispImage);

% reg_setting = struct;
% reg_setting.reg_CC_coarse_en               = int32(1);
% reg_setting.reg_coefficient_integer_digit = int32(1);
% reg_setting.reg_coefficient_00               =int32(0x0400);
% reg_setting.reg_coefficient_01               =int32(0);
% reg_setting.reg_coefficient_02               =int32(0);
% reg_setting.reg_coefficient_10               =int32(0);
% reg_setting.reg_coefficient_11               =int32(0x0400);
% reg_setting.reg_coefficient_12               =int32(0);
% reg_setting.reg_coefficient_20               =int32(0);
% reg_setting.reg_coefficient_21               =int32(0);
% reg_setting.reg_coefficient_22               =int32(0x0400);
% 
% reg_setting=read_reg_setting(save_reg_full_path_name, reg_setting);

% Get the original dimensions of the image
% [originalHeight, originalWidth, numChannels] = size(inputImage);

% Compute the new dimensions for the scaled image
% outputimage=uint16(zeros(originalHeight,originalWidth,numChannels));
% 
% outputimage=pixel_cc_pipeline(inputImage, reg_setting, originalWidth, originalHeight, num_max);

% section_input=inputImage(1:24,1:24,:);
% section_output=outputimage(1:24,1:24,:);

% save_img_full_path_name=fullfile(mfilePath,'output_colorchecker_identity.ppm');
% save_ppm(save_img_full_path_name, outputimage, num_max);

% dispinputImage = double(section_input)/double(num_max);
% dispoutputimage= double(section_output)/double(num_max);
% Display each channel as a red image
% figure;
% subplot(1, 2, 1);
% imshow(dispinputImage);
% title('Input image');
% 
% subplot(1, 2, 2);
% imshow(dispoutputimage);
% title('Output image');


