module Hash32to16(  
    input clk,  
    input rstn,  
    input start,  
    input [31:0] seed,      // 32-bit seed  
    output reg finish,      // Finish signal  
    output reg [15:0] hash  // 16-bit hash value  
);  

    // Internal State  
    reg [31:0] internal_seed;  

    // Simple hashing function  
    function [15:0] simple_hash(input [31:0] seed);  
        begin  
            simple_hash = (seed[15:0] ^ (seed[31:16] << 8)) + ((seed[31:16] >> 8) ^ seed[15:0]);  
            simple_hash = simple_hash ^ (simple_hash >> 4);  
            simple_hash = simple_hash * 169150151;  
            simple_hash = simple_hash ^ (simple_hash >> 16);  
        end  
    endfunction  

    // Process  
    always @(posedge clk or negedge rstn) begin  
        if (!rstn) begin  
            finish <= 0;  
            hash <= 16'b0;  
            internal_seed <= 32'b0;  
        end else if (start) begin  
            finish <= 0;  
            internal_seed <= seed;           // Store seed on start signal  
            hash <= simple_hash(internal_seed); // Compute hash  
            finish <= 1;                     // Indicate the process finished  
        end   
    end  

endmodule