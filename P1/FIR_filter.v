`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:40 06/20/2018 
// Design Name: 
// Module Name:    FIR_filter 
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
module FIR_filter(input Clk,input [15:0] X_input,output reg [15:0] Y_output);
    
    reg  [15:0] COE [18:0];   
    wire [15:0] Add_res;
    wire [15:0] Mul_res [18:0];

	//coeficients 
	 initial begin 	 
	 COE[0] = 26;
	 COE[1] = 270;
	 COE[2] = 963;
	 COE[3] = 2424;
	 COE[4] = 4869;
	 COE[5] = 8259;
	 COE[6] = 12194;
	 COE[7] = 15948;
	 COE[8] = 18666;
	 COE[9] = 19660;
	 COE[10] = 18666;
	 COE[11] = 15948;
	 COE[12] = 12194;
	 COE[13] = 8259;
	 COE[14] = 4869;
	 COE[15] = 2424;
	 COE[16] = 963;
	 COE[17] = 270;
	 COE[18] = 26;
	 end 
	 
	 assign Mul_res[0] = X_input * COE[0];
	 assign Mul_res[1] = X_input * COE[1];
	 assign Mul_res[2] = X_input * COE[2];
	 assign Mul_res[3] = X_input * COE[3];
	 assign Mul_res[4] = X_input * COE[4];
	 assign Mul_res[5] = X_input * COE[5];
	 assign Mul_res[6] = X_input * COE[6];
	 assign Mul_res[7] = X_input * COE[7];
	 assign Mul_res[8] = X_input * COE[8];
	 assign Mul_res[9] = X_input * COE[9];
	 assign Mul_res[10] = X_input * COE[10];
	 assign Mul_res[11] = X_input * COE[11];
	 assign Mul_res[12] = X_input * COE[12];
	 assign Mul_res[13] = X_input * COE[13]; 
	 assign Mul_res[14] = X_input * COE[14]; 
	 assign Mul_res[15] = X_input * COE[15]; 
	 assign Mul_res[16] = X_input * COE[16]; 
	 assign Mul_res[17] = X_input * COE[17]; 
	 assign Mul_res[18] = X_input * COE[18];
	 
	 
	 assign Add_res = Mul_res[0]+Mul_res[1]+Mul_res[2]+Mul_res[3]+
	Mul_res[4]+Mul_res[5]+Mul_res[6]+Mul_res[7]+
	Mul_res[8]+Mul_res[9]+Mul_res[10]+Mul_res[11]+Mul_res[12]+Mul_res[13]+
	Mul_res[14]+Mul_res[15]+Mul_res[16]+Mul_res[17]+Mul_res[18];
	 
    always@ (posedge Clk)
        Y_output <= Add_res;
		  
initial $monitor("%b\n",Y_output);

endmodule

