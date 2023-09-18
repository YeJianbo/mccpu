`timescale 1ns/1ns
//仿真
module multi_cycle_cpu_tb;
    //时钟、复位信号
    reg clk,rst,memclk;
    wire [31:0] a,b,alu,adr,wdata,rdata,pc,ir;
    //执行状态：1IF,2ID,3EXE,4MEM,5WB
    wire [2:0] state;
//    reg [31:0] registers [31:0];
    //实例化
    top cpu(clk,rst,state,a,b,alu,adr,wdata,rdata,pc,ir,memclk);
    initial begin
        rst = 0;
        memclk = 0;
        clk = 1;
    
        #1 rst   = 1;
        //结束仿真
        #114514 $finish;
    end
    always #1 memclk = !memclk;
    always #2 clk = !clk;
endmodule