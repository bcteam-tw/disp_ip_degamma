function [total_degamma_lut reg_setting_out]=read_degamma_lut_setting(reg_filepath, reg_degamma_setting, total_degamma_lut);
fid = fopen(reg_filepath, 'r');

%% read header
index=zeros(1);

while(feof(fid)==0)
    tline = fgetl(fid);
    sub_str = split(tline, ':');
    index=str2num(sub_str{1})+1;
    if sub_str==""
        continue;
    else        
        reg_degamma_setting.degamma_lut(index) = sscanf(sub_str{2},'%x');
    end
    if(index<(127+1))
        total_degamma_lut(index)=reg_degamma_setting.degamma_lut(index);
    else
        total_degamma_lut(130)=reg_degamma_setting.degamma_lut(index);
    end
end

total_degamma_lut(128)=reg_degamma_setting.reg_degma_253;
total_degamma_lut(129)=reg_degamma_setting.reg_degma_254;

reg_setting_out=reg_degamma_setting;
fclose(fid);

end