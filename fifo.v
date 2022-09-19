`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////  	
//  Company: 
//  Engineer: // 
//  Create Date: 29.07.2021 14:14:02 
//  Design Name: 
//  Module Name: fifo 
//  Project Name: 
//  Target Devices:  
//  Tool Versions: 
//  Description: // 
//  Dependencies: // 
//  Revision: 
//  Revision 0.01 - File Created 
//  Additional Comments:
// ////////////////////////////////////////////////////////////////////////////////// 
// This is linear queue / FIFO 
// The queue length 10
// The data width is 16 bits 
module fifo(
  DATAOUT, full,rst, empty, clock,wn, rn, DATAIN 
);
output reg [15:0] DATAOUT; 
  output full, empty;
  input [15:0] DATAIN;
  input clock, wn, rn,rst; // Need to understand what is wn and rn are for 
  reg [3:0] wptr=0, rptr=0; // pointers tracking the stack
  reg [15:0] memory [0:9]; // the stack is 8 bit wide and 8 locations in size reg [3:0] count=0; 
assign full = (count==10); assign empty = (count ==0); 
always @(posedge clock) 
  begin:write 
if(wn && !full)
  begin memory[wptr] <=DATAIN; 
  end 
else if (rn & wn)
  begin 
memory[wptr] <= DATAIN; 
  end 
end 
always @(posedge clock) 
  begin:read
    if(rn && !empty)
      begin
        DATAOUT=memory[rptr]; 
      end 
else if(rn && wn) begin DATAOUT=memory[rptr]; end 
end 
always @(posedge clock)
  begin:pointer
    if(rst)begin
      rptr<=0; 
      wptr<=0;
    end
    else begin
      wptr<=(wn && !full)||(wn && rn)?wptr+1:wptr; 
if(wptr==10) 
begin 
wptr=0; 
end 
rptr<=(rn && !empty)||(wn && rn)?rptr+1:rptr; 
      if(rptr==10)
        begin 
rptr=0; 
        end 
    end 
  end 
always @(posedge clock)
  begin:counter
    if(rst)
      begin 
count<=0;
      end
    else begin
      case({wn,rn})
        2'b00:count<=count; 
        2'b01:count<=(count==0)?count:count-1; 
        2'b10:count<=(count==10)?count:count+1; 
        2'b11:count<=count; 
        default:count<=count; 
endcase
end 
end 
Endmodule 
