/*********************************************************
 *
 *********************************************************/

module tb_alu;

    /* Instantiate ALU */
    alu i_alu ( .in0(in0),
                .in1(in1),
                .shift(shift),
                .op(op),
                .bt(bt),
                .result(result),
                .result_high(result_high));

    /* Internal Signals */
    integer i;
    reg [31:0] in0;
    reg [31:0] in1;
    reg [4:0] shift;
    reg [4:0] op;
    wire bt;
    wire [31:0] result;
    wire [31:0] result_high;

    /* Testbench Stimulus */
    initial
    begin
        for (i = 0; i < 16; i = i+1)
        begin
            in0     = i;
            in1     = 32'b1;
            op      = 5'b0;
            shift   = 5'b0;
            #10;
            $display("Result: %d", result);
        end
        $finish;
    end /* End of Testbench Stimulus */

    /* Testbench Waveform */
    initial
    begin
        $dumpfile("alu_wave.vcd");
        $dumpvars(0, tb_alu);
    end /* End of Waveform Dump */

endmodule
