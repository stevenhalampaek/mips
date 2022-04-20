/************************************************************
 * Author: Steven Paek
 * Description: MIPS Memory Module - Inst/Data Memory
 ************************************************************/

module memory(  input           clk,
                input           rst,
                input           port_rst,
                input [31:0]    addr,
                input           MemRead,
                input           MemWrite,
                input           inport_sel,
                input           inport_en,
                input [31:0]    WrData,
                input [31:0]    in0_1,
                output [31:0]   outport,
                output [31:0]   data);

    /* Internal Signals/Wires */
    wire        wr_en;
    wire        out_en;
    wire        in0_en;
    wire        in1_en;
    wire [1:0]  mux_sel;
    wire [31:0] inport0;
    wire [31:0] inport1;
    wire [31:0] ram_data;

    /* Instantiate Memory Sub-Blocks */
    assign in0_en = (inport_sel == 1'b0 && inport_en == 1'b1) ? 1 : 0;
    assign in1_en = (inport_sel == 1'b1 && inport_en == 1'b1) ? 1 : 0;

    /* Instruction/Data RAM */
    ram inst_data_ram ( .clk(clk),
                        .addr(addr[9:2]),
                        .data(WrData),
                        .wr_en(wr_en),
                        .q(ram_data));

    /* Memory Controller */
    memory_controller i_memory_controller ( .addr(addr),
                                            .MemRead(MemRead),
                                            .MemWrite(MemWrite),
                                            .wr_en(wr_en),
                                            .out_en(out_en),
                                            .mux_sel(mux_sel));

    /* Port 0 Register */
    register i_inport0_register (   .clk(clk),
                                    .rst(port_rst),
                                    .en(in0_en),
                                    .in(in0_1),
                                    .out(inport0));

    /* Port 1 Register */
    register i_inport1_register (   .clk(clk),
                                    .rst(port_rst),
                                    .en(in1_en),
                                    .in(in0_1),
                                    .out(inport1));

    /* Output Port Register */
    register i_outport_register (   .clk(clk),
                                    .rst(rst),
                                    .en(out_en),
                                    .in(WrData),
                                    .out(outport));

    /* Output MUX */
    assign data = (mux_sel[1]) ? (mux_sel[0] ? 32'b0 : inport1) : (mux_sel[0] ? inport0 : ram_data);

//always @(ram_data or inport0 or inport1 or mux_sel) begin
//        case (mux_sel)
//            2'b00 : data = ram_data;
//            2'b01 : data = inport0;
//            2'b10 : data = inport1;
//            2'b11 : data = 0;
//        endcase
//    end


endmodule
