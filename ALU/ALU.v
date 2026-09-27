//-----------------------------------------------------------------------------
// Module      : alu_4bit
// Description : Simple registered 4-bit ALU supporting add, subtract,
//               bitwise NOT of A and reduction-OR of B.
//-----------------------------------------------------------------------------
module alu_4bit (
    input               clk,
    input               reset,
    input        [1:0]  opcode,   // Operation select
    input  signed [3:0] a,        // Operand A, 2's complement
    input  signed [3:0] b,        // Operand B, 2's complement

    output reg signed [4:0] c     // ALU result, 2's complement
);

    // Opcode encoding
    localparam OP_ADD            = 2'b00; // c = a + b
    localparam OP_SUB            = 2'b01; // c = a - b
    localparam OP_NOT_A          = 2'b10; // c = ~a
    localparam OP_REDUCTION_OR_B = 2'b11; // c = |b

    reg signed [4:0] alu_result;

    // Combinational operation select
    always @(*) begin
        case (opcode)
            OP_ADD:            alu_result = a + b;
            OP_SUB:            alu_result = a - b;
            OP_NOT_A:          alu_result = ~a;
            OP_REDUCTION_OR_B: alu_result = |b;
            default:           alu_result = 5'sd0;
        endcase
    end

    // Registered output
    always @(posedge clk or posedge reset) begin
        if (reset)
            c <= 5'sd0;
        else
            c <= alu_result;
    end

endmodule
