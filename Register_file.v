module Register_file (

input      clk, RegWrite,
      wire [4:0]  rsA,         //rs address
      wire [4:0]  rtA,         //rt address
      wire [4:0]  write_reg,   //rd address
      wire [31:0] Regwrite_data,

output wire [31:0] rsV,        //rs value
       wire [31:0] rtV         //rt value
);

reg [31:0] registers[31:0];

//.....initialization....//???
//     write part 
always @(posedge clk)
  begin
    if (RegWrite && (write_reg!=0)) //??????
      begin
       registers[write_reg] <= Regwrite_data;
      end 
  end

//     read part 
   assign rsV= registers[rsA];
   assign rtV= registers[rtA];

endmodule
