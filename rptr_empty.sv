module rptr_empty (rempty,raddr,rptr,rq2_wptr,rinc, rclk, rrst_n);
parameter addr = 4;
output rempty;
reg rempty;
output [addr-1:0] raddr;
output [addr :0] rptr;
reg [addr :0] rptr;
input [addr :0] rq2_wptr;
input rinc, rclk, rrst_n;
reg [addr:0] rbin;
wire [addr:0] rgraynext, rbinnext;
wire rempty_val;
// GRAY pointer
always @(posedge rclk or negedge rrst_n)
if (!rrst_n)
    {rbin, rptr} <= 0;
else 
   {rbin, rptr} <= {rbinnext, rgraynext};
// Memory read-address pointer (okay to use binary to address memory)
assign raddr = rbin[addr-1:0];
assign rbinnext = rbin + (rinc & ~rempty);
assign rgraynext = (rbinnext>>1) ^ rbinnext;
//---------------------------------------------------------------
// FIFO empty when the next rptr == synchronized wptr or on reset
//---------------------------------------------------------------
assign rempty_val = (rgraynext == rq2_wptr);
always @(posedge rclk or negedge rrst_n)
if (!rrst_n) 
   rempty <= 1'b1;
else 
   rempty <= rempty_val;
endmodule
