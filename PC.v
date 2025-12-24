module PC (
input        rst, clk,
input  wire  [31:0]in,

output reg   [31:0]out
);

always @(posedge clk)
  begin 
    if(rst)  out= 32'd0;
    else    
      begin
        out<=in;
        in = out + 32'd4;
      end

  end

endmodule