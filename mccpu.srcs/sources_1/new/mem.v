`timescale 1ns / 1ps
//*************************************************************************
//   > 文件名: mcmem.v
//
//*************************************************************************
module mem(
    input  [31:0] wdata,     // 写数据（datain）
    input  [31:0] adr,       // 地址
    input  wen,              // 写使能
    input  clk,              // 存储时钟
    output [31:0] rdata   // 读数据（dataout） 
);
    reg [31:0] rdata;
    //数据存储器，字节地址6'b00_0000~6'b11_1111
    //其中0~39为指令，40~63为一般存储
    reg [31:0] DM [63:0];  
    wire [5:0] addr;
    assign addr = adr[7:2];
    
//    wire [31:0] inst[39:0];  // 指令存储器，字节地址7'b000_0000~7'b111_1111
    initial 
        begin
            $readmemh("inst.coe", DM, 0); // Read COE file into ROM
        end
    //指令移至inst.coe
    //------------- 指令编码 ---------|------- 汇编指令 -------|PC|---结果---|//
//    assign inst[ 0] = 32'h3c010000; // main:lui  $1, 0
//    assign inst[ 1] = 32'h34240080; //      ori  $4, $1, 0x80
//    assign inst[ 2] = 32'h20050004; //      addi $5, $0,  4
//    assign inst[ 3] = 32'h0c000018; // call:jal  sum 
//    assign inst[ 4] = 32'hac820000; //      sw   $2, 0($4)
//    assign inst[ 5] = 32'h8c890000; //      lw   $9, 0($4)
//    assign inst[ 6] = 32'h01244022; //      sub  $8, $9, $4
//    assign inst[ 7] = 32'h20050003; //      addi $5, $0,  3     
//    assign inst[ 8] = 32'h20a5ffff; //loop2:addi $5, $5, -1 
//    assign inst[ 9] = 32'h34a8ffff; //      ori  $8, $5, 0xffff
//    assign inst[10] = 32'h39085555; //      xori $8, $8, 0x5555
//    assign inst[11] = 32'h2009ffff; //      addi $9, $0, -1
//    assign inst[12] = 32'h312affff; //      andi $10, $9,0xffff
//    assign inst[13] = 32'h01493025; //      or   $6, $10, $9
//    assign inst[14] = 32'h01494026; //      xor  $8, $10, $9
//    assign inst[15] = 32'h01463824; //      and  $7, $10, $6
//    assign inst[16] = 32'h10a00001; //      beq  $5, $0, shift
//    assign inst[17] = 32'h08000008; //      j    loop2 
//    assign inst[18] = 32'h2005ffff; //shift:addi $5, $0, -1      
//    assign inst[19] = 32'h000543c0; //      sll  $8, $5, 15
//    assign inst[20] = 32'h00084400; //      sll  $8, $8, 16
//    assign inst[21] = 32'h00084403; //      sra  $8, $8, 16
//    assign inst[22] = 32'h000843c2; //      srl  $8, $8, 15
//    assign inst[23] = 32'h08000017; //finish:j   finish 
//    assign inst[24] = 32'h00004020; //sum:  add  $8, $0, $0
//    assign inst[25] = 32'h8c890000; //loop: lw   $9, 0($4)
//    assign inst[26] = 32'h20840004; //      addi $4, $4,  4
//    assign inst[27] = 32'h01094020; //      add  $8, $8, $9
//    assign inst[28] = 32'h20a5ffff; //      addi $5, $5, -1
//    assign inst[29] = 32'h14a0fffb; //      bne  $5, $0, loop
//    assign inst[30] = 32'h00081000; //      sll  $2, $8, 0 
//    assign inst[31] = 32'h03e00008; //      jr   $31
//    assign inst[32] = 32'h000000a3; //      data[0]    0 +  a3 =  a3 
//    assign inst[33] = 32'h00000027; //      data[1]   a3 +  27 =  ca
//    assign inst[34] = 32'h00000079; //      data[2]   ca +  79 = 143
//    assign inst[35] = 32'h00000115; //      data[3]  143 + 115 = 258
//    assign inst[36] = 32'h00000000; //      sum, should be = 0x00000258, stored by sw 
    
////     将 inst 赋值给 DM
//    integer i;
//    always @(*) begin
//        for (i = 0; i < 40; i = i + 1) begin
//            DM[i] = inst[i];
//        end
//    end


    
    //写数据
    always @(posedge clk)    // 当写使能为1，数据写入内存
    begin
        if (wen)
        begin
            DM[addr][31:0] <= wdata[31:0];
        end
    end
    
    
    //读数据,取4字节
    always @(posedge clk)
//    always @(*)
    begin
        case (addr)
            6'd0  : rdata <= DM[0];
            6'd1  : rdata <= DM[1];
            6'd2  : rdata <= DM[2];
            6'd3  : rdata <= DM[3];
            6'd4  : rdata <= DM[4];
            6'd5  : rdata <= DM[5];
            6'd6  : rdata <= DM[6];
            6'd7  : rdata <= DM[7];
            6'd8  : rdata <= DM[8];
            6'd9  : rdata <= DM[9];
            6'd10 : rdata <= DM[10];
            6'd11 : rdata <= DM[11];
            6'd12 : rdata <= DM[12];
            6'd13 : rdata <= DM[13];
            6'd14 : rdata <= DM[14];
            6'd15 : rdata <= DM[15];
            6'd16 : rdata <= DM[16];
            6'd17 : rdata <= DM[17];
            6'd18 : rdata <= DM[18];
            6'd19 : rdata <= DM[19];
            6'd20 : rdata <= DM[20];
            6'd21 : rdata <= DM[21];
            6'd22 : rdata <= DM[22];
            6'd23 : rdata <= DM[23];
            6'd24 : rdata <= DM[24];
            6'd25 : rdata <= DM[25];
            6'd26 : rdata <= DM[26];
            6'd27 : rdata <= DM[27];
            6'd28 : rdata <= DM[28];
            6'd29 : rdata <= DM[29];
            6'd30 : rdata <= DM[30];
            6'd31 : rdata <= DM[31];
            6'd32 : rdata <= DM[32];
            6'd33 : rdata <= DM[33];
            6'd34 : rdata <= DM[34];
            6'd35 : rdata <= DM[35];
            6'd36 : rdata <= DM[36];
            6'd37 : rdata <= DM[37];
            6'd38 : rdata <= DM[38];
            6'd39 : rdata <= DM[39];
            6'd40 : rdata <= DM[40];
            6'd41 : rdata <= DM[41];
            6'd42 : rdata <= DM[42];
            6'd43 : rdata <= DM[43];
            6'd44 : rdata <= DM[44];
            6'd45 : rdata <= DM[45];
            6'd46 : rdata <= DM[46];
            6'd47 : rdata <= DM[47];
            6'd48 : rdata <= DM[48];
            6'd49 : rdata <= DM[49];
            6'd50 : rdata <= DM[50];
            6'd51 : rdata <= DM[51];
            6'd52 : rdata <= DM[52];
            6'd53 : rdata <= DM[53];
            6'd54 : rdata <= DM[54];
            6'd55 : rdata <= DM[55];
            6'd56 : rdata <= DM[56];
            6'd57 : rdata <= DM[57];
            6'd58 : rdata <= DM[58];
            6'd59 : rdata <= DM[59];
            6'd60 : rdata <= DM[60];
            6'd61 : rdata <= DM[61];
            6'd62 : rdata <= DM[62];
            6'd63 : rdata <= DM[63];
            default: rdata <= 32'h0; // 未处理地址，默认值为0
        endcase
    end
endmodule

