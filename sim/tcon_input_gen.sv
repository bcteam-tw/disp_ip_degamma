module tcon_input_gen(
	clk,
	rstn,
	
	vsync,
	hsync,
	de,
	vde,
	vbk,
	frame_end,
	
	r_out,
	g_out,
	b_out
);
parameter DW 				= 10;
parameter DLY				= 0.1; 
string 						ppm_filename;

parameter WIDTH 			= 1920;
parameter HEIGHT 			= 1080;
parameter IMG_SIZE			= WIDTH*HEIGHT;

//parameter H_BLANKING		= 100;
//parameter V_BLANKING		= 1;
parameter V_BACK_BLANKING	= 1;
parameter V_FRONT_BLANKING	= 1;

parameter BACK_PORCH		= 5;
parameter FRONT_PORCH		= 10;
parameter HSYNC_WIDTH		= 5;

parameter H_BLANK_1			= HSYNC_WIDTH + BACK_PORCH;
parameter TOTAL_HBLANK		= HSYNC_WIDTH + BACK_PORCH + FRONT_PORCH;

parameter IDLE_STATE		= 2'b00;
parameter ACT_STATE 		= 2'b01;
parameter FINISH_STATE		= 2'b10;

input 						clk;
input 						rstn;

output 						vsync;
output 						hsync;
output 						de;
output 						vde;
output 						vbk;
output 						frame_end;

output [DW-1:0] 			r_out;
output [DW-1:0] 			g_out;
output [DW-1:0] 			b_out;

reg [1:0] 					model_state;

reg [11:0] 					hcnt;
reg [10:0] 					vcnt;
reg [31:0] 					active_cnt;

reg [DW-1:0] 				frame_r [0:IMG_SIZE-1];
reg [DW-1:0] 				frame_g [0:IMG_SIZE-1];
reg [DW-1:0] 				frame_b [0:IMG_SIZE-1];

integer 					fcnt;
integer 					cyc_cnt;
integer 					input_gain;

wire vsync_w;
wire hsync_w;
wire de_w;
wire vde_w;
wire vbk_w;
wire frame_end_w;

assign vsync	 			= (model_state>IDLE_STATE) ? vsync_w 		: 1'b0;
assign hsync 				= (model_state>IDLE_STATE) ? hsync_w 		: 1'b0;
assign de 					= (model_state>IDLE_STATE) ? de_w 			: 1'b0;
assign vde 					= (model_state>IDLE_STATE) ? vde_w 			: 1'b0;
assign vbk 					= (model_state>IDLE_STATE) ? vbk_w 			: 1'b0;
assign frame_end		 	= (model_state>IDLE_STATE) ? frame_end_w 	: 1'b0;

assign vsync_w				= (vcnt == 0);
assign hsync_w				= (hcnt < HSYNC_WIDTH);
assign de_w					= (hcnt >= H_BLANK_1) & (hcnt < (WIDTH + H_BLANK_1)) &
							  (vcnt >= V_BACK_BLANKING) & (vcnt < (HEIGHT + V_BACK_BLANKING));
assign vde_w				= (vcnt >= V_BACK_BLANKING) & (vcnt < (HEIGHT + V_BACK_BLANKING));
assign vbk_w				= ~vde_w;
assign frame_end_w			= ((hcnt == (WIDTH + TOTAL_HBLANK - 1)) & (vcnt == (HEIGHT + V_BACK_BLANKING + V_FRONT_BLANKING-1)));

assign r_out 				= (de_w==1 && active_cnt < IMG_SIZE) ? frame_r[active_cnt]*input_gain : 'd0;
assign g_out 				= (de_w==1 && active_cnt < IMG_SIZE) ? frame_g[active_cnt]*input_gain : 'd0;
assign b_out 				= (de_w==1 && active_cnt < IMG_SIZE) ? frame_b[active_cnt]*input_gain : 'd0;

always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		hcnt				<= 12'b0;
		vcnt				<= 11'b0;
		active_cnt			<= 32'b0;
	end else if(frame_end == 1) begin
		model_state			<= FINISH_STATE;
	end else if(model_state == ACT_STATE) begin
		hcnt				<= (hcnt == (WIDTH  + TOTAL_HBLANK - 1) ? 12'b0: hcnt + 1'b1);
		vcnt				<= (vcnt == (HEIGHT + V_BACK_BLANKING + V_FRONT_BLANKING - 1) & (hcnt == (WIDTH + TOTAL_HBLANK -1))) ? 11'b0: (hcnt == WIDTH + TOTAL_HBLANK - 1) ? vcnt + 1'b1: vcnt;
		active_cnt			<= vsync ? 32'b0 : de ? active_cnt + 1'b1 : active_cnt;
		
		cyc_cnt				<= cyc_cnt + 1'b1;
		
		//if(vcnt>=(V_BACK_BLANKING) && hcnt == 59)
			//$finish;
			
		//if(vcnt>=(V_BLANKING) && hcnt > 120)
			//$finish;
		
		//if(vcnt>=(V_BLANKING+1) && hcnt>4)
		//	$finish;
	end
end

initial begin
	input_gain				= 1;
	fcnt 					= 0;
	model_state 			= IDLE_STATE;
	
	while(1) @(posedge vsync)begin
		fcnt 				= fcnt + 1;
	end
end

// open ppm file
integer fp;
integer k;
string  frm_type;
integer frm_w;
integer frm_h;
integer frm_max;
task read_frame;
	begin
		fp = $fopen(ppm_filename, "r");
		
		$fscanf(fp, "%s %d %d %d", frm_type, frm_w, frm_h, frm_max);
		for(k = 0; k < IMG_SIZE; k = k+1)begin
			$fscanf(fp, "%d %d %d", frame_r[k], frame_g[k], frame_b[k]);
		end
	end
endtask

task start;
	begin
		cyc_cnt				= 0;
		hcnt				= 12'b0;
		vcnt				= 11'b0;
		active_cnt			= 32'b0;
		model_state 		= ACT_STATE;
	end
endtask

task end_of_frame;
	begin
		hcnt				= 12'b0;
		vcnt				= 11'b0;
		active_cnt			= 32'b0;
		model_state 		= IDLE_STATE;		
	end
endtask

endmodule
