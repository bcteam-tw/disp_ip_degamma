module tcon_hvmode(
	h_cnt,
	v_cnt,
	
	vs_out,
	hs_out,
	de_out,
	
	clk,
	rstn,
	
	enable,
	
	reg_vspw,
	reg_vsbp,
	reg_vsfp,
	reg_vsat,
	
	reg_hspw,
	reg_hsbp,
	reg_hsfp,
	reg_hsat
);
parameter HCNT_BW 					= 11;	
parameter VCNT_BW 					= 11;

parameter HSPM_BW					= 8;	
parameter VSPM_BW					= 8;

output [HCNT_BW-1:0]				h_cnt;
output [VCNT_BW-1:0]				v_cnt;
output								vs_out;
output								hs_out;
output								de_out;

input								clk;
input								rstn;
input								enable; 

input [VSPM_BW-1:0]					reg_vspw;	// vertical pulse width
input [VSPM_BW-1:0]					reg_vsbp;	// vertical back porch
input [VSPM_BW-1:0]					reg_vsfp;	// vertical front porch
input [VCNT_BW-1:0]					reg_vsat;	// vertical active region

input [HSPM_BW-1:0]					reg_hspw;	// horizontal pulse width
input [HSPM_BW-1:0]					reg_hsbp;	// horizontal back porch
input [HSPM_BW-1:0]					reg_hsfp;	// horizontal front porch
input [HCNT_BW-1:0]					reg_hsat;	// horizontal active region

reg [HCNT_BW-1:0]					h_cnt;
reg [VCNT_BW-1:0]					v_cnt;
reg 								vs_out;
reg 								hs_out;
reg 								de_out;

wire [HCNT_BW-1:0]					hs_period;					
wire [VCNT_BW-1:0]					vs_period;		
wire 								is_end_of_hline;

assign hs_period					= reg_hspw + reg_hsbp + reg_hsfp + reg_hsat - 1;
assign vs_period					= reg_vsbp + reg_vsfp + reg_vsat - 1;
assign is_end_of_hline				= (h_cnt == hs_period) ? 1'b1 : 1'b0;
wire is_hcnt_cont_incr				= (h_cnt < hs_period)  ? 1'b1 : 1'b0;
wire is_vcnt_cont_incr				= (v_cnt < vs_period)  ? 1'b1 : 1'b0;

// ------------------------------------------------------------------
always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		h_cnt						<= 'd0;
	end else if(~enable)begin
		h_cnt						<= 'd0;
	end else begin
		if(is_hcnt_cont_incr)begin
			h_cnt					<= h_cnt + 1'b1;
		end else begin
			h_cnt					<= 'd0;
		end
	end
end

always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		v_cnt						<= 'd0;
	end else if(~enable)begin
		v_cnt						<= 'd0;
	end else if(is_end_of_hline) begin
		if(is_vcnt_cont_incr)begin
			v_cnt					<= v_cnt + 1'b1;
		end else begin
			v_cnt					<= 'd0;
		end
	end
end

// ------------------------------------------------------------------

always@(*)begin
	if(enable)begin
		if(v_cnt < reg_vspw)begin
			vs_out					= 1'b1;
		end else begin
			vs_out					= 1'b0;
		end
	end else begin
		vs_out						= 1'b0;
	end
end

always@(*)begin
	if(enable)begin
		if(h_cnt < reg_hspw)begin
			hs_out					= 1'b1;
		end else begin
			hs_out					= 1'b0;
		end
	end else begin
		hs_out						= 1'b0;
	end
end

// ------------------------------------------------------------------

wire hcnt_in_act_region 			= (h_cnt >= (reg_hsbp) && h_cnt < (reg_hsbp+reg_hsat)) ? 1'b1 : 1'b0;
wire vcnt_in_act_region 			= (v_cnt >= (reg_vsbp) && v_cnt < (reg_vsbp+reg_vsat)) ? 1'b1 : 1'b0;

always@(*)begin
	if(enable)begin
		de_out						= hcnt_in_act_region & vcnt_in_act_region;
	end else begin
		de_out						= 1'b0;
	end
end


endmodule