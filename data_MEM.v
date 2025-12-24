module data_MEM (      
input            clk,
input wire       memr, //read enable
input wire       memw, //write enable
input wire [31:0]datain,
input wire [4:0]address, // for 32 words

output reg [31:0]dataout
);

reg [31:0] d_mem [0:63];   // 64x32 data memory

always @(posedge clk)
  begin
    if(memw && ~memr)    d_mem[address] <= datain;
    else                 dataout <= d_mem[address];
  end
endmodule