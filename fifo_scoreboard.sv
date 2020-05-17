`ifndef fifo_scoreboard //Preprocessor commands
`define fifo_scoreboard 

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"

class fifo_scoreboard extends uvm_scoreboard;
`uvm_component_utils (fifo_scoreboard) //Class registration.

uvm_analysis_export #(fifo_seq_item) dut_export; //uvm_analysis_export exports a lower level uvm_analysis_imp to its parent.
uvm_analysis_export #(fifo_seq_item) model_export; //uvm_analysis_export exports a lower level uvm_analysis_imp to its parent.


uvm_tlm_analysis_fifo #(fifo_seq_item) dut_fifo; //this class provides storage of transaction between 2 independently running processes.
uvm_tlm_analysis_fifo #(fifo_seq_item) model_fifo;//seq_items are put into the FIFO via put_export. seq_items are fetched from the FIFO in the order they arrived via get_export.

function new(string name = "fifo_scoreboard",uvm_component parent = null);
  super.new(name,parent);
dut_export = new("dut_export", this); //Create the instance of the ports.
model_export = new("model_export", this);
dut_fifo = new("dut_fifo", this);
model_fifo = new("model_fifo", this);
endfunction : new

function void connect_phase(uvm_phase phase);
	dut_export.connect(dut_fifo.analysis_export); //Connect the Port of the FIFO to the port of the scoreboard. 
	model_export.connect(model_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
 
int comparator_matches,comparator_mismatches;


fifo_seq_item dut_tr, model_tr; //Create handles of the seq_item.

repeat(50) begin
dut_fifo.get(dut_tr); //get seq_item from the FIFO.
model_fifo.get(model_tr);


//Compare the seq_items
//if(dut_tr.compare(model_tr)) 
if((dut_tr.data_in===model_tr.data_in)&(dut_tr.data_out===model_tr.data_out)&(dut_tr.w_en===model_tr.w_en)&(dut_tr.r_en===model_tr.r_en)&(dut_tr.full===model_tr.full)&(dut_tr.empty===model_tr.empty))
 begin

// uvm_report_info ("Scoreboard",$psprintf("Comparator match"),UVM_LOW);
 comparator_matches++;
end
else 
 begin
// uvm_report_info ("Scoreboard",$psprintf("Comparator mismatch"),UVM_LOW);
 comparator_mismatches++; 
  end
end


//Display the number of matches and mismatches.
`uvm_info("Comparator Mismatches",$sformatf("Mismatches = %0d",comparator_mismatches),UVM_LOW)
`uvm_info("Comparator Matches",$sformatf("Matches = %0d",comparator_matches),UVM_LOW)

endtask

endclass:fifo_scoreboard

`endif

