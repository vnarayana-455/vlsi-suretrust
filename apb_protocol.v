`timescale 1ns / 1ps
module apb_protocol(clk,rst,pready,pread,penable,
pwrite,addr,pwdata,psel,prdata);
parameter S_IDLE = 3'b000;
parameter S_SETUP = 3'b001;
parameter S_ACCESS = 3'b010;
input clk,rst,pready,pread,penable;
input [7:0]pwrite;
input [3:0]addr;
output reg [7:0]pwdata;
output reg psel;
output reg [7:0]prdata;
reg [2:0]state,nxt_state;
reg [7:0] databus,addrbus;
initial begin
if(rst ==1)begin
psel =0;end
pwdata =0;prdata=0;
end
always@(posedge clk) begin
    if(penable)begin
        if(pready)begin
            if(pwrite)begin
            addrbus = addr;
            databus = pwdata;       
            end            
            if(pread) begin
            prdata = pwdata;
            end
        end
    end
    
 end
always@(nxt_state) begin
    state = nxt_state;
end
always@(posedge clk) begin
case(state)
    S_IDLE:begin
    psel = 0;
        if (pready == 1)  begin
            nxt_state = S_SETUP;
        end
    end
    S_SETUP:begin
    psel = 1;
    nxt_state = S_ACCESS;   
    end
    S_ACCESS:begin
    psel = 1;
        if (pready == 0)  begin
            nxt_state = S_ACCESS;   
        end
        if(pready == 1) begin
            nxt_state = S_SETUP;
        end       
    end
endcase
end             
endmodule