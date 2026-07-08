`timescale 1ns / 1ps

module digital_lock_tb;

    // Inputs
    reg clk;
    reg rst;
    reg enter;
    reg [3:0] password;

    // Outputs
    wire unlock;
    wire alarm;

    // Instantiate the Design Under Test (DUT)
    digital_lock uut (
        .clk(clk),
        .rst(rst),
        .enter(enter),
        .password(password),
        .unlock(unlock),
        .alarm(alarm)
    );

    // Clock Generation (10 ns period)
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial
    begin
        // Initialize inputs
        rst = 1;
        enter = 0;
        password = 4'b0000;

        // Release reset
        #10 rst = 0;

        // -----------------------------
        // Test Case 1: Correct Password
        // -----------------------------
        #10;
        password = 4'b1010;
        enter = 1;
        #10;
        enter = 0;

        // -----------------------------
        // Test Case 2: Wrong Password
        // -----------------------------
        #20;
        password = 4'b0001;
        enter = 1;
        #10;
        enter = 0;

        // -----------------------------
        // Test Case 3: Wrong Password
        // -----------------------------
        #20;
        password = 4'b0011;
        enter = 1;
        #10;
        enter = 0;

        // -----------------------------
        // Test Case 4: Third Wrong Password
        // Alarm should activate
        // -----------------------------
        #20;
        password = 4'b0100;
        enter = 1;
        #10;
        enter = 0;

        // -----------------------------
        // Test Case 5: Correct Password
        // Alarm remains active until reset
        // -----------------------------
        #20;
        password = 4'b1010;
        enter = 1;
        #10;
        enter = 0;

        // -----------------------------
        // Test Case 6: Reset
        // -----------------------------
        #20;
        rst = 1;
        #10;
        rst = 0;

        // -----------------------------
        // Test Case 7: Correct Password
        // Unlock should work again
        // -----------------------------
        #20;
        password = 4'b1010;
        enter = 1;
        #10;
        enter = 0;

        #50;
        $finish;
    end

    // Display Results
    initial
    begin
        $monitor("Time=%0t | Password=%b | Enter=%b | Unlock=%b | Alarm=%b",
                  $time, password, enter, unlock, alarm);
    end

endmodule
