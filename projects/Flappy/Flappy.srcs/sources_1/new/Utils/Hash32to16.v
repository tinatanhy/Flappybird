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
reg [31:0] internal_seed, internal_seed_next;
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
reg [15:0] hash_buffer, hash_buffer_next, hash_next;
// Process  
always @(posedge clk) begin  
    if (!rstn) begin  
        status <= 2'b00;
        internal_seed <= 0;
        hash_buffer <= 0;
    end else begin
        status <= next_status;
        hash_buffer <= hash_buffer_next;
        hash <= hash_next;
        internal_seed <= internal_seed_next;
    end
end  

assign finish = status == 2'b00;

always @(*) begin
    hash_next = 0;
    hash_buffer_next = 0;
    next_status = status;
    internal_seed_next = internal_seed;
    case(status)
    2'b00: begin
        if(start) begin
            internal_seed_next = seed;
            next_status = 2'b01;
        end
        else begin
            next_status = 2'b00;
        end
        hash_buffer_next = hash_buffer;
        hash_next = hash_buffer;
    end
    2'b01: begin
        hash_buffer_next = ((internal_seed[15:0] ^ (internal_seed[31:16] << 8)) + ((internal_seed[31:16] >> 8) ^ internal_seed[15:0])) * 1209846;  
        hash_next = hash;
        next_status = 2'b10;
    end
    2'b10: begin
        hash_buffer_next = (hash_buffer ^ (hash_buffer >> 4)) * 169150151;  
        hash_next = hash;
        next_status = 2'b11;
    end
    2'b11: begin
        hash_buffer_next = hash_buffer ^ (hash_buffer >> 8);  
        hash_next = hash_buffer ^ (hash_buffer >> 8);
        next_status = 2'b00;
    end
    endcase
end

endmodule