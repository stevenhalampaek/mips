/************************************************************
 * Author: 
 * Description: ALU Controller
 ************************************************************/

module alu_controller(  input [5:0]         ir,
                        input [5:0]         op,
                        output reg [4:0]    op_sel,
                        output reg          hi_en,
                        output reg          lo_en,
                        output reg [1:0]    alu_lo_hi);

    /* ALU Operations */
    localparam
        ADD     = 5'd0,
        SUB     = 5'd1,
        MULTS   = 5'd2, 
        MULTU   = 5'd3,
        AND     = 5'd4,
        SRL     = 5'd5,
        SRA     = 5'd6,
        SLT     = 5'd7,
        BGT     = 5'd8,
        BLTE    = 5'd9,
        OR      = 5'd10,
        XOR     = 5'd11,
        BEQ     = 5'd12,
        BNE     = 5'd13,
        BLT     = 5'd14,
        BGTE    = 5'd15,
        SLL     = 5'd16,
        JA      = 5'd17,
        JAL     = 5'd18,
        JR      = 5'd19,
        MFHI    = 5'd20,
        MFLO    = 5'd21,
        SLTU    = 5'd22,
        SW      = 5'd23,
        LW      = 5'd24;

    always @ (*) begin

        /* Initialize */
        op_sel      = 0;
        hi_en       = 0;
        lo_en       = 0;
        alu_lo_hi   = 0;

        /* ALU OP MUX*/
        case(op)
            /* R-Type Instructions */
            6'b000000:
                case(ir)
                6'b100001 :
                    begin
                        op_sel      = ADD;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end /* End of case ADD */
    
                6'b100011 :
                    begin
                        op_sel      = SUB;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end /* End of case SUB */
    
                6'b011000:
                    begin
                        op_sel      = MULTS;
                        hi_en       = 1;
                        lo_en       = 1;
                        alu_lo_hi   = 0;
                    end
    
                6'b011001:
                    begin
                        op_sel      = MULTU;
                        hi_en       = 1;
                        lo_en       = 1;
                        alu_lo_hi   = 0;
                    end
    
                6'b100100:
                    begin
                        op_sel      = AND;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
    
                6'b000010:
                    begin
                        op_sel      = SRL;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
    
    
                6'b000011:
                    begin
                        op_sel      = SRA;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
    
                6'b101010:
                    begin
                        op_sel      = SLT;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
    
                6'b101011:
                    begin
                        op_sel      = SLT;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
   
                6'b100101:
                    begin
                        op_sel      = OR;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
    
                6'b100110:
                    begin
                        op_sel      = XOR;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
   
                6'b000000:
                    begin
                        op_sel      = SLL;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
   
                /* Jump Register */
                6'b001000:
                    begin
                        op_sel      = ADD;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 0;
                    end
    
                6'b010000: /* Do nothing */
                    begin
                        op_sel      = MFHI;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 2'b10;
                   end
    
                6'b010010: /* Do nothing */
                    begin
                        op_sel      = MFLO;
                        hi_en       = 0;
                        lo_en       = 0;
                        alu_lo_hi   = 2'b01;
                  end
                endcase /* End of ir case */

            /* I-Type: Add Immediate */
            6'b001001:
                begin
                    op_sel      = ADD;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* I-Type: Sub Immediate */
            6'b010000:
                begin
                    op_sel      = SUB;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* I-Type: And Immediate */
            6'b001100:
                begin
                    op_sel      = AND;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* I-Type: Or Immediate */
            6'b001101:
                begin
                    op_sel      = OR;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* I-Type: Xor Immediate */
            6'b001110:
                begin
                    op_sel      = XOR;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* I-Type: Load Word */
            6'b100011:
                begin
                    op_sel      = ADD;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* I-Type: Store Word */
            6'b101011:
                begin
                    op_sel      = ADD;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* Branch beq */
            6'b000100:
                begin
                    op_sel      = BEQ;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* Branch bne */
            6'b000101:
                begin
                    op_sel      = BNE;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* Branch bltez */
            6'b000110:
                begin
                    op_sel      = BLTE;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* Branch bgtz */
            6'b000111:
                begin
                    op_sel      = BGT;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

            /* Branch bltz bgtez */
            6'b000001:
                begin
                    op_sel      = BLT;
                    hi_en       = 0;
                    lo_en       = 0;
                    alu_lo_hi   = 0;
                end

        endcase /* End of op case */
    end /* End of always */

endmodule
