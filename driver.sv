class driver;
  transaction tr;                  // Define a transaction object
  mailbox #(transaction) mbx;       // Create a mailbox to receive data from the generator
  virtual dff_if vif;              // virtual interface for DUT

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;                // Initialize the mailbox for receiving data
  endfunction

  task reset();
    vif.rst <= 1'b1;               // Assert reset signal
    repeat(5) @(posedge vif.clk);  // wait for 5 clock cycles
    vif.rst <= 1'b0;               // Deassert reset signal
    @(posedge vif.clk);            // wait for one more clock cycle
    $display("[DRV] : RESET DONE"); // Display reset completion message
  endtask

  task run();
    forever begin
      mbx.get(tr);                 // Get a transaction from the generator
      vif.din <= tr.din;           // Set DUT input from the transaction
      @(posedge vif.clk);          // wait for the rising edge of the clock
      tr.display("DRV");
      vif.din <= 1'b0;             // Set DUT input to 0
      @(posedge vif.clk);          // wait for the rising edge of the clock
    end
  endtask
endclass
