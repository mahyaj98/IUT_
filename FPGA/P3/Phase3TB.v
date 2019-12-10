`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:53:00 06/28/2018
// Design Name:   P3
// Module Name:   G:/ngR/Uni/4 Hardware Description Languages/HW/FinalProjP3/P3TB.v
// Project Name:  FinalProjP3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: P3
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module P3TB;

	// Inputs
	reg aclk;
	reg s_valid;
	reg [15:0] Data_in;

	// Outputs
	wire ready;
	wire valid;
	wire [15:0] Data_out;

	// Instantiate the Unit Under Test (UUT)
	P3 uut (
		.aclk(aclk), 
		.s_axis_data_tvalid(s_valid), 
		.s_axis_data_tready(ready), 
		.m_axis_data_tvalid(valid), 
		.s_axis_data_tdata(Data_in), 
		.m_axis_data_tdata(Data_out)
	);
	
	initial forever #10 aclk = ~aclk;
	reg CLK = 0;
	always #11337.86848072562 CLK =~ CLK;
	integer mcd, mcdout, i = 0;
	initial begin
		// Initialize Inputs
		aclk = 0;
		s_valid = 0;

		// Wait 100 ns for global reset to finish
		// Add stimulus here
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
	end
	
	always @(posedge(CLK)) begin : Read
		if(!$feof(mcd)) 
			$fscanf(mcd , "%b\n" , Data_in);
			s_valid = 1;

		
	end
	
	always @(posedge(CLK)) begin : Write
		if(valid) begin 
			$fwrite(mcdout, "%b\n", Data_out);
		end
	end
	always @(posedge(CLK)) begin 
		if($feof(mcd)) begin 
			$fclose(mcd|mcdout);
			$finish;
		end
	end
      
endmodule

