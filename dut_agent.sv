//Agent class consists of the Sequencer, Driver & Monitor with the connections between them.

`ifndef dut_agent //Preprocessor commands.
`define dut_agent //They are being used to insure that the given header file doesn't get included more than once, to prevent multiple definition errors.

import uvm_pkg::*;     //Include the UVM BCL
`include "uvm_macros.svh" //Include the macros
`include "shared_driver.sv"     //Include the other files that will be used by the class.
`include "shared_sequencer.sv"
`include "dut_config.sv"
`include "dut_monitor.sv"


class dut_agent extends uvm_agent; //Agent class

`uvm_component_utils (dut_agent) //Class Registration

uvm_analysis_port #(fifo_seq_item)aport; 

shared_driver a_driver;       //Handles to the child components.
shared_sequencer a_sequencer;
dut_monitor d_monitor;

dut_config d_cfg;   //Handle of the interface.


function new(string name = "dut_agent", uvm_component parent = null); //Constructor
  super.new(name,parent);
 endfunction     

//Propagate the interface and create the child components in the build phase
function void build_phase(uvm_phase phase); 
  aport = new("aport",this); 
if(!uvm_config_db#(dut_config)::get(this, "", "config", d_cfg))begin
       `uvm_error("build_phase dut","Unable to find configuration object")
       end

  a_driver = shared_driver::type_id::create("a_driver", this); //Create the child components.
  a_sequencer = shared_sequencer::type_id::create("a_sequencer", this);
  d_monitor = dut_monitor::type_id::create("d_monitor", this);

endfunction:build_phase

function void connect_phase(uvm_phase phase);
  a_driver.seq_item_port.connect(a_sequencer.seq_item_export); //Connect the driver and sequencer
  d_monitor.aport.connect(aport); //Connect the analysis port of the monitor to the analysis port of the agent.
endfunction:connect_phase

endclass:dut_agent

`endif
