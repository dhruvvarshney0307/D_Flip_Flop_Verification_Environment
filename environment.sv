class environment;
  generator gen;  // Generator instance
  driver drv;      // Driver instance
  monitor mon;     // Monitor instance
  scoreboard sco;  // Scoreboard instance
  event next;      // Event to signal communication between generator and scoreboard
  mailbox #(transaction) gdmbox;  // Mailbox for communication between generator and driver
  mailbox #(transaction) msmbox;  // Mailbox for communication between monitor and scoreboard
  mailbox #(transaction) mbxref;  // Mailbox for communication between generator and scoreboard
  virtual dff_if vif;             // virtual interface for DUT

  function new(virtual dff_if vif);
    gdmbox = new(); // Create a mailbox for generator-driver communication
    mbxref = new(); // Create a mailbox for generator-scoreboard reference data
    gen = new(gdmbox, mbxref); // Initialize the generator
    drv = new(gdmbox);         // Initialize the driver
    msmbox = new(); // Create a mailbox for monitor-scoreboard communication
    mon = new(msmbx);          // Initialize the monitor
    sco = new(msmbx, mbxref);  // Initialize the scoreboard
    this.vif = vif;            // Set the virtual interface for DUT
    drv.vif = this.vif;        // Connect the virtual interface to the driver
    mon.vif = this.vif;        // Connect the virtual interface to the monitor
    gen.sconext = next;        // Set the communication event between generator and scoreboard
    sco.sconext = next;        // Set the communication event between scoreboard and generator
  endfunction

  task pre_test();
    drv.reset(); // Perform the driver reset
  endtask

  task test();
    fork
      gen.run(); // Start generator
      drv.run(); // Start monitor
      mon.run(); // Start monitor
      sco.run(); // Start Scoreboard
    join_any
  endtask

  task post_test();
    wait(gen.done.triggered); // Wait for generator to complete
    $finish();                // Finish simulation
  endtask

  task run();
    pre_test();  // Run pre-test setup
    test();      // Run the test
    post_test(); // Run post-test cleanup
  endtask
endclass
