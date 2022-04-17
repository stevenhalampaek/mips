/************************************************************
 * Author: 
 * Description:
 ************************************************************/

module memory_controller(   input [31:0]    addr,
                            input           MemRead,
                            input           MemWrite,
                            output          wr_en,
                            output          out_en,
                            output [1:0]    mux_sel);

    /* Memory I/O Addresses */
    localparam
        USER_PORT_0 = 32'h0000FFF8,
        USER_PORT_1 = 32'h0000FFFC,
        USER_PORT_2 = 32'h0000FFFC;

    /* */
    always @(*)
    begin
        /* Initialize to 0 */
        wr_en   = 0;
        out_en  = 0;
        mux_sel = 0;

        if (MemRead) begin
            if (addr == USER_PORT_0)
                mux_sel = 2'b01;
            else if (addr == USER_PORT_1)
                mux_sel = 2'b10;
            else
                mux_sel = 0;
        end else if (MemWrite) begin
            if (addr == USER_PORT_2)
                out_en  = 1;
            else
                wr_en   = 1;
        end
    end

endmodule
