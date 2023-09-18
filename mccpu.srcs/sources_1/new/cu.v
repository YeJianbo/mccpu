`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Nanjing University of Science&Technology
// Engineer: Ye Jianbo
// 
// Create Date: 2023/08/21 21:04:23
// Design Name: 
// Module Name: mccu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 控制单元
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cu(op,func,z,clk,rst,wpc,wir,wmem,wreg,iord,regrt,m2reg,
            aluc,shift,alusrca,alusrcb,pcsource,jal,sext,state);
    input [5:0] op,func;//操作码（I/J型指令）与功能码（R型指令）
    input       z,clk,rst;//ALU零标志、时钟信号、复位信号
//    input [31:0] alu;
    //各种使能信号
    output reg wpc,wir,wmem,wreg,iord,regrt,m2reg;
    output reg [3:0] aluc;//alu控制信号
    output reg [1:0] shift,alusrcb,pcsource;//alu输入b选择、PC来源选择
    output reg       alusrca,jal,sext;
    output reg [2:0] state;
    
    reg [2:0]       next_state;
    //CPU的六个状态（开始、取指、译码、执行、访存、写回）
    parameter [2:0] IDLE = 3'b000,
                    IF = 3'b001,
                    ID = 3'b010,
                    EXE = 3'b011,
                    MEM = 3'b100,
                    WB = 3'b101;
    //一些指令以及对应的机器码
    wire r_type,i_add,i_sub,i_and,i_or,i_xor,i_nor,i_sll,i_srl,i_sra,i_jr,i_addu,i_subu;
    wire i_addi,i_addiu,i_andi,i_ori,i_xori,i_nori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
    wire i_bgt,i_bge,i_blt,i_ble,i_sllv,i_srlv,i_srav;
    and(r_type,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);
    and(i_add,r_type,func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and(i_sub,r_type,func[5],~func[4],~func[3],~func[2],func[1],~func[0]);
    and(i_addu,r_type,func[5],~func[4],~func[3],~func[2],~func[1],func[0]);
    and(i_subu,r_type,func[5],~func[4],~func[3],~func[2],func[1],func[0]);
    and(i_and,r_type,func[5],~func[4],~func[3],func[2],~func[1],~func[0]);
    and(i_or,r_type,func[5],~func[4],~func[3],func[2],~func[1],func[0]);
    and(i_nor,r_type,func[5],~func[4],~func[3],func[2],func[1],func[0]);
    and(i_xor,r_type,func[5],~func[4],~func[3],func[2],func[1],~func[0]);
    and(i_sll,r_type,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and(i_srl,r_type,~func[5],~func[4],~func[3],~func[2],func[1],~func[0]);
    and(i_sra,r_type,~func[5],~func[4],~func[3],~func[2],func[1],func[0]);
    and(i_sllv,r_type,~func[5],~func[4],~func[3],func[2],~func[1],~func[0]);
    and(i_srlv,r_type,~func[5],~func[4],~func[3],func[2],func[1],~func[0]);
    and(i_srav,r_type,~func[5],~func[4],~func[3],func[2],func[1],func[0]);
    and(i_jr,r_type,~func[5],~func[4],func[3],~func[2],~func[1],~func[0]);
    and(i_addi,~op[5],~op[4],op[3],~op[2],~op[1],~op[0]);
    and(i_andi,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);
    and(i_ori,~op[5],~op[4],op[3],op[2],~op[1],op[0]);
    and(i_xori,~op[5],~op[4],op[3],op[2],op[1],~op[0]);
    and(i_lw,op[5],~op[4],~op[3],~op[2],op[1],op[0]);
    and(i_sw,op[5],~op[4],op[3],~op[2],op[1],op[0]);
    and(i_beq,~op[5],~op[4],~op[3],op[2],~op[1],~op[0]);
    and(i_bne,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);
    and(i_lui,~op[5],~op[4],op[3],op[2],op[1],op[0]);
    and(i_j,~op[5],~op[4],~op[3],~op[2],op[1],~op[0]);
    and(i_jal,~op[5],~op[4],~op[3],~op[2],op[1],op[0]);
    and(i_addiu,~op[5],~op[4],op[3],~op[2],~op[1],op[0]);
    and(i_nori,~op[5],op[4],op[3],op[2],op[1],op[0]);//改
    and(i_bgt,~op[5],~op[4],~op[3],op[2],op[1],op[0]);//改
    and(i_ble,~op[5],~op[4],~op[3],op[2],op[1],~op[0]);//改
    and(i_bge,~op[5],~op[4],~op[3],~op[2],~op[1],op[0]);//改
    and(i_blt,~op[5],~op[4],op[3],~op[2],op[1],op[0]);//改
    
//    wire i_shift;
//    or (i_shift,i_sll,i_srl,i_sra,i_sllv,i_srlv,i_srav);
        
    always @* begin
    //使能
    wpc = 0;
    wir = 0;
    wmem = 0;
    wreg = 0;
    iord = 0;
    aluc = 4'b0000;     //ALU操作：add
    alusrca = 0;        //ALU输入a
    alusrcb = 2'h0;
    regrt = 0;
    m2reg = 0;
    shift = 0;
    pcsource = 2'h0;
    jal = 0;
    sext = 1;
    //根据当前状态执行
    case(state)
        IF:begin
          wpc = 1;
          wir = 1;
          alusrca = 1;
          alusrcb = 2'h1;
          next_state = ID;
        end
        
        ID:begin
          if(i_j) begin
            pcsource = 2'h3;
            wpc = 1;
            next_state = IF;
          end else if (i_jal) begin
            pcsource = 2'h3;
            wpc = 1;
            jal = 1;
            wreg = 1;
            next_state = IF;
          end else if (i_jr) begin
            pcsource = 2'h2;
            wpc = 1;
            next_state = IF;
          end else begin
            aluc = 4'b0000;
            alusrca = 1;
            alusrcb = 2'h3;
            next_state = EXE;
          end
        end
        
        EXE: begin
        //
          aluc[3] = i_sra | i_addu | i_subu | i_nor | i_addiu | i_nori | i_bgt | i_bge | i_blt | i_ble | i_srav;
          aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_lui | i_subu | i_srlv | i_srav;
          aluc[1] = i_xor | i_sll | i_srl | i_sra |i_xori | i_beq |i_bne | i_lui | i_bgt | i_bge | i_blt | i_ble | i_srlv | i_srav | i_sllv;
          aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori | i_nor | i_nori | i_bgt | i_ble | i_srlv | i_srav | i_sllv;
          //跳转指令
          if(i_beq || i_bne || i_bgt || i_bge || i_blt || i_ble) begin
            pcsource = 2'h1;
            //符合跳转条件，pc写使能
            wpc = i_beq & z | i_bne & ~z | i_bgt & z | i_bge & ~z | i_blt & z | i_ble & ~z;
            next_state = IF;
          end else begin
            if(i_lw || i_sw) begin
                alusrcb = 2'h2;
                next_state = MEM;
            end else begin
                if(i_sll|i_srl|i_sra|i_sllv|i_srlv|i_srav) shift = 2'b01;
                if(i_sllv|i_srlv|i_srav) shift[1] = 1;
                if(i_addi || i_andi || i_ori || i_xori || i_lui || i_addiu || i_nori)
                    alusrcb = 2'h2;
                //符号扩展 关
                if(i_andi || i_ori || i_xori || i_nori) sext = 0;
                next_state = WB;
            end
          end
        end
        MEM:begin
          iord = 1;
          if(i_lw) begin
            next_state = WB;
          end else begin
            wmem = 1;
            next_state = IF;
          end
        end
        
        WB: begin
            if(i_lw) m2reg = 1;
            if(i_lw || i_addi || i_andi || i_ori || i_xori || i_lui || i_nori || i_addiu)
              regrt = 1;
            wreg = 1;
            next_state = IF;
        end
        
        default: begin
            next_state = IF;
        end
      endcase
    end
    
    always @ (posedge clk or negedge rst) begin
        if(rst == 0) begin
            state <= IF;
        end else begin
            state <= next_state;
        end
    end
endmodule
