module SegWithMask(  
    input                   clk,        // 100MHz 时钟  
    input                   rst,        // 复位信号 (高电平有效)  
    input       [31:0]     output_data,// 输出数据  
    input       [ 7:0]     output_valid, // 每个数码管的有效信号  
    output reg  [ 6:0]     seg_data,   // 7段显示器数据输出  
    output reg  [ 7:0]     seg_an      // 8位数码管阳极控制  
);  

    reg [31:0] counter;  
    reg [2:0]  seg_id; // 管 Id, 用于选择哪个数码管  
    reg [3:0]  seg_data1; // 存储当前要显示的4位数据  

    // 生成400Hz的信号  
    always @(posedge clk) begin  
        if (rst) begin  
            counter <= 0;  
            seg_id <= 0;  
        end else begin  
            if (counter >= 249999) begin   
                counter <= 0;  
                seg_id <= seg_id + 1;   
                if (seg_id >= 3'b111) begin // 0-7的循环  
                    seg_id <= 0; // Reset seg_id when it exceeds the last index (7)  
                end  
            end else begin  
                counter <= counter + 1;  
            end  
        end  
    end  

    // 控制数码管  
    always @(*) begin  
        if (output_valid[seg_id]) begin // 检查当前管是否有效  
            case (seg_id)  
                3'b000: begin  
                    seg_data1 = output_data[3:0];   
                    seg_an = 8'b11111110;  // 选择第一个数码管  
                end       
                3'b001: begin  
                    seg_data1 = output_data[7:4];      
                    seg_an = 8'b11111101;  // 选择第二个数码管  
                end  
                3'b010: begin  
                    seg_data1 = output_data[11:8];      
                    seg_an = 8'b11111011;  // 选择第三个数码管  
                end  
                3'b011: begin  
                    seg_data1 = output_data[15:12];     
                    seg_an = 8'b11110111;  // 选择第四个数码管  
                end  
                3'b100: begin  
                    seg_data1 = output_data[19:16];     
                    seg_an = 8'b11101111;  // 选择第五个数码管  
                end  
                3'b101: begin  
                    seg_data1 = output_data[23:20];     
                    seg_an = 8'b11011111;  // 选择第六个数码管  
                end  
                3'b110: begin  
                    seg_data1 = output_data[27:24];     
                    seg_an = 8'b10111111; // 选择第七个数码管  
                end  
                3'b111: begin  
                    seg_data1 = output_data[31:28];     
                    seg_an = 8'b01111111;  // 选择第八个数码管  
                end  
                default: begin  
                    seg_data1 = 4'b0000;  // 如果没有选择，默认输出为0  
                    seg_an = 8'b11111111; // 关闭所有数码管  
                end  
            endcase   
        end else begin  
            seg_data1 = 4'b0000;  // 如果无效，输出为0  
            seg_an = 8'b11111111;  // 关闭所有数码管  
        end   

        // 根据4位数字选择7段显示  
        case(seg_data1)  
            4'b0000: seg_data = ~7'b0111111; // 0 -> inverse   
            4'b0001: seg_data = ~7'b0000110; // 1 -> inverse   
            4'b0010: seg_data = ~7'b1011011; // 2 -> inverse   
            4'b0011: seg_data = ~7'b1001111; // 3 -> inverse   
            4'b0100: seg_data = ~7'b1100110; // 4 -> inverse   
            4'b0101: seg_data = ~7'b1101101; // 5 -> inverse   
            4'b0110: seg_data = ~7'b1111101; // 6 -> inverse   
            4'b0111: seg_data = ~7'b0000111; // 7 -> inverse   
            4'b1000: seg_data = ~7'b1111111; // 8 -> inverse   
            4'b1001: seg_data = ~7'b1101111; // 9 -> inverse   
            4'b1010: seg_data = ~7'b1110111; // A -> inverse   
            4'b1011: seg_data = ~7'b1111111; // B -> inverse   
            4'b1100: seg_data = ~7'b0111001; // C -> inverse   
            4'b1101: seg_data = ~7'b1011110; // D -> inverse   
            4'b1110: seg_data = ~7'b1111001; // E -> inverse   
            4'b1111: seg_data = ~7'b1110001; // F -> inverse   
            default: seg_data = 7'b1111111;  // Close all segments (i.e., turned on)  
    endcase  
    end  
endmodule