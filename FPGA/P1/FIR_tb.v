`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:40 06/20/2018 
// Design Name: 
// Module Name:    FIR_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FIR_tb;

// Inputs
    reg Clk;
    reg [15:0] Xin;

    // Outputs
    wire [15:0] Yout;

	//internal var
	integer file, code; 
 
  
    FIR_filter uut (
        .Clk(Clk), 
        .Xin(Xin), 
        .Yout(Yout)
    );
    
    //Generate a clock with 10 ns clock period.
    initial Clk = 0;
    always #5 Clk =~Clk;
	
	//Initialize and apply the inputs.
    initial begin
		file = $fopen("../Audio_Noisy_Binary.txt","r");
		while (!$feof(file)) begin 	
        code = $fscanf(file,"%b",Xin);
        #10;
		end 
		$fclose(file);
	end
	

	
endmodule
