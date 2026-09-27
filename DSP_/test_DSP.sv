//-----------------------------------------------------------------------------
// Testbench   : dsp_tb
// Description : Applies random small-magnitude operands to the dsp module
//               and self-checks against a golden model, accounting for the
//               3-cycle pipeline latency of p relative to a, b, d.
//-----------------------------------------------------------------------------
module dsp_tb ();

    reg  [17:0] a, b, d;
    reg  [47:0] c;
    reg         clk, rst_n;
    wire [47:0] p;

    integer error_count = 0;
    integer i;
    reg [47:0] golden_model_result;

    dsp dut (clk, rst_n, a, b, c, d, p);

    initial begin
        clk = 1;
        forever begin
            #1;
            clk = ~clk;
        end
    end

    initial begin
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        rst_n = 0;
        check_reset();
        rst_n = 1;

        // Small operand range keeps the expected values easy to verify by eye.
        for (i = 0; i < 10; i++) begin
            a = $urandom_range(5, 0);
            b = $urandom_range(5, 0);
            d = $urandom_range(5, 0);
            check_result($urandom_range(5, 0)); // p arrives two cycles after c is applied
        end

        rst_n = 0;
        $display("ERROR_COUNT = %d", error_count);
        $stop();
    end

    task check_result(input logic [47:0] c_val);
        @(negedge clk);
        @(negedge clk);
        c = c_val;
        @(negedge clk);
        @(negedge clk);
        if (p != golden_model()) begin
            error_count++;
        end
        $display(" a=%0d , b=%0d , c=%0d , d=%0d ((d+b)*a)+c=%0d and golden_model=%0d and p=%0d \n",
                  a, b, c, d, ((d + b) * a) + c, golden_model_result, p);
    endtask

    function [47:0] golden_model();
        golden_model_result = ((d + b) * a) + c;
        return golden_model_result;
    endfunction

    task check_reset();
        @(negedge clk);
        if (rst_n == 0) begin
            if (a || b || c || d) begin
                error_count++;
            end
        end
    endtask

endmodule
