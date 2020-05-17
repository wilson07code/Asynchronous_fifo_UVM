module fifo_dut (data_out,full,empty,data_in,w_en,wclk,r_en,rclk,rst);
parameter data = 14; parameter addr = 4;
output [data-1:0] data_out;
reg [data-1:0] data_out;
output full;
output empty;
input [data-1:0] data_in;
input w_en,wclk,r_en,rclk,rst;


wire [data-1:0]data_out1;
wire [addr-1:0] waddr, raddr;
wire [addr:0] wptr, rptr, wq2_rptr, rq2_wptr;


assign r_en1=(r_en & (~empty));
assign w_en1=(w_en & (~full));

sync_r2w sync_r2w (wq2_rptr,rptr,wclk,rst);
sync_w2r sync_w2r (rq2_wptr,wptr,rclk,rst);

fifomem #(data,addr) fifomem (data_out1,data_in,waddr,raddr,w_en1,full,wclk);

always@(posedge rclk)
if(empty==1'b1 || r_en==1'b0)
data_out=14'd0;
else
data_out=data_out1;

rptr_empty #(addr) rptr_empty (empty,raddr,rptr,rq2_wptr,r_en1,rclk,rst);
wptr_full #(addr) wptr_full (full, waddr,wptr, wq2_rptr,w_en1, wclk,rst);

endmodule
