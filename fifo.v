module fifo(
    input clk,
    input reset,
    input write,
    input read,
    input [7:0]data_in,
    output reg [7:0]data_out,
    output reg valid,
    output full,
    output empty
);

reg [7:0] mem [0:15];
reg [4:0] wr_ptr;
reg [4:0] rd_ptr;

assign empty = (wr_ptr == rd_ptr);
assign full = (wr_ptr[3:0] == rd_ptr[3:0]) && (wr_ptr[4] != rd_ptr[4]);

always @(posedge clk) begin
    if(reset) begin
        data_out <= 8'h0;
        wr_ptr <= 5'h0;
        rd_ptr <= 5'h0;
        valid <= 1'b0;
    end
    else begin
        if(write && !full) begin
            mem[wr_ptr[3:0]] <= data_in;
            wr_ptr <= wr_ptr + 1'b1;
        end
        if(read && !empty) begin
            data_out <= mem[rd_ptr[3:0]];
            rd_ptr <= rd_ptr + 1'b1;
            valid <= 1'b1;
        end
        else begin
            valid <= 1'b0;
        end

    end
end
endmodule



module tb_fifo();

    reg clk;
    reg reset;
    reg write;
    reg read;
    reg [7:0] data_in;
    
    wire [7:0] data_out;
    wire valid;
    wire full;
    wire empty;

    integer i;

    fifo d1 (
        .clk(clk),
        .reset(reset),
        .write(write),
        .read(read),
        .data_in(data_in),
        .data_out(data_out),
        .valid(valid),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    
    task write_byte(input [7:0] data);
        begin
            @(negedge clk);
            write = 1'b1;
            data_in = data;
            @(negedge clk);
            write = 1'b0;
        end
    endtask

    task read_byte();
        begin
            @(negedge clk);
            read = 1'b1;
            @(negedge clk);
            read = 1'b0;
        end
    endtask
    
    initial begin
        $dumpfile("fifo_wave.vcd");
        $dumpvars(0, tb_fifo);

        clk = 0;
        write = 0;
        read = 0;
        data_in = 8'h00;

        // testing reset
        reset = 1'b1;
        #20;
        reset = 1'b0;

        // filling the buffer to max
        for (i = 0; i < 16; i = i + 1) begin
            write_byte(i + 8'hA0);
        end
        
        #10;

        // trying to overflow the buffer
        write_byte(8'hFF);
        #10;

        // reading all the elements in the buffer
        for (i = 0; i < 16; i = i + 1) begin
            read_byte();
        end

        #10;

        // trying to underflow the buffer
        read_byte();
        #10;

        // reading and writing at the same time
        write_byte(8'h55);
        
        @(negedge clk);
        write = 1'b1;
        read = 1'b1;
        data_in = 8'hAA;
        @(negedge clk);
        write = 1'b0;
        read = 1'b0;

        #10;

        // reading and writing at the same time multiple time
        for (i = 0; i < 40; i = i + 1) begin
            @(negedge clk);
            write = 1'b1;
            data_in = i;
            read = 1'b1;
        end
        @(negedge clk);
        write = 0;
        read = 0;

        #50;
        $finish;
    end

endmodule