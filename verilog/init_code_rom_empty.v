module init_code_rom_0(
	Q,
	A,
	
	cen,
	
	clk,
	rstn
);
parameter A_BW 					= 7;

output reg [11:0]				Q;
input  [A_BW-1:0]				A;
			
input 							cen;
			
input 							clk;
input							rstn;

always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		Q		  <= 'd0;
	end else if(~cen)begin
		case(A)
			0: Q <=  'd0;
			1: Q <=  'd5;
			2: Q <=  'd10;
			3: Q <=  'd15;
			4: Q <=  'd21;
			5: Q <=  'd28;
			6: Q <=  'd37;
			7: Q <=  'd47;
			8: Q <=  'd59;
			9: Q <=  'd72;
			10: Q <= 'd86;
			11: Q <= 'd102;
			12: Q <= 'd120;
			13: Q <= 'd140;
			14: Q <= 'd161;
			15: Q <= 'd184;
			16: Q <= 'd208;
			17: Q <= 'd235;
			18: Q <= 'd263;
			19: Q <= 'd294;
			20: Q <= 'd326;
			21: Q <= 'd360;
			22: Q <= 'd397;
			23: Q <= 'd435;
			24: Q <= 'd475;
			25: Q <= 'd518;
			26: Q <= 'd562;
			27: Q <= 'd609;
			28: Q <= 'd658;
			29: Q <= 'd710;
			30: Q <= 'd763;
			31: Q <= 'd819;
			32: Q <= 'd877;
			33: Q <= 'd937;
			34: Q <= 'd1000;
			35: Q <= 'd1065;
			36: Q <= 'd1133;
			37: Q <= 'd1203;
			38: Q <= 'd1275;
			39: Q <= 'd1350;
			40: Q <= 'd1428;
			41: Q <= 'd1508;
			42: Q <= 'd1591;
			43: Q <= 'd1676;
			44: Q <= 'd1763;
			45: Q <= 'd1854;
			46: Q <= 'd1947;
			47: Q <= 'd2043;
			48: Q <= 'd2141;
			49: Q <= 'd2242;
			50: Q <= 'd2346;
			51: Q <= 'd2452;
			52: Q <= 'd2562;
			53: Q <= 'd2674;
			54: Q <= 'd2789;
			55: Q <= 'd2907;
			56: Q <= 'd3027;
			57: Q <= 'd3151;
			58: Q <= 'd3277;
			59: Q <= 'd3406;
			60: Q <= 'd3539;
			61: Q <= 'd3682;
			62: Q <= 'd3829;
			63: Q <= 'd3980;
			64: Q <= 'd4057;					
  		default:Q <= 'd0;
		endcase
	end
end

endmodule

module init_code_rom_1(
	Q,
	A,
	
	cen,
	
	clk,
	rstn
);
parameter A_BW 					= 7;

output reg [11:0]				Q;
input  [A_BW-1:0]				A;
			
input 							cen;
			
input 							clk;
input							rstn;

always@(posedge clk or negedge rstn)begin
	if(~rstn)begin
		Q		  <= 'd0;
	end else if(~cen)begin
		case(A)
			0: Q <=  'd2;
			1: Q <=  'd7;
			2: Q <=  'd12;
			3: Q <=  'd18;
			4: Q <=  'd25;
			5: Q <=  'd33;
			6: Q <=  'd42;
			7: Q <=  'd53;
			8: Q <=  'd65;
			9: Q <=  'd79;
			10: Q <= 'd94;
			11: Q <= 'd111;
			12: Q <= 'd130;
			13: Q <= 'd150;
			14: Q <= 'd172;
			15: Q <= 'd196;
			16: Q <= 'd221;
			17: Q <= 'd249;
			18: Q <= 'd278;
			19: Q <= 'd310;
			20: Q <= 'd343;
			21: Q <= 'd378;
			22: Q <= 'd416;
			23: Q <= 'd455;
			24: Q <= 'd496;
			25: Q <= 'd540;
			26: Q <= 'd586;
			27: Q <= 'd634;
			28: Q <= 'd684;
			29: Q <= 'd736;
			30: Q <= 'd791;
			31: Q <= 'd848;
			32: Q <= 'd907;
			33: Q <= 'd968;
			34: Q <= 'd1032;
			35: Q <= 'd1099;
			36: Q <= 'd1168;
			37: Q <= 'd1239;
			38: Q <= 'd1313;
			39: Q <= 'd1389;
			40: Q <= 'd1468;
			41: Q <= 'd1549;
			42: Q <= 'd1633;
			43: Q <= 'd1719;
			44: Q <= 'd1808;
			45: Q <= 'd1900;
			46: Q <= 'd1994;
			47: Q <= 'd2091;
			48: Q <= 'd2191;
			49: Q <= 'd2294;
			50: Q <= 'd2399;
			51: Q <= 'd2507;
			52: Q <= 'd2617;
			53: Q <= 'd2731;
			54: Q <= 'd2847;
			55: Q <= 'd2967;
			56: Q <= 'd3089;
			57: Q <= 'd3214;
			58: Q <= 'd3341;
			59: Q <= 'd3472;
			60: Q <= 'd3610;
			61: Q <= 'd3756;
			62: Q <= 'd3904;
			63: Q <= 'd4018;
			64: Q <= 'd4095;			
  		default:Q <= 'd0;
		endcase
	end
end

endmodule