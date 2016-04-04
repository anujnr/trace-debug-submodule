//Backpressure module for trace debug
//Anuj Rao 4/4/16
//Contact: anr044@ucsd.edu or anujnr@gmail.com
//

module dut #(parameter sample_width_p = 16
             , counter_width_p = 16)
  (input clk
   , input [sample_width_p-1:0]	sample_data
   , input	sample_valid
   , output logic [sample_width_p:0] fifo_data
   , output logic fifo_valid
   , input fifo_ready
  );
    
//   assert(sample_width_p >= counter_width_p)
//  	else $error("Sample_width must be atleast as much as the counter_width!");

  logic [counter_width_p-1:0] ctr;  
  
  always_ff @(posedge clk)
    begin
    
      if(fifo_ready && ctr==1)
        begin
          fifo_data <= sample_valid? {1'b0,sample_data}: '0;
      	  fifo_valid <= sample_valid;
      	  ctr <= ctr;
        end
      
      else if(fifo_ready) //non-zero ctr
        begin
          fifo_data <= {1'b1,ctr};
          fifo_valid <= 1'b1;
          ctr <= 1;
        end
      
      else if(~fifo_ready && sample_valid)
        begin
          ctr <= ctr + 1;
          fifo_data  <= fifo_data;
          fifo_valid <= fifo_valid;
        end
  
    else
		begin
          ctr <= ctr;
          fifo_data  <= fifo_data;
      	  fifo_valid <= fifo_valid;
        end
      
    end
      
endmodule
