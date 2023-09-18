/************************************************
** 进位生成器与进位传播器
根据低层次的进位生成和传递信号，计算出高层次的进位
生成、传递和输出信号，用于进一步计算32位进位前瞻加
法器的进位运算。
************************************************/
module gp (g,p,c_in,g_out,p_out,c_out);
    input [1:0] g, p;
    input       c_in;
    output      g_out,p_out,c_out;
    assign      g_out = g[1] | p[1] & g[0];
    assign      p_out = p[1] & p[0];
    assign      c_out = g[0] | p[0] & c_in;
endmodule
