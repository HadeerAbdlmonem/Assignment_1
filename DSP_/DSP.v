//-----------------------------------------------------------------------------
// Module      : dsp
// Description : 3-stage pipelined multiply-accumulate DSP slice.
//               Stage 1: register inputs, compute (d +/- b).
//               Stage 2: multiply a_reg_stg2 by the add/sub result.
//               Stage 3: add/subtract c_reg to/from the multiply result -> p.
//-----------------------------------------------------------------------------
module dsp (
    input                clk,
    input                rst_n,
    input        [17:0]  a,
    input        [17:0]  b,
    input        [47:0]  c,
    input        [17:0]  d,
    output reg   [47:0]  p
);

    parameter OPERATION = "ADD"; // "ADD" or "SUBTRACT"

    reg [17:0] a_reg_stg1, a_reg_stg2, b_reg, d_reg;
    reg [18:0] adder_out_stg;  // one extra bit to avoid overflow on d +/- b
    reg [47:0] c_reg;
    reg [36:0] mult_out;       // width = width(multiplier) + width(multiplicand)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg_stg1    <= 0;
            a_reg_stg2    <= 0;
            b_reg         <= 0;
            d_reg         <= 0;
            c_reg         <= 0;
            adder_out_stg <= 0;
            mult_out      <= 0;
            p             <= 0;
        end
        else begin
            a_reg_stg1 <= a;
            a_reg_stg2 <= a_reg_stg1;
            b_reg      <= b;
            c_reg      <= c;
            d_reg      <= d;

            if (OPERATION == "ADD") begin
                adder_out_stg <= d_reg + b_reg;
                p             <= mult_out + c_reg;
            end
            else if (OPERATION == "SUBTRACT") begin
                adder_out_stg <= d_reg - b_reg;
                p             <= mult_out - c_reg;
            end

            mult_out <= a_reg_stg2 * adder_out_stg;
        end
    end

endmodule
