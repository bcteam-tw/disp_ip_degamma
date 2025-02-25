module tcon_output_ppm_saver(
	vsync,
	de,
	r_in,
	g_in,
	b_in,
	clk,
	rstn
);
string						ppm_filename;
string						ans_ppm_filename;

parameter DW 				= 8;
parameter WIDTH 			= 1366;
parameter HEIGHT 			= 768;
parameter IMG_SIZE			= WIDTH*HEIGHT;

input vsync;
input de;
input [DW-1:0] r_in;
input [DW-1:0] g_in;
input [DW-1:0] b_in;

reg [DW-1:0] rec_r[0:IMG_SIZE-1];
reg [DW-1:0] rec_g[0:IMG_SIZE-1];
reg [DW-1:0] rec_b[0:IMG_SIZE-1];

reg [DW-1:0] ans_r[0:IMG_SIZE-1];
reg [DW-1:0] ans_g[0:IMG_SIZE-1];
reg [DW-1:0] ans_b[0:IMG_SIZE-1];

reg [DW-1:0] ans_mem[0:IMG_SIZE*3-1];

input						clk;
input						rstn;

integer i;
integer j;
integer num_max;
integer fp;
integer fp_ans;
string  frm_type;
integer frm_w;
integer frm_h;
integer frm_max;
integer k;
integer m;

integer err;
integer frame_count;
integer check_ans;

reg R_err;
reg G_err;
reg B_err;

wire [DW-1:0] sel_ans_r = ans_r[i];
wire [DW-1:0] sel_ans_g = ans_g[i];
wire [DW-1:0] sel_ans_b = ans_b[i];

wire [DW-1:0] sel_rec_r = rec_r[m];
wire [DW-1:0] sel_rec_g = rec_g[m];
wire [DW-1:0] sel_rec_b = rec_b[m];


always@(negedge clk)begin
	if(de)begin
		rec_r[i] <= r_in;
		rec_g[i] <= g_in;
		rec_b[i] <= b_in;
		
		if(check_ans)begin
			if(ans_r[i]!==r_in || ans_g[i]!==g_in || ans_b[i]!==b_in)begin
				//$display("%d: [ANS] %d,%d,%d / [OUT] %d,%d,%d [x]", i, ans_r[i], ans_g[i], ans_b[i], r_in, g_in, b_in);
				err = err + 1;
                //$display("errors = %d", err);				
				//$finish;
			end
			
			if(ans_r[i]!==r_in)
				R_err <= 1'b1;
			else 
				R_err <= 1'b0;
			if(ans_g[i]!==g_in)
				G_err <= 1'b1;
			else 
				G_err <= 1'b0;
			if(ans_b[i]!==b_in)
				B_err <= 1'b1;
			else 
				B_err <= 1'b0;				
		end
		i <= i + 1;
		m <= i;		
	end else begin
		R_err <= 1'b0;
		G_err <= 1'b0;
		B_err <= 1'b0;
	end
end

always@(posedge vsync)begin
	frame_count <= frame_count + 1;
end

always@(negedge vsync)begin
	if(frame_count>=1)begin
		if(err>0)begin
			$display("Previous frame output errors = %d", err);
		end else begin
			$display("Previous frame outputs are all correct");
		end	
	end

	clear();
	//load_ans();
end

initial begin
	check_ans = 1;
	i = 0;
	frame_count = 0;
	num_max = $pow(2, DW) - 1;
	
	for(j = 0; j < IMG_SIZE; j=j+1)begin
		rec_r[j] <= 'd0;
		rec_g[j] <= 'd0;
		rec_b[j] <= 'd0;
	end
end

task clear;
	begin
		err = 0;
		i = 0;
		for(j = 0; j < IMG_SIZE; j=j+1)begin
			rec_r[j] <= 'd0;
			rec_g[j] <= 'd0;
			rec_b[j] <= 'd0;
		end
	end
endtask

task save;
	begin
		fp = $fopen(ppm_filename, "w");
		
		$fwrite(fp, "P3 %d %d %d\n", WIDTH, HEIGHT, num_max);
		for(j = 0; j < IMG_SIZE; j=j+1)begin
			$fwrite(fp, "%d %d %d\n", rec_r[j], rec_g[j], rec_b[j]);
		end
		$fclose(fp);
	end
endtask

task load_ans;
	begin
		//$display(ans_ppm_filename);
		
		fp_ans = $fopen(ans_ppm_filename, "r");
		
		$fscanf(fp_ans, "%s %d %d %d\n", frm_type, frm_w, frm_h, frm_max);
		
		for(k = 0; k < frm_w*frm_h; k = k+1)begin
			$fscanf(fp_ans, "%d %d %d\n", ans_r[k], ans_g[k], ans_b[k]);
		end
		
		$display("[PPM Saver] GroundTrue PPM file loaded: %s", ans_ppm_filename);
		
		$fclose(fp_ans);
	end
endtask

endmodule