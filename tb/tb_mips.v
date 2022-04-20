/*********************************************************
 * Author: Steven Paek
 * Description: MIPS Testbench
 *********************************************************/

module tb_mips;

    /* Internal Testbench Signals */
    reg         clk;
    reg         rst;
    reg         port_sel;
    reg         port_en;
    reg[31:0]  user_input;
    wire[15:0]        leds;

    /* Instantiate Block */
    mips_top i_mips_top (   .clk(clk),
                            .rst(rst),
                            .port_sel(port_sel),
                            .port_en(port_en),
                            .user_input(user_input),
                            .leds(leds));


    /* Define Clock Period */
    always #10 clk = ~clk;

    /* Testbench Stimulus */
    initial
    begin
        clk         = 0;
        rst         = 1;
        port_sel    = 0;
        port_en     = 0;
        user_input  = 16'hCAFE;
        #50;
        rst         = 0;
    end

    /* Testbench Duration */
    initial
    #1000 $finish;

    /* Dump Waveform */
    initial begin
        $dumpfile("mips_wave.vcd");
        $dumpvars(0, tb_mips);
    end

endmodule
