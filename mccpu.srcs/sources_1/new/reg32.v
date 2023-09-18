//32位寄存器（不带使能信号）
module reg32 (d,clk,rst,q); 
    input [31:0] d;    // 32位数据输入
    input clk, rst;    // 时钟、复位信号    
    output reg [31:0] q; // 输出
    always @(negedge rst or posedge clk)
        if (!rst) q <= 0;//复位
        else q <= d;
endmodule
