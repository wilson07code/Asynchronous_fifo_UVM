module fifomem (rdata,wdata,waddr,raddr,wclken, wfull, wclk);
parameter data = 14; // Memory data word width
parameter addr = 4; // Number of mem address bits
output [data-1:0] rdata;
input [data-1:0] wdata;
input [addr-1:0] waddr, raddr;
input wclken, wfull, wclk;
parameter DEPTH = 1<<addr;
reg [data-1:0] mem [0:DEPTH-1];
assign rdata = mem[raddr];
always @(posedge wclk)
if (wclken && !wfull)
    mem[waddr] <= wdata;
endmodule
