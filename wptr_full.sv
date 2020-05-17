module wptr_full (wfull,waddr,wptr,wq2_rptr,winc, wclk, wrst_n);
parameter addr = 4;
output wfull;
reg wfull;

output [addr-1:0] waddr;
output [addr :0] wptr;
reg [addr :0] wptr;

input [addr :0] wq2_rptr;
input winc, wclk, wrst_n;
reg [addr:0] wbin;
wire [addr:0] wgraynext, wbinnext;
wire wfull_val;
// GRAY pointer
always @(posedge wclk or negedge wrst_n)
if (!wrst_n)
    {wbin, wptr} <= 0;
else 
   {wbin, wptr} <= {wbinnext, wgraynext};
// Memory write-address pointer (okay to use binary to address memory)
assign waddr = wbin[addr-1:0];
assign wbinnext = wbin + (winc & ~wfull);
assign wgraynext = (wbinnext>>1) ^ wbinnext;
assign wfull_val = (wgraynext=={~wq2_rptr[addr:addr-1],
wq2_rptr[addr-2:0]});
always @(posedge wclk or negedge wrst_n)
if (!wrst_n) 
   wfull <= 1'b0;
else 
   wfull <= wfull_val;
endmodule	
