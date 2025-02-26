module DUT(
	vsync_in,
	de_in,
	r_in,
	g_in,
	b_in,
	
	vsync_out,
	de_out,
	r_out,
	g_out,
	b_out,

    reg_degamma_en,
	
	clk,
	rstn
);

parameter IN_DW 		  = 8;
parameter OUT_DW 		  = 12;
parameter DEG_DW          = 12;
parameter TBL_DW          = 7; //for two tables

parameter MAXIMUM	      = 4095;
parameter HCNT_BW 	      = 11;	
parameter VCNT_BW 	      = 11;

parameter IN_WIDTH 	      = 24;
parameter IN_HEIGHT       = 48;
parameter I_VSYNC_WIDTH	  = 1;
parameter I_V_BACK_PORCH  = 1;
parameter I_V_FRONT_PORCH = 1;
parameter I_HSYNC_WIDTH	  = 1;
parameter I_H_BACK_PORCH  = 10;
parameter I_H_FRONT_PORCH = 10;
	
parameter OUT_WIDTH  	  = 24;
parameter OUT_HEIGHT 	  = 48;
parameter O_VSYNC_WIDTH	  = 1;
parameter O_V_BACK_PORCH  = 1;
parameter O_V_FRONT_PORCH = 1;
parameter O_HSYNC_WIDTH	  = 1;
parameter O_H_BACK_PORCH  = 10;
parameter O_H_FRONT_PORCH = 10;

input			            vsync_in;
input			            de_in;
input [IN_DW-1:0]           r_in;
input [IN_DW-1:0]           g_in;
input [IN_DW-1:0]           b_in;


							
input                       reg_degamma_en;
							
output reg			        vsync_out;
output reg			        de_out;
output reg [OUT_DW-1:0]	    r_out;
output reg [OUT_DW-1:0]	    g_out;
output reg [OUT_DW-1:0]	    b_out;

reg  [OUT_DW:0]             sel_r;
reg  [OUT_DW:0]             sel_g;
reg  [OUT_DW:0]             sel_b;
						        
reg  [OUT_DW:0]             tempR_value;
reg  [OUT_DW:0]             tempG_value;
reg  [OUT_DW:0]             tempB_value;
						    
reg	[OUT_DW-1:0]		    r;
reg	[OUT_DW-1:0]		    g;
reg	[OUT_DW-1:0]		    b;
							
reg 						lutr_a_en;
reg 						lutr_b_en;
reg  [TBL_DW-1:0]			lutr_a_adr;
reg  [TBL_DW-1:0]			lutr_b_adr;
wire [DEG_DW-1:0]   	    lutr_a_q;
wire [DEG_DW-1:0]		    lutr_b_q;
							
reg 						lutg_a_en;
reg 						lutg_b_en;
reg  [TBL_DW-1:0]			lutg_a_adr;
reg  [TBL_DW-1:0]			lutg_b_adr;
wire [DEG_DW-1:0]   	    lutg_a_q;
wire [DEG_DW-1:0]		    lutg_b_q;
							
reg 						lutb_a_en;
reg 						lutb_b_en;
reg  [TBL_DW-1:0]			lutb_a_adr;
reg  [TBL_DW-1:0]			lutb_b_adr;
wire [DEG_DW-1:0]   	    lutb_a_q;
wire [DEG_DW-1:0]		    lutb_b_q;
							
input					    clk;
input					    rstn;
						    
reg						    vs_d1;
reg						    de_d1;
						    
reg						    vs_d2;
reg						    de_d2;

reg						    vs_d3;
reg						    de_d3;
						    
						    
reg [HCNT_BW-1:0]		    h_cnt;
reg [VCNT_BW-1:0]		    v_cnt;

wire vsync_in_pulse;
wire vsync_out_pulse;

wire hv_vs;
wire hv_de;
reg  hv_enable;

reg out_hv_vs_d;
reg out_hv_vs_d2;
reg out_hv_vs_d3;
reg out_hv_de_d;
reg out_hv_de_d2;
reg out_hv_de_d3;

