module pulse_synchronizer (	input clk_a,
				input clk_b,
				input pulse_in,
				input a_reset,
				output reg pulse_out );
				
	reg q_a, q_b1, q_b2, q_b3;		
	
	always@(posedge clk_a or posedge a_reset)			//domain A converting pulse to level
	begin
		if(a_reset == 1'b1)
			q_a <= 1'b0;
		
		else if(pulse_in == 1'b1)
			q_a <= ~q_a;
	end
	
	always@(posedge clk_b or posedge a_reset)			//domain B logic
	begin
		if(a_reset == 1'b1)
			{q_b1, q_b2, q_b3, pulse_out} <= 4'd0;
		
		else
		begin
			q_b1 <= q_a;
			q_b2 <= q_b1;
			q_b3 <= q_b2;
			pulse_out <= q_b2 ^ q_b3;
		end
	end		
endmodule
