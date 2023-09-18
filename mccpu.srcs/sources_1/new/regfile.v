/************************************************
// 32*32寄存器
************************************************/
module regfile(raddr1,raddr2,wdata,waddr,we,clk,rst,rdata1,rdata2); 
    input [31:0] wdata;//写入数据
    input [4:0] raddr1;//读端口1
    input [4:0] raddr2;//读端口2
    input [4:0] waddr;//写端口
    input we;      //写使能
    input clk,rst; // 时钟与复位信号
    output [31:0] rdata1, rdata2;//读端口AB读出的数据
    reg [31:0] register [1:31];// 31个32bit寄存器
    assign rdata1 = (raddr1 == 0)? 0 : register[raddr1];//端口1读取数据
    assign rdata2 = (raddr2 == 0)? 0 : register[raddr2];//端口2读取数据
    integer i;
    //写寄存器
    always @(posedge clk or negedge rst)
        if (!rst)
            for(i=1; i<32; i=i+1)
                register[i] <= 0; //复位
        else
            if ((waddr != 0) && we) //写1-31号寄存器并且写使能为1，写入数据
                register[waddr] <= wdata;
endmodule
