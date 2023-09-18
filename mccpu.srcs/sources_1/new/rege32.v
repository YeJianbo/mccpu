//32位寄存器(带使能)
//时钟上升沿时根据使能信号将输入的数据存储到输出中
module rege32 (d,clk,rst,e,q);
    input [31:0] d;    // 32位数据输入
    input e;           // 使能信号
    input clk, rst;    // 时钟、复位信号
    output reg [31:0] q; // 输出
    //时钟上升沿或复位下降沿
    always @(negedge rst or posedge clk)
        if (!rst)  q <= 0; //复位
        else if (e) q <= d; //如果使能信号为1，q=d
endmodule
