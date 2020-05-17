`include "fifo_dut.sv"
`include "fifo_model.sv"
`include "fifomem.sv"
`include "sync_w2r.sv"
`include "sync_r2w.sv"
`include "rptr_empty.sv"
`include "wptr_full.sv"
`include "dut_if.sv"
`include "model_if.sv"
`include "dut_config.sv"
`include "model_config.sv"
`include "fifo_seq_item.sv"
`include "fifo_seq.sv"
`include "shared_sequencer.sv"
`include "shared_driver.sv"
`include "dut_monitor.sv"
`include "model_monitor.sv"
`include "dut_agent.sv"
`include "model_agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_env.sv"

module fifo_top; //Top level module

import uvm_pkg::*; //Include the UVM BCL
`include "fifo_test.sv" //Include the test or test library.

dut_if dut_vi(); //Instantiate the DUT interface
model_if model_vi();  //Instantiate the model interface

fifo_dut DUT(.data_out(dut_vi.data_out),.data_in(dut_vi.data_in),.full(dut_vi.full),.empty(dut_vi.empty),.w_en(dut_vi.w_en),.wclk(dut_vi.wclk),.r_en(dut_vi.r_en),.rclk(dut_vi.rclk),.rst(dut_vi.rst));

fifo_model MODEL(.data_out(model_vi.data_out),.data_in(model_vi.data_in),.full(model_vi.full),.empty(model_vi.empty),.w_en(model_vi.w_en),.wclk(model_vi.wclk),.r_en(model_vi.r_en),.rclk(model_vi.rclk),.rst(model_vi.rst));



initial
begin
dut_vi.wclk=1'b0;
dut_vi.rclk=1'b0;
model_vi.wclk=1'b0;
model_vi.rclk=1'b0;
end



always
begin
#10
fork
dut_vi.wclk=~dut_vi.wclk;
dut_vi.rclk=~dut_vi.rclk;
model_vi.wclk=~model_vi.wclk;
model_vi.rclk=~model_vi.rclk;
join
end

initial 
begin
  fork
dut_vi.rst=1'b0;
model_vi.rst=1'b0;
join
#20;
fork
dut_vi.rst=1'b1;
model_vi.rst=1'b1;
join
end

initial begin
    uvm_config_db#(virtual dut_if)::set(uvm_root::get(), "*", "dut_vi", dut_vi); //Set the interface.uvm_root class serves as the implicit top-level and phase controller for all UVM components.
    uvm_config_db#(virtual model_if)::set(uvm_root::get(), "*", "model_vi", model_vi); 

    run_test("fifo_test"); //Run the test named arbiter_test.
  end

endmodule

