/************************************************************
 * Author: Steven Paek
 * Description: MIPS Datapath
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
                        input [5:0]     ALUOp,
                        input           ALUSrcA,
                        input [1:0]     ALUSrcB,
                        input           RegWrite,
                        input           RegDst,
                        input           in_sel,
                        input           in_en,
                        input [31:0]    in0_1,
                        output [31:0]   outport,
                        output [31:0]   opcode);

    /* Internal Signals */
    wire [31:0] program_counter_reg_in;
    wire [31:0] program_counter_reg_out;
    wire [31:0] program_counter_wire;
    wire [31:0] memory_out_wire;
    wire [31:0] memory_reg_out_wire;
    wire [31:0] memory_reg_mux_wire;
    wire [31:0] instruction_wire;
    wire [4:0]  instruction_mux_wire;
    wire [31:0] alu_mux_wire;
    wire [31:0] RegA_wire;
    wire [31:0] RegB_wire;
    wire [31:0] RegA_mux_wire;
    wire [31:0] RegB_mux_wire;
    wire [4:0]  op_sel;
    wire [31:0] alu_out_lo;
    wire [31:0] alu_out_hi;
    wire [31:0] alu_reg_out;
    wire [31:0] alu_lo_reg_wire;
    wire [31:0] alu_hi_reg_wire;
    wire        bt;
    wire        lo_en;
    wire        hi_en;
    wire [1:0]  alu_mux_sel;
    wire [31:0] shifted_wire;
    wire [31:0] sign_extended_wire;
    /* Structural Implementation */

    /* Program Counter (PC) */
    register i_program_counter (        .clk(clk),
                                        .rst(rst),
                                        .en(PCWrite || (PCWriteCond && bt)),
                                        .in(program_counter_reg_in),
                                        .out(program_counter_reg_out));

    /* PC MUX */
    assign program_counter_wire = (IorD) ? alu_reg_out : program_counter_reg_out;

    /* Inst/Data Memory */
    memory i_inst_data_memory (         .clk(clk),
                                        .rst(rst),
                                        .port_rst(port_rst),
                                        .addr(program_counter_wire),
                                        .MemRead(MemRead),
                                        .MemWrite(MemWrite),
                                        .inport_sel(in_sel),
                                        .inport_en(in_en),
                                        .WrData(RegB_wire),
                                        .in0_1(in0_1),
                                        .outport(outport),
                                        .data(memory_out_wire));

    /* Memory Data Register */
    register i_mem_data_reg (           .clk(clk),
                                        .rst(rst),
                                        .en(1'b1),
                                        .in(memory_out_wire),
                                        .out(memory_reg_out_wire));

    /* Memory Data MUX */
    assign memory_reg_mux_wire = (MemToReg) ? memory_reg_out_wire : alu_mux_wire;

    /* Instruction Register */
    register i_instruction_register (   .clk(clk),
                                        .rst(rst),
                                        .en(IRWrite),
                                        .in(memory_out_wire),
                                        .out(instruction_wire));
    
    /* Opcode for Controller */
    assign opcode = instruction_wire;

    /* Instruction MUX */
    assign instruction_mux_wire = (RegDst) ? instruction_wire[15:11] : instruction_wire[20:16];

    /* Register File */
    register_file i_register_file (     .clk(clk),
                                        .rst(rst),
                                        .wr_en(RegWrite),
                                        .JumpAndLink(JumpAndLink),
                                        .jal_addr(program_counter_reg_out),
                                        .wr_addr(instruction_mux_wire),
                                        .wr_data(memory_reg_mux_wire),
                                        .rd_addr0(instruction_wire[25:21]),
                                        .rd_addr1(instruction_wire[20:16]),
                                        .rd_data0(RegA_wire),
                                        .rd_data1(RegB_wire));

    /* Sign Extension */
    assign sign_extended_wire = (isSigned) ? {16'hFFFF, instruction_wire[15:0]} : {16'b0, instruction_wire[15:0]};
    
    /* Shift */
    assign shifted_wire = {sign_extended_wire[29:0], 2'b0};
    
    /* Reg A MUX */
    assign RegA_mux_wire = (ALUSrcA) ? RegA_wire : program_counter_reg_out;

    /* Reg B MUX */
    assign RegB_mux_wire = (ALUSrcB[1]) ? (ALUSrcB[0] ? shifted_wire : sign_extended_wire) : (ALUSrcB[0] ? 32'd4 : RegB_wire);

    /* Arithmetic Logic Unit (ALU) */
    alu i_alu (                         .in0(RegA_mux_wire),
                                        .in1(RegB_mux_wire),
                                        .shift(instruction_wire[10:6]),
                                        .op(op_sel),
                                        .bt_out(bt),
                                        .result_out(alu_out_lo),
                                        .result_out_high(alu_out_hi));

    /* Arithmetic Logic Unit (ALU) Controller */
    alu_controller i_alu_controller (   .ir(instruction_wire[5:0]),
                                        .op(ALUOp),
                                        .op_sel(op_sel),
                                        .hi_en(hi_en),
                                        .lo_en(lo_en),
                                        .alu_lo_hi(alu_mux_sel));

    /* ALU Output Register */
    register i_alu_out_reg (            .clk(clk),
                                        .rst(rst),
                                        .en(1'b1),
                                        .in(alu_out_lo),
                                        .out(alu_reg_out));

    /* ALU Lo Register */
    register i_alu_lo_reg (             .clk(clk),
                                        .rst(rst),
                                        .en(lo_en),
                                        .in(alu_out_lo),
                                        .out(alu_lo_reg_wire));

    /* ALU Hi Register */
    register i_alu_hi_reg (             .clk(clk),
                                        .rst(rst),
                                        .en(hi_en),
                                        .in(alu_out_hi),
                                        .out(alu_hi_reg_wire));

    /* ALU MUX */
    assign alu_mux_wire = (alu_mux_sel[1]) ? (alu_mux_sel[0] ? 32'b0 : alu_hi_reg_wire) : (alu_mux_sel[0] ? alu_lo_reg_wire : alu_reg_out);

    /* Program Counter Feedback MUX */
    assign program_counter_reg_in = (PCSrc[1]) ? (PCSrc[0] ? 32'b0 : ({program_counter_reg_out[31:28], instruction_wire[25:0], 2'b00})) : (PCSrc[0] ? alu_reg_out : alu_out_lo);

endmodule
