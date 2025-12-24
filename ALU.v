module ALU (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [2:0]  ALUcontrol,

    output reg  [31:0] Result,
    output wire Zero,
    //output wire Negative,
   // output wire Carry,
   // output wire Overflow
);

    always @(*)
    begin
        case (ALUcontrol)
            3'b000: Result = A + B;
            3'b001: Result = A - B;
            3'b010: Result = A & B;
            3'b011: Result = A | B;
            3'b100: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            default: Result = 32'd0;
        endcase
    end

    assign Zero     = (Result == 32'd0);
  /*  assign Negative = Result[31];
    assign Carry = (ALUcontrol == 3'b000) ? (Result < A) :
                   (ALUcontrol == 3'b001) ? ~(A < B)      :
                   1'b0;
    
    assign Overflow = (ALUcontrol == 3'b001) ?
                      ((A[31] ^ B[31]) & (Result[31] ^ A[31])) :
                      1'b0;
*/
endmodule
