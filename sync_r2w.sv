module sync_r2w (wq2_rptr,rptr,wclk, wrst_n);
parameter addr = 4;
output [addr:0] wq2_rptr;
reg [addr:0] wq2_rptr;

input [addr:0] rptr;
input wclk, wrst_n;
reg [addr:0] wq1_rptr;
always @(posedge wclk or negedge wrst_n)
if (!wrst_n) 
   {wq2_rptr,wq1_rptr} <= 0;
else 
   {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
endmodule
