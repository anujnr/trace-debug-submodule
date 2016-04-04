//Testbench for the backpressure module
//Anuj Rao 4/4/16
//Contact: anr044@ucsd.edu or anujnr@gmail.com
//

module tb_nonsynth;
  
 localparam width_lp = 16;
 localparam cycle_time_lp = 10.0;
  
 localparam counter_width_lp = 4;
 localparam sample_width_lp = 4;
  
  logic [width_lp-1:0] clk_cnt;
  logic clk,rst;
 
  logic [sample_width_lp-1:0] sample_data;
  logic [sample_width_lp:0] fifo_data;
  logic fifo_valid, fifo_ready, sample_valid;

  // generate clock
  always begin
   #(cycle_time_lp/2.0) clk=~clk;
  end
  
  //test environment
  initial
    begin
      // waveform generation
      $dumpfile("dump.vcd");
      $dumpvars(2,tb_nonsynth);

      //inital inputs values
      clk=0;
      rst=1;
      sample_valid=0;
      sample_data=0;
      fifo_ready=1;
      
      #(10) rst=0;
    end

    
 /* synthesizeable code */
  
  // cycle counter to generate some input data
  counter #(.width_p(width_lp),.init_val_p(0))
  bcc (.clk(clk)
       ,.reset_i(rst)	
       ,.ctr_r_o(clk_cnt)
      );
  
 // instantiate the design
  dut #(.sample_width_p(sample_width_lp)
        , .counter_width_p(counter_width_lp))
  my_dut (.clk(clk)
          , .sample_data(sample_data)
          , .sample_valid(sample_valid)
          , .fifo_data(fifo_data)
          , .fifo_valid(fifo_valid)
          , .fifo_ready(fifo_ready)
          , .rst(rst)
         );

/* end synthesizeable code */
  always @(posedge clk)
    begin
      if(clk_cnt>0)
        begin
          sample_valid=1; 
          fifo_ready=1;
          sample_data=clk_cnt[0+:sample_width_lp];
          if(clk_cnt==3||clk_cnt==4) sample_valid=0; //when fifo_ready=1 data flows in accordance to inputs
          if(clk_cnt==7||clk_cnt==8) fifo_ready=0;
          if(clk_cnt==14|| clk_cnt==15) sample_valid=0;
          if(clk_cnt>10 && clk_cnt<28) fifo_ready=0;
          if(clk_cnt==29) fifo_ready=0; 
        end
      if(clk_cnt==32) $finish;
    end
 

endmodule
