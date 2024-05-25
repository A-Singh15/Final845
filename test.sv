`timescale 1ns/1ps

program automatic test(ac_if.test acif);

    // Declare the environment
    environment env;

    // Initial block to initialize and run the environment
    initial begin
        $vcdpluson;
        env = new(acif);
        env.build();
        env.run();
        env.wrap_up();
    end

endprogram
