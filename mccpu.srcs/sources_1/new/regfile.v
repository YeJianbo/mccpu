/************************************************
// 32*32�Ĵ���
************************************************/
module regfile(raddr1,raddr2,wdata,waddr,we,clk,rst,rdata1,rdata2); 
    input [31:0] wdata;//д������
    input [4:0] raddr1;//���˿�1
    input [4:0] raddr2;//���˿�2
    input [4:0] waddr;//д�˿�
    input we;      //дʹ��
    input clk,rst; // ʱ���븴λ�ź�
    output [31:0] rdata1, rdata2;//���˿�AB����������
    reg [31:0] register [1:31];// 31��32bit�Ĵ���
    assign rdata1 = (raddr1 == 0)? 0 : register[raddr1];//�˿�1��ȡ����
    assign rdata2 = (raddr2 == 0)? 0 : register[raddr2];//�˿�2��ȡ����
    integer i;
    //д�Ĵ���
    always @(posedge clk or negedge rst)
        if (!rst)
            for(i=1; i<32; i=i+1)
                register[i] <= 0; //��λ
        else
            if ((waddr != 0) && we) //д1-31�żĴ�������дʹ��Ϊ1��д������
                register[waddr] <= wdata;
endmodule
