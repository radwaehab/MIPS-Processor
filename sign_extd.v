 module sign_extd(
input  wire        extd,
input  wire    [15:0]in,
output reg     [31:0]out
);

wire msb;
assign  msb = in[15];
assign out =  (extd)?   (msb? {16'hffff ,in} : {16'h0 ,in} ) : 
                        {16'h0 ,in};

endmodule
