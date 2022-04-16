/*********************************************************
 * Author: Steven Paek
 * Description: MIPS Testbench
 *********************************************************/

module tb_mips;

    reg [3:0] memory [0:7];
    reg [4:0] i;

    /* Memory */
    initial
    begin
        $readmemb("/Users/stevenpaek/Desktop/git/mips/rtl/program.txt", memory);
        for (i = 0; i < 8; i = i + 1)
            $display("Memory: %b", memory[i]);
    end    

endmodule
