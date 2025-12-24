module Register_file (

input      clk, RegWrite,
      wire [2:0]  rs,   //rs
      wire [2:0]  rt,   //rt
      wire [2:0]  rd,   //rd
      wire [31:0] write_data,

output wire [31:0] Read_data1,
       wire [31:0] Read_data2
);

reg [31:0] registers[31:0];

//.....initialization....//???
//     write part 
always @(posedge clk)
  begin
    if (RegWrite && (rd!=0))
      begin
       registers[rd] <= write_data;
      end 
  end

//     read part 
   assign Read_data1= registers[rs];
   assign Read_data2= registers[rt];

endmodule