//Cycle counter module
//Anuj Rao 4/4/16
//Contact: anr044@ucsd.edu or anujnr@gmail.com
//

module counter #(parameter width_p=16
                                  , init_val_p=0)
   (input clk
    , input reset_i
    , output logic [width_p-1:0] ctr_r_o
   );

	always_ff @(posedge clk)
     begin
       if (reset_i)
         ctr_r_o <= init_val_p;
       else
         ctr_r_o <= ctr_r_o+1;
     end

endmodule // counter