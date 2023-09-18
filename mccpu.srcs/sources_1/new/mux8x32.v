/************************************************
// 32λ8·ѡ����
************************************************/
module mux8x32(a0, a1, a2, a3, a4, a5, a6, a7, s, y);
    input [31:0] a0, a1, a2, a3, a4, a5, a6, a7; // 8��32λ����
    input [2:0] s; // 3bitѡ���ź�
    output [31:0] y; // ���
    function [31:0] select; // ����
        input [31:0] a0, a1, a2, a3, a4, a5, a6, a7;
        input [2:0] s;
        case (s)
            3'b000: select = a0; // 000ѡ0
            3'b001: select = a1; // 001ѡ1
            3'b010: select = a2; // 010ѡ2
            3'b011: select = a3; // 011ѡ3
            3'b100: select = a4; // 100ѡ4
            3'b101: select = a5; // 101ѡ5
            3'b110: select = a6; // 110ѡ6
            3'b111: select = a7; // 111ѡ7
        endcase
    endfunction
    // ʹ�ò������ú���
    assign y = select(a0, a1, a2, a3, a4, a5, a6, a7, s);
endmodule
