module sync_w2r (rq2_wptr,wptr,rclk,rrst_n);
parameter addr = 4;
output [addr:0] rq2_wptr;
reg [addr:0] rq2_wptr;

input [addr:0] wptr;
input rclk, rrst_n;
reg [addr:0] rq1_wptr;
always @(posedge rclk or negedge rrst_n)
if (!rrst_n) 
   {rq2_wptr,rq1_wptr} <= 0;
else 
   {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule
