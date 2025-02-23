function reg_setting_out=read_degamma_setting(reg_filepath, reg_degamma_setting);
fid = fopen(reg_filepath, 'r');

%% read header
while(feof(fid)==0)
    tline = fgetl(fid);
    %tline = strrep(tline,' ',''); % Replace space with null.
    sub_str = split(tline, ':');
    if sub_str==""
        continue;
    elseif strcmp(sub_str{1},'reg_degma_en')
        reg_degamma_setting.reg_degma_en=str2num(sub_str{2});
    elseif strcmp(sub_str{1},'reg_degma_253')
        reg_degamma_setting.reg_degma_253 = sscanf(sub_str{2},'%x');
    elseif strcmp(sub_str{1},'reg_degma_254')
        reg_degamma_setting.reg_degma_254 = sscanf(sub_str{2},'%x');
    else
        ;            
    end
            
end
reg_setting_out=reg_degamma_setting;
fclose(fid);

end