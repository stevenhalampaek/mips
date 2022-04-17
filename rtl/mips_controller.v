/************************************************************
 * Author: Steven Paek
 * Description: MIPS Pipeline Controller
 ************************************************************/

module mips_controller( input clk,
                        input rst,
                        input [31:0]    opcode,
                        output          PCWriteCond,
                        output          PCWrite,
                        output          IorD,
                        output          MemRead,
                        output          MemWrite,
                        output          IRWrite,
                        output          isSigned,
                        output [1:0]    PCSource,
                        output [5:0]    ALUOp,
                        output          ALUSrcA,
                        output [1:0]    ALUSrcB,
                        output          RegWrite,
                        output          RegDst,
                        output          JumpAndLink);

    /* Controller States */
    localparam
        INIT                = 5'd0,
        INSTRUCTION_FETCH   = 5'd1,
        INSTRUCTION_DECODE  = 5'd2,
        JUMP_STATE_0        = 5'd3,
        JUMP_STATE_1        = 5'd4,
        JR_STATE            = 5'd5,
        JUMP_LINK_STATE_0   = 5'd6,
        JUMP_LINK_STATE_1   = 5'd7,
        R_TYPE_0            = 5'd8,
        R_TYPE_1            = 5'd9,
        R_TYPE_2            = 5'd10,
        IMMEDIATE_0         = 5'd11,
        IMMEDIATE_1         = 5'd12,
        IMMEDIATE_2         = 5'd13,
        IMMEDIATE_3         = 5'd14,
        LOAD_0              = 5'd15,
        LOAD_1              = 5'd16,
        LOAD_2              = 5'd17,
        LOAD_3              = 5'd18,
        LOAD_4              = 5'd19,
        LOAD_PORT_0         = 5'd20,
        LOAD_PORT_1         = 5'd21,
        STORE_0             = 5'd22,
        STORE_1             = 5'd23,
        STORE_2             = 5'd24,
        WAIT                = 5'd25,
        BRANCH_0            = 5'd26,
        BRANCH_1            = 5'd27,
        BRANCH_2            = 5'd28,
        DUMMY_0             = 5'd29,
        DUMMY_1             = 5'd30,
        DUMMY_2             = 5'd31;

    /* State Signals */
    reg [4:0] state;

    always @(posedge clk)
    begin
        /* Reset All Outputs */
        if (rst) begin
            state       = INIT;
            PCWriteCond = 0;
            JumpAndLink = 0;
            PCWrite     = 0;
            IorD        = 0;
            MemRead     = 0;
            MemWrite    = 0;
            MemToReg    = 0;
            IRWrite     = 0;
            isSigned    = 0;
            PCSource    = 0;
            ALUOp       = 0;
            ALUSrcA     = 0;
            ALUSrcB     = 0;
            RegWrite    = 0;
            RegDst      = 0;
        end else begin /* End of if rst */

            /* Initialize Outputs Before Assignment */
            PCWriteCond = 0;
            JumpAndLink = 0;
            PCWrite     = 0;
            IorD        = 0;
            MemRead     = 0;
            MemWrite    = 0;
            MemToReg    = 0;
            IRWrite     = 0;
            isSigned    = 0;
            PCSource    = 0;
            ALUOp       = 0;
            ALUSrcA     = 0;
            ALUSrcB     = 0;
            RegWrite    = 0;
            RegDst      = 0;

            case (state)
            begin

                INIT:
                    begin
                        state   = INSTRUCTION_FETCH;
                    end

                INSTRUCTION_FETCH:
                    begin
                        state   = INSTRUCTION_DECODE;
                        PCWrite = 1;
                        MemRead = 1;
                        IRWrite = 1;
                        ALUOp   = 6'b001001;
                        ALUSrcB = 2'b01;
                    end

                INSTRUCTION_DECODE:
                    begin
                        ALUSrcA = 0;
                        ALUSrcB = 2'b11;
                        ALUOp   = 6'b001001;
                        case (opcode[31:26])
                        begin
                            6'b000000:
                                state   = R_TYPE_0;
                            6'b000010:
                                state   = JUMP_STATE_0;
                            6'b000011:
                                state   = JUMP_LINK_STATE_0;
                            6'b000100:
                                state   = BRANCH_0;
                            6'b000101:
                                state   = BRANCH_0;
                            6'b001001:
                                state   = IMMEDIATE_1;
                            6'b001010:
                                state   = IMMEDIATE_1;
                            6'b001100:
                                state   = IMMEDIATE_1;
                            6'b001101:
                                state   = IMMEDIATE_1;
                            6'b001110:
                                state   = IMMEDIATE_1;
                            6'b010000:
                                state   = IMMEDIATE_1;
                            6'b100011:
                                state   = LOAD_0;
                            6'b101011:
                                state   = STORE_0;
                            6'b111111:
                                state   = WAIT;
                            default:
                                state   = INSTRUCTION_DECODE;
                        endcase
                    end

                JUMP_STATE_0:
                    begin
                        PCWrite     = 1;
                        PCSource    = 2'b10;
                        state       = JUMP_STATE_1;
                    end

                JUMP_STATE_1:
                    begin
                        PCWrite     = 1;
                        PCSource    = 2'b10;
                        state       = INSTRUCTION_FETCH;
                    end

                JR_STATE:
                    begin
                        state       = INSTRUCTION_FETCH;
                    end

                JUMP_LINK_STATE_0:
                    begin
                        PCWrite     = 1;
                        PCSource    = 2'b10;
                        JumpAndLink = 1;
                        state       = JUMP_LINK_STATE_1;
                    end

                JUMP_LINK_STATE_1:
                    begin
                        PCWrite     = 1;
                        PCSource    = 2'b10;
                        state       = INSTRUCTION_FETCH;
                    end

                R_TYPE_0:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 0;
                        ALUOp       = opcode[31:26];
                        MemToReg    = 0;
                        state       = R_TYPE_1;
                    end

                R_TYPE_1:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 0;
                        ALUOp       = opcode[31:26];
                        MemToReg    = 0;
                        RegDst      = 1;
                        RegWrite    = 0;
                        state       = R_TYPE_2;
                    end

                R_TYPE_2:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 0;
                        ALUOp       = opcode[31:26];
                        MemToReg    = 0;
                        RegDst      = 1;
                        RegWrite    = 1;
                        state       = INSTRUCTION_FETCH;
                        if (opcode[5:0] == 6'b001000) begin
                            PCWrite = 1;
                            state   = JR_STATE;
                        end
                    end

                IMMEDIATE_0:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 2'b10;
                        ALUOp       = opcode[31:26];
                        state       = IMMEDIATE_1;
                    end

                IMMEDIATE_1:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 2'b10;
                        ALUOp       = opcode[31:26];
                        state       = IMMEDIATE_2;
                    end

                IMMEDIATE_2:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 2'b10;
                        ALUOp       = opcode[31:26];
                        RegDst      = 0;
                        RegWrite    = 0;
                        state       = IMMEDIATE_3;
                    end

                IMMEDIATE_3:
                    begin
                        RegDst      = 0;
                        RegWrite    = 1;
                        state       = INSTRUCTION_FETCH;
                    end

                LOAD_0:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 2'b10;
                        ALUOp       = 6'b001001;
                        state       = LOAD_1;
                    end

                LOAD_1:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 2'b10;
                        MemRead     = 1;
                        IorD        = 1;
                        state       = LOAD_2;
                    end

                LOAD_2:
                    begin
                        RegDst      = 0;
                        MemToReg    = 1;
                        RegWrite    = 0;
                        IorD        = 1;
                        if (opcode[15:0] == 16'hFFF8) begin
                            RegWrite    = 1;
                            state       = LOAD_PORT_0;
                        end else if (opcode[15:0] == 16'hFFFC) begin
                            RegWrite    = 1;
                            state       = LOAD_PORT_0;
                        end else begin
                            state       = LOAD_3;
                        end
                    end

                LOAD_3:
                    begin
                        RegDst      = 0;
                        MemToReg    = 1;
                        RegWrite    = 1;
                        state       = LOAD_4;
                    end

                LOAD_4:
                    begin
                        RegDst      = 0;
                        MemToReg    = 1;
                        RegWrite    = 0;
                        state       = INSTRUCTION_FETCH;
                    end

                LOAD_PORT_0:
                    begin
                        state       = LOAD_PORT_1;
                    end

                LOAD_PORT_1:
                    begin
                        state       = INSTRUCTION_FETCH'
                    end

                STORE_0:
                    begin
                        ALUSrcA     = 1;
                        ALUSrcB     = 2'b10;
                        ALUOp       = 6'b001001;
                        state       = STORE_1;
                    end

                STORE_1:
                    begin
                        MemWrite    = 1;
                        IorD        = 1;
                        state       = STORE_2;
                    end

                STORE_2:
                    begin
                        MemWrite    = 0;
                        IorD        = 0;
                        state       = INSTRUCTION_FETCH;
                    end

                WAIT:
                    begin
                        state       = WAIT;
                    end

                BRANCH_0:
                    begin
                        PCWriteCond = 0;
                        PCSource    = 2'b01;
                        ALUOp       = 6'b001001;
                        ALUSrcA     = 0;
                        ALUSrcB     = 2'b11;
                        state       = BRANCH_1;
                    end

                BRANCH_1:
                    begin
                        PCWriteCond = 1;
                        PCSource    = 2'b01;
                        ALUOp       = opcode[31:26];
                        ALUSrcA     = 1;
                        ALUSrcB     = 0;
                        state       = BRANCH_2;
                    end

                BRANCH_2:
                    begin
                        state       = INSTRUCTION_FETCH;
                    end

                DUMMY_0:
                    begin
                    end

                DUMMY_1:
                    begin
                    end

                DUMMY_2:
                    begin
                    end

            endcase /* End case states */

        end /* End of if rst else */
    end /* End of posedge clk */

endmodule
