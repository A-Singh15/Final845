`timescale 1ns/1ps

`include "defines.sv"

class driver;

  // Number of transactions and loop variable
  int no_transactions = 0, j;             

  // Virtual interface handle
  virtual top_if topif;      

  // Mailbox handle for Gen2Driver
  mailbox gen2driv;                   
  
  // Constructor: Initializes the virtual interface and mailbox
  function new(virtual top_if topif, mailbox gen2driv);
    this.topif = topif; 
    this.gen2driv = gen2driv;     
  endfunction

  // Start task: Resets the values in memories before starting the operation
  task start;
    $display(" ================================================= Start of driver, topif.start: %b =================================================\n", topif.start);
    wait(!topif.start);
    $display(" ================================================= [DRIVER_INFO] Initialized to Default =================================================\n");
    for(j = 0; j < `SMEM_MAX; j++)
      `DRIV_IF.S_mem[j] <= 0;
    for(j = 0; j < `RMEM_MAX; j++)
      `DRIV_IF.R_mem[j] <= 0;
    wait(topif.start);
    $display(" ================================================= [DRIVER_INFO] All Memories Set =================================================");
  endtask
  
  // run task: Drives transactions into DUT through the interface
  task run();
    Transaction trans;
    int timeout_counter;
    forever begin
      gen2driv.get(trans);
      $display(" *---------*----------*--------* DRIVER TRANSACTION -%0d *--------*--------*-------*----------*", no_transactions);
      topif.R_mem = trans.R_mem;  // Drive R_mem to interface
      topif.S_mem = trans.S_mem;  // Drive S_mem to interface
      topif.start = 1; 
      @(posedge topif.ME_DRIVER.clk);
      `DRIV_IF.Expected_motionX <= trans.Expected_motionX;  // Drive Expected Motion X to interface
      `DRIV_IF.Expected_motionY <= trans.Expected_motionY;  // Drive Expected Motion Y to interface
      $display("[DRIVER_INFO]     :: Driver Packet Expected_motionX: %d and Expected_motionY: %d", trans.Expected_motionX, trans.Expected_motionY);       

      timeout_counter = 0;
      while (topif.completed != 1) begin
        @(posedge topif.ME_DRIVER.clk);
        timeout_counter++;
        if (timeout_counter > 1000000) begin
          $error("Timeout occurred waiting for DUT to complete");
          $finish;
        end
      end

      topif.start = 0;
      $display("[DRIVER_INFO]     :: DUT sent completed = 1 ");
      no_transactions++;
      @(posedge topif.ME_DRIVER.clk);
    end
  endtask
  
endclass
