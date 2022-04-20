/*********************************************************
 *
 *********************************************************/

module tb_register;

    /* Instantiate ALU */
    register i_reg ( .clk(clk),
                .rst(rst),
                .en(en),
                .in(in),
                .out(out));

    /* Internal Signals */
    integer i;
    reg [31:0] in;
    wire [31:0] out;
    reg  clk = 1;
    reg  rst = 1;
    reg en;

    always #10 clk = ~clk;
    /* Testbench Stimulus */
    initial
    begin
        # 20 rst = 0;
        for (i = 0; i < 16; i = i+1)
        begin
            in     = i;
            en = 0;
            if (i%4 == 0)
                en = 1;
            else
                en = 0;
            #10;
        end
        $finish;
    end /* End of Testbench Stimulus */

    initial
    #160 $finish;

    /* Testbench Waveform */
    initial
    begin
        $dumpfile("register_wave.vcd");
        $dumpvars(0, tb_register);
    end /* End of Waveform Dump */

endmodule
