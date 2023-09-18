//ALU
module alu (a,b,aluc,r,z);
    input [31:0] a,b;//����
    input [3:0] aluc;//ALU�����ź�
    //0000+     0100-       0001AND     0101OR      0010XOR
    //0110LUI    0011SLL     0111SRL     1111SRA
    //1000 addu   //1001nor   1100subu
    output [31:0] r;//������
    output z; //0��־
    //����
    wire [31:0] d_and = a&b; 
    wire [31:0] d_or  = a|b; 
    wire [31:0] d_xor = a^b; 
    wire [31:0] d_nor = ~d_or;
    wire [31:0] d_lui = {b[15:0],16'h0};
    wire [31:0] d_and_or  = aluc[2]?d_or:d_and;
    wire [31:0] d_xor_lui = aluc[2]?d_lui:d_xor;
    wire [31:0] d_addu = a + b;
    wire [31:0] d_add = $signed(a) + $signed(b);
    wire [31:0] d_subu = a - b;
    wire [31:0] d_sub = $signed(a) - $signed(b);
    // �з��űȽ� slt
    wire d_slt = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
    // �з��űȽ� sgt
    wire d_sgt = ($signed(a) > $signed(b)) ? 1'b1 : 1'b0;
    wire [31:0] d_as, d_sh;
    shift shifter(b,a[4:0],aluc[2],aluc[3],d_sh);
 // ѡ����Ӧ������
    assign r = (aluc == 4'b0000) ? d_add : // add
               (aluc == 4'b0100) ? d_sub : // sub
               (aluc == 4'b0001) ? d_and : // and
               (aluc == 4'b0101) ? d_or :  // or
               (aluc == 4'b0010) ? d_xor : // xor
               (aluc == 4'b0110) ? d_lui : // lui
               (aluc == 4'b0011) ? d_sh :  // sll
               (aluc == 4'b0111) ? d_sh :  // srl
               (aluc == 4'b1111) ? d_sh :  // sra
               (aluc == 4'b1001) ? d_nor : // nor
               (aluc == 4'b1000) ? d_addu :// addu
               (aluc == 4'b1100) ? d_subu :// subu
               (aluc == 4'b1010) ? d_slt : // slt
               (aluc == 4'b1011) ? d_sgt : // sgt
               32'd0;
    assign z = ~|r;
endmodule