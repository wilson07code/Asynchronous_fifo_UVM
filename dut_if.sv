//The DUT interface consists of all the inputs & outputs

interface dut_if;

parameter data = 14; parameter addr = 4;
logic [data-1:0] data_out;
logic full,empty;
logic [data-1:0] data_in;
logic w_en,wclk,r_en,rclk,rst;


endinterface:dut_if
