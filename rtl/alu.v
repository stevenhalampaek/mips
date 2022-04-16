/************************************************************
 * Author: 
 * Description:
 ************************************************************/

module alu( input [31:0]        in0,
            input [31:0]        in1,
            input [4:0]         shift,
            input [4:0]         op,
            output reg          bt,
            output reg [31:0]   result,
            output reg [31:0]   result_high);

    /* ALU Operations */
    localparam
        ADD     = 5'd0,
        SUB     = 5'd1;

    always @ (*) begin

        /* Initialize */

        /* ALU OP MUX*/
        case(op)

            ADD :
                begin
                    bt          = 1'b0;
                    result      = in0 + in1;
                    result_high = 32'b0;
                end /* End of case ADD */

            SUB :
                begin
                    bt          = 1'b0;
                    result      = in0 - in1;
                    result_high = 32'b0;
                end /* End of case SUB */

        endcase /* End of case */
    end /* End of always */

endmodule
