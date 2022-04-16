/************************************************************
 * Author: Steven Paek
 * Description: 
 ************************************************************/

module ram( input           clk,
            input [7:0]     addr,
            inout [31:0]    data,
            input           cs,
            input           we,
            input           oe);

    /* RAM */
    reg [31:0] mem [0:20];
    reg [31:0] tmp;

    always @(posedge clk)
    begin
        if (cs & we)
            mem[addr] <= data;
        else if (cs & !we)
            tmp <= mem[addr];
    end

    assign data = (cs & oe & !we) ? tmp : 'hz;

    initial
    begin
        $readmemb("/Users/stevenpaek/Desktop/git/mips/rtl/program.txt", mem);
    end

endmodule
