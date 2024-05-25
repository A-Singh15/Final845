`timescale 1ns/1ps

`include "defines.sv"

class generator;

  // Transaction class handle
  Transaction trans;

  // Number of transactions to generate
  int trans_count = `TRANSACTION_COUNT;

  // Mailbox handle for communication with driver
  mailbox gen2driv;

  // Event to signal end of generation
  event ended;

  // Constructor: Initializes mailbox and event handles
  function new(mailbox gen2driv, event ended);
    this.gen2driv = gen2driv;
    this.ended = ended;
  endfunction

  // Main task: Generates transactions and sends them to the driver
  task run();
    $display("*---------*----------*----------*----------*----------*----------*----------*----------*------*");
    $display("*---------*----------* ENGR 850: DIGITAL DESIGN VERIFICATION FINAL PROJECT *----------*----------*");
    $display("*---------*----------*----------*----------*----------*----------*----------*----------*------*");
    $display("*---------*----------*--------* GENERATOR MODULE -BEGINS *--------*--------*-------*----------*");
    repeat (trans_count) begin
      trans = new();
      if (!trans.randomize()) $fatal("Randomization failed"); // Randomize Transaction class
      trans.gen_Rmem(); // Generate Rmem from Smem
      trans.display();
      gen2driv.put(trans); // Put transaction packet into mailbox
    end
    -> ended; // Signal that generation is ended
  endtask

endclass
