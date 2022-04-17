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
                    input [31:0] user_input,
                    /* Outputs */
                    output [15:0] leds);

    /* Internal Signals */
    wire [31:0] opcode;
    wire [5:0]  ALUOp;
    wire        PCWriteCond;
    wire        PCWrite;
    wire        IorD;
    wire        MemRead;
    wire        MemWrite;
    wire        MemToReg;
    wire        IRWrite;
    wire        isSigned;
    wire [1:0]  PCSource;
    wire        ALUSrcA;
    wire [1:0]  ALUSrcB;
    wire        RegWrite;
    wire        RegDst;
    wire        JumpAndLink;
    wire [31:0] outport;
    wire        port_rst;

    /* Instantiate Sub Blocks */
    mips_controller i_mips_controller ( .clk(clk), 
                                        .rst(rst),
                                        .opcode(opcode),
                                        .PCWriteCond(PCWriteCond),
                                        .PCWrite(PCWrite),
                                        .IorD(IorD),
                                        .MemRead(MemRead),
                                        .MemWrite(MemWrite),
                                        .MemToReg(MemToReg),
                                        .IRWrite(IRWrite),
                                        .isSigned(isSigned),
                                        .PCSource(PCSource),
                                        .ALUOp(ALUOp),
                                        .ALUSrcA(ALUSrcA),
                                        .ALUSrcB(ALUSrcB),
                                        .RegWrite(RegWrite),
                                        .RegDst(RegDst),
                                        .JumpAndLink(JumpAndLink));

    mips_datapath i_mips_datapath ( .clk(clk), 
                                    .rst(rst),
                                    .port_rst(port_rst),
                                    .PCWriteCond(PCWriteCond),
                                    .PCWrite(PCWrite),
                                    .IorD(IorD),
                                    .MemRead(MemRead),
                                    .MemWrite(MemWrite),
                                    .MemToReg(MemToReg),
                                    .IRWrite(IRWrite),
                                    .JumpAndLink(JumpAndLink),
                                    .isSigned(isSigned),
                                    .PCSource(PCSource),
                                    .ALUOp(ALUOp),
                                    .ALUSrcA(ALUSrcA),
                                    .ALUSrcB(ALUSrcB),
                                    .RegWrite(RegWrite),
                                    .RegDst(RegDst),
                                    .in_sel(in_sel),
                                    .in_en(in_en),
                                    .in0_1(user_input),
                                    .outport(outport),
                                    .opcode(opcode));

 endmodule
