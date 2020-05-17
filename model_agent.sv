//Agent class consists of the Sequencer, Driver & Monitor with the connections between them.

`ifndef model_agent //Preprocessor commands.
`define model_agent //They are being used to insure that the given header file doesn't get included more than once, to prevent multiple definition errors.

import uvm_pkg::*;     //Include the UVM BCL
`include "uvm_macros.svh" //Include the macros
`include "shared_driver.sv"     //Include the other files that will be used by the class.
`include "shared_sequencer.sv"
`include "model_config.sv"
`include "model_monitor.sv"


class model_agent extends uvm_agent; //Agent class

`uvm_component_utils (model_agent) //Class Registration
uvm_analysis_port #(fifo_seq_item)aport; 


shared_driver a_driver;       //Handles to the child components.
shared_sequencer a_sequencer;
model_monitor m_monitor;

model_config m_cfg;   //Handle of the interface.



function new(string name = "model_agent", uvm_component parent = null); //Constructor
  super.new(name,parent);
endfunction     

//Propagate the interface and create the child components in the build phase
function void build_phase(uvm_phase phase); 
aport = new("aport",this); 
if(!uvm_config_db#(model_config)::get(this, "", "config", m_cfg))begin
       `uvm_error("build_phase model","Unable to find configuration object")
       end

  a_driver = shared_driver::type_id::create("a_driver", this); //Create the child components.
  a_sequencer = shared_sequencer::type_id::create("a_sequencer", this);
  m_monitor = model_monitor::type_id::create("m_monitor", this);

endfunction:build_phase

function void connect_phase(uvm_phase phase);
  a_driver.seq_item_port.connect(a_sequencer.seq_item_export); //Connect the driver and sequencer
  m_monitor.aport.connect(aport); //Connect the analysis port of the monitor to the analysis port of the agent.
endfunction:connect_phase

endclass:model_agent

`endif
