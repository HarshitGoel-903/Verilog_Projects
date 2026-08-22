module alu8 (
    input [7:0] a,
    input [7:0] b,
    input sel,
    input [2:0] opcode,
    output reg [7:0] result,
    output zero_flag,
    output reg carry_flag,
    output sign_flag,
    output reg overflow_flag
);


always @(*) begin
    carry_flag = 1'b0;
    overflow_flag = 1'b0;
    result = 8'h0;
    case(opcode)
    3'h0: begin
        {carry_flag,result} = a+b;
        overflow_flag = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
    end

    3'h1: begin
        {carry_flag,result} = a-b;
        overflow_flag = (~a[7] & b[7] & result[7]) | (a[7] & ~b[7] & ~result[7]);
    end

    3'h2: result = a&b;
    3'h3: result = a|b;
    3'h4: result = a^b;
    3'h5: result =(~sel)? {a[7] , a[7:1]}:{b[7] , b[7:1]};
    3'h6: result =(~sel)? {a[6:0] , a[0]}: {b[6:0] , b[0]};
    3'h7: result =(~sel)? ~a: ~b;
    default: result = 8'h0;
    endcase
end

assign zero_flag = (result == 8'h0);
assign sign_flag = result[7];

endmodule
