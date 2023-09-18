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
// Description: CPU模块，详见注释

//////////////////////////////////////////////////////////////////////////////////
module multi_cycle_cpu(clk,rst,rdata,pc,inst,alua,alub,alu,wmem,madr,wdata,state);
    input [31:0] rdata;//读取到的数据
    input clk, rst;//时钟与复位信号
    output [31:0] pc; //程序计数器PC
    output [31:0] inst; //指令
    output [31:0] alua;//alu一号输入
    output [31:0] alub;//alu二号输入
    output [31:0] alu; //alu计算结果
    output [31:0] madr; //内存地址
    output [31:0] wdata;//要写入内存的数据
    output [2:0] state; //cpu状态
    output wmem; // 内存写使能
//    output reg [31:0] registers [0:31];
//    output [31:0] regfile[31:0];
    // 指令字段
    wire    [5:0] op   = inst[31:26];
    wire    [4:0] rs   = inst[25:21];
    wire    [4:0] rt   = inst[20:16];
    wire    [4:0] rd   = inst[15:11];
    wire    [5:0] func = inst[5:0];
    wire   [15:0] imm  = inst[15:0];
    wire   [25:0] addr = inst[25:0];
    // 控制信号
    wire    [3:0] aluc;//ALU运算控制
    wire    [1:0] pcsrc;//PC来源选择
    wire          wreg;//寄存器写使能
    wire          regrt;//目标寄存器
    wire          m2reg;//存数
    wire    [1:0] shift;//移位
    wire    [1:0] alusrcb;//alu输入b
    wire          jal;
    wire          sext;//符号扩展
    wire          wpc;//pc写使能
    wire          wir;//ir写使能
    wire          iord;//选择内存地址
    wire          selpc;//选择PC
    // 数据通路
    wire   [31:0] bpc;//分支目标地址
    wire   [31:0] npc;//next PC
    wire   [31:0] qa;//寄存器输出端口1
    wire   [31:0] qb;//寄存器输出端口2
    wire   [31:0] alua;//ALU输入a
    wire   [31:0] alub;//ALU输入b
    wire   [15:0] alu_control;//alu控制信号
    wire   [31:0] wd;//写寄存器数据
    wire   [31:0] r; //ALU输出或内存数据
    wire   [31:0] sa  = {27'b0,inst[10:6]}; //偏移量
    wire   [15:0] s16 = {16{sext & inst[15]}};//16位
    wire   [31:0] i32 = {s16,imm};//32位立即数
    wire   [31:0] dis = {s16[13:0],imm,2'b00}; //字间距离
    wire   [31:0] jpc = {pc[31:28],addr,2'b00};//跳转目标地址
    wire    [4:0] reg_dest;                    //目标寄存器（Rs或者Rt）
    wire    [4:0] wn  = reg_dest | {5{jal}};   //写寄存器号
    wire          z;                           //0标志
    wire   [31:0] rega;                        //寄存器a
    wire   [31:0] regb;                        //寄存器b
    wire   [31:0] regc;                        //寄存器c
    wire   [31:0] data;                        //DR输出
    wire   [31:0] opa;                         //sa或寄存器a输出
//    reg [31:0] registers [0:31];
//    parameter [2:0] IDLE = 3'b000,
//                       IF = 3'b001,
//                       ID = 3'b010,
//                      EXE = 3'b011,
//                      MEM = 3'b100,
//                       WB = 3'b101;
   // 修改寄存器值的逻辑，根据需要在不同的状态进行修改
//  always @(posedge clk or negedge rst) begin
//      case (state)
//        // 在不同的状态下更新寄存器的值
//        // 例如，你可以在写回阶段更新寄存器的值
//        WB: begin
//          if (wreg) begin
//            registers[wn] <= wd;
//          end
//        end
//        // 其他状态的更新逻辑可以在这里添加
//        default: begin
//          // 默认情况下，不做任何修改
//        end
//      endcase
//    end
    // 模块实例化
    //控制单元
    cu control_unit (op,func,z,clk,rst,wpc,wir,wmem,wreg,iord,
                       regrt,m2reg,aluc,shift,selpc,alusrcb,
                       pcsrc,jal,sext,state);
    //PC寄存器
    rege32  ip    (npc,clk,rst,wpc,pc);
    //指令寄存器
    rege32  ir    (rdata,clk,rst,wir,inst); 
    //数据寄存器
    reg32   dr    (rdata,clk,rst,data);
    //寄存器abc
    reg32   reg_a (qa, clk,rst,rega);
    reg32   reg_b (qb, clk,rst,regb);
    reg32   reg_c (alu,clk,rst,regc);
    //选择sa或者寄存器a输出
    //移位时，按偏移量
    //shift[1]==1,取regfile对应值，放到sa
//    mux2x32 regsa();
    //如果shift[1]  sa<=qa
    mux4x32 aorsa (rega,sa,rega,rega,shift,opa);

    //alu输入ab、alu输出
    mux2x32 alu_a (opa,pc,selpc,alua);
    mux4x32 alu_b (regb,32'h4,i32,dis,alusrcb,alub);
    mux2x32 alu_m (regc,data,m2reg,r);
    //访存地址
    mux2x32 mem_a (pc,regc,iord,madr);
    //链接（r或pc）
    mux2x32 link  (r,pc,jal,wd);
    //reg写选择（选择写rd还是rt）
    mux2x5 reg_wn (rd,rt,regrt,reg_dest);
    //给PC赋新值
    mux4x32 nextpc(alu,regc,qa,jpc,pcsrc,npc);
    //寄存器
    regfile rf (rs,rt,wd,wn,wreg,clk,rst,qa,qb); 
    //ALU
    alu alunit (alua,alub,aluc,alu,z);
    //译码器
    decoder4x16 decoder(aluc,alu_control);
    //写入内存的数据
    assign wdata = regb;
endmodule

