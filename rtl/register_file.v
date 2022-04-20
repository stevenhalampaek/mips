/************************************************************
 * Author: Steven Paek
 * Description: Register File
 *
 * Register 00: Zero Register - Always Contains 0
 * Register 01: General Purpose Register
 * Register 02: General Purpose Register
 * Register 03: General Purpose Register
 * Register 04: General Purpose Register
 * Register 05: General Purpose Register
 * Register 06: General Purpose Register
 * Register 07: General Purpose Register
 * Register 08: General Purpose Register
 * Register 09: General Purpose Register
 * Register 10: General Purpose Register
 * Register 11: General Purpose Register
 * Register 12: General Purpose Register
 * Register 13: General Purpose Register
 * Register 14: General Purpose Register
 * Register 15: General Purpose Register
 * Register 16: General Purpose Register
 * Register 17: General Purpose Register
 * Register 18: General Purpose Register
 * Register 19: General Purpose Register
 * Register 20: General Purpose Register
 * Register 21: General Purpose Register
 * Register 22: General Purpose Register
 * Register 23: General Purpose Register
 * Register 24: General Purpose Register
 * Register 25: General Purpose Register
 * Register 26: General Purpose Register
 * Register 27: General Purpose Register
 * Register 29: General Purpose Register
 * Register 30: General Purpose Register
 * Register 31: General Purpose Register
 ************************************************************/

module register_file(   input           clk,
                        input           rst,
                        input           wr_en,
                        input           JumpAndLink,
                        input  [31:0]   jal_addr,
                        input  [4:0]    wr_addr,
                        input  [31:0]   wr_data,
                        input  [4:0]    rd_addr0,
                        input  [4:0]    rd_addr1,
                        output reg [31:0]   rd_data0,
                        output reg [31:0]   rd_data1);

    /* Register Array */
    reg [31:0] registers [0:31];
    reg [31:0] debug_r17;
    reg [31:0] debug_r18;
    reg [31:0] debug_r19;
    reg [31:0] debug_r20;
    reg [31:0] debug_r21;
    reg [31:0] debug_r22;
    reg [31:0] debug_r23;

    integer i;
    always @(posedge clk)
    begin
        if (rst == 1) begin
            debug_r17 = 32'b0;            
            debug_r18 = 32'b0;
            debug_r19 = 32'b0;
            debug_r20 = 32'b0;
            debug_r21 = 32'b0;
            debug_r22 = 32'b0;
            debug_r23 = 32'b0;
            /* Clear all registers */
            for (i = 0; i < 32; i = i + 1)
                registers[i] = 32'b0;
        end else begin /* End of rst */

            /* Jump And Link Reg 31 */
            if (JumpAndLink)
                registers[31] = jal_addr;

            /* Write Port 0 */
            if (wr_en) begin
                if (wr_addr == 5'b0) begin
                    registers[0] = 32'b0;
                end else begin /* End of addr 0 */
                    registers[wr_addr] = wr_data;
                end /* End of other addr */
            end /* End of write */

            /* Read Port 0 */
            if (rd_addr0 == 5'b0)
                rd_data0 = 32'b0;
            else
                rd_data0 = registers[rd_addr0];

            /* Read Port 1 */
            if (rd_addr1 == 5'b0)
                rd_data1 = 32'b0;
            else
                rd_data1 = registers[rd_addr1];
            debug_r17 = registers[17];            
            debug_r18 = registers[18];
            debug_r19 = registers[19];
            debug_r20 = registers[20];
            debug_r21 = registers[21];
            debug_r22 = registers[22];
            debug_r23 = registers[23];

        end /* End of else */
    end /* End posedge clk */

endmodule
