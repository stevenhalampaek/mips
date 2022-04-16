/****************************************
 * Author: Steven Halam Paek
 * Description:
 ****************************************/

 module mips_top (  /* Clock/Reset */
                    input clk, 
                    input rst,
                    /* Inputs */
                    input port_sel,
                    input port_en,
                    input [7:0] switches,
                    /* Outputs */
                    output [15:0] leds);

    /* Internal Signals */
    wire [31:0] inst_opcode;
    wire [5:0]  alu_opcode;
    wire        pc_write_cond;
    wire        pc_write;
    wire        i_or_d;
    wire        mem_read;
    wire        mem_write;
    wire        mem_to_reg;
    wire        ir_write;
    wire        is_signed;
    wire [1:0]  pc_source;
    wire        alu_src_a;
    wire [1:0]  alu_src_b;
    wire        reg_write;
    wire        reg_dest;
    wire        jump_and_link;
    wire [31:0] outport;
    wire        port_rst;

    /* Instantiate Sub Blocks */
    mips_controller i_mips_controller (.clk(clk), .rst(rst));

    mips_datapath i_mips_datapath (.clk(clk), .rst(rst));

 endmodule
