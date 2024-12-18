module SegController2(  
    input                   clk,         // 100MHz 时钟  
    input                   rst,         // 复位信号 (高电平有效)  
    input       [55:0]     output_data,  // 自定义输出数据  
    input       [ 7:0]     output_valid, // 每个数码管的有效信号  
    output reg  [ 6:0]     seg_data,     // 7段显示器数据输出  
    output reg  [ 7:0]     seg_an        // 8位数码管阳极控制  
);  

//   ---6--- 
//  |       |
//  1       5
//  |       |
//   ---0--- 
//  |       |
//  2       4
//  |       |
//   ---3---


reg [31:0] counter;  
reg [2:0]  seg_id; // 管 Id, 用于选择哪个数码管  

// 生成400Hz的信号  
always @(posedge clk) begin  
    if (rst) begin  
        counter <= 0;  
        seg_id <= 0;  
    end else begin  
        if (counter >= 24999) begin   
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
                seg_data = output_data[6:0];   
                seg_an = 8'b11111110;  // 选择第一个数码管  
            end       
            3'b001: begin  
                seg_data = output_data[13:7];      
                seg_an = 8'b11111101;  // 选择第二个数码管  
            end  
            3'b010: begin  
                seg_data = output_data[20:14];      
                seg_an = 8'b11111011;  // 选择第三个数码管  
            end  
            3'b011: begin  
                seg_data = output_data[27:21];     
                seg_an = 8'b11110111;  // 选择第四个数码管  
            end  
            3'b100: begin  
                seg_data = output_data[34:28];     
                seg_an = 8'b11101111;  // 选择第五个数码管  
            end  
            3'b101: begin  
                seg_data = output_data[41:35];     
                seg_an = 8'b11011111;  // 选择第六个数码管  
            end  
            3'b110: begin  
                seg_data = output_data[48:42];     
                seg_an = 8'b10111111; // 选择第七个数码管  
            end  
            3'b111: begin  
                seg_data = output_data[55:49];     
                seg_an = 8'b01111111;  // 选择第八个数码管  
            end  
            default: begin  
                seg_data = 7'b0;  // 如果没有选择，默认输出为0  
                seg_an = 8'b11111111; // 关闭所有数码管  
            end  
        endcase   
    end else begin  
        seg_data = 7'b0;  // 如果无效，输出为0  
        seg_an = 8'b11111111;  // 关闭所有数码管  
    end   

end  
endmodule