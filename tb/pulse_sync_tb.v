`timescale 1ns/1ps

module pulse_sync_tb;
	reg clk_a;
	reg clk_b;
	reg pulse_in;
	reg a_reset;
	wire pulse_out;
	
	pulse_synchronizer DUT (	.clk_a(clk_a),
					.clk_b(clk_b),
					.pulse_in(pulse_in),
					.a_reset(a_reset),
					.pulse_out(pulse_out)
				);
	
	initial
	begin
		$dumpfile("simulation.vcd"); // Creates the file
    		$dumpvars(0, pulse_sync_tb);  // Dumps ALL signals in this module and below
	end
				
	task reset_dut;
	begin
		@(negedge clk_a);
			a_reset = 1'b1;
			pulse_in = 1'b0;
		
		@(negedge clk_b);
		@(negedge clk_b);
		
		@(negedge clk_a);
			a_reset = 1'b0;
	end
	endtask
	
	task send_pulse;
	begin
		@(negedge clk_a);
			pulse_in = 1'b1;
			
		@(negedge clk_a);
			pulse_in = 1'b0;
	end
	endtask
	
	initial
		{clk_a, clk_b} = 2'd0;
		
	always
		#5 clk_a = ~clk_a;
	
	always
		#12.5 clk_b = ~clk_b;
	
	initial
	begin
		reset_dut();
				
		#20 send_pulse();
		
		#500 $finish;
	end
	
endmodule
