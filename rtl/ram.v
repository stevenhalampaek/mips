/************************************************************
 * Author: Steven Paek
 * Description: 
 ************************************************************/

module ram( input           clk,
            input [7:0]     addr,
            input [31:0]    data,
            input           wr_en,
            output [31:0]   q);

    /* RAM */
    reg [31:0] mem [0:255];
    reg [31:0] tmp;

    always @(posedge clk)
    begin
        if (wr_en)
            mem[addr] <= data;
        else
            tmp <= mem[addr];
    end

    assign q = tmp;

    initial
    begin
        $readmemb("/Users/stevenpaek/Desktop/git/mips/rtl/program.txt", mem);
    end

endmodule
