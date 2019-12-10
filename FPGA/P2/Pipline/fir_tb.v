`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:45:40 06/21/2018
// Design Name:   firp
// Module Name:   C:/Xilinx.ISE.Design.Suite.v14.7_2/project_fpga/fir_P2/fir_tb.v
// Project Name:  fir_P2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: firp
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fir_tb;

	// Inputs
	reg clock;
	reg reset;
	reg [15:0] input_sample;
	integer mcd=0 , mcdout=0;
	wire done;
	reg start;
	//integer i=0;
	// Outputs
	wire [15:0] output_sample;

	// Instantiate the Unit Under Test (UUT)
	firp uut (
		.clock(clock), 
		.reset(reset),
		.done(done),
		.start(start),
		.input_sample(input_sample), 
		.output_sample2(output_sample)
	);
	

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 1;
		start=1;

		mcd = $fopen("Audio_Noisy_Binary.txt", "r");
		mcdout = $fopen ("Audio_Binary.txt","w");
		if (mcd == 0) begin
			$display("Audio_Noisy_Binary handle was NULL");
			$finish;
		end

	if (mcdout == 0) begin
			$display("Audio_Binary handle was NULL");
			$finish;
		end
		$fscanf(mcd , "%b\n" ,input_sample);
		// Wait 100 ns for global reset to finish
      forever #2 clock=~clock;
		// Add stimulus here
	end
	
	always @(posedge(done)) begin : Read
		start<=1;
		if(!$feof(mcd)) 
			$fscanf(mcd , "%b\n" ,input_sample);
		
	end
	
	always @(negedge(done)) begin : Write
			$fwrite(mcdout,"%b\n",output_sample);
	end
	always @(posedge(clock)) begin 
		start<=0;
		reset<=0;
		if($feof(mcd)) begin 
			$fclose(mcd|mcdout);
			$finish;
		end
	end
      
endmodule




