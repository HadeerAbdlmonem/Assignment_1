//-----------------------------------------------------------------------------
// Module      : adder
// Description : Registered 4-bit signed adder (5-bit result to avoid
//               overflow).
//-----------------------------------------------------------------------------
module adder (
    input               clk,
    input               reset,
    input  signed [3:0] a,    // Operand A, 2's complement
    input  signed [3:0] b,    // Operand B, 2's complement
    output reg signed [4:0] c // Sum, 2's complement
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            c <= 5'sd0;
        else
            c <= a + b;
    end

endmodule

// Coverage report generation:
// vcover report adder_tb.ucdb -details -annotate -all -output coverage_report.txt
