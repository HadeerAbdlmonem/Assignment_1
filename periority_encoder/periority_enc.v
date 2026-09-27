//-----------------------------------------------------------------------------
// Module      : priority_enc
// Description : Registered 4-to-2 priority encoder. Bit 0 of d has the
//               lowest priority, bit 3 the highest. valid is low only when
//               d is all zeros.
//-----------------------------------------------------------------------------
module priority_enc (
    input        clk,
    input        rst,
    input  [3:0] d,
    output reg [1:0] y,
    output reg       valid
);

    always @(posedge clk) begin
        if (rst) begin
            y     <= 2'b0;
            valid <= 0;
        end
        else begin
            casex (d)
                4'b1000: y <= 2'b00;
                4'bX100: y <= 2'b01;
                4'bXX10: y <= 2'b10;
                4'bXXX1: y <= 2'b11;
                default: y <= y; // d == 4'b0000: hold previous value, valid goes low below
            endcase
            valid <= (~|d) ? 1'b0 : 1'b1;
        end
    end

endmodule
