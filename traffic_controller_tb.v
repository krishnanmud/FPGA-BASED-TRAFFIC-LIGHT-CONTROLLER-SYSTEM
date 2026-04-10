module tb;

reg clk = 0;
reg reset = 1;
reg emergency = 0;

wire A_r, A_y, A_g;
wire B_r, B_y, B_g;

traffic_controller uut(
    clk, reset, emergency,
    A_r, A_y, A_g,
    B_r, B_y, B_g
);

always #5 clk = ~clk;

initial begin
    #10 reset = 0;

    // Normal operation
    #100;

    // Emergency condition
    emergency = 1;
    #50;

    emergency = 0;
    #100;

    $stop;
end

endmodule