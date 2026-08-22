module tb_alu8();

    reg  [7:0] a;
    reg  [7:0] b;
    reg        sel;
    reg  [2:0] opcode;

    wire [7:0] result;
    wire       zero_flag;
    wire       carry_flag;
    wire       sign_flag;
    wire       overflow_flag;

    alu8 t1 (
        .a(a),
        .b(b),
        .sel(sel),
        .opcode(opcode),
        .result(result),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .sign_flag(sign_flag),
        .overflow_flag(overflow_flag)
    );

    initial begin

        $dumpfile("alu8_wave.vcd");
        $dumpvars(0, tb_alu8);

        
        $monitor("time =%t , opcode =%b ,  sel=%b , a=%b , b=%b , result=%b , zf=%b , cf=%b , sf=%b , of=%b", 
                 $time, opcode, sel, a, b, result, zero_flag, carry_flag, sign_flag, overflow_flag);

        $display("\n addition");
        sel = 0; opcode = 3'h0;
        
        a = 8'd10; b = 8'd5; #10; 
        a = 8'hFF; b = 8'h01; #10; 
        a = 8'h7F; b = 8'h01; #10; 
        a = 8'h80; b = 8'hFF; #10;

        $display("\n subtraction");
        opcode = 3'h1;
        
        a = 8'd10; b = 8'd5; #10; 
        a = 8'h00; b = 8'h01; #10; 
        a = 8'h7F; b = 8'hFF; #10;

        $display("\n bitwise");
        a = 8'hAA; b = 8'h55;

        
        opcode = 3'h2; #10;
        opcode = 3'h3; #10;
        opcode = 3'h4; #10;

        $display("\n shift right and left");
        a = 8'b1000_0010;
        b = 8'b0000_1101;
        
        opcode = 3'h5; sel = 0; #10;
        opcode = 3'h5; sel = 1; #10;
        
        opcode = 3'h6; sel = 0; #10;
        opcode = 3'h6; sel = 1; #10;

        $display("\n not");
        opcode = 3'h7; 
        sel = 0; a = 8'h00; #10;
        sel = 1; b = 8'hFF; #10;
        $finish;
    end

endmodule
