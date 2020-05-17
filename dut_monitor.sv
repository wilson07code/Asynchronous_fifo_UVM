`ifndef dut_monitor //Preprocessor commands
`define dut_monitor 


import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"


class dut_monitor extends uvm_monitor; //Monitor Class

`uvm_component_utils(dut_monitor) //Class Registration

virtual dut_if dut_vi; //Handle to the interface
uvm_analysis_port#(fifo_seq_item) aport; //Declare the analysis port.

function new(string name = "dut_monitor", uvm_component parent = null); //Constructor
      super.new(name, parent);
endfunction: new

//Propagate the interface
function void build_phase(uvm_phase phase);
   aport = new("aport",this); //Create an instance of the port.

if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vi", dut_vi)) begin
            `uvm_fatal("DUT/MON/NOVIF", "No virtual interface specified for this monitor instance")
         end
endfunction:build_phase

task run_phase(uvm_phase phase);
  repeat(50)
begin
  fifo_seq_item tr; //Handle to the transaction
  
  @(posedge dut_vi.wclk);
  begin
    tr = fifo_seq_item::type_id::create("tr", this); //Create the transaction.
    
    tr.data_in=dut_vi.data_in;
    tr.data_out=dut_vi.data_out;
    tr.full=dut_vi.full;
    tr.empty=dut_vi.empty;
    tr.w_en=dut_vi.w_en;
    tr.r_en=dut_vi.r_en;
    
    
    uvm_report_info("DUT monitor",tr.convert2string());
    aport.write(tr); //Send the transaction through the analysis port and broadcast it.
  end


  @(posedge dut_vi.rclk);
  begin
    tr = fifo_seq_item::type_id::create("tr", this); //Create the transaction.
    
    tr.data_in=dut_vi.data_in;
    tr.data_out=dut_vi.data_out;
    tr.full=dut_vi.full;
    tr.empty=dut_vi.empty;
    tr.w_en=dut_vi.w_en;
    tr.r_en=dut_vi.r_en;
    
    
 //   uvm_report_info("DUT monitor",tr.convert2string());
    aport.write(tr); //Send the transaction through the analysis port and broadcast it.
  end

end
 
 
 endtask : run_phase
 endclass : dut_monitor

`endif
