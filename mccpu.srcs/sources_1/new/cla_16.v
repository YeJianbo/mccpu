/************************************************
** ** 16位超前进位加法器
************************************************/
module cla_16 (a,b,c_in,g_out,p_out,s);
    input  [15:0] a, b;
    input         c_in;
    output        g_out, p_out;
    output [15:0] s;
    wire    [1:0] g, p;
    wire          c_out;
    cla_8 a0 (a[7:0], b[7:0], c_in, g[0],p[0],s[7:0]);
    cla_8 a1 (a[15:8],b[15:8],c_out,g[1],p[1],s[15:8]);
    gp   gp0 (g,p,c_in, g_out,p_out,c_out);
endmodule
