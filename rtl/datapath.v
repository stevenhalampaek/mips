/************************************************************
 * Author: 
 * Description:
 ************************************************************/

module mips_datapath(   input           clk,
                        input           rst,
                        input           port_rst,
                        input           PCWriteCond,
                        input           PCWrite,
                        input           IorD,
                        input           MemRead,
                        input           MemWrite,
                        input           MemToReg,
                        input           IRWrite,
                        input           JumpAndLink,
                        input           isSigned,
                        input [1:0]     PCSrc,
                        input [5:0]     ALU_Op,
                        input           ALU_SrcA,
                        input [1:0]     ALU_SrcB,
                        input           RegWrite,
                        input           RegDst,
                        input           in_sel,
                        input           in_en,
                        input [31:0]    in0_1,
                        output [31:0]   outport,
                        output [31:0]   opcode);

    /* Internal Signals */
    wire [31:0] pc_in_wire;
    wire [31:0] pc_out_wire;
    wire pc_mux_wire;
    wire memory_out_wire;
    wire memory_data_out_wire;
    wire ir_out_wire;

    /* Structural Implementation */

    /* Program Counter (PC) */

    /* PC MUX */

    /* Inst/Data Memory */

    /* Register File */

    /* Reg A */

    /* Reg B */

    /* Arithmetic Logic Unit (ALU) */



endmodule
