// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Shehab Hesham			:| 31/11/2023:| Module Created
// ============================================================================

module vga_controller_test(
  input clock,
  input neg_reset,
  output wire video_on,
  output wire x_is_done,
  output wire y_is_done,
  output wire horizontal_sync,
  output wire vertical_sync,
  output wire [9:0] hcount_output,
  output wire [9:0] vcount_output
);

  reg hsync;
  reg vsync;
  
  // For Horizontal
  reg [9:0] pixel_register_x;
  reg [9:0] next_pixel_register_x;
  
  // For Vertical
  reg [9:0] pixel_register_y;
  reg [9:0] next_pixel_register_y; 

  // VGA timing parameters
  localparam horizontal_display = 640;
  localparam horizontal_front_porch = 16;
  localparam horizontal_sync_signal = 96;
  localparam horizontal_back_porch = 48;
  localparam vertical_display = 480;
  localparam vertical_front_porch = 10;
  localparam vertical_sync_signal = 2;
  localparam vertical_back_porch = 33;

  // Initialize counters
  initial begin
    hsync = 0;
    vsync = 0;
    pixel_register_x = 0;
    next_pixel_register_x = 1;
    pixel_register_y = 0;
    next_pixel_register_y = 1;
  end

  always @(posedge clock) begin
    if (~neg_reset) begin
      // Reset values on neg_reset
      hsync <= 0;
      vsync <= 0;
      pixel_register_x <= 0;
      next_pixel_register_x <= 1;
      pixel_register_y <= 0;
      next_pixel_register_y <= 1;
    end
    else begin
      // Main function
      vsync <= (vcount_output < vertical_front_porch + vertical_display) || (vcount_output >= (vertical_front_porch + vertical_display + vertical_sync_signal)) ? 1 : 0;
      hsync <= (hcount_output < horizontal_front_porch + horizontal_display) || (hcount_output >= (horizontal_front_porch + horizontal_display + horizontal_sync_signal)) ? 1 : 0;
      
      // Horizontal Counters Section
      if (x_is_done) begin
        pixel_register_x <= 0;
        next_pixel_register_x <= 1;
      end
      else begin
        pixel_register_x <= x_is_done ? 0 : pixel_register_x + 1;
        next_pixel_register_x <= x_is_done ? 10'b0 : next_pixel_register_x + 1;
      end

      // Vertical Counters Section
      if (y_is_done) begin
        pixel_register_y <= 0;
        next_pixel_register_y <= 1;
      end
      else if (x_is_done) begin
        pixel_register_y <= y_is_done ? 0 : pixel_register_y + 1;
        next_pixel_register_y <= y_is_done ? 10'b0 : next_pixel_register_y + 1;
      end
    end
  end

  // Assign outputs
  assign video_on = (hcount_output < horizontal_display) && (vcount_output < vertical_display);
  assign horizontal_sync = hsync;
  assign vertical_sync = vsync;
  assign hcount_output = pixel_register_x;
  assign x_is_done = (pixel_register_x == (horizontal_display + horizontal_front_porch + horizontal_sync_signal + horizontal_back_porch - 1));
  assign vcount_output = pixel_register_y;
  assign y_is_done = (pixel_register_y == (vertical_display + vertical_front_porch + vertical_sync_signal + vertical_back_porch ));

endmodule
