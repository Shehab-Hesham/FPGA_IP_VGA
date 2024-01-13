// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Shehab Hesham			:| 31/12/2023:| Module Created
// ============================================================================

module displayer (
	input wire clock, 
	input wire neg_reset, 
	input wire [7:0] RED, 
	input wire [7:0] GREEN, 
	input wire [7:0] BLUE, 
	input wire video_on, 
	output wire [3:0] RED_out, 
	output wire [3:0] GREEN_out,
	output wire [3:0] BLUE_out
					); 
					
	reg [3:0] dummy_red ; 
	reg [3:0] dummy_green ; 
	reg [3:0] dummy_blue ;
	reg [3:0] blank = 0 ; 
	
	assign RED_out = dummy_red ; 
	assign GREEN_out = dummy_green ; 
	assign BLUE_out = dummy_blue ;
	
	initial begin
		dummy_red = 0 ;
		dummy_green = 0 ;
		dummy_blue = 0 ;
	end
		
	always @ (posedge clock) begin
		if (~neg_reset) begin
			dummy_red <= 0 ;
			dummy_green <= 0 ;
			dummy_blue <= 0 ;
		end
		else begin
			dummy_red <= RED[7:4] ;
			dummy_green <= GREEN[7:4] ; 
			dummy_blue <= BLUE[7:4] ;
		end	
	end

endmodule
