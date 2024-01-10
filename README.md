# FPGA_IP_VGA

Implementing an Image Processing Library with VGA Output on a DE10-Lite Board.

An image is first inserted into the Python script that handles the input image and tailors it into the appropriate format. Each image pixel is in hexadecimal format: RRGGBB. This means that each image pixel is 24 bits deep, with 8 bits for each color layer. More information can be found in the project’s documentation.

The Python script outputs 3 hexadecimal files, one per color channel. Each line in the .hex file contains 2 hexadecimal values, corresponding to 8 bits.

The 3 output hex files are added to the Verilog project environment and are then stored into the memory arrays.

The flow of the system is described in more detail in the document.

Note: This is a flawed project that is constantly being improved.
