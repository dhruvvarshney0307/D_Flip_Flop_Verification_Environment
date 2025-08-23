class driver;
  
  transaction tr;
  mailbox #(transaction) mbx;
  virtual dff_if vif;
  
  function new(mailbox #(transaction) mbx, virtual dff_if vif);
    this.mbx = mbx;
    
    if (vif == null) begin
      $fatal(1, "[DRV] Virtual interface handle is null. Driver cannot operate.");
    end
    this.vif = vif;
  endfunction
  
  task reset();
    vif.rst <= 1'b1;
    repeat(5) @(posedge vif.clk);
    vif.rst <= 1'b0;
    vif.din <= 1'b0;
    @(posedge vif.clk);
    $display("[DRV] Reset Done");
  endtask
  
  task run();
    forever begin
      mbx.get(tr);
      $display("[DRV] Got transaction: din=%b", tr.din);

      vif.din <= tr.din;
      @(posedge vif.clk);
    end
  endtask
  
endclass
