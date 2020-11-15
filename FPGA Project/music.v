// Music demo verilog file
// (c) fpga4fun.com 2003-2015

// Plays a little tune on a speaker
// Uses a 25MHz clock if possible (other frequencies will
// change the pitch/speed of the song)

//EDITED BY JON CRISTOBAL -> Meant for 16MHz clock

/////////////////////////////////////////////////////
module music(
	input clk,
	output reg speaker
);

reg [30:0] tone;
always @(posedge clk) tone <= tone+31'd1;

wire [7:0] fullnote;
music_ROM get_fullnote(.clk(clk), .address(tone[29:22]), .note(fullnote));

wire [2:0] octave;
wire [3:0] note;
divide_by12 get_octave_and_note(.numerator(fullnote[5:0]), .quotient(octave), .remainder(note));

reg [8:0] clkdivider;
always @*
case(note)
	 0: clkdivider = 9'd511;//A
	 1: clkdivider = 9'd482;// A#/Bb
	 2: clkdivider = 9'd455;//B
	 3: clkdivider = 9'd430;//C
	 4: clkdivider = 9'd405;// C#/Db
	 5: clkdivider = 9'd383;//D
	 6: clkdivider = 9'd361;// D#/Eb
	 7: clkdivider = 9'd341;//E
	 8: clkdivider = 9'd322;//F
	 9: clkdivider = 9'd303;// F#/Gb
	10: clkdivider = 9'd286;//G
	11: clkdivider = 9'd270;// G#/Ab
	default: clkdivider = 9'd0;
endcase

reg [8:0] counter_note;
reg [7:0] counter_octave;
always @(posedge clk) counter_note <= counter_note==0 ? clkdivider : counter_note-9'd1;
always @(posedge clk) if(counter_note==0) counter_octave <= counter_octave==0 ? 8'd255 >> octave : counter_octave-8'd1;
always @(posedge clk) if(counter_note==0 && counter_octave==0 && fullnote!=0 && tone[21:18]!=0) speaker <= ~speaker;
endmodule


/////////////////////////////////////////////////////
module divide_by12(
	input [5:0] numerator,  // value to be divided by 12
	output reg [2:0] quotient,
	output [3:0] remainder
);

reg [1:0] remainder3to2;
always @(numerator[5:2])
case(numerator[5:2])
	 0: begin quotient=0; remainder3to2=0; end
	 1: begin quotient=0; remainder3to2=1; end
	 2: begin quotient=0; remainder3to2=2; end
	 3: begin quotient=1; remainder3to2=0; end
	 4: begin quotient=1; remainder3to2=1; end
	 5: begin quotient=1; remainder3to2=2; end
	 6: begin quotient=2; remainder3to2=0; end
	 7: begin quotient=2; remainder3to2=1; end
	 8: begin quotient=2; remainder3to2=2; end
	 9: begin quotient=3; remainder3to2=0; end
	10: begin quotient=3; remainder3to2=1; end
	11: begin quotient=3; remainder3to2=2; end
	12: begin quotient=4; remainder3to2=0; end
	13: begin quotient=4; remainder3to2=1; end
	14: begin quotient=4; remainder3to2=2; end
	15: begin quotient=5; remainder3to2=0; end
endcase

assign remainder[1:0] = numerator[1:0];  // the first 2 bits are copied through
assign remainder[3:2] = remainder3to2;  // and the last 2 bits come from the case statement
endmodule
/////////////////////////////////////////////////////


module music_ROM(
	input clk,
	input [7:0] address,
	output reg [7:0] note
);

