class transaction;
  rand bit din;   // Define a random input bit "din"
  bit dout;      // Define an output bit "dout"

  function transaction copy();
    copy = new();      // Create a new transaction object
    copy.din = this.din; // Copy the input value
    copy.dout = this.dout; // Copy the output value
  endfunction

  function void display(input string tag);
    $display("[%0s] : DIN : %0b DOUT : %0b", tag, din, dout);
  endfunction
endclass
