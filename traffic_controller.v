module traffic_controller(
    input clk,
    input reset,
    input emergency,
    output reg A_red, A_yellow, A_green,
    output reg B_red, B_yellow, B_green
);

reg [1:0] state;
reg [3:0] counter;

// State encoding
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        counter <= 0;
    end 
    else begin

        // Emergency override
        if (emergency) begin
            state <= S0;
            counter <= 0;
        end 
        else begin
            counter <= counter + 1;

            case (state)
                S0: if (counter == 5) begin state <= S1; counter <= 0; end
                S1: if (counter == 2) begin state <= S2; counter <= 0; end
                S2: if (counter == 5) begin state <= S3; counter <= 0; end
                S3: if (counter == 2) begin state <= S0; counter <= 0; end
            endcase
        end
    end
end

// Output logic
always @(*) begin
    case (state)
        S0: begin
            A_green=1; A_yellow=0; A_red=0;
            B_red=1; B_yellow=0; B_green=0;
        end
        S1: begin
            A_green=0; A_yellow=1; A_red=0;
            B_red=1; B_yellow=0; B_green=0;
        end
        S2: begin
            A_red=1; A_yellow=0; A_green=0;
            B_green=1; B_yellow=0; B_red=0;
        end
        S3: begin
            A_red=1; A_yellow=0; A_green=0;
            B_yellow=1; B_green=0; B_red=0;
        end
    endcase
end

endmodule