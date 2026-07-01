`timescale 1ns / 1ps
// peak_detector


module ptm #(
    parameter integer DIV_RATIO = 4
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] data_in,

    output reg  [7:0]  peak,
    output reg  [15:0] interval,

    output wire        clk_en_out
);

    wire clk_en;

    assign clk_en_out = clk_en;

    clk_div #(
        .DIV_RATIO(DIV_RATIO)
    ) u_clk_div (
        .clk   (clk),
        .rst_n (rst_n),
        .clk_en(clk_en)
    );

    reg [15:0] timer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            peak     <= 8'd0;
            interval <= 16'd0;
            timer    <= 16'd0;
        end
        else begin

            // Count every system clock
            timer <= timer + 1'b1;

            // Check peak only at clk_en pulse
            if (clk_en) begin

                if (data_in > peak) begin
                    peak     <= data_in;

                    // +1 gives actual clock count
                    interval <= timer + 1'b1;

                    timer    <= 16'd0;
                end

            end

        end
    end

endmodule
