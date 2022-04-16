/************************************************************
 * Author: Steven Paek
 * Description: 32-bit Register
 ************************************************************/

module register(    input               clk,
                    input               rst,
                    input               en,
                    input      [31:0]   in,
                    output reg [31:0]   out);

    always @(posedge clk)
    begin
        if (rst) begin
            out = 0;
        end else begin
            if (en)
                out = in;
        end
    end

endmodule
