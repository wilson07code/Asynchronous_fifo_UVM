`ifndef model_monitor //Preprocessor commands
`define model_monitor 


import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"


class model_monitor extends uvm_monitor; //Monitor Class

`uvm_component_utils(model_monitor) //Class Registration

virtual model_if model_vi; //Handle to the interface
uvm_analysis_port#(fifo_seq_item) aport; //Declare the analysis port.

function new(string name = "model_monitor", uvm_component parent = null); //Constructor
      super.new(name, parent);
endfunction: new

//Propagate the interface
function void build_phase(uvm_phase phase);
   aport = new("aport",this); //Create an instance of the port.

if (!uvm_config_db#(virtual model_if)::get(this, "", "model_vi", model_vi)) begin
            `uvm_fatal("model/MON/NOVIF", "No virtual interface specified for this monitor instance")
         end
endfunction:build_phase

task run_phase(uvm_phase phase);
 repeat(50)

  begin
  fifo_seq_item tr; //Handle to the transaction
  
 @(posedge model_vi.wclk);
  begin
    tr = fifo_seq_item::type_id::create("tr", this); //Create the transaction.
    
    tr.data_in=model_vi.data_in;
    tr.data_out=model_vi.data_out;
    tr.full=model_vi.full;
    tr.empty=model_vi.empty;
    tr.w_en=model_vi.w_en;
    tr.r_en=model_vi.r_en;
    
    
    uvm_report_info("Model monitor",tr.convert2string());
    aport.write(tr); //Send the transaction through the analysis port and broadcast it.
  end


  @(posedge model_vi.rclk);
  begin
    tr = fifo_seq_item::type_id::create("tr", this); //Create the transaction.
    
    tr.data_in=model_vi.data_in;
    tr.data_out=model_vi.data_out;
    tr.full=model_vi.full;
    tr.empty=model_vi.empty;
    tr.w_en=model_vi.w_en;
    tr.r_en=model_vi.r_en;
    
    
  //  uvm_report_info("Model monitor",tr.convert2string());
    aport.write(tr); //Send the transaction through the analysis port and broadcast it.
  end

end
 
 
 endtask : run_phase
 endclass : model_monitor

`endif

