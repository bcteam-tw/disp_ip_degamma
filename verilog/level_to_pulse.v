module level_to_pulse(
	i,
	o,
	
	clk,
	rstn
);
input 							i;
output							o;
input							clk;
input							rstn;

reg								i_d;
always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		i_d						<= 'd0;
	end else begin
		i_d						<= i;
	end
end
assign o 						= (~i_d) & i;

endmodule