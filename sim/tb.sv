`timescale 1ns/1ps
`include "/media/sf_share_mount/disp_ip_degamma/sim/tcon_input_gen.sv"
`include "/media/sf_share_mount/disp_ip_degamma/sim/tcon_output_ppm_saver.sv"

`include "/media/sf_share_mount/disp_ip_degamma/verilog/DUT.v"
`include "/media/sf_share_mount/disp_ip_degamma/verilog/level_to_pulse.v"
`include "/media/sf_share_mount/disp_ip_degamma/verilog/tcon_hvmode.v"
`include "/media/sf_share_mount/disp_ip_degamma/verilog/init_code_rom_empty.v"

module tb;

parameter P					= 10;	// clock unit (10ns)
parameter D					= 0.1;	// delay after clock positive edge

parameter TOTAL_FRAME		= 1;
parameter IN_WIDTH		    = 24;
parameter IN_HEIGHT	        = 36;
//parameter IN_WIDTH        = 1280;
//parameter IN_HEIGHT       = 800;
		
parameter OUT_WIDTH         = 24;
parameter OUT_HEIGHT        = 36;
//parameter OUT_WIDTH       = 1280;
//parameter OUT_HEIGHT	    = 800;

parameter IN_BW				= 8;
parameter OUT_BW			= 12;
//parameter SHIFT_IN_OUT    = 2;
parameter MAXIMUM	        = 4095;

parameter I_HSYNC_WIDTH		= 1;
parameter I_H_BACK_PORCH	= 10;
parameter I_H_FRONT_PORCH	= 10;
parameter I_VSYNC_WIDTH		= 1;
parameter I_V_BACK_PORCH	= 1;
parameter I_V_FRONT_PORCH	= 1;

parameter O_HSYNC_WIDTH		= 1;
parameter O_H_BACK_PORCH	= 6;
parameter O_H_FRONT_PORCH	= 6;
parameter O_VSYNC_WIDTH		= 1;
parameter O_V_BACK_PORCH	= 1;
parameter O_V_FRONT_PORCH	= 1;

localparam IN_H_LINE_CYCLE	= I_HSYNC_WIDTH + I_H_BACK_PORCH + I_H_FRONT_PORCH + IN_WIDTH;
localparam IN_FRAME_CYCLE	= IN_H_LINE_CYCLE*(I_V_BACK_PORCH + I_V_FRONT_PORCH + IN_HEIGHT);

localparam OUT_H_LINE_CYCLE	= O_HSYNC_WIDTH + O_H_BACK_PORCH + O_H_FRONT_PORCH + OUT_WIDTH;
localparam OUT_FRAME_CYCLE	= OUT_H_LINE_CYCLE*(O_V_BACK_PORCH + O_V_FRONT_PORCH + OUT_HEIGHT);

integer i;
integer frame_i;
integer frame_o;

string 						 base_dir;
string 						 input_ppm_fname;
string 						 output_ppm_fname;
							 
wire 						 input_vsync;
wire 						 input_hsync;
wire 						 input_de;
wire 						 input_frame_end;
wire [IN_BW-1:0] 			 input_r;
wire [IN_BW-1:0] 			 input_g;
wire [IN_BW-1:0] 			 input_b;
							 
wire 						 dut_vsync_out;
wire 						 dut_de_out;
wire [OUT_BW-1:0] 			 dut_r_out;
wire [OUT_BW-1:0] 			 dut_g_out;
wire [OUT_BW-1:0] 			 dut_b_out;

reg degamma_en;

reg clk;
reg rstn;

initial begin
	clk = 0;
	forever begin
		#(P/2) clk = ~clk;
	end
end

initial begin
	$fsdbDumpfile("vcs.fsdb");
	$fsdbDumpvars;
end

initial begin
	base_dir						= "/media/sf_share_mount/disp_ip_degamma/";
	degamma_en=1;	
	
	rstn = 1;
	clk = 0;

	#P;
	rstn = 0;
	#P;
	rstn = 1;
	#P;	
	
	@(posedge clk);
	
	for(frame_i=0;frame_i<(TOTAL_FRAME);frame_i=frame_i+1)begin	
		case(frame_i)
			0: begin u_input_gen.ppm_filename			= {base_dir, "inputs/colorchecker_8b_36x24.ppm"}; end	
			//1: begin u_input_gen.ppm_filename			= {base_dir, "inputs/test_in.ppm"};end		
			//2: begin u_input_gen.ppm_filename			= {base_dir, "inputs/input_trump_24x48_10b.ppm"};        end		
			//3: begin u_input_gen.ppm_filename			= {base_dir, "inputs/input_colorchecker_24x48.ppm"};     end			
			//0: begin u_input_gen.ppm_filename			= {base_dir, "inputs/01Night_mount_1280x800_10b.ppm"};end	
			//1: begin u_input_gen.ppm_filename			= {base_dir, "inputs/02Sea_side_1280x800_10b.ppm"};   end		
			//2: begin u_input_gen.ppm_filename			= {base_dir, "inputs/03Win_desktop_1280x800_10b.ppm"};end		
			//3: begin u_input_gen.ppm_filename			= {base_dir, "inputs/04Effel_tower_1280x800_10b.ppm"};end			
			//4: begin u_input_gen.ppm_filename			= {base_dir, "inputs/05Dawn_lake_1280x800_12b.ppm"};end	
			//5: begin u_input_gen.ppm_filename			= {base_dir, "inputs/06Mount_lake_1280x800_12b.ppm"};end		
			//6: begin u_input_gen.ppm_filename			= {base_dir, "inputs/07Autumn_mount_1280x800_12b.ppm"};end		
			//7: begin u_input_gen.ppm_filename			= {base_dir, "inputs/08sea_walk_1280x800._12b.ppm"};end			
			
			default: begin u_input_gen.ppm_filename	        = {base_dir, "inputs/input_colorchecker_24x48.ppm"};end
		endcase
		
		u_input_gen.read_frame();		// input gen load image from ppm file

		@(posedge clk);
		#D;
		u_input_gen.start();			// start input gen
		
		@(posedge input_frame_end);		// wait until finishing a input frame
		
		//@(posedge clk);
		@(negedge clk);
		#D;
		u_input_gen.end_of_frame();		// end of input gen		
		
		#D;
	end
	
end

initial begin
	frame_o							= 0;
	u_output_saver.check_ans		= 0;
	
	for(frame_o = 0; frame_o < TOTAL_FRAME; frame_o = frame_o + 1)begin
		@(posedge dut_vsync_out);		// wait until positive edge of vsync_out
		
		case(frame_o)
		    0: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/colorchecker_12b_out_36x24.ppm"}  ; u_output_saver.ppm_filename = {base_dir, "outputs/output_colorchecker_24x36_12b.ppm"};  end
		    //1: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/test_12b_out.ppm"} ; u_output_saver.ppm_filename = {base_dir, "outputs/output_colorchecker2_24x48_10b.ppm"}; end
		    //2: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_trump_18x36.ppm"}         ; u_output_saver.ppm_filename = {base_dir, "outputs/output_trump_24x48_10b.ppm"};         end
		    //3: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker_H_0.ppm"}	  ; u_output_saver.ppm_filename = {base_dir, "outputs/output_colorchecker_24x48_10b.ppm"};  end
		    //0: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker_18x36.ppm"}      ; u_output_saver.ppm_filename = {base_dir, "outputs/01Night_mount_1280x800_10b_out_c124.ppm"};end
		    //1: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker2_18x36.ppm"}     ; u_output_saver.ppm_filename = {base_dir, "outputs/02Sea_side_1280x800_10b_out_c124.ppm"};   end
		    //2: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_trump_18x36.ppm"}             ; u_output_saver.ppm_filename = {base_dir, "outputs/03Win_desktop_1280x800_10b_out_c124.ppm"};end
		    //3: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker_H_0.ppm"}	      ; u_output_saver.ppm_filename = {base_dir, "outputs/04Effel_tower_1280x800_10b_out_c124.ppm"};end
		    //4: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker_18x36.ppm"}      ; u_output_saver.ppm_filename = {base_dir, "outputs/05Dawn_lake_1280x800_12b.ppm"}; end
		    //5: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker2_18x36.ppm"}     ; u_output_saver.ppm_filename = {base_dir, "outputs/06Mount_lake_1280x800_12b.ppm"}; end
		    //6: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_trump_18x36.ppm"}             ; u_output_saver.ppm_filename = {base_dir, "outputs/07Autumn_mount_1280x800_12b.ppm"}; end
		    //7: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker_H_0.ppm"}	      ; u_output_saver.ppm_filename = {base_dir, "outputs/08sea_walk_1280x800.ppm"};   end
			default: begin u_output_saver.ans_ppm_filename   = {base_dir, "ans/output_colorchecker_18x36.ppm"}; u_output_saver.ppm_filename = {base_dir, "outputs/output_colorchecker_24x48.ppm"}; end
		endcase
	
		if(u_output_saver.check_ans)
			u_output_saver.load_ans();
		
		//if(frame_o==0)begin
			#(P*(IN_FRAME_CYCLE-I_H_FRONT_PORCH));			// delay for a complete frame
			//wait(dut_de_out==0);
			//@(posedge dut_vsync_out);
		//end
		
		@(negedge clk);					// save received output image to ppm file 
		#D;
		u_output_saver.save();				
	end
	
	#(P*10);
	$finish;
	
end

// Display Input Generator
tcon_input_gen u_input_gen(
	.clk							(clk				),
	.rstn							(rstn				),
	
	.vsync							(input_vsync		),
	.hsync							(input_hsync        ),
	.de								(input_de			),
	.vde							(),
	.vbk							(),
	.frame_end						(input_frame_end	),
	
	.r_out							(input_r			),
	.g_out							(input_g			),
	.b_out							(input_b			)
);
defparam u_input_gen.DW 			  = IN_BW;
defparam u_input_gen.WIDTH			  = IN_WIDTH;
defparam u_input_gen.HEIGHT			  = IN_HEIGHT;
defparam u_input_gen.V_BACK_BLANKING  = I_V_BACK_PORCH;
defparam u_input_gen.V_FRONT_BLANKING = I_V_FRONT_PORCH;
defparam u_input_gen.BACK_PORCH		  = I_H_BACK_PORCH;
defparam u_input_gen.FRONT_PORCH	  = I_H_FRONT_PORCH;
defparam u_input_gen.HSYNC_WIDTH	  = I_HSYNC_WIDTH;

// Display Output Saver
tcon_output_ppm_saver u_output_saver(
	.vsync							(dut_vsync_out		),
	.de								(dut_de_out			),
	.r_in							(dut_r_out			),
	.g_in							(dut_g_out			),
	.b_in							(dut_b_out			),
	.clk							(clk				),
	.rstn							(rstn				)
);
defparam u_output_saver.DW 			= OUT_BW;
defparam u_output_saver.WIDTH		= OUT_WIDTH;
defparam u_output_saver.HEIGHT		= OUT_HEIGHT;

// IP Design
DUT u_DUT(
	.vsync_in						(input_vsync		),
	.de_in							(input_de			),
	.r_in							(input_r			),
	.g_in							(input_g			),
	.b_in							(input_b			),
	
	.vsync_out						(dut_vsync_out		),
	.de_out							(dut_de_out			),
	.r_out							(dut_r_out			),
	.g_out							(dut_g_out			),
	.b_out							(dut_b_out			),

    .reg_degamma_en                 (degamma_en		    ),
	
	.clk							(clk				),
	.rstn							(rstn				)
);
defparam u_DUT.IN_DW        = IN_BW;
defparam u_DUT.OUT_DW 	    = OUT_BW;
defparam u_DUT.MAXIMUM 	    = MAXIMUM;

defparam u_DUT.IN_WIDTH 		   = IN_WIDTH;
defparam u_DUT.IN_HEIGHT 		   = IN_HEIGHT;
defparam u_DUT.I_VSYNC_WIDTH 	   = I_VSYNC_WIDTH;
defparam u_DUT.I_V_BACK_PORCH 	   = I_V_BACK_PORCH;
defparam u_DUT.I_V_FRONT_PORCH 	   = I_V_FRONT_PORCH;
defparam u_DUT.I_HSYNC_WIDTH 	   = I_HSYNC_WIDTH;
defparam u_DUT.I_H_BACK_PORCH 	   = I_H_BACK_PORCH;
defparam u_DUT.I_H_FRONT_PORCH 	   = I_H_FRONT_PORCH;

defparam u_DUT.OUT_WIDTH 		   = OUT_WIDTH;
defparam u_DUT.OUT_HEIGHT 		   = OUT_HEIGHT;
defparam u_DUT.O_VSYNC_WIDTH 	   = O_VSYNC_WIDTH;
defparam u_DUT.O_V_BACK_PORCH 	   = O_V_BACK_PORCH;
defparam u_DUT.O_V_FRONT_PORCH 	   = O_V_FRONT_PORCH;
defparam u_DUT.O_HSYNC_WIDTH 	   = O_HSYNC_WIDTH;
defparam u_DUT.O_H_BACK_PORCH 	   = O_H_BACK_PORCH;
defparam u_DUT.O_H_FRONT_PORCH 	   = O_H_FRONT_PORCH;

endmodule