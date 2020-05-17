module fifo_model (data_out,full,empty,data_in,w_en,wclk,r_en,rclk,rst);
parameter data = 14; parameter addr = 4;
parameter DEPTH = 1<<addr;
output [data-1:0] data_out;
reg [data-1:0] data_out;
output reg full;
output reg empty;
input [data-1:0] data_in;
input w_en,wclk,r_en,rclk,rst;

 int q[$];
reg [4:0] rad,wad;

always@(rad,wad)
begin
  
  
    if(!rst)
      begin
        full=0;
        empty=1;
      end
      
    else
      begin
          if(rad==wad)
            begin
            empty=1;
            rad=0;
            wad=0;
          end
          else if(~wad[4]&(wad-rad<3))
            empty=1;
          else
            empty=0;
            
            if(({~wad[4],wad[3:0]})==rad)
              full=1;
            else if(wad[4]&(wad-rad>12))
              full=1;
            else full=0;
          
      end
    
end

always@(posedge wclk)
begin
    if(!rst)
      wad=0;
    else
    if(w_en&!full)
      begin
    q.push_front(data_in);
    wad++;
  end
      
end

always@(posedge rclk)
begin
  if(!rst)
    begin
      data_out=0;
    rad=0;
  end
  else    
    if(r_en&!empty)
      begin
    data_out=q.pop_back();
    rad++;
  end
else 
data_out=0;      
end


endmodule
