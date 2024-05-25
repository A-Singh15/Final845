`timescale 1ns/1ps

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class environment;
  // Handles for Generator, Driver, Monitor, Scoreboard, and Coverage
  generator gen;                          
  driver driv;
  monitor mon;
  scoreboard scb;
  coverage cov;                 
  
  // Mailbox handles for communication between components
  mailbox gen2driv, mon2scb, mon2cov;      
  
  // Events for synchronization
  event gen_ended;
  event mon_done;
  
  // Virtual interface handle
  virtual top_if topif;          

  // Constructor: Initializes the virtual interface and component instances
  function new(virtual top_if topif);
    this.topif = topif;
    this.build();
  endfunction : new

  // Build function: Initializes the mailboxes and component instances
  function void build();     
    gen2driv = new();
    mon2scb = new();
    mon2cov = new();
    gen = new(gen2driv, gen_ended);
    driv = new(topif, gen2driv);
    mon = new(topif, mon2scb, mon2cov);
    scb = new(mon2scb);
    cov = new(topif, mon2cov);
  endfunction : build

  // Run task: Executes the run tasks of all components
  task run();
    fork
      begin
        driv.start(); 
        driv.run();
      end
      gen.run();
      mon.run();
      scb.run();
      cov.cove();
    join_any
  endtask
  
  // wrap_up task: Waits for completion and prints the coverage report
  task wrap_up();
    wait(gen_ended.triggered);
    wait(gen.trans_count == driv.no_transactions);
    wait(gen.trans_count == scb.no_transactions);
    $display (" Motion Estimator Coverage Report = %0.2f %% \n", cov.ME_Coverage);  // Print coverage report
    //scb.summary();  // Print summary
    $finish;
  endtask 
    
endclass;
