module finalproject #(
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter SCAN_RATE   = 1000
)(
    input  wire        CLK,
    input  wire        RST_N,
    input  wire [3:0]  ROWS,
    output reg  [3:0]  COLS,
    output reg  [7:0]  HEX0,
    output reg  [7:0]  HEX1,
    output reg  [7:0]  HEX2,
    output reg  [9:0]  LEDS,
    output reg  [7:0]  DBG
);

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
            key_pressed <= 0;
            
            if (key_ready) begin
                if (ROWS != 4'b1111 && prev_rows == 4'b1111) begin
                    case ({COLS, ROWS})
                        8'b1110_1110: begin key_value <= 4'd1; key_pressed <= 1; end
                        8'b1110_1101: begin key_value <= 4'd4; key_pressed <= 1; end
                        8'b1110_1011: begin key_value <= 4'd7; key_pressed <= 1; end
                        8'b1110_0111: begin key_value <= 4'hE; key_pressed <= 1; end
                        
                        8'b1101_1110: begin key_value <= 4'd2; key_pressed <= 1; end
                        8'b1101_1101: begin key_value <= 4'd5; key_pressed <= 1; end
                        8'b1101_1011: begin key_value <= 4'd8; key_pressed <= 1; end
                        8'b1101_0111: begin key_value <= 4'd0; key_pressed <= 1; end
                        
                        8'b1011_1110: begin key_value <= 4'd3; key_pressed <= 1; end
                        8'b1011_1101: begin key_value <= 4'd6; key_pressed <= 1; end
                        8'b1011_1011: begin key_value <= 4'd9; key_pressed <= 1; end
                        8'b1011_0111: begin key_value <= 4'hF; key_pressed <= 1; end
                        
                        8'b0111_1110: begin key_value <= 4'hA; key_pressed <= 1; end
                        8'b0111_1101: begin key_value <= 4'hB; key_pressed <= 1; end
                        8'b0111_1011: begin key_value <= 4'hC; key_pressed <= 1; end
                        8'b0111_0111: begin key_value <= 4'hD; key_pressed <= 1; end
                        
                        default: key_pressed <= 0;
                    endcase
                    
                    if (key_pressed) begin
                        key_ready <= 0;
                        debounce_timer <= 0;
                    end
                end
            end else begin
                debounce_timer <= debounce_timer + 1;
                if (debounce_timer >= 16'd1000) begin
                    key_ready <= 1;
                end
            end
            
            prev_rows <= ROWS;
        end
    end

    reg [6:0] operand1 = 0;
    reg [6:0] operand2 = 0;
    reg [2:0] operation = 0;
    reg [7:0] result = 0;
    reg calculation_done = 0;
    reg display_result = 0;
    reg input_first_operand = 1;
    reg [1:0] digit_count = 0;
    
    reg [3:0] display_digit1 = 0;
    reg [3:0] display_digit0 = 0;
    
    // Increased delay for comfortable input (1 second)
    reg [25:0] input_delay_counter = 0;
    reg input_ready = 1;
    
    localparam OP_NONE = 3'd0;
    localparam OP_ADD  = 3'd1;
    localparam OP_SUB  = 3'd2;
    localparam OP_MUL  = 3'd3;
    localparam OP_DIV  = 3'd4;

    reg key_pressed_prev = 0;
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            key_pressed_prev <= 0;
        end else begin
            key_pressed_prev <= key_pressed;
        end
    end
    
    wire key_rising_edge = key_pressed && !key_pressed_prev;

    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            operand1 <= 0;
            operand2 <= 0;
            operation <= OP_NONE;
            result <= 0;
            calculation_done <= 0;
            display_result <= 0;
            input_first_operand <= 1;
            digit_count <= 0;
            display_digit1 <= 0;
            display_digit0 <= 0;
            input_delay_counter <= 0;
            input_ready <= 1;
        end else begin
            // Input delay handling - INCREASED to 1 second
            if (!input_ready) begin
                input_delay_counter <= input_delay_counter + 1;
                if (input_delay_counter >= 26'd50_000_000) begin // 1 second delay
                    input_ready <= 1;
                    input_delay_counter <= 0;
                end
            end
            
            if (key_rising_edge && input_ready) begin
                LEDS[3:0] <= key_value;
                
                if (key_value == 4'hE) begin
                    operand1 <= 0;
                    operand2 <= 0;
                    operation <= OP_NONE;
                    result <= 0;
                    calculation_done <= 0;
                    display_result <= 0;
                    input_first_operand <= 1;
                    digit_count <= 0;
                    display_digit1 <= 0;
                    display_digit0 <= 0;
                    input_ready <= 1;
                end else if (!calculation_done) begin
                    // Start input delay for ALL key presses
                    input_ready <= 0;
                    
                    if (key_value <= 4'd9) begin
                        if (input_first_operand) begin
                            case (digit_count)
                                2'd0: begin
                                    operand1 <= key_value;
                                    display_digit1 <= 0;
                                    display_digit0 <= key_value;
                                    digit_count <= 1;
                                end
                                2'd1: begin
                                    operand1 <= (operand1 * 7'd10) + key_value;
                                    display_digit1 <= operand1[3:0];
                                    display_digit0 <= key_value;
                                    digit_count <= 2;
                                end
                                default: begin
                                    operand1 <= key_value;
                                    display_digit1 <= 0;
                                    display_digit0 <= key_value;
                                    digit_count <= 1;
                                end
                            endcase
                        end else begin
                            case (digit_count)
                                2'd0: begin
                                    operand2 <= key_value;
                                    display_digit1 <= 0;
                                    display_digit0 <= key_value;
                                    digit_count <= 1;
                                end
                                2'd1: begin
                                    operand2 <= (operand2 * 7'd10) + key_value;
                                    display_digit1 <= operand2[3:0];
                                    display_digit0 <= key_value;
                                    digit_count <= 2;
                                end
                                default: begin
                                    operand2 <= key_value;
                                    display_digit1 <= 0;
                                    display_digit0 <= key_value;
                                    digit_count <= 1;
                                end
                            endcase
                        end
                    end else if (key_value >= 4'hA && key_value <= 4'hD) begin
                        case (key_value)
                            4'hA: operation <= OP_ADD;
                            4'hB: operation <= OP_SUB;
                            4'hC: operation <= OP_MUL;
                            4'hD: operation <= OP_DIV;
                        endcase
                        display_result <= 0;
                        input_first_operand <= 0;
                        digit_count <= 0;
                    end else if (key_value == 4'hF) begin
                        calculation_done <= 1;
                        display_result = 1;
                        
                        case (operation)
                            OP_ADD: result <= operand1 + operand2;
                            OP_SUB: result <= (operand1 >= operand2) ? (operand1 - operand2) : 0;
                            OP_MUL: result <= operand1 * operand2;
                            OP_DIV: result <= (operand2 != 0) ? (operand1 / operand2) : 8'hEE;
                            default: result <= 0;
                        endcase
                    end
                end
            end
        end
    end

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
                4'hA: bcd2seg7 = 7'b0001000;
                4'hB: bcd2seg7 = 7'b0000011;
                4'hC: bcd2seg7 = 7'b1000110;
                4'hD: bcd2seg7 = 7'b0100001;
                4'hE: bcd2seg7 = 7'b0000110;
                4'hF: bcd2seg7 = 7'b0001110;
                default: bcd2seg7 = 7'b1111111;
            endcase
        end
    endfunction

    function [3:0] get_tens_digit;
        input [6:0] number;
        begin
            if (number >= 90) get_tens_digit = 4'd9;
            else if (number >= 80) get_tens_digit = 4'd8;
            else if (number >= 70) get_tens_digit = 4'd7;
            else if (number >= 60) get_tens_digit = 4'd6;
            else if (number >= 50) get_tens_digit = 4'd5;
            else if (number >= 40) get_tens_digit = 4'd4;
            else if (number >= 30) get_tens_digit = 4'd3;
            else if (number >= 20) get_tens_digit = 4'd2;
            else if (number >= 10) get_tens_digit = 4'd1;
            else get_tens_digit = 4'd0;
        end
    endfunction

    function [3:0] get_units_digit;
        input [6:0] number;
        begin
            get_units_digit = number - (get_tens_digit(number) * 10);
        end
    endfunction

    reg [3:0] op_display;
    
    always @(*) begin
        case (operation)
            OP_ADD: op_display = 4'hA;
            OP_SUB: op_display = 4'hB;
            OP_MUL: op_display = 4'hC;
            OP_DIV: op_display = 4'hD;
            default: op_display = 4'hF;
        endcase
        
        if (display_result) begin
            if (result == 8'hEE && operation == OP_DIV) begin
                HEX0 = {1'b1, bcd2seg7(4'hE)};
                HEX1 = {1'b1, bcd2seg7(4'hE)};
            end else begin
                HEX0 = {1'b1, bcd2seg7(get_units_digit(result[6:0]))};
                HEX1 = {1'b1, bcd2seg7(get_tens_digit(result[6:0]))};
            end
            HEX2 = {1'b1, bcd2seg7(op_display)};
        end else begin
            HEX0 = {1'b1, bcd2seg7(display_digit0)};
            
            if (digit_count == 2'd2) begin
                HEX1 = {1'b1, bcd2seg7(display_digit1)};
            end else begin
                HEX1 = 8'b11111111;
            end
            
            if (operation != OP_NONE) begin
                HEX2 = {1'b1, bcd2seg7(op_display)};
            end else begin
                HEX2 = 8'b11111111;
            end
        end
        
        LEDS[9] = calculation_done;
        LEDS[8] = (operation != OP_NONE);
        LEDS[7] = input_first_operand;
        LEDS[6:5] = digit_count;
        LEDS[4] = input_ready;
        
        DBG[3:0] = operand1[3:0];
        DBG[7:4] = {operation, calculation_done};
    end

endmodule