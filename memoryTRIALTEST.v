// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Shehab Hesham			:| 10/11/2023:| Module Created
// ============================================================================

module SRAM_TEST #(
  parameter databus_width = 8,
  parameter RAM_memory_location_number = 307200,
  parameter address_bus_width = $clog2(RAM_memory_location_number)
) (
  input wire clock,
  input wire neg_reset,
  input wire video_on,
  output wire [databus_width-1 : 0] read_data_output_R,
  output wire [databus_width-1 : 0] read_data_output_G,
  output wire [databus_width-1 : 0] read_data_output_B,
  output wire [address_bus_width-1 : 0] read_address_output
);

  reg [address_bus_width-1:0] address_counter;
  reg [databus_width-1:0] ram_R [0:RAM_memory_location_number-1];
  reg [databus_width-1:0] ram_G [0:RAM_memory_location_number-1];
  reg [databus_width-1:0] ram_B [0:RAM_memory_location_number-1];

  reg [databus_width-1 : 0]   read_data_R ;
  reg [databus_width-1 : 0]   read_data_G ;
  reg [databus_width-1 : 0]   read_data_B ;
  reg [address_bus_width-1 : 0] read_address ;

  assign read_data_output_R = (video_on) ? read_data_R : 8'b0;
  assign read_data_output_G = (video_on) ? read_data_G : 8'b0;
  assign read_data_output_B = (video_on) ? read_data_B : 8'b0;
  assign read_address_output = (video_on) ? read_address : read_address -1 ;

  // Read memory initialization file
  initial begin
    address_counter <= 0; // Initialize address counter
    //initialize memory during simulation
    $readmemh("RGBPy/R.hex", ram_R);
    $readmemh("RGBPy/G.hex", ram_G);
    $readmemh("RGBPy/B.hex", ram_B);
  end

  always @(posedge clock) begin
    if (~neg_reset) begin
      // Synchronous reset
      read_data_R <= 0;
      read_data_G <= 0;
      read_data_B <= 0;
      address_counter <= 0;
    end 
	 else begin
      if (video_on) begin
			// Read data from the RAM based on the address counter
			read_data_R <= ram_R[address_counter];
			read_data_G <= ram_G[address_counter];
			read_data_B <= ram_B[address_counter];
			
        // Increment the address counter only when video_on is high
        address_counter <= address_counter + 1;
      end
    end

    // Assign the current address counter to the read address output
    read_address <= address_counter;
  end

endmodule
