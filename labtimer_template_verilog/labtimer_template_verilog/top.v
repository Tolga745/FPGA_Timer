module top
(
    input clk,
    input [3:0] sw,
    input [3:0] btn,
    output [7:0] led,
    output reg [7:0] seven,
    output reg [3:0] segment
);

wire [3:0] m10, m1, s10, s1;
wire HZ1;
wire [3:0] debounced_btn;

debounce debounce_btn0 (
    .clk(clk),
    .bin(btn[0]),
    .bout(debounced_btn[0])
);

debounce debounce_btn1 (
    .clk(clk),
    .bin(btn[1]),
    .bout(debounced_btn[1])
);

debounce debounce_btn2 (
    .clk(clk),
    .bin(btn[2]),
    .bout(debounced_btn[2])
);

debounce debounce_btn3 (
    .clk(clk),
    .bin(btn[3]),
    .bout(debounced_btn[3])
);

labtimer tmr1(clk, sw[0], debounced_btn[3], debounced_btn[2], debounced_btn[1], debounced_btn[0], HZ1, m10, m1, s10, s1);

reg [6:0]  hex2seven[15:0];
reg [15:0] dispCounter = 0;
reg [1:0]  segCounter = 0;
reg [24:0] divCounter;

assign led = {sw, btn};
assign HZ1 = (divCounter==25'd26999999);

initial begin
	hex2seven[0]  = 7'b0111111;
	hex2seven[1]  = 7'b0000110;
	hex2seven[2]  = 7'b1011011;
	hex2seven[3]  = 7'b1001111;
	hex2seven[4]  = 7'b1100110;
	hex2seven[5]  = 7'b1101101;
	hex2seven[6]  = 7'b1111101;
	hex2seven[7]  = 7'b0000111;
	hex2seven[8]  = 7'b1111111;
	hex2seven[9]  = 7'b1101111;
	hex2seven[10] = 7'b1110111;
	hex2seven[11] = 7'b1111100;
	hex2seven[12] = 7'b0111001;
	hex2seven[13] = 7'b1011110;
	hex2seven[14] = 7'b1111001;
	hex2seven[15] = 7'b1110001;
	segment = 4'b0001;
end

always @(posedge clk) begin
	dispCounter <= dispCounter + 1;
	if (dispCounter == 0) begin
		segCounter <= segCounter + 1;
	end
end

always @(m10 or m1 or s10 or s1 or segCounter) begin
	case (segCounter)
	2'b00 : begin seven <= {1'b0, hex2seven[s1]};  segment <= 4'b0001; end
	2'b01 : begin seven <= {1'b0, hex2seven[s10]}; segment <= 4'b0010; end
	2'b10 : begin seven <= {1'b1, hex2seven[m1]};  segment <= 4'b0100; end
	2'b11 : begin seven <= {1'b0, hex2seven[m10]}; segment <= 4'b1000; end
	endcase
end

always@(posedge clk) begin
	if(sw[0] | (divCounter==25'd26999999)) divCounter <= 0;
	else divCounter <= divCounter+1;
end

endmodule
