class monitor;
    virtual ac_if.test acif;
    transaction tr;
    mailbox mbx;

    extern function new(mailbox mbx, input virtual ac_if.test acif);
    extern virtual task run();
    extern virtual task wrap_up();
endclass : monitor

function monitor::new(mailbox mbx, input virtual ac_if.test acif);
    this.mbx = mbx;
    this.acif = acif;
    tr = new();
endfunction : new

task monitor::run();
    // Wait for reset to be applied and removed
    wait(acif.rst == 1);
    wait(acif.rst == 0);

    // Main monitoring loop
    while (1) begin
        @(acif.cb);
        tr.sum = acif.cb.sum;
        mbx.put(tr);
    end
endtask : run

task monitor::wrap_up();
    //empty for now
endtask : wrap_up
