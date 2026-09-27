//-----------------------------------------------------------------------------
// Testbench   : priority_enc_tb
// Description : Exhaustively drives every 4-bit input pattern at priority_enc
//               and self-checks y/valid, then checks reset.
//-----------------------------------------------------------------------------
module priority_enc_tb ();

    reg        clk;
    reg        rst;
    reg  [3:0] d;
    wire [1:0] y;
    wire       valid;

    integer i;
    integer error_count;
    integer correct_count;

    priority_enc dut (clk, rst, d, y, valid);

    initial begin
        error_count   = 0;
        correct_count = 0;
        rst = 1;
        clk = 0;
        forever begin
            #1;
            clk = ~clk;
        end
    end

    initial begin
        rst = 0;
        for (i = 0; i < 16; i = i + 1) begin
            d = i;
            self_check(d);
        end

        d   = 0;
        rst = 1;
        check_reset();
        #1;
        rst = 0;
        #1;
        rst = 1;
        check_reset();
        #1;

        $display("ERROR_COUNT=%d ,CORRECT_COUNT=%d \n", error_count, correct_count);
        $stop();
    end

    task self_check(input [3:0] d_combination);
        @(negedge clk);
        casex (d_combination)
            4'bxxx1: begin
                check_y(2'b11);
                check_valid(1'b1);
            end
            4'bxx10: begin
                check_y(2'b10);
                check_valid(1'b1);
            end
            4'bx100: begin
                check_y(2'b01);
                check_valid(1'b1);
            end
            4'b1000: begin
                check_y(2'b00);
                check_valid(1'b1);
            end
            4'b0000: begin
                correct_count++;
                check_valid(1'b0);
            end
        endcase
    endtask

    task check_y(input [1:0] expected_y);
        if (y != expected_y) begin
            $display("ERROR IN Y -------> actual_output_y=%b , expected_output_y=%b \n", y, expected_y);
            error_count++;
        end
        else begin
            correct_count++;
        end
    endtask

    task check_valid(input expected_valid);
        if (valid != expected_valid) begin
            $display("ERROR IN Valid ------> expected_valid_output_value=%b , actual_output_valid=%b\n", expected_valid, valid);
            error_count++;
        end
        else begin
            correct_count++;
        end
    endtask

    task check_reset();
        @(negedge clk);
        if (y || valid) begin
            $display("ERROR in reset\n");
            error_count++;
        end
        else correct_count++;
    endtask

endmodule
