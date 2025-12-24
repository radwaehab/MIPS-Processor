module sign_extd(
input  wire        extd,
input  wire    [15:0]in,
output reg     [31:0]out
);
wire o;
assign o = (~extd)?   {16'h0 ,in} : {16'h0xffff ,in};
assign out = (32'd4)*o;  // shift left 2


/*
alway @*
  begin
    if(~extd)  
  end
*/
endmodule