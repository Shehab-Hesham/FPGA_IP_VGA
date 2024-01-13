// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Shehab Hesham			:| 20/11/2023:| Module Created
// ============================================================================

module IMAGE_PROCESSING #(
	parameter add_to = 100,
	parameter subtract_from = 100,
	parameter threshold = 127
)(
	input wire clock,
	input wire neg_reset,
	input wire [9:0] IP_decision_switches,
	input wire [7:0] RED_values,
	input wire [7:0] GREEN_values,
	input wire [7:0] BLUE_values,
	output wire [7:0] RED_values_OUT,
	output wire [7:0] GREEN_values_OUT,
	output wire [7:0] BLUE_values_OUT,
	output wire [2:0] relative_pixel_address
);

	reg [7:0] RED;
	reg [7:0] GREEN;
	reg [7:0] BLUE;
	reg [2:0] work_address; // we only use 8 pixels per module instantiation

	assign relative_pixel_address = work_address;
	assign RED_values_OUT = RED;
	assign GREEN_values_OUT = GREEN;
	assign BLUE_values_OUT = BLUE;

	initial begin
		// Initialize pixel values
		RED = 0;
		GREEN = 0;
		BLUE = 0;
		work_address = 0;
	end

	always @(posedge clock) begin
		if (~neg_reset) begin
			// Synchronous reset
			RED <= 0;
			GREEN <= 0;
			BLUE <= 0;
			work_address <= 0;
		end
		else begin
			
			case (IP_decision_switches)
				10'b0000000000: begin
					// ORIGINAL
					RED <= RED_values;
					GREEN <= GREEN_values;
					BLUE <= BLUE_values;
				end
				10'b0000000001: begin
					// ADD_BRIGHTNESS
					/*RED <= RED_values + add_to;
					GREEN <= GREEN_values + add_to;
					BLUE <= BLUE_values + add_to;
					if (RED > 255) RED <= 255;
					if (BLUE > 255) BLUE <= 255;
					if (GREEN > 255) GREEN <= 255;*/
					RED <= (RED_values + add_to > 255) ? 255 : RED_values + add_to; 
					GREEN <= (GREEN_values + add_to > 255) ? 255 : RED_values + add_to; 
					BLUE <= (BLUE_values + add_to > 255) ? 255 : RED_values + add_to; 
				end
				10'b0000000010: begin
					// SUBTRACT_BRIGHTNESS
					/*RED <= RED_values - subtract_from;
					GREEN <= GREEN_values - subtract_from;
					BLUE <= BLUE_values - subtract_from;
					if (RED < 0) RED <= 0;
					if (BLUE < 0) BLUE <= 0;
					if (GREEN < 0) GREEN <= 0;*/
					RED <= (RED_values < subtract_from ) ? 0 : RED_values - subtract_from; 
					GREEN <= (GREEN_values < subtract_from ) ? 0 : GREEN_values - subtract_from; 
					BLUE <= (BLUE_values < subtract_from ) ? 0 : BLUE_values - subtract_from; 
				end
				10'b0000000011: begin
					// THRESHOLD
					RED <= (RED_values >= threshold) ? 255 : 0;
					GREEN <= (GREEN_values >= threshold) ? 255 : 0;
					BLUE <= (BLUE_values >= threshold) ? 255 : 0;
				end
				10'b0000000100: begin
					// INVERSION
					RED <= 255 - RED_values;
					GREEN <= 255 - GREEN_values;
					BLUE <= 255 - BLUE_values;
				end
				// Add more cases as necessary
				default: begin
					RED <= RED_values;
					GREEN <= GREEN_values;
					BLUE <= BLUE_values;
				end
			endcase
			
			// Increment the address counter
			work_address <= work_address + 1;
			

		end
	end
endmodule