//32λ�Ĵ���������ʹ���źţ�
module reg32 (d,clk,rst,q); 
    input [31:0] d;    // 32λ��������
    input clk, rst;    // ʱ�ӡ���λ�ź�    
    output reg [31:0] q; // ���
    always @(negedge rst or posedge clk)
        if (!rst) q <= 0;//��λ
        else q <= d;
endmodule
