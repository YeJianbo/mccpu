`timescale 1ns/1ns
//����
module multi_cycle_cpu_tb;
    //ʱ�ӡ���λ�ź�
    reg clk,rst,memclk;
    wire [31:0] a,b,alu,adr,wdata,rdata,pc,ir;
    //ִ��״̬��1IF,2ID,3EXE,4MEM,5WB
    wire [2:0] state;
//    reg [31:0] registers [31:0];
    //ʵ����
    top cpu(clk,rst,state,a,b,alu,adr,wdata,rdata,pc,ir,memclk);
    initial begin
        rst = 0;
        memclk = 0;
        clk = 1;
    
        #1 rst   = 1;
        //��������
        #114514 $finish;
    end
    always #1 memclk = !memclk;
    always #2 clk = !clk;
endmodule