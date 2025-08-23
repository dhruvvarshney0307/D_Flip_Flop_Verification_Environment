module dff(dff_if vif);
  always_ff @(posedge vif.clk or posedge vif.rst)
    if (vif.rst)
      vif.dout <= 1'b0;
    else
      vif.dout <= vif.din;
endmodule
