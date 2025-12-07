module Project #(
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter SCAN_RATE   = 1000
)(
    input  wire        CLK,
    input  wire        RST_N,          // Active-low async reset
    input  wire [3:0]  ROWS,           // Row inputs
    output reg  [3:0]  COLS,           // Column outputs
    output reg  [7:0]  HEX0,           // Last entered digit
    output reg  [9:0]  LEDS,           // LED outputs
    output reg  [7:0]  DBG,            // Debug outputs
    output reg         p1,
    output reg         p2
);

    //==========================================================
    // Clock enable generator (creates scan tick)
    //==========================================================
    localparam integer COUNT_MAX = CLK_FREQ_HZ / SCAN_RATE;
    reg [$clog2(COUNT_MAX)-1:0] clk_cnt = 0;
    reg clk_en = 0;

    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            clk_cnt <= 0;
            clk_en  <= 0;
        end else begin
            if (clk_cnt == COUNT_MAX-1) begin
                clk_cnt <= 0;
                clk_en  <= 1;
            end else begin
                clk_cnt <= clk_cnt + 1;
                clk_en  <= 0;
            end
        end
    end

    //==========================================================
    // Column scan pattern (active low)
    //==========================================================
    reg [1:0] col_index = 0;
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            col_index <= 0;
            COLS <= 4'b1110;
        end else if (clk_en) begin
            case (col_index)
                2'd0: COLS <= 4'b1110;
                2'd1: COLS <= 4'b1101;
                2'd2: COLS <= 4'b1011;
                2'd3: COLS <= 4'b0111;
            endcase
            col_index <= col_index + 1;
        end
    end

    //==========================================================
    // Key detection with debouncing
    //==========================================================
    reg [3:0] key_value = 4'hF;
    reg key_pressed = 0;
    reg [3:0] prev_rows = 4'b1111;
    reg [15:0] debounce_timer = 0;
    reg key_ready = 1;
    
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            key_value <= 4'hF;
            key_pressed <= 0;
            prev_rows <= 4'b1111;
            debounce_timer <= 0;
            key_ready <= 1;
        end else if (clk_en) begin
            // Default: clear key_pressed
            key_pressed <= 0;
            
            if (key_ready) begin
                // Detect key press on falling edge of any row
                if (ROWS != 4'b1111 && prev_rows == 4'b1111) begin
                    case ({COLS, ROWS})
                        8'b1110_1110: begin key_value <= 4'd1; key_pressed <= 1; end
                        8'b1110_1101: begin key_value <= 4'd4; key_pressed <= 1; end
                        8'b1110_1011: begin key_value <= 4'd7; key_pressed <= 1; end
                        8'b1110_0111: begin key_value <= 4'hE; key_pressed <= 1; end  // *
                        
                        8'b1101_1110: begin key_value <= 4'd2; key_pressed <= 1; end
                        8'b1101_1101: begin key_value <= 4'd5; key_pressed <= 1; end
                        8'b1101_1011: begin key_value <= 4'd8; key_pressed <= 1; end
                        8'b1101_0111: begin key_value <= 4'd0; key_pressed <= 1; end
                        
                        8'b1011_1110: begin key_value <= 4'd3; key_pressed <= 1; end
                        8'b1011_1101: begin key_value <= 4'd6; key_pressed <= 1; end
                        8'b1011_1011: begin key_value <= 4'd9; key_pressed <= 1; end
                        8'b1011_0111: begin key_value <= 4'hF; key_pressed <= 1; end  // #
                        
                        8'b0111_1110: begin key_value <= 4'hA; key_pressed <= 1; end
                        8'b0111_1101: begin key_value <= 4'hB; key_pressed <= 1; end
                        8'b0111_1011: begin key_value <= 4'hC; key_pressed <= 1; end
                        8'b0111_0111: begin key_value <= 4'hD; key_pressed <= 1; end
                        
                        default: key_pressed <= 0;
                    endcase
                    
                    // Start debounce timer when key is detected
                    key_ready <= 0;
                    debounce_timer <= 0;
                end
            end else begin
                // Count debounce timer
                debounce_timer <= debounce_timer + 1;
                if (debounce_timer >= 16'd1000) begin
                    key_ready <= 1;
                end
            end
            
            prev_rows <= ROWS;
        end
    end

    //==========================================================
    // Edge detection for key_pressed
    //==========================================================
    reg key_pressed_prev = 0;
    wire key_rising_edge;
    
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            key_pressed_prev <= 0;
        end else begin
            key_pressed_prev <= key_pressed;
        end
    end
    
    assign key_rising_edge = key_pressed && !key_pressed_prev;

    //==========================================================
    // Password capture (5 digits) with integrated match logic
    //==========================================================
    reg [3:0] password [0:4];
    reg [2:0] pw_index = 0;
    reg       pw_done  = 0;
    reg [3:0] last_digit = 4'hF;
    reg       pw_match;  // Password match result
    reg       compare_done;  // Indicates comparison is complete

    // Static password - Change these values to set your password
    localparam [3:0] STATIC_PW_0 = 4'd1;
    localparam [3:0] STATIC_PW_1 = 4'd2;
    localparam [3:0] STATIC_PW_2 = 4'd3;
    localparam [3:0] STATIC_PW_3 = 4'd4;
    localparam [3:0] STATIC_PW_4 = 4'd1;

    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            pw_index     <= 0;
            pw_done      <= 0;
            last_digit   <= 4'hF;
            pw_match     <= 0;
            compare_done <= 0;
            password[0] <= 4'hF;
            password[1] <= 4'hF;
            password[2] <= 4'hF;
            password[3] <= 4'hF;
            password[4] <= 4'hF;
        end else begin
            // Process key press only on rising edge
            if (key_rising_edge) begin
                if (key_value == 4'ha) begin
                    // 'A' pressed -> reset password input process
                    pw_index     <= 0;
                    pw_done      <= 0;
                    last_digit   <= 4'hF;
                    pw_match     <= 0;
                    password[0] <= 4'hF;
                    password[1] <= 4'hF;
                    password[2] <= 4'hF;
                    password[3] <= 4'hF;
                    password[4] <= 4'hF;
                    compare_done <= 0;
                end else if (!pw_done) begin
                    if (key_value <= 4'd9) begin
                        // Store digit and update display
                        password[pw_index] <= key_value;
                        last_digit <= key_value;
                        
                        // Increment index (stop at 5)
                        if (pw_index < 3'd5)
                            pw_index <= pw_index + 1;
                            
                    end else if (key_value == 4'hf) begin // '#' pressed
                        // Check if exactly 5 digits entered (pw_index should be 5)
                        if (pw_index == 3'd5) begin
                            pw_done <= 1;
                        
                            // Perform comparison digit-by-digit with localparams
                            pw_match <= (password[0] == STATIC_PW_0) &&
                                       (password[1] == STATIC_PW_1) &&
                                       (password[2] == STATIC_PW_2) &&
                                       (password[3] == STATIC_PW_3) &&
                                       (password[4] == STATIC_PW_4);
                            compare_done <= 1;
                        end else begin
                            // Wrong number of digits - comparison fails
                            pw_done <= 1;
                            pw_match <= 0;
                            compare_done <= 1;
                        end
                    end
                end
            end
        end
    end

    // Register p1 and p2 outputs for stability
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            p1 <= 0;
            p2 <= 0;
        end else begin
            p1 <= compare_done && pw_match;   // Only high when comparison done AND match
            p2 <= compare_done && !pw_match;  // Only high when comparison done AND no match
        end
    end

    //==========================================================
    // 7-segment display decoder (common anode)
    //==========================================================
    function [6:0] bcd2seg7;
        input [3:0] bcd;
        begin
            case (bcd)
                4'd0: bcd2seg7 = 7'b1000000;
                4'd1: bcd2seg7 = 7'b1111001;
                4'd2: bcd2seg7 = 7'b0100100;
                4'd3: bcd2seg7 = 7'b0110000;
                4'd4: bcd2seg7 = 7'b0011001;
                4'd5: bcd2seg7 = 7'b0010010;
                4'd6: bcd2seg7 = 7'b0000010;
                4'd7: bcd2seg7 = 7'b1111000;
                4'd8: bcd2seg7 = 7'b0000000;
                4'd9: bcd2seg7 = 7'b0010000;
                default: bcd2seg7 = 7'b1111111;
            endcase
        end
    endfunction

    //==========================================================
    // Display + debug
    //==========================================================
    always @(*) begin
        HEX0 = {1'b1, bcd2seg7(last_digit)};   // Show last entered digit
        LEDS[9] = pw_done;                     // LED9 lights when done ('#' pressed)
        LEDS[8] = compare_done;                // LED8 shows comparison is complete
        LEDS[7] = pw_match;                    // LED7 shows match result
        LEDS[6:5] = pw_index[1:0];             // Show lower 2 bits of index
        LEDS[4] = key_ready;                   // LED4 shows debounce state
        LEDS[3:0] = key_value;                 // Show current key value
        DBG[3:0] = last_digit;
        DBG[7:4] = {pw_done, pw_index};
    end

endmodule