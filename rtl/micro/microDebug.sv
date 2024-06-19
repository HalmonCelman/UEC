module microDebug
#(parameter
    WIDTH          = 16, // datapath width
    IRAM_ADDR_BITS = 8   // instruction RAM address size
)(
    input wire clk,
    input wire rst,
    input wire micRstBtn,
    input wire PCenBtn,
    input wire extCtlBtn,
    input wire [IRAM_ADDR_BITS-1:0] iram_wa,
    input wire      iram_wen,
    input wire [WIDTH-1:0]   iram_din,
    input wire [1:0] mode,
    input wire [3:0] register,
    output logic [15:0] monitorValue
);

logic PCenable, extCtl;

logic [15:0] data, instr, pc;

debounce u_dbPC(
    .clk,
    .reset(rst),
    .sw(PCenBtn),
    .db_level(),
    .db_tick(PCenable)
);

debounce u_dbext(
    .clk,
    .reset(rst),
    .sw(extCtlBtn),
    .db_level(extCtl),
    .db_tick()
);


micro u_micro(
    .clk,
    .reset(micRstBtn | rst),
    .PCenable,
    .extCtl,
    .monRFSrc(register),
    .monRFData(data),
    .monInstr(instr),
    .monPC(pc),
    .iram_wa,
    .iram_wen,
    .iram_din
);

always_comb begin
    case(mode)
        2'b01: monitorValue = data;
        2'b10: monitorValue = instr;
        2'b11: monitorValue = pc;
        default: monitorValue = '0;    
    endcase
end

endmodule