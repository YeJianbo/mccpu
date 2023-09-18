`timescale 1ns / 1ps
//********************************************************************
// > 文件名：mccomp_display.v
//********************************************************************
module mccomp_display(
    //时钟与复位信号
    input clk,
    input resetn, 
    //按钮时钟信号
    input btn_clk,
    //LCD复位信号
    output lcd_rst,
    //片选信号
    output lcd_cs,
    //选择信号
    output lcd_rs,
    //写使能
    output lcd_wr,
    //读使能
    output lcd_rd,
    //数据I/O总线
    inout [15:0] lcd_data_io,
    //背光控制信号
    output lcd_bl_ctr,
    //I2C总线
    inout ct_int,
    inout ct_sda,
    output ct_scl,
    output ct_rstn
    );
    
    wire cpu_clk; 
    reg btn_clk_r1;
    reg btn_clk_r2;
    
    always @(posedge clk) begin
        if (!resetn) begin
            btn_clk_r1 <= 1'b0;
        end else begin
            btn_clk_r1 <= ~btn_clk;
        end
        btn_clk_r2 <= btn_clk_r1;
    end
    
    wire clk_en;
    assign clk_en = !resetn || (!btn_clk_r1 && btn_clk_r2);
    BUFGCE cpu_clk_cg(.I(clk), .CE(clk_en), .O(cpu_clk));
    
    wire [2:0] q;
    wire [31:0] a, b, alu, adr, tom, fromm, pc, ir;
    
    //实例化
    top cpu(cpu_clk,resetn,q,a,b,alu,adr,tom,fromm,pc,ir,clk);
    
    reg display_valid;
    reg [39:0] display_name;
    reg [31:0] display_value;
    wire [5:0] display_number;
    wire input_valid;
    wire [31:0] input_value;
    
    lcd_module lcd_module(
        .clk (clk), //10Mhz
        .resetn (resetn),
        .display_valid (display_valid),
        .display_name (display_name),
        .display_value (display_value),
        .display_number (display_number),
        .input_valid (input_valid),
        .input_value (input_value),
        .lcd_rst (lcd_rst),
        .lcd_cs (lcd_cs),
        .lcd_rs (lcd_rs),
        .lcd_wr (lcd_wr),
        .lcd_rd (lcd_rd),
        .lcd_data_io (lcd_data_io),
        .lcd_bl_ctr (lcd_bl_ctr),
        .ct_int (ct_int),
        .ct_sda (ct_sda),
        .ct_scl (ct_scl),
        .ct_rstn (ct_rstn)
    );
    
    always @(posedge clk) begin
        case (display_number)
            6'd1: begin
                display_valid <= 1'b1;
                display_name <= "Q";
                display_value <= q;
            end
            6'd2: begin
                display_valid <= 1'b1;
                display_name <= "A";
                display_value <= a;
            end
            6'd3: begin
                display_valid <= 1'b1;
                display_name <= "B";
                display_value <= b;
            end
            6'd4: begin
                display_valid <= 1'b1;
                display_name <= "ALU";
                display_value <= alu;
            end
            6'd5: begin
                display_valid <= 1'b1;
                display_name <= "ADR";
                display_value <= adr;
            end
            6'd6: begin
                display_valid <= 1'b1;
                display_name <= "TOM";
                display_value <= tom;
            end
            6'd7: begin
                display_valid <= 1'b1;
                display_name <= "FROMM";
                display_value <= fromm;
            end
            6'd8: begin
                display_valid <= 1'b1;
                display_name <= "PC";
                display_value <= pc;
            end
            6'd9: begin
                display_valid <= 1'b1;
                display_name <= "IR";
                display_value <= ir;
            end
            default: begin
                display_valid <= 1'b0;
                display_name <= 40'd0;
                display_value <= 32'd0;
            end
        endcase
    end
endmodule
