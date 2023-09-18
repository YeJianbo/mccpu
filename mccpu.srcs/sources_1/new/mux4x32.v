/************************************************
//32位4路选择器
************************************************/
module mux4x32(a0,a1,a2,a3,s,y);
    input [31:0] a0,a1,a2,a3; // 4个32位输入
    input   [1:0] s;//2bit选择信号
    output [31:0] y;//输出
    function  [31:0] select;      // 函数
        input [31:0] a0,a1,a2,a3; 
        input  [1:0] s;
        case (s) 
            2'b00: select = a0;   // 00选0
            2'b01: select = a1;   // 01选1
            2'b10: select = a2;   // 10选2
            2'b11: select = a3;   // 11选3
        endcase
    endfunction
    //使用参数调用函数
    assign y = select(a0,a1,a2,a3,s);
endmodule
