% Read an ASCII ppm image
directory_content = dir; % contains everything of the current directory
mfilePath = directory_content(1).folder; % returns the path that is currently open

% Read an input JPEG image
% addpath('JPEG/');
% inputImage = imread('06Mount_lake_1280x800.jpg');
% inputImage = uint16(inputImage);
% [originalHeight, originalWidth, numChannels] = size(inputImage);
% 
% outputimage=uint16(zeros(originalHeight,originalWidth,numChannels));
% %outputimage2=uint16(zeros(originalHeight,1,1));
% 
% outputimage=bitshift(inputImage(:,:,:), 4);
% 
% num_max = 4095;
%  
% save_img_full_path_name=fullfile(mfilePath,'06Mount_lake_1280x800_12b.ppm');
% save_ppm(save_img_full_path_name, outputimage, num_max);

colorchecker = zeros([24,3]);
colorchecker(1,1)  = 119;  colorchecker(1,2)  = 94 ; colorchecker(1,3)  = 86;
colorchecker(2,1)  = 185;  colorchecker(2,2)  = 138; colorchecker(2,3)  = 121;
colorchecker(3,1)  = 95 ;  colorchecker(3,2)  = 118; colorchecker(3,3)  = 151;
colorchecker(4,1)  = 87 ;  colorchecker(4,2)  = 101; colorchecker(4,3)  = 64;
colorchecker(5,1)  = 124;  colorchecker(5,2)  = 120; colorchecker(5,3)  = 168;
colorchecker(6,1)  = 89 ;  colorchecker(6,2)  = 179; colorchecker(6,3)  = 161;
colorchecker(7,1)  = 210;  colorchecker(7,2)  = 115; colorchecker(7,3)  = 48;
colorchecker(8,1)  = 68 ;  colorchecker(8,2)  = 85 ; colorchecker(8,3)  = 161;
colorchecker(9,1)  = 184;  colorchecker(9,2)  = 77 ; colorchecker(9,3)  = 92;
colorchecker(10,1) = 87 ;  colorchecker(10,2) = 55 ; colorchecker(10,3) = 100;
colorchecker(11,1) = 149;  colorchecker(11,2) = 178; colorchecker(11,3) = 60;
colorchecker(12,1) = 217;  colorchecker(12,2) = 150; colorchecker(12,3) = 43;
colorchecker(13,1) = 44 ;  colorchecker(13,2) = 60 ; colorchecker(13,3) = 139;
colorchecker(14,1) = 63 ;  colorchecker(14,2) = 139; colorchecker(14,3) = 70;
colorchecker(15,1) = 165;  colorchecker(15,2) = 53 ; colorchecker(15,3) = 58;
colorchecker(16,1) = 226;  colorchecker(16,2) = 189; colorchecker(16,3) = 20;
colorchecker(17,1) = 178;  colorchecker(17,2) = 79 ; colorchecker(17,3) = 142;
colorchecker(18,1) = 0;    colorchecker(18,2) = 125; colorchecker(18,3) = 157;
colorchecker(19,1) = 235;  colorchecker(19,2) = 234; colorchecker(19,3) = 232;
colorchecker(20,1) = 190;  colorchecker(20,2) = 191; colorchecker(20,3) = 193;
colorchecker(21,1) = 151;  colorchecker(21,2) = 152; colorchecker(21,3) = 154;
colorchecker(22,1) = 113;  colorchecker(22,2) = 113; colorchecker(22,3) = 114;
colorchecker(23,1) = 79 ;  colorchecker(23,2) = 80 ; colorchecker(23,3) = 82;
colorchecker(24,1) = 49 ;  colorchecker(24,2) = 49 ; colorchecker(24,3) = 52;

colorchecker_img = zeros([36,24,3]);

for i=1:24
    for j=1:36
        colorchecker_img(j,i,:)=colorchecker(i,:);
    end
end
%imshow(colorchecker_img./1023);

originalWidth    =uint16(zeros(1));
originalHeight    =uint16(zeros(1));
%num_max = uint16(zeros(1));
num_max = 255;

save_img_full_path_name=fullfile(mfilePath,'colorchecker_8b_36x24.ppm');
save_ppm(save_img_full_path_name, colorchecker_img, num_max);

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


