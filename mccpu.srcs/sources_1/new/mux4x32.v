/************************************************
//32λ4·ѡ����
************************************************/
module mux4x32(a0,a1,a2,a3,s,y);
    input [31:0] a0,a1,a2,a3; // 4��32λ����
    input   [1:0] s;//2bitѡ���ź�
    output [31:0] y;//���
    function  [31:0] select;      // ����
        input [31:0] a0,a1,a2,a3; 
        input  [1:0] s;
        case (s) 
            2'b00: select = a0;   // 00ѡ0
            2'b01: select = a1;   // 01ѡ1
            2'b10: select = a2;   // 10ѡ2
            2'b11: select = a3;   // 11ѡ3
        endcase
    endfunction
    //ʹ�ò������ú���
    assign y = select(a0,a1,a2,a3,s);
endmodule
