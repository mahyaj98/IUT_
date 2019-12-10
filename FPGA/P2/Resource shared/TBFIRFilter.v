`timescale 1ns / 1ps

module TBFIRFilter();
	reg [0:15] Data ;
	wire [0:15] DataOut;
	reg CLK ;
	wire Data_valid;
	always #1 CLK =~ CLK;
	integer mcd=0 , mcdout=0;
	FIRFilter FIR( CLK , Data , Data_valid , DataOut);

	initial begin
		CLK = 1;
		mcd = $fopen("Audio_Noisy_Binary.txt", "r");
		mcdout = $fopen ("Audio_Binary.txt","w");
		if (mcd == 0) begin
			$display("Audio_Noisy_Binary handle was NULL");
			$finish;
		end
		else begin 
		end
		if (mcdout == 0) begin
			$display("Audio_Binary handle was NULL");
			$finish;
		end
	end
	
	always @(posedge(CLK)) begin : Read
		if(!$feof(mcd)) 
			$fscanf(mcd , "%b\n" , Data);
		
	end
	
	always @(posedge(CLK)) begin : Write
		if(Data_valid) begin 
			$fwrite(mcdout,"%b\n",DataOut);
		end
	end
	always @(posedge(CLK)) begin 
		if($feof(mcd)) begin 
			$fclose(mcd|mcdout);
			$finish;
		end
	end
endmodule