always @(posedge clk)
case(address)
	  0: note<= 8'd25; //is D note
	  1: note<= 8'd25;
	  2: note<= 8'd25;
	  3: note<= 8'd25;
	  4: note<= 8'd25;
	  5: note<= 8'd25;
	  6: note<= 8'd25;
	  7: note<= 8'd25;
	  8: note<= 8'd23;
	  9: note<= 8'd23;
	 10: note<= 8'd23;
	 11: note<= 8'd23;
	 12: note<= 8'd23;
	 13: note<= 8'd23;
	 14: note<= 8'd23;
	 15: note<= 8'd23;
	 16: note<= 8'd21;
	 17: note<= 8'd21;
	 18: note<= 8'd21;
	 19: note<= 8'd21;
	 20: note<= 8'd21;
	 21: note<= 8'd21;
	 22: note<= 8'd21;
	 23: note<= 8'd21;
	 24: note<= 8'd22;
	 25: note<= 8'd22;
	 26: note<= 8'd22;
	 27: note<= 8'd22;
	 28: note<= 8'd22;
	 29: note<= 8'd22;
	 30: note<= 8'd22;
	 31: note<= 8'd22;
	 32: note<= 8'd00;
	 33: note<= 8'd00;
	 34: note<= 8'd22;
	 35: note<= 8'd25;
	 36: note<= 8'd25;
	 37: note<= 8'd25;
	 38: note<= 8'd25;
	 39: note<= 8'd25;
	 40: note<= 8'd25;
	 41: note<= 8'd27;
	 42: note<= 8'd27;
	 43: note<= 8'd27;
	 44: note<= 8'd26;
	 45: note<= 8'd27;
	 46: note<= 8'd27;
	 47: note<= 8'd27;
	 48: note<= 8'd27;
	 49: note<= 8'd27;
	 50: note<= 8'd27;
	 51: note<= 8'd22;
	 52: note<= 8'd22;
	 53: note<= 8'd00;
	 54: note<= 8'd00;
	 55: note<= 8'd25;
	 56: note<= 8'd25;
	 57: note<= 8'd25;
	 58: note<= 8'd21;
	 59: note<= 8'd20;
	 60: note<= 8'd25;
	 61: note<= 8'd26;
	 62: note<= 8'd26;
	 63: note<= 8'd25;
	 64: note<= 8'd22;
	 65: note<= 8'd23;
	 66: note<= 8'd24;
	 67: note<= 8'd24;
	 68: note<= 8'd24;
	 69: note<= 8'd24;
	 70: note<= 8'd22;
	 71: note<= 8'd22;
	 72: note<= 8'd22;
	 73: note<= 8'd00;
	 74: note<= 8'd00;
	 75: note<= 8'd25;
	 76: note<= 8'd25;
	 77: note<= 8'd25;
	 78: note<= 8'd25;
	 79: note<= 8'd25;
	 80: note<= 8'd25;
	 81: note<= 8'd25;
	 82: note<= 8'd27;
	 83: note<= 8'd29;
	 84: note<= 8'd27;
	 85: note<= 8'd27;
	 86: note<= 8'd29;
	 87: note<= 8'd27;
	 88: note<= 8'd27;
	 89: note<= 8'd27;
	 90: note<= 8'd27;
	 91: note<= 8'd27;
	 92: note<= 8'd27;
	 93: note<= 8'd27;
	 94: note<= 8'd25;
	 95: note<= 8'd25;
	 96: note<= 8'd25;
	 97: note<= 8'd25;
	 98: note<= 8'd25;
	 99: note<= 8'd26;
	100: note<= 8'd27;
	101: note<= 8'd23;
	102: note<= 8'd27;
	103: note<= 8'd26;
	104: note<= 8'd26;
	105: note<= 8'd26;
	106: note<= 8'd26;
	107: note<= 8'd25;
	108: note<= 8'd25;
	109: note<= 8'd26;
	110: note<= 8'd26;
	111: note<= 8'd25;
	112: note<= 8'd25;
	113: note<= 8'd25;
	114: note<= 8'd25;
	115: note<= 8'd25;
	116: note<= 8'd26;
	117: note<= 8'd25;
	118: note<= 8'd25;
	119: note<= 8'd25;
	120: note<= 8'd24;
	121: note<= 8'd24;
	122: note<= 8'd24;
	123: note<= 8'd29;
	124: note<= 8'd27;
	125: note<= 8'd26;
	126: note<= 8'd24;
	127: note<= 8'd26;
	128: note<= 8'd26;
	129: note<= 8'd25;
	130: note<= 8'd25;
	131: note<= 8'd25;
	132: note<= 8'd25;
	133: note<= 8'd25;
	134: note<= 8'd25;
	135: note<= 8'd25;
	136: note<= 8'd26;
	137: note<= 8'd25;
	138: note<= 8'd25;
	139: note<= 8'd24;
	140: note<= 8'd22;
	141: note<= 8'd23;
	142: note<= 8'd24;
	143: note<= 8'd26;
	144: note<= 8'd26;
	145: note<= 8'd26;
	146: note<= 8'd25;
	147: note<= 8'd23;
	148: note<= 8'd23;
	149: note<= 8'd23;
	150: note<= 8'd26;
	151: note<= 8'd26;
	152: note<= 8'd25;
	153: note<= 8'd25;
	154: note<= 8'd26;
	155: note<= 8'd26;
	156: note<= 8'd25;
	157: note<= 8'd25;
	158: note<= 8'd25;
	159: note<= 8'd25;
	160: note<= 8'd25;
	161: note<= 8'd25;
	162: note<= 8'd26;
	163: note<= 8'd26;
	164: note<= 8'd26;
	165: note<= 8'd26;
	166: note<= 8'd26;
	167: note<= 8'd26;
	168: note<= 8'd26;
	169: note<= 8'd26;
	170: note<= 8'd26;
	171: note<= 8'd24;
	172: note<= 8'd24;
	173: note<= 8'd24;
	174: note<= 8'd22;
	175: note<= 8'd22;
	176: note<= 8'd22;
	177: note<= 8'd22;
	178: note<= 8'd24;
	179: note<= 8'd24;
	180: note<= 8'd24;
	181: note<= 8'd24;
	182: note<= 8'd24;
	183: note<= 8'd00;
	184: note<= 8'd00;
	185: note<= 8'd22; // repeat from here
	186: note<= 8'd25;
	187: note<= 8'd24;
	188: note<= 8'd25;
	189: note<= 8'd26;
	190: note<= 8'd30;
	191: note<= 8'd30;
	192: note<= 8'd31;
	193: note<= 8'd30;
	194: note<= 8'd27;
	195: note<= 8'd29;
	196: note<= 8'd27; // end repeat
	197: note<= 8'd22;
	198: note<= 8'd25;
	199: note<= 8'd24;
	200: note<= 8'd25;
	201: note<= 8'd26;
	202: note<= 8'd30;
	203: note<= 8'd30;
	204: note<= 8'd31;
	205: note<= 8'd30;
	206: note<= 8'd27;
	207: note<= 8'd29;
	208: note<= 8'd27;
	209: note<= 8'd22;
	210: note<= 8'd25;
	211: note<= 8'd24;
	212: note<= 8'd26;
	213: note<= 8'd30;
	214: note<= 8'd30;
	215: note<= 8'd31;
	216: note<= 8'd30;
	217: note<= 8'd27;
	218: note<= 8'd29;
	219: note<= 8'd27;
	220: note<= 8'd27;
	221: note<= 8'd27;
	222: note<= 8'd27;
	223: note<= 8'd30;
	224: note<= 8'd30;
	225: note<= 8'd27;
	226: note<= 8'd26;
	227: note<= 8'd27;
	228: note<= 8'd26;
	229: note<= 8'd25;
	230: note<= 8'd25;
	231: note<= 8'd25;
	232: note<= 8'd24;
	233: note<= 8'd25;
	234: note<= 8'd00;
	235: note<= 8'd00;
	236: note<= 8'd00;
	237: note<= 8'd00;
	238: note<= 8'd00;
	239: note<= 8'd00;
	240: note<= 8'd00;
	241: note<= 8'd0;
	242: note<= 8'd00;
	default: note <= 8'd0;
endcase
endmodule

/////////////////////////////////////////////////////
