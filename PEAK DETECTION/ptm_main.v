`timescale 1ns / 1ps

module ptm_main #(
    parameter integer DIV_RATIO = 4
)(
    input         clk_pad,
    input         rst_n_pad,
    input   [7:0] data_in_pad,
    output  [7:0] peak_pad,
    output [15:0] interval_pad,
    output        clk_en_out_pad
);

    // Internal Wires for Core Logic
    wire       clk;
    wire       rst_n;
    wire [7:0] data_in;
    wire [7:0] peak;
    wire [15:0] interval;
    wire       clk_en_out;
    wire       ptm_clk;

    // Clock Buffering
    pc3c01 pc3c01_1 (.CCLK(ptm_clk), .CP(clk)); 
    pc3d01 pc3d01_1 (.PAD(clk_pad),   .CIN(ptm_clk));

    // Input Pad Instantiations
    pc3d01 pc3d01_2 (.PAD(rst_n_pad), .CIN(rst_n));
    // data_in[7:0]
    pc3d01 pc3d01_3 (.PAD(data_in_pad[0]), .CIN(data_in[0]));
    pc3d01 pc3d01_4 (.PAD(data_in_pad[1]), .CIN(data_in[1]));
    pc3d01 pc3d01_5 (.PAD(data_in_pad[2]), .CIN(data_in[2]));
    pc3d01 pc3d01_6 (.PAD(data_in_pad[3]), .CIN(data_in[3]));
    pc3d01 pc3d01_7 (.PAD(data_in_pad[4]), .CIN(data_in[4]));
    pc3d01 pc3d01_8 (.PAD(data_in_pad[5]), .CIN(data_in[5]));
    pc3d01 pc3d01_9 (.PAD(data_in_pad[6]), .CIN(data_in[6]));
    pc3d01 pc3d01_10 (.PAD(data_in_pad[7]), .CIN(data_in[7]));


    // Output Pad Instantiations
    // peak[7:0]
    pc3o05 pc3o05_1 (.I(peak[0]), .PAD(peak_pad[0]));
    pc3o05 pc3o05_2 (.I(peak[1]), .PAD(peak_pad[1]));
    pc3o05 pc3o05_3 (.I(peak[2]), .PAD(peak_pad[2]));
    pc3o05 pc3o05_4 (.I(peak[3]), .PAD(peak_pad[3]));
    pc3o05 pc3o05_5 (.I(peak[4]), .PAD(peak_pad[4]));
    pc3o05 pc3o05_6 (.I(peak[5]), .PAD(peak_pad[5]));
    pc3o05 pc3o05_7 (.I(peak[6]), .PAD(peak_pad[6]));
    pc3o05 pc3o05_8 (.I(peak[7]), .PAD(peak_pad[7]));


    // interval[15:0]
    pc3o05 pc3o05_9 (.I(interval[0]), .PAD(interval_pad[0]));
    pc3o05 pc3o05_10 (.I(interval[1]), .PAD(interval_pad[1]));
    pc3o05 pc3o05_11 (.I(interval[2]), .PAD(interval_pad[2]));
    pc3o05 pc3o05_12 (.I(interval[3]), .PAD(interval_pad[3]));
    pc3o05 pc3o05_13 (.I(interval[4]), .PAD(interval_pad[4]));
    pc3o05 pc3o05_14 (.I(interval[5]), .PAD(interval_pad[5]));
    pc3o05 pc3o05_15 (.I(interval[6]), .PAD(interval_pad[6]));
    pc3o05 pc3o05_16 (.I(interval[7]), .PAD(interval_pad[7]));
    pc3o05 pc3o05_17 (.I(interval[8]), .PAD(interval_pad[8]));
    pc3o05 pc3o05_18 (.I(interval[9]), .PAD(interval_pad[9]));
    pc3o05 pc3o05_19 (.I(interval[10]), .PAD(interval_pad[10]));
    pc3o05 pc3o05_20 (.I(interval[11]), .PAD(interval_pad[11]));
    pc3o05 pc3o05_21 (.I(interval[12]), .PAD(interval_pad[12]));
    pc3o05 pc3o05_22 (.I(interval[13]), .PAD(interval_pad[13]));
    pc3o05 pc3o05_23 (.I(interval[14]), .PAD(interval_pad[14]));
    pc3o05 pc3o05_24 (.I(interval[15]), .PAD(interval_pad[15]));
    

    // clk_en_out
    pc3o05 pc3o05_clk_en (.I(clk_en_out), .PAD(clk_en_out_pad));

    // PTM Core Instantiation
    ptm #(
        .DIV_RATIO(DIV_RATIO)
    ) u_ptm (
        .clk        (clk),
        .rst_n      (rst_n),
        .data_in    (data_in),
        .peak       (peak),
        .interval   (interval),
        .clk_en_out (clk_en_out)
    );

endmodule
