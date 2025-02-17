function [gamma_output_mode0] =generate_degamma_table_256LUT(total_degamma_lut, bitdepth);
    %input is 8 bit image
    num_array=256;    
    gamma_table_mode0=uint16(zeros(num_array,1));
    idx_left=int32(1);
    idx_right=int32(1);
    idx_left_value=int32(0);
    idx_right_value=int32(0);
    input=int32(0);
    
    temp=zeros(1);
    temp=uint16(temp);
    %%mode 0
    for input =0 : (num_array-1)

        idx_left = bitshift(input,-1)+1;
        if (idx_left < 128)
            idx_right = idx_left + 1;
        else
            idx_left = 127;
            idx_right = 130;
        end
        
        idx_left_value=total_degamma_lut(idx_left);
        idx_right_value=total_degamma_lut(idx_right);
        
        if(idx_left<127)
		    if (bitand(input ,1))
			    gamma_table_mode0(input+1) = bitshift((idx_left_value + idx_right_value + 1),-1);
            else
			    gamma_table_mode0(input+1) = idx_left_value;            
            end            
        else %input==252,253,254
            if(input==252)
                gamma_table_mode0(input+1)=total_degamma_lut(127);
            elseif(input==253)
                gamma_table_mode0(input+1)=total_degamma_lut(128);
            elseif(input==254)
                gamma_table_mode0(input+1)=total_degamma_lut(129);
            else%(input==255)
                gamma_table_mode0(input+1)=total_degamma_lut(130);
            end                
        end        
    end    
    gamma_output_mode0=gamma_table_mode0;
   
end