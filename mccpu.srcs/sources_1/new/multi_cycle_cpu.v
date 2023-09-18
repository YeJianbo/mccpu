`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Nanjing University of Science&Technology
// Engineer: Ye Jianbo
// 
// Create Date: 2023/08/21 15:32:50
// Design Name: 
// Module Name: mccpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: CPUģ�飬���ע��

//////////////////////////////////////////////////////////////////////////////////
module multi_cycle_cpu(clk,rst,rdata,pc,inst,alua,alub,alu,wmem,madr,wdata,state);
    input [31:0] rdata;//��ȡ��������
    input clk, rst;//ʱ���븴λ�ź�
    output [31:0] pc; //���������PC
    output [31:0] inst; //ָ��
    output [31:0] alua;//aluһ������
    output [31:0] alub;//alu��������
    output [31:0] alu; //alu������
    output [31:0] madr; //�ڴ��ַ
    output [31:0] wdata;//Ҫд���ڴ������
    output [2:0] state; //cpu״̬
    output wmem; // �ڴ�дʹ��
//    output reg [31:0] registers [0:31];
//    output [31:0] regfile[31:0];
    // ָ���ֶ�
    wire    [5:0] op   = inst[31:26];
    wire    [4:0] rs   = inst[25:21];
    wire    [4:0] rt   = inst[20:16];
    wire    [4:0] rd   = inst[15:11];
    wire    [5:0] func = inst[5:0];
    wire   [15:0] imm  = inst[15:0];
    wire   [25:0] addr = inst[25:0];
    // �����ź�
    wire    [3:0] aluc;//ALU�������
    wire    [1:0] pcsrc;//PC��Դѡ��
    wire          wreg;//�Ĵ���дʹ��
    wire          regrt;//Ŀ��Ĵ���
    wire          m2reg;//����
    wire    [1:0] shift;//��λ
    wire    [1:0] alusrcb;//alu����b
    wire          jal;
    wire          sext;//������չ
    wire          wpc;//pcдʹ��
    wire          wir;//irдʹ��
    wire          iord;//ѡ���ڴ��ַ
    wire          selpc;//ѡ��PC
    // ����ͨ·
    wire   [31:0] bpc;//��֧Ŀ���ַ
    wire   [31:0] npc;//next PC
    wire   [31:0] qa;//�Ĵ�������˿�1
    wire   [31:0] qb;//�Ĵ�������˿�2
    wire   [31:0] alua;//ALU����a
    wire   [31:0] alub;//ALU����b
    wire   [15:0] alu_control;//alu�����ź�
    wire   [31:0] wd;//д�Ĵ�������
    wire   [31:0] r; //ALU������ڴ�����
    wire   [31:0] sa  = {27'b0,inst[10:6]}; //ƫ����
    wire   [15:0] s16 = {16{sext & inst[15]}};//16λ
    wire   [31:0] i32 = {s16,imm};//32λ������
    wire   [31:0] dis = {s16[13:0],imm,2'b00}; //�ּ����
    wire   [31:0] jpc = {pc[31:28],addr,2'b00};//��תĿ���ַ
    wire    [4:0] reg_dest;                    //Ŀ��Ĵ�����Rs����Rt��
    wire    [4:0] wn  = reg_dest | {5{jal}};   //д�Ĵ�����
    wire          z;                           //0��־
    wire   [31:0] rega;                        //�Ĵ���a
    wire   [31:0] regb;                        //�Ĵ���b
    wire   [31:0] regc;                        //�Ĵ���c
    wire   [31:0] data;                        //DR���
    wire   [31:0] opa;                         //sa��Ĵ���a���
//    reg [31:0] registers [0:31];
//    parameter [2:0] IDLE = 3'b000,
//                       IF = 3'b001,
//                       ID = 3'b010,
//                      EXE = 3'b011,
//                      MEM = 3'b100,
//                       WB = 3'b101;
   // �޸ļĴ���ֵ���߼���������Ҫ�ڲ�ͬ��״̬�����޸�
//  always @(posedge clk or negedge rst) begin
//      case (state)
//        // �ڲ�ͬ��״̬�¸��¼Ĵ�����ֵ
//        // ���磬�������д�ؽ׶θ��¼Ĵ�����ֵ
//        WB: begin
//          if (wreg) begin
//            registers[wn] <= wd;
//          end
//        end
//        // ����״̬�ĸ����߼��������������
//        default: begin
//          // Ĭ������£������κ��޸�
//        end
//      endcase
//    end
    // ģ��ʵ����
    //���Ƶ�Ԫ
    cu control_unit (op,func,z,clk,rst,wpc,wir,wmem,wreg,iord,
                       regrt,m2reg,aluc,shift,selpc,alusrcb,
                       pcsrc,jal,sext,state);
    //PC�Ĵ���
    rege32  ip    (npc,clk,rst,wpc,pc);
    //ָ��Ĵ���
    rege32  ir    (rdata,clk,rst,wir,inst); 
    //���ݼĴ���
    reg32   dr    (rdata,clk,rst,data);
    //�Ĵ���abc
    reg32   reg_a (qa, clk,rst,rega);
    reg32   reg_b (qb, clk,rst,regb);
    reg32   reg_c (alu,clk,rst,regc);
    //ѡ��sa���߼Ĵ���a���
    //��λʱ����ƫ����
    //shift[1]==1,ȡregfile��Ӧֵ���ŵ�sa
//    mux2x32 regsa();
    //���shift[1]  sa<=qa
    mux4x32 aorsa (rega,sa,rega,rega,shift,opa);

    //alu����ab��alu���
    mux2x32 alu_a (opa,pc,selpc,alua);
    mux4x32 alu_b (regb,32'h4,i32,dis,alusrcb,alub);
    mux2x32 alu_m (regc,data,m2reg,r);
    //�ô��ַ
    mux2x32 mem_a (pc,regc,iord,madr);
    //���ӣ�r��pc��
    mux2x32 link  (r,pc,jal,wd);
    //regдѡ��ѡ��дrd����rt��
    mux2x5 reg_wn (rd,rt,regrt,reg_dest);
    //��PC����ֵ
    mux4x32 nextpc(alu,regc,qa,jpc,pcsrc,npc);
    //�Ĵ���
    regfile rf (rs,rt,wd,wn,wreg,clk,rst,qa,qb); 
    //ALU
    alu alunit (alua,alub,aluc,alu,z);
    //������
    decoder4x16 decoder(aluc,alu_control);
    //д���ڴ������
    assign wdata = regb;
endmodule

