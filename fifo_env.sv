//Environment class consists of the agent and the scoreboard and the connection between them.
`ifndef fifo_env //Preprocessor commands
`define fifo_env

import uvm_pkg::*; //Include the UVM BCL
`include "uvm_macros.svh" //Include the macros.
`include "dut_agent.sv"
`include "model_agent.sv"

`include "fifo_scoreboard.sv"

class fifo_env extends uvm_env;

`uvm_component_utils (fifo_env) //Class registration

dut_agent d_agent; //Create handle of the child components
model_agent m_agent;   
fifo_scoreboard a_scoreboard; 


function new(string name = "fifo_env", uvm_component parent = null); //Construstor
  super.new(name,parent);
endfunction     

function void build_phase(uvm_phase phase); 
  d_agent = dut_agent::type_id::create("d_agent", this); //Create the child components
  
  m_agent = model_agent::type_id::create("m_agent", this); 
  a_scoreboard = fifo_scoreboard::type_id::create("a_scoreboard", this); 

endfunction:build_phase

function void connect_phase(uvm_phase phase);
  d_agent.aport.connect(a_scoreboard.dut_export);  //Connect one port of the scoreboard to the DUT agent port.
  m_agent.aport.connect(a_scoreboard.model_export); //Connect the other port of the scoreboard to the MODEL agent port.
 
endfunction:connect_phase

endclass:fifo_env

 `endif
