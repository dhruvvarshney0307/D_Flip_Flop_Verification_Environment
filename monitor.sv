class monitor;
  transaction tr;                  // Define a transaction object
  mailbox #(transaction) mbx;       // Create a mailbox to send data to the scoreboard
  virtual dff_if vif;              // virtual interface for DUT

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;                // Initialize the mailbox for sending data to the scoreboard
  endfunction

  task run();
    tr = new();                    // Create a new transaction
    forever begin
      repeat(2) @(posedge vif.clk); // wait for two rising edges of the clock
      tr.dout = vif.dout;          // Capture DUT output
      mbx.put(tr);                 // send the captured data to the scoreboard
      tr.display("MON");           // display transaction information
    end
  endtask
endclass
