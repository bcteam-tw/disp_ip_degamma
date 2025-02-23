function outputimage=degamma_8b_to_12b(inputimage, degamma_table, Width, Height, numChannels);
    outputimage=uint16(zeros(Height,Width,numChannels));
    
    for j =1 : Height
            for i = 1 : Width
                outputimage(j,i,1)=degamma_table(inputimage(j, i,1)+1,1);
                outputimage(j,i,2)=degamma_table(inputimage(j, i,2)+1,1);
                outputimage(j,i,3)=degamma_table(inputimage(j, i,3)+1,1);
        end        
    end
    
end