`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Nanjing University of Science&Technology
// Engineer: Ye Jianbo
// 
// Create Date: 2023/08/21 16:33:43
// Design Name: 
// Module Name: top
// Description: CPU顶层模块，用于连接mem与cpu
//////////////////////////////////////////////////////////////////////////////////

module top(clock,rst,state,a,b,alu,adr,wdata,rdata,pc,ir,mem_clk);
    //时钟信号 复位信号 内存时钟
    input clock,rst,mem_clk;
    //alu的两个输入a、b, alu结果，内存地址，写入内存的数据，从内存读取的数据
    output [31:0] a,b,alu,adr,wdata,rdata,pc,ir;
    //cpu状态
    output [2:0] state;
//    output [31:0] registers [31:0];
//    output [31:0] regfile[31:0];
    wire         wmem;
    //实例化模块
    multi_cycle_cpu cpu (clock,rst,rdata,pc,ir,a,b,alu,wmem,adr,wdata,state);
    mem memory (wdata,adr,wmem,mem_clk,rdata);
endmodule
