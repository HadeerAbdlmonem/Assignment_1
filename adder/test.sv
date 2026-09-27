//-----------------------------------------------------------------------------
// Testbench   : adder_tb
// Description : Directed self-checking testbench for the adder module.
//               Sweeps zero, min, max and combined operand values and
//               checks the reset behavior.
//-----------------------------------------------------------------------------
module adder_tb;

    integer error_count, correct_count;
    localparam MAX_POS = 7;
    localparam MAX_NEG = -8;

    logic              clk;
    logic              rst;
    logic signed [3:0] a;
    logic signed [3:0] b;
    logic signed [4:0] c;

    adder dut (clk, rst, a, b, c);

    initial begin
        clk = 0;
        forever begin
            #1;
            clk = ~clk;
        end
    end

    initial begin
        // Initialize all variables
        error_count   = 0;
        correct_count = 0;
        a = 0;
        b = 0;
        assert_reset();

        a = 0;       b = 0;       check_result(0);
        a = MAX_NEG; b = 0;       check_result(MAX_NEG);
        a = MAX_POS; b = 0;       check_result(MAX_POS);
        a = 0;       b = MAX_NEG; check_result(MAX_NEG);
        a = 0;       b = MAX_POS; check_result(MAX_POS);
        a = MAX_POS; b = MAX_POS; check_result(14);
        a = MAX_NEG; b = MAX_NEG; check_result(-16);
        a = MAX_NEG; b = MAX_POS; check_result(-1);
        a = MAX_POS; b = MAX_NEG; check_result(-1);

        $display("ERROR_COUNT=%d , CORRECT_COUNT=%d \n", error_count, correct_count);
        rst = 1;
        #2;
        $stop();
    end

    task check_result(input integer expected_sum);
        @(negedge clk);
        if (expected_sum == c) begin
            correct_count = correct_count + 1;
        end
        else begin
            $display("ERROR a=%d, b=%d, expected_sum=%d , but the actual output c=%d\n", a, b, expected_sum, c);
            error_count = error_count + 1;
        end
    endtask

    task assert_reset();
        rst = 1;
        @(negedge clk);
        check_result(0);
        rst = 0;
    endtask

endmodule
