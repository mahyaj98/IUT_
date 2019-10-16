`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:31:45 06/19/2018 
// Design Name: 
// Module Name:    firp 
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

module firp(
  input clock,
  input reset,
  input done,
  input start,
  input wire[15:0] input_sample,
  output [15:0] output_sample2);

parameter N = 19;
wire [32:0]tmp;
wire [15:0] coeffs[18:0];
reg [15:0] holderBefore[18:0];
integer i=0;
wire [16:0] saveSum;
reg [15:0] a,b;
reg [15:0] coeff;
wire [32:0] savemulti;
reg [32:0] final;
wire [32:0] output_sample;
integer j=0;


    assign coeffs[0]=26;
    assign coeffs[1]=270;
    assign coeffs[2]=963;
    assign coeffs[3]=2424;
    assign coeffs[4]=4869;
    assign coeffs[5]=8259;
    assign coeffs[6]=12194;
    assign coeffs[7]=15948;
    assign coeffs[8]=18666;
    assign coeffs[9]=19660;
    assign coeffs[10]=18666;
    assign coeffs[11]=15948;
    assign coeffs[12]=12194;
	 assign coeffs[13]=8259;
	 assign coeffs[14]=4869;
	 assign coeffs[15]=2424;
	 assign coeffs[16]=963;
	 assign coeffs[17]=270;
	 assign coeffs[18]=26;

Adder A(.a(a),.b(b),.s(saveSum));
Adder2 B(.a(savemulti),.b(final),.s(output_sample));
multiplier M(.b(saveSum),.a(coeff),.p(savemulti));

assign done = (j==11) ? 1 : 0;
 
always @(posedge clock or posedge reset)
begin
    if(reset)
        begin
				for(i=0;i<19;i=i+1) begin
					holderBefore[i] <= 0;
				end
				final <= 0;
        end
    else if(start)
        begin  
				for(i=18;i>0;i=i-1) begin
					holderBefore[i] <= holderBefore[i-1];
				end
            holderBefore[0]     <= input_sample;
        end
		else begin
		if(j>=0 && j<=8) begin
			a <= holderBefore[j];
			b <= holderBefore[18-j];
		end
		if (j>=1 && j<=10 ) begin
			coeff <= coeffs[j-1];
		end
		
		if(j==9) begin
			a <= holderBefore[9];
			b <=0;
		end
		
		j<=j+1;
		if(j > 2) begin
		final <= output_sample;
		end
		
		if(j==12) begin
			j<=0;
			final <= 0;
		end
	end
end

assign tmp=RoundOuput(output_sample[32:0]);
assign output_sample2 = tmp[32:17];

function [32:0] RoundOuput;
		input reg [32:0] din;
		RoundOuput= ( din + 33'b0_0000_0000_0000_0001_0000_0000_0000_0000);
endfunction

endmodule
