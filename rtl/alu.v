/************************************************************
 * Author: Steven Paek
 * Description: ALU
 ************************************************************/

module alu( input [31:0]        in0,
            input [31:0]        in1,
            input [4:0]         shift,
            input [4:0]         op,
            output          bt,
            output [31:0]   result,
            output [31:0]   result_high);

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

    reg [63:0] tmp_unsigned;
    reg signed [63:0] tmp_signed;

    always @ (*) begin

        /* Initialize */
        tmp_unsigned    = 0;
        tmp_signed      = 0;
        bt              = 0;
        result          = 0;
        result_high     = 0;

        /* ALU OP MUX*/
        case(op)

            ADD :
                begin
                    result      = in0 + in1;
                end /* End of case ADD */

            SUB :
                begin
                    result      = in0 - in1;
                end /* End of case SUB */

            MULTS:
                begin
                    tmp_signed  = $signed(in0) * $signed(in1);
                    result      = tmp_signed[31:0];
                    result_high = tmp_signed[63:32];
                end

            MULTU:
                begin
                    tmp_unsigned    = in0 * in1;
                    result          = tmp_unsigned[31:0];
                    result_high     = tmp_unsigned[63:32];
                end

            AND:
                begin
                    result  = in0 & in1;
                end

            SRL:
                begin
                    result  = in1 >> shift;
                end


            SRA:
                begin
                    result in1 >>> shift;
                end

            SLT:
                begin
                    if ($signed(in0) < $signed(in1))
                        result = 32'b1;
                end

            BGT:
                begin
                    if ($signed(in0) > $signed(0))
                        bt = 1'b1;
                end

            BLTE:
                begin
                    if ($signed(in0) <= $signed(0))
                        bt = 1'b1;
                end

            OR:
                begin
                    result = in0 | in1;
                end

            XOR:
                begin
                    result = in0 ^ in1;
                end

            BEQ:
                begin
                    if ($signed(in0) == $signed(in1))
                        bt = 1;
                end

            BNE:
                begin
                    if ($signed(in0) != $signed(in1))
                        bt = 1;
                end

            BLT:
                begin
                    if ($signed(in0) < $signed(0))
                        bt = 1;
                end

            BGTE:
                begin
                    if ($signed(in0) >= $signed(0))
                        bt = 1;
                end

            SLL:
                begin
                    result = in1 << shift;
                end

            JA: /* Do nothing */
                begin
                end

            JAL: /* Do nothing */
                begin
                end

            JR: /* Do nothing */
                begin
                end

            MFHI: /* Do nothing */
                begin
                end

            MFLO: /* Do nothing */
                begin
                end

            SLTU: /* Do nothing */
                begin
                end

            SW:
                begin
                    result = in0 + in1;
                end

            LW:
                begin
                    result = in0 + in1;
                end

        endcase /* End of case */
    end /* End of always */

endmodule
