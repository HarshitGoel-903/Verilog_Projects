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
