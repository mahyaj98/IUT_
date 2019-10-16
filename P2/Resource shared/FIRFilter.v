module FIRFilter( input CLK , input [0:15] Data , output Data_valid , output [0:15] DataOut);
	 
	reg tmpData_valid=0;
	reg [0:15] RegisteredData [0:18];
	wire [0:15] Coef [0:18];
	reg  [0:31] OutMult;
	reg [0:15] A , B;
	wire [0:31] C;
	wire [0:32] tmp;
	reg [0:32] Sum ;
	integer i=0 , j;
	reg INIT;
	MULTIPLIER MULT (
	.a(A), 
	.b(B),
	.p(C) );

	assign Coef[0] = 26,Coef[1] = 270 ,
	Coef[2] = 963,Coef[3] = 2424 ,  Coef[4] = 4869,Coef[5] = 8259 ,
	Coef[6] = 12194,Coef[7] = 15948 ,	Coef[8] = 18666,Coef[9] = 19660 ,
	Coef[18] = 26,Coef[17] = 270 ,
	Coef[16] = 963,Coef[15] = 2424 ,  Coef[14] = 4869,Coef[13] = 8259 ,
	Coef[12] = 12194,Coef[11] = 15948 ,	Coef[10] = 18666;
	
	assign Data_valid = tmpData_valid;
	always @(posedge(CLK)) begin 
		if(!Data_valid) begin 
			if(i==18) begin 
				tmpData_valid <= 1;
			end
			RegisteredData[i]<= Data;
			i = i +1;
		end
		else begin 
			for(j = 0 ; j < 18 ; j = j +1) begin 
				RegisteredData[j]<= RegisteredData[j+1];
			end
			RegisteredData[18] <= Data;
		end
		Sum = 0;
		for( j = 0; j < 19 ; j=j+1) begin 
			A = Coef[j] ;
			B = RegisteredData[j];
			OutMult = C;
			Sum = Sum + OutMult;
		end
	end
	
	assign tmp = RoundOutput(Sum);
	assign DataOut = tmp[17:32];
	function [0:32] RoundOutput;
		input reg [0:32] din;
		RoundOutput = (din + 33'b0_0000_0000_0000_0001_0000_0000_0000_0000) ;
	endfunction
endmodule
