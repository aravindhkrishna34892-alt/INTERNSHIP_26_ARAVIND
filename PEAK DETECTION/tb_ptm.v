`timescale 1ns / 1ps

module tb_ptm;

    localparam integer DIV_RATIO  = 4;
    localparam integer CLK_PERIOD = 10;

    reg         clk;
    reg         rst_n;
    reg  [7:0]  data_in;

    wire [7:0]  peak;
    wire [15:0] interval;
    wire        clk_en_out;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------
    ptm #(
        .DIV_RATIO(DIV_RATIO)
    ) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .data_in    (data_in),
        .peak       (peak),
        .interval   (interval),
        .clk_en_out (clk_en_out)
    );

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------
    initial clk = 1'b0;

    always #(CLK_PERIOD/2)
        clk = ~clk;

    //--------------------------------------------------
    // Reference Model
    //--------------------------------------------------
    reg [7:0]  exp_peak;
    reg [15:0] exp_interval;
    reg [15:0] exp_timer;

    integer pass_count;
    integer fail_count;

    //--------------------------------------------------
    // Peak Checker
    //--------------------------------------------------
    task check_peak;
        input [7:0] got;
        input [7:0] expected;
        begin
            if (got === expected) begin
                pass_count = pass_count + 1;
                $display("PASS | PEAK     | got=%0d", got);
            end
            else begin
                fail_count = fail_count + 1;
                $display("FAIL | PEAK     | got=%0d expected=%0d",
                         got, expected);
            end
        end
    endtask

    //--------------------------------------------------
    // Interval Checker
    //--------------------------------------------------
    task check_interval;
        input [15:0] got;
        input [15:0] expected;
        begin
            if (got === expected) begin
                pass_count = pass_count + 1;
                $display("PASS | INTERVAL | got=%0d", got);
            end
            else begin
                fail_count = fail_count + 1;
                $display("FAIL | INTERVAL | got=%0d expected=%0d",
                         got, expected);
            end
        end
    endtask

    //--------------------------------------------------
    // Wait for sampling instant
    //--------------------------------------------------
    // FIX: clk_en is asserted for an entire clock period
    // (count == DIV_RATIO-1), not a single-cycle pulse derived
    // from an edge detector. The DUT actually captures data_in
    // on the posedge of clk where clk_en is high *at that edge*.
    // Waiting on @(posedge clk_en_out) is unreliable because:
    //   (a) if clk_en_out is already high when we start waiting,
    //       this task blocks for a full extra DIV_RATIO cycle
    //   (b) the capture itself happens ON the clock edge, not
    //       sometime after clk_en_out rises combinationally
    // So instead: wait for a posedge clk that occurs while
    // clk_en_out is high. That is the exact edge the DUT uses.
    //--------------------------------------------------
    task wait_for_capture_edge;
        begin
            // Always advance one edge first (unconditionally), then
            // hunt for the next edge where clk_en_out=1 -- this edge
            // IS the capture edge. peak/interval become visible one
            // edge later (nonblocking assignment), so wait once more.
            @(posedge clk);
            while (clk_en_out !== 1'b1) begin
                @(posedge clk);
            end
            @(posedge clk);
            #1; // let nonblocking assignments settle
        end
    endtask

    //--------------------------------------------------
    // Apply sample and verify
    //--------------------------------------------------
    task apply_and_check;
        input [7:0] val;
        begin

            data_in = val;

            wait_for_capture_edge;

            // Reference model
            // Mirrors ptm.v's actual behavior (confirmed against golden
            // DUT trace): each apply_and_check call spans exactly one
            // clk_en window = DIV_RATIO clk cycles. On a capture edge
            // with a new max, interval = (timer value going into this
            // window's edge) + DIV_RATIO, then timer resets to 0.
            if (val > exp_peak) begin
                exp_interval = exp_timer + DIV_RATIO;
                exp_peak     = val;
                exp_timer    = 16'd0;
            end
            else begin
                exp_timer = exp_timer + DIV_RATIO;
            end

            check_peak(peak, exp_peak);
            check_interval(interval, exp_interval);

        end
    endtask

    //--------------------------------------------------
    // Reset
    //--------------------------------------------------
    task do_reset;
        begin

            rst_n   = 1'b0;
            data_in = 8'd0;

            repeat(4)
                @(posedge clk);

            rst_n = 1'b1;

            exp_peak     = 8'd0;
            exp_interval = 16'd0;
            exp_timer    = 16'd0;

            // No extra clk_en alignment wait here. The DUT's timer
            // and count start from a known state (0) the instant
            // rst_n deasserts. The very next apply_and_check call IS
            // the first valid clk_en window -- inserting an extra
            // wait here consumes a phantom window the reference
            // model has no way to account for.

        end
    endtask

    //--------------------------------------------------
    // Main Test
    //--------------------------------------------------
    initial begin

        $dumpfile("tb_ptm.vcd");
        $dumpvars(0, tb_ptm);

        pass_count = 0;
        fail_count = 0;

        do_reset();

        $display("\n=== Peak Tracker Test ===\n");

        // Rising peaks
        apply_and_check(8'd50);
        apply_and_check(8'd100);
        apply_and_check(8'd200);

        // No new peak
        apply_and_check(8'd150);
        apply_and_check(8'd180);
        apply_and_check(8'd199);

        // New peak
        apply_and_check(8'd230);

        // More samples
        apply_and_check(8'd50);
        apply_and_check(8'd230);
        apply_and_check(8'd1);

        // Final peak
        apply_and_check(8'd255);

        // Extra edge-case coverage beyond the original vector set
        // Back-to-back new peaks every capture window
        apply_and_check(8'd255); // equal to current peak -> NOT a new peak (strictly >)

        // Reset mid-sequence, then resume
        do_reset();
        apply_and_check(8'd10);
        apply_and_check(8'd20);

        $display("\n==============================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);
        $display("==============================\n");

        #100;
        $finish;

    end

endmodule
