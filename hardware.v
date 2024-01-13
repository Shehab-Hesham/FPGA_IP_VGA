// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Shehab Hesham			:| 10/10/2023:| Added Verilog file
// ============================================================================


//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

//`define ENABLE_ADC_CLOCK
`define ENABLE_CLOCK1
//`define ENABLE_CLOCK2
//`define ENABLE_SDRAM
//`define ENABLE_HEX0
//`define ENABLE_HEX1
//`define ENABLE_HEX2
//`define ENABLE_HEX3
//`define ENABLE_HEX4
//`define ENABLE_HEX5
`define ENABLE_KEY
//`define ENABLE_LED
`define ENABLE_SW
`define ENABLE_VGA
//`define ENABLE_ACCELEROMETER
//`define ENABLE_ARDUINO
//`define ENABLE_GPIO

module hardware(

		//////////// ADC CLOCK: 3.3-V LVTTL //////////
`ifdef ENABLE_ADC_CLOCK
	input 		          		ADC_CLK_10,
`endif
	//////////// CLOCK 1: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK1
	input 		          		MAX10_CLK1_50,
`endif
	//////////// CLOCK 2: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK2
	input 		          		MAX10_CLK2_50,
`endif

	//////////// SDRAM: 3.3-V LVTTL //////////
`ifdef ENABLE_SDRAM
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,
`endif

	//////////// SEG7: 3.3-V LVTTL //////////
`ifdef ENABLE_HEX0
	output		     [7:0]		HEX0,
`endif
`ifdef ENABLE_HEX1
	output		     [7:0]		HEX1,
`endif
`ifdef ENABLE_HEX2
	output		     [7:0]		HEX2,
`endif
`ifdef ENABLE_HEX3
	output		     [7:0]		HEX3,
`endif
`ifdef ENABLE_HEX4
	output		     [7:0]		HEX4,
`endif
`ifdef ENABLE_HEX5
	output		     [7:0]		HEX5,
`endif

	//////////// KEY: 3.3 V SCHMITT TRIGGER //////////
`ifdef ENABLE_KEY
	input 		     [1:0]		KEY,
`endif

	//////////// LED: 3.3-V LVTTL //////////
`ifdef ENABLE_LED
	output		     [9:0]		LEDR,
`endif

	//////////// SW: 3.3-V LVTTL //////////
`ifdef ENABLE_SW
	input 		     [9:0]		SW,
`endif

	//////////// VGA: 3.3-V LVTTL //////////
`ifdef ENABLE_VGA
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,
`endif

	//////////// Accelerometer: 3.3-V LVTTL //////////
`ifdef ENABLE_ACCELEROMETER
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,
`endif

	//////////// Arduino: 3.3-V LVTTL //////////
`ifdef ENABLE_ARDUINO
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,
`endif

	//////////// GPIO, GPIO connect to GPIO Default: 3.3-V LVTTL //////////
`ifdef ENABLE_GPIO
	inout 		    [35:0]		GPIO
`endif
);



//=======================================================
//  REG/WIRE declarations
//=======================================================


  wire clock_out; 
  reg neg_reset;
  reg [9:0] switches ; 
  
  // Outputs
  wire [7:0] read_data_R;
  wire [7:0] read_data_G;
  wire [7:0] read_data_B;
  wire [17:0] read_address;
  wire [7:0] out_red ;
  wire [7:0] out_green ;
  wire [7:0] out_blue ;
  wire [2:0] out_address ; 
  
  wire video_on;
  wire horizontal_sync;
  wire vertical_sync;
  wire x_done; 
  wire y_done; 
  wire [9:0] x_pixels;
  wire [9:0] y_pixels;
  
  wire [3:0] red_vga;
  wire [3:0] green_vga;
  wire [3:0] blue_vga;
  

//=======================================================
//  Module Instantiation
//=======================================================
  
  
	 Frequency_Divider clocking (
	 .clock_fifty(MAX10_CLK1_50), 
	 .clock_twenty_five_output(clock_out)
		               );
	   SRAM_TEST #(8, 307200, 18) sram (
    .clock(clock_out),
    .neg_reset(KEY[0]),
	 .video_on(video_on),
    .read_data_output_R(read_data_R),
	 .read_data_output_G(read_data_G),
	 .read_data_output_B(read_data_B),
    .read_address_output(read_address)
												);
										
	IMAGE_PROCESSING #(100, 100, 127) IP (
	 .clock(clock_out),
	 .neg_reset(neg_reset),
	 .IP_decision_switches(switches),
	 .RED_values(read_data_R),
	 .GREEN_values(read_data_G),
	 .BLUE_values(read_data_B),
	 .RED_values_OUT(out_red),
	 .GREEN_values_OUT(out_green),
	 .BLUE_values_OUT(out_blue),
	 .relative_pixel_address(out_address)
	                    );

							  
	 vga_controller_test vga (
		.clock(clock_out),
		.neg_reset(KEY[0]),
		.video_on(video_on),
		.x_is_done(x_done),
		.y_is_done(y_done),
		.horizontal_sync(VGA_HS),
		.vertical_sync(VGA_VS),
		.hcount_output(x_pixels),
		.vcount_output(y_pixels)
							       );
							
	displayer disp(
	 .clock(clock_out), 
	 .neg_reset(KEY[0]), 
	 .RED(out_red), 
	 .GREEN(out_green), 
	 .BLUE(out_blue), 
	 .video_on(video_on), 
	 .RED_out(VGA_R), 
	 .GREEN_out(VGA_G),
	 .BLUE_out(VGA_B)
					);


endmodule
