//32λ�Ĵ���(��ʹ��)
//ʱ��������ʱ����ʹ���źŽ���������ݴ洢�������
module rege32 (d,clk,rst,e,q);
    input [31:0] d;    // 32λ��������
    input e;           // ʹ���ź�
    input clk, rst;    // ʱ�ӡ���λ�ź�
    output reg [31:0] q; // ���
    //ʱ�������ػ�λ�½���
    always @(negedge rst or posedge clk)
        if (!rst)  q <= 0; //��λ
        else if (e) q <= d; //���ʹ���ź�Ϊ1��q=d
endmodule
