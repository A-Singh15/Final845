`timescale 1ns/1ps

`include "environment.sv"

program automatic test(top_if topif); 

  // Instance of the environment class
  environment env;
  
  // Initial block to set up and run the environment
  initial begin
    $vcdpluson;
    env = new(topif);  // Create a new environment instance with the given interface
    env.build();
    //env.gen.trans_count = `TRANSACTION_COUNT;  // Set the total number of transactions to be generated
    env.run();  // Start the run task of the environment
    env.wrap_up();
  end
endprogram
