module ALU_control(
input  wire [1:0]         alu_op,
input  wire [5:0]         funct,   
output reg [3:0]      ALUcontrol
);
always @*
  begin
    //ALUcontrol = 4'b0000; // default at start of always//???
    if (alu_op == 2'b10) begin                  //R_type
        case (funct) 
            6'b100000 :   ALUcontrol= 4'b0010;  //add
            6'b100010 :   ALUcontrol= 4'b0110;  //sub
            6'b100100 :   ALUcontrol= 4'b0000;  //AND
            6'b100101 :   ALUcontrol= 4'b0001;  //OR
            6'b101010 :   ALUcontrol= 4'b0111;  //slt
        endcase
      end 
    else begin
        case(alu_op)
            2'b00     :   ALUcontrol= 4'b0010;  //add
            2'b01     :   ALUcontrol= 4'b0110;  //sub
            2'b10     :   ALUcontrol= 4'b0000;  //AND
        endcase
       end

  end 

endmodule