// 1st pipeline ======================================================//
always@(*)begin
    if (reg_degamma_en && (de_in || de_d1)) begin
        sel_r      <= r_in;
        sel_g      <= g_in;
        sel_b      <= b_in;
        lutr_a_en<= 1'b0;	
        lutr_b_en<= 1'b0;
        lutg_a_en<= 1'b0;	
        lutg_b_en<= 1'b0;
        lutb_a_en<= 1'b0;	
        lutb_b_en<= 1'b0;				
        if(r_in[IN_DW-1:1]<'d126) begin
	    	if(r_in[1:0]=='d0) begin
                lutr_a_adr <= (r_in>>2);//r_in[IN_DW-1:2];
                // lutr_a_en<= 1'b0;	
                // lutr_b_en<= 1'b1;
	    	end else if (r_in[1:0]=='d1) begin
                lutr_a_adr <= (r_in>>2);//r_in[IN_DW-1:2];
  	            lutr_b_adr <= (r_in>>2);//r_in[IN_DW-1:2];
                // lutr_a_en<= 1'b0;
                // lutr_b_en<= 1'b0;
	    	end else if (r_in[1:0]=='d2) begin
  	            lutr_b_adr <= (r_in>>2);//r_in[IN_DW-1:2];
                // lutr_a_en<= 1'b1;
                // lutr_b_en<= 1'b0;
            end	else begin
                lutr_a_adr <= (r_in>>2)+1;//r_in[IN_DW-1:2]+1;
  	            lutr_b_adr <= (r_in>>2);//r_in[IN_DW-1:2];
                // lutr_a_en<= 1'b0;
                // lutr_b_en<= 1'b0;
	    	end				
	    end else if (r_in=='d252) begin
                lutr_a_adr <= 'd63;
                // lutr_a_en<= 1'b0;	
                // lutr_b_en<= 1'b1;
	    end else if (r_in=='d253) begin
  	            lutr_b_adr <= 'd63;
                // lutr_a_en<= 1'b1;
                // lutr_b_en<= 1'b0;
	    end else if (r_in=='d254) begin
                lutr_a_adr <= 'd64;
                // lutr_a_en<= 1'b0;	
                // lutr_b_en<= 1'b1;
	    end else begin
  	            lutr_b_adr <= 'd64;
                // lutr_a_en<= 1'b1;
                // lutr_b_en<= 1'b0;	
	    end

        if(g_in[IN_DW-1:1]<'d126) begin
	    	if(g_in[1:0]=='d0) begin
                lutg_a_adr <= (g_in>>2);//[IN_DW-1:2];
                // lutg_a_en<= 1'b0;	
                // lutg_b_en<= 1'b1;
	    	end else if (g_in[1:0]=='d1) begin
                lutg_a_adr <= (g_in>>2);//[IN_DW-1:2];
  	            lutg_b_adr <= (g_in>>2);//[IN_DW-1:2];
                // lutg_a_en<= 1'b0;
                // lutg_b_en<= 1'b0;
	    	end else if (g_in[1:0]=='d2) begin
  	            lutg_b_adr <= (g_in>>2);//[IN_DW-1:2];
                // lutg_a_en<= 1'b1;
                // lutg_b_en<= 1'b0;
            end	else begin
                lutg_a_adr <= (g_in>>2)+1;
  	            lutg_b_adr <= (g_in>>2);
                // lutg_a_en<= 1'b0;
                // lutg_b_en<= 1'b0;
	    	end				
	    end else if (g_in[IN_DW-1:0]=='d252) begin
                lutg_a_adr <= 'd63;
                // lutg_a_en<= 1'b0;	
                // lutg_b_en<= 1'b1;
	    end else if (g_in[IN_DW-1:0]=='d253) begin
  	            lutg_b_adr <= 'd63;
                // lutg_a_en<= 1'b1;
                // lutg_b_en<= 1'b0;
	    end else if (g_in[IN_DW-1:0]=='d254) begin
                lutg_a_adr <= 'd64;
                // lutg_a_en<= 1'b0;	
                // lutg_b_en<= 1'b1;
	    end else begin
  	            lutg_b_adr <= 'd64;
                // lutg_a_en<= 1'b1;
                // lutg_b_en<= 1'b0;	
	    end

        if(b_in[IN_DW-1:1]<'d126) begin
	    	if(b_in[1:0]=='d0) begin
                lutb_a_adr <= (b_in>>2);//[IN_DW-1:2];
                // lutb_a_en<= 1'b0;	
                // lutb_b_en<= 1'b1;
	    	end else if (b_in[1:0]=='d1) begin
                lutb_a_adr <= (b_in>>2);//[IN_DW-1:2];
  	            lutb_b_adr <= (b_in>>2);//[IN_DW-1:2];
                // lutb_a_en<= 1'b0;
                // lutb_b_en<= 1'b0;
	    	end else if (b_in[1:0]=='d2) begin
  	            lutb_b_adr <= (b_in>>2);//[IN_DW-1:2];
                // lutb_a_en<= 1'b1;
                // lutb_b_en<= 1'b0;
            end	else begin
                lutb_a_adr <= (b_in>>2)+1;//[IN_DW-1:2]+1;
  	            lutb_b_adr <= (b_in>>2);//[IN_DW-1:2];
                // lutb_a_en<= 1'b0;
                // lutb_b_en<= 1'b0;
	    	end				
	    end else if (b_in[IN_DW-1:0]=='d252) begin
                lutb_a_adr <= 'd63;
                // lutb_a_en<= 1'b0;	
                // lutb_b_en<= 1'b1;
	    end else if (b_in[IN_DW-1:0]=='d253) begin
  	            lutb_b_adr <= 'd63;
                // lutb_a_en<= 1'b1;
                // lutb_b_en<= 1'b0;
	    end else if (b_in[IN_DW-1:0]=='d254) begin
                lutb_a_adr <= 'd64;
                // lutb_a_en<= 1'b0;	
                // lutb_b_en<= 1'b1;
	    end else begin
  	            lutb_b_adr <= 'd64;
                // lutb_a_en<= 1'b1;
                // lutb_b_en<= 1'b0;	
	    end		
	end else begin
        lutr_a_en<= 1'b1;
        lutr_b_en<= 1'b1;
        lutg_a_en<= 1'b1;
        lutg_b_en<= 1'b1;
        lutb_a_en<= 1'b1;
        lutb_b_en<= 1'b1;

        lutr_a_adr <= 'd0;
  	    lutr_b_adr <= 'd0;
        lutg_a_adr <= 'd0;
  	    lutg_b_adr <= 'd0;
        lutb_a_adr <= 'd0;
  	    lutb_b_adr <= 'd0;
		
        sel_r      <= 'd0;
        sel_g      <= 'd0;
        sel_b      <= 'd0;
	end
end

// 1st pipeline ======================================================//
always@(posedge clk or negedge rstn)begin    
    if(~rstn)begin
	    tempR_value <= 'd0;
	    tempG_value <= 'd0;
	    tempB_value <= 'd0;			
    end else begin//if(de_in) begin
        if (reg_degamma_en && (de_d1 || de_d2) ) begin            
			if(sel_r[IN_DW-1:1]<'d126) begin			
         		if(sel_r[1:0]=='d0) begin
                    tempR_value <= lutr_a_q;
				end else if (sel_r[1:0]=='d2) begin
                    tempR_value <= lutr_b_q;
				end else begin
                    tempR_value <= ((lutr_a_q+lutr_b_q+1)>>1);
				end				
	    	end else if (sel_r[IN_DW-1:0]=='d252) begin
                tempR_value <= lutr_a_q;
			end else if (sel_r[IN_DW-1:0]=='d253) begin
                tempR_value <= lutr_b_q;
	    	end else if (sel_r[IN_DW-1:0]=='d254) begin
                tempR_value <= lutr_a_q;
	    	end else begin
			    tempR_value <= lutr_b_q;
			end

			if(sel_g[IN_DW-1:1]<'d126) begin			
         		if(sel_g[1:0]=='d0) begin
                    tempG_value <= lutg_a_q;
				end else if (sel_g[1:0]=='d2) begin
                    tempG_value <= lutg_b_q;
				end else begin
                    tempG_value <= ((lutg_a_q+lutg_b_q+1)>>1);
				end				
	    	end else if (sel_g[IN_DW-1:0]=='d252) begin
                tempG_value <= lutg_a_q;
			end else if (sel_g[IN_DW-1:0]=='d253) begin
                tempG_value <= lutg_b_q;
	    	end else if (sel_g[IN_DW-1:0]=='d254) begin
                tempG_value <= lutg_a_q;
	    	end else begin
			    tempG_value <= lutg_b_q;
			end
			
			if(sel_b[IN_DW-1:1]<'d126) begin			
         		if(sel_b[1:0]=='d0) begin
                    tempB_value <= lutb_a_q;
				end else if (sel_b[1:0]=='d2) begin
                    tempB_value <= lutb_b_q;
				end else begin
                    tempB_value <= ((lutb_a_q+lutb_b_q+1)>>1);
				end				
	    	end else if (sel_b[IN_DW-1:0]=='d252) begin
                tempB_value <= lutb_a_q;
			end else if (sel_b[IN_DW-1:0]=='d253) begin
                tempB_value <= lutb_b_q;
	    	end else if (sel_b[IN_DW-1:0]=='d254) begin
                tempB_value <= lutb_a_q;
	    	end else begin
			    tempB_value <= lutb_b_q;
			end			
	    end else begin
		    tempR_value <= 'd0;
		    tempG_value <= 'd0;
		    tempB_value <= 'd0;
		end
		
	end
end

always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		vs_d1				<= 1'b0;
		de_d1				<= 1'b0;
	
	end else begin
		vs_d1				<= vsync_in;
		de_d1				<= de_in;
        out_hv_vs_d		    <= hv_vs;
        out_hv_de_d		    <= hv_de;
	end
		
end

// 2nd pipeline ======================================================//
always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
        r       <= 'd0;
        g       <= 'd0;
        b       <= 'd0;   
	end else if(out_hv_de_d) begin			
        if (tempR_value<0) begin
            r <= 0;
	    end else if (tempR_value>MAXIMUM) begin
	        r <= MAXIMUM;
	    end else begin
            r <= tempR_value;
	    end		

        if (tempG_value<0) begin
            g <= 0;
	    end else if (tempG_value>MAXIMUM) begin
	        g <= MAXIMUM;
	    end else begin
            g <= tempG_value;
	    end		

        if (tempB_value<0) begin
            b <= 0;
	    end else if (tempB_value>MAXIMUM) begin
	        b <= MAXIMUM;
	    end else begin
            b <= tempB_value;
	    end		
	end
end

always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		vs_d2				<= 1'b0;
		de_d2				<= 1'b0;
	
	end else begin
		vs_d2				<= vs_d1;
		de_d2				<= de_d1;	
        out_hv_vs_d2		<= out_hv_vs_d;
        out_hv_de_d2		<= out_hv_de_d;		
	end
		
end

// output ======================================================//
always@(posedge clk or negedge rstn)begin
	    if(~rstn)begin
	    	hv_enable					<= 'b0;
	    end else if(vsync_in_pulse)begin
    	    if(reg_degamma_en) begin
	    	    hv_enable					<= 'b1;
	        end else begin
	    	    hv_enable					<= 'b0;
			end			
	    end
end

always@(*)begin
    if (reg_degamma_en) begin
        vsync_out		<= vs_d2;
        de_out			<= de_d2;
        r_out			<= r;
        g_out			<= g;
        b_out			<= b;	
    end else begin
        vsync_out		<= vsync_in;
        de_out			<= de_in;
        r_out			<= r_in;
        g_out			<= g_in;
        b_out			<= b_in;
	end

end

// always@(posedge clk or negedge rstn)begin
	// if(~rstn)begin
		// vs_d3				<= 1'b0;
		// de_d3				<= 1'b0;
	
	// end else begin
		// vs_d3				<= vs_d2;
		// de_d3				<= de_d2;	
        // out_hv_vs_d3		<= out_hv_vs_d2;
        // out_hv_de_d3		<= out_hv_de_d2;		
	// end
		
// end


// --------------------------------------------------------------------
level_to_pulse u_vsync_in_d(
	.i							(vsync_in		),
	.o							(vsync_in_pulse	),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

level_to_pulse u_vsync_out_d(
	.i							(vsync_out		),
	.o							(vsync_out_pulse),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

tcon_hvmode  u_hvmode(
	.h_cnt							(h_cnt   		),
	.v_cnt							(v_cnt	    	),
	
	.vs_out							(hv_vs			),
	.hs_out							(				),
	.de_out							(hv_de			),
	
	.clk							(clk			),
	.rstn							(rstn			),
	
	.enable							(hv_enable		),
	
	.reg_vspw						(I_VSYNC_WIDTH	),
	.reg_vsbp						(I_V_BACK_PORCH	),
	.reg_vsfp						(I_V_FRONT_PORCH),
	.reg_vsat						(IN_HEIGHT		),
	
	.reg_hspw						(I_HSYNC_WIDTH	),
	.reg_hsbp						(I_H_BACK_PORCH	),
	.reg_hsfp						(I_H_FRONT_PORCH),
	.reg_hsat						(IN_WIDTH		)
);

init_code_rom_0 u_contrast_lutr_a
(
	.Q							(lutr_a_q   		),
	.A							(lutr_a_adr  	    ),
	
	.cen						(lutr_a_en		),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

init_code_rom_0 u_contrast_lutg_a
(
	.Q							(lutg_a_q   		),
	.A							(lutg_a_adr  	    ),
	
	.cen						(lutg_a_en		),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

init_code_rom_0 u_contrast_lutb_a
(
	.Q							(lutb_a_q   		),
	.A							(lutb_a_adr  	    ),
	
	.cen						(lutb_a_en		),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

init_code_rom_1 u_contrast_lutr_b
(
	.Q							(lutr_b_q   		),
	.A							(lutr_b_adr  	    ),
	
	.cen						(lutr_b_en		),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

init_code_rom_1 u_contrast_lutg_b
(
	.Q							(lutg_b_q   		),
	.A							(lutg_b_adr  	    ),
	
	.cen						(lutg_b_en		),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

init_code_rom_1 u_contrast_lutb_b
(
	.Q							(lutb_b_q   		),
	.A							(lutb_b_adr  	    ),
	
	.cen						(lutb_b_en		),
	
	.clk						(clk			),
	.rstn						(rstn			)
);

endmodule