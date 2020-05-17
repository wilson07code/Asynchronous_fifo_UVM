`ifndef shared_driver  //Preprocessor commands.
`define shared_driver 

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"

//Driver class parameterised by the type of transaction. The driver is shared between the MODEL & DUT
class shared_driver extends uvm_driver #(fifo_seq_item); 

virtual dut_if dut_vi; //Interface handles
virtual model_if model_vi;

fifo_seq_item tr; //Handle to the transaction.

`uvm_component_utils(shared_driver) //Class Registration

function new(string name = "shared_driver", uvm_component parent = null); //Constructor
 super.new(name,parent);
endfunction

//Propagate the interface
function void build_phase(uvm_phase phase);
  super.build_phase(phase);

   if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_vi",dut_vi))
     `uvm_fatal("NOVIF",{"virtual interface must be set for:",get_full_name(),".vif"});

if(!uvm_config_db#(virtual model_if)::get(this,"","model_vi",model_vi))
     `uvm_fatal("NOVIF",{"virtual interface must be set for:",get_full_name(),".vif"});

   
endfunction: build_phase


task run_phase(uvm_phase phase);
 phase.raise_objection(this); //Raise objection.
  repeat(50) begin
        
@(posedge dut_vi.wclk)
begin
         seq_item_port.get_next_item(tr); //Request for a sequence.
         
         //Items given from the transaction to the virtual interface i.e wiggling the pins of the DUT 
         
    dut_vi.data_in=tr.data_in;
	   model_vi.data_in = tr.data_in;

	   dut_vi.w_en=tr.w_en;
	   model_vi.w_en = tr.w_en;

	   dut_vi.r_en=tr.r_en;
	   model_vi.r_en = tr.r_en;

	          
         seq_item_port.item_done(); //Indicates to the sequencer that the request is complete.

        // uvm_report_info("driver",tr.convert2string());
 end


@(posedge dut_vi.rclk)
begin
 dut_vi.r_en=tr.r_en;
 model_vi.r_en = tr.r_en;
end
         end

phase.drop_objection(this); //Drop objection.
endtask : run_phase

endclass:shared_driver

`endif
