//-----------------------------------------------------------------------------
// Testbench   : alu_4bit_tb
// Description : Directed self-checking testbench for alu_4bit. Exercises
//               extreme operand values on add/subtract, checks NOT and
//               reduction-OR opcodes, sweeps every opcode on a fixed operand
//               pair, and checks the async reset.
//-----------------------------------------------------------------------------
module alu_4bit_tb ();

    logic               clk, rst;
    logic        [1:0]  opcode;
    logic signed [3:0]  a, b;
    logic signed [4:0]  c;

    integer error_count = 0;

    localparam MAX_INPUT_VALUE = 7;
    localparam MIN_INPUT_VALUE = -8;

    alu_4bit dut (clk, rst, opcode, a, b, c);

    // Free-running clock
    initial begin
        clk = 0;
        forever begin
            #1;
            clk = ~clk;
        end
    end

    // Pulse reset once at the start
    initial begin
        rst = 1;
        #1;
        rst = 0;
    end

    initial begin
        opcode = 2'b00; apply_extreme_input_values();
        opcode = 2'b01; apply_extreme_input_values();

        opcode = 2'b10;
        a = 4'b1101;
        b = 4'b0100;
        @(negedge clk);
        if (c != (~a)) begin
            $display("ERROR   a=%b , b=%b , c=%b opcode=%b \n", a, b, c, opcode);
            error_count++;
        end

        opcode = 2'b11;
        a = 4'b1111;
        b = 4'b0100;
        @(negedge clk);
        if (c != (|b)) begin
            $display("ERROR   a=%b , b=%b , c=%b opcode=%b\n", a, b, c, opcode);
            error_count++;
        end

        // Finally, sweep every opcode on a fixed pair of operands.
        opcode = 2'b00;
        @(negedge clk);
        if ((a + b) != c) error_count++;
        opcode = 2'b01;
        @(negedge clk);
        if ((a - b) != c) error_count++;
        opcode = 2'b10;
        @(negedge clk);
        if (c != (~a)) error_count++;
        opcode = 2'b11;
        @(negedge clk);
        if (c != (|b)) error_count++;
        opcode = 2'bxx;
        @(negedge clk);
        if (c != 0) error_count++;

        // Check reset
        rst = 1;
        @(negedge clk);
        if (c != 0) begin
            $display("ERROR in reset \n");
            error_count++;
        end

        $display("ERROR_COUNT = %d\n", error_count);
        $stop();
    end

    task apply_extreme_input_values();
        $display("apply_extreme_input_values: applying corner-case operand pairs\n");
        a = 0;                 b = 0;                 check_output(a, b);
        a = MAX_INPUT_VALUE;   b = 0;                 check_output(a, b);
        a = 0;                 b = MAX_INPUT_VALUE;   check_output(a, b);
        a = MAX_INPUT_VALUE;   b = 0;                 check_output(a, b);
        a = 0;                 b = MAX_INPUT_VALUE;   check_output(a, b);
        a = MAX_INPUT_VALUE;   b = MAX_INPUT_VALUE;   check_output(a, b);
        a = MIN_INPUT_VALUE;   b = MIN_INPUT_VALUE;   check_output(a, b);
        a = MAX_INPUT_VALUE;   b = MIN_INPUT_VALUE;   check_output(a, b);
        a = MIN_INPUT_VALUE;   b = MAX_INPUT_VALUE;   check_output(a, b);
    endtask

    task check_output(input logic [3:0] a_val, input logic [3:0] b_val);
        $display("check_output: comparing DUT result against the expected value\n");
        @(negedge clk);
        if (opcode == 2'b00) begin
            if ((a + b) != c) begin
                $display("ERROR   a=%b , b=%b , c=%b opcode=%b \n", a, b, c, opcode);
                error_count++;
            end
        end
        else if (opcode == 2'b01) begin
            if ((a - b) != c) begin
                error_count++;
                $display("ERROR   a=%b , b=%b , c=%b opcode=%b \n", a, b, c, opcode);
            end
        end
    endtask

endmodule
