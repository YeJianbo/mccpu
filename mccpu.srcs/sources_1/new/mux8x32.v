/************************************************
// 32位8路选择器
************************************************/
module mux8x32(a0, a1, a2, a3, a4, a5, a6, a7, s, y);
    input [31:0] a0, a1, a2, a3, a4, a5, a6, a7; // 8个32位输入
    input [2:0] s; // 3bit选择信号
    output [31:0] y; // 输出
    function [31:0] select; // 函数
        input [31:0] a0, a1, a2, a3, a4, a5, a6, a7;
        input [2:0] s;
        case (s)
            3'b000: select = a0; // 000选0
            3'b001: select = a1; // 001选1
            3'b010: select = a2; // 010选2
            3'b011: select = a3; // 011选3
            3'b100: select = a4; // 100选4
            3'b101: select = a5; // 101选5
            3'b110: select = a6; // 110选6
            3'b111: select = a7; // 111选7
        endcase
    endfunction
    // 使用参数调用函数
    assign y = select(a0, a1, a2, a3, a4, a5, a6, a7, s);
endmodule
