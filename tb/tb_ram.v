/*********************************************************
 *
 *********************************************************/

module tb_ram;

    /* Instantiate ALU */
    ram i_ram ( .clk(clk),
                .addr(addr),
                .data(data),
                .cs(cs),
                .we(we),
                .oe(oe));

    /* Internal Signals */
    integer i;
    reg clk;
    reg we;
    reg cs;
    reg oe;
    reg [7:0] addr;
    wire [31:0] data;
    reg [31:0] tb_data;

    /* Testbench Stimulus */
    always #10 clk = ~clk;

    initial
    begin
        cs = 1'b1;
        oe = 1'b1;
        for (i = 0; i < 20; i = i + 1)
        begin
            addr = i;
            $display("RAM: %h", data);
        end
        $finish;
    end /* End of Testbench Stimulus */

    /* Testbench Waveform */
    initial
    begin
        $dumpfile("ram_wave.vcd");
        $dumpvars(0, tb_ram);
    end /* End of Waveform Dump */

endmodule
