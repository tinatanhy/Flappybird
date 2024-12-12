module Hash32to16(  
    input clk,  
    input rstn,  
    input start,  
    input [31:0] seed,      // 32-bit seed  
    output finish,      // Finish signal  
    output reg [15:0] hash  // 16-bit hash value  
);  

// Internal State  
// reg [15:0] hash_buffer;
reg [31:0] internal_seed;
reg [1:0] status;
reg [1:0] next_status;

// Simple hashing function  
// function [15:0] simple_hash(input [31:0] seed);  
//     begin  
//         simple_hash = (seed[15:0] ^ (seed[31:16] << 8)) + ((seed[31:16] >> 8) ^ seed[15:0]);  
//         simple_hash = simple_hash ^ (simple_hash >> 4);  
//         simple_hash = simple_hash * 169150151;  
//     end  
// endfunction  
wire[15:0] hash_buffer0 = ((internal_seed[15:0] ^ (internal_seed[31:16] << 8)) + ((internal_seed[31:16] >> 8) ^ internal_seed[15:0])) * 1209846;  
wire[15:0] hash_buffer1 = hash_buffer0 ^ (hash_buffer0 >> 4);  
wire[15:0] hash_buffer2 = hash_buffer1 * 169150151;  
wire[15:0] hash_buffer3 = hash_buffer2 ^ (hash_buffer2 >> 8);  
// Process  
always @(posedge clk) begin  
    if (!rstn) begin  
        status <= 2'b00;
    end else begin
        status <= next_status;
    end
end  

always @(*) begin
    case(status)
    2'b01: begin
        hash = hash_buffer3;
    end
    endcase
end

assign finish = status == 2'b00;

always @(*) begin
    next_status = status;
    case(status)
    2'b00: begin
        if(start) begin
            internal_seed = seed;
            next_status = 2'b01;
        end
        else begin
            next_status = 2'b00;
        end
    end
    2'b01: begin
        // hash_buffer = simple_hash(internal_seed);
        next_status = 2'b10;
    end
    2'b10: begin
        next_status = 2'b11;
    end
    2'b11: begin
        next_status = 2'b00;
    end
    endcase
end

endmodule