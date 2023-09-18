/************************************************
//移位器
************************************************/
module shift(d,sa,right,arith,sh);
    input  [31:0] d; //输入
    input   [4:0] sa;//偏移位数
    input right;     //1左0右
    input arith;     //1算数0逻辑
    output [31:0] sh;//移位后结果
    reg    [31:0] sh;
    always @* begin 
        if (!right) begin  //左移
            sh = d << sa;
        end else if (!arith) begin //逻辑右移
            sh = d >> sa;
        end else begin //算术右移
            sh = $signed(d) >>> sa;
        end
    end
endmodule
