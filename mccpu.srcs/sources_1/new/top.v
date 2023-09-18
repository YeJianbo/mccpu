`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Nanjing University of Science&Technology
// Engineer: Ye Jianbo
// 
// Create Date: 2023/08/21 16:33:43
// Design Name: 
// Module Name: top
// Description: CPU����ģ�飬��������mem��cpu
//////////////////////////////////////////////////////////////////////////////////

module top(clock,rst,state,a,b,alu,adr,wdata,rdata,pc,ir,mem_clk);
    //ʱ���ź� ��λ�ź� �ڴ�ʱ��
    input clock,rst,mem_clk;
    //alu����������a��b, alu������ڴ��ַ��д���ڴ�����ݣ����ڴ��ȡ������
    output [31:0] a,b,alu,adr,wdata,rdata,pc,ir;
    //cpu״̬
    output [2:0] state;
//    output [31:0] registers [31:0];
//    output [31:0] regfile[31:0];
    wire         wmem;
    //ʵ����ģ��
    multi_cycle_cpu cpu (clock,rst,rdata,pc,ir,a,b,alu,wmem,adr,wdata,state);
    mem memory (wdata,adr,wmem,mem_clk,rdata);
endmodule
