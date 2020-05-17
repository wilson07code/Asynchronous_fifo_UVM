`ifndef fifo_seq_item //Preprocessor commands
`define fifo_seq_item

import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_seq_item extends uvm_sequence_item;
`uvm_object_utils(fifo_seq_item) //Class registration using object_utils.
parameter data = 14; parameter addr = 4;

rand logic [data-1:0] data_in;
rand logic [addr-1:0] waddr;
rand logic [addr-1:0] raddr;
rand logic w_en,r_en;

logic [data-1:0] data_out;
logic full,empty;



function new(string name = "fifo_seq_item"); //Constructor. Transaction is not a component, hence, has no parent.
  super.new(name);
endfunction : new

function string convert2string(); //to print debug messages or contents of a particular transaction
 return $sformatf("%s\nData In=%b  Data Out=%b waddr=%b raddr=%b W_EN=%b  R_EN=%b  Full=%b  Empty=%b",super.convert2string(),data_in,data_out,w_en,r_en,waddr,raddr,full,empty);endfunction: convert2string


endclass : fifo_seq_item

`endif

 