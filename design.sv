// Copyright 2016 by the authors
//
// Copyright and related rights are licensed under the Solderpad
// Hardware License, Version 0.51 (the "License"); you may not use
// this file except in compliance with the License. You may obtain a
// copy of the License at http://solderpad.org/licenses/SHL-0.51.
// Unless required by applicable law or agreed to in writing,
// software, hardware and materials distributed under this License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
// OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the
// License.
//
// Authors:
//    Anuj Rao <anujnr@gmail.com>

//Backpressure module for trace debug

module dut #(parameter sample_width_p = 16
             , counter_width_p = 16)
  (input clk
   , input rst
  
   , input [sample_width_p-1:0]	sample_data
   , input	sample_valid
   
   , output logic [sample_width_p:0] fifo_data
   , output logic fifo_valid
   , input fifo_ready
  );
    
//   assert(sample_width_p >= counter_width_p)
//  	else $error("Sample_width must be atleast as much as the counter_width!");

  logic [counter_width_p-1:0] ctr;  

  always_comb
    begin      

      if(ctr!=0) //ctr had been incremented 
        begin
          fifo_data = {1'b1,ctr};
          fifo_valid = 1'b1;
        end

      else //generic case
        begin
          fifo_data = {1'b0,sample_data};
      	  fifo_valid = sample_valid;
        end
        
    end
  
  always_ff @(posedge clk)
    begin
      
      //second condition is to reset the counter after error packet is sent
      if(rst || (fifo_ready && fifo_data[sample_width_p]==1'b1))
          ctr <= 0;      
 
      //Corner case: fifo is ready asserts for only one clock cycle and the error packet was sent sent
      else if(~fifo_ready && fifo_data[sample_width_p]==1'b1)
          ctr <= 1;      

      //second condition below factors in the error packet
      else if((~fifo_ready && sample_valid && ~(&ctr)) || (sample_valid && fifo_ready && ctr!=0 && ~(&ctr))) 
          ctr <= ctr + 1;
      
      else
          ctr <= ctr;      
    end
      
endmodule
