// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Shehab Hesham			:| 10/10/2023:| Module Created
// ============================================================================

module Frequency_Divider(
	input wire clock_fifty, 
	output wire clock_twenty_five_output
		                     ); //this module is designed because VGA standards require a frequency of 25MHz
	
	
	reg clock_twenty_five ; 
	
	assign clock_twenty_five_output = clock_twenty_five ; 
	
	initial begin
    clock_twenty_five = 1'b0; // or any initial value
	end
	
	always @ (posedge clock_fifty) begin
	 clock_twenty_five <= ~clock_twenty_five ; 
	end
	
endmodule