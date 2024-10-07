module clock (clk);
output clk;
reg clk;
initial 
clk = 0; 
always
#100 clk = ~clk ;
endmodule


module MPISALU(ALUctl,A,B,ALUOut);
input [5:0] ALUctl;
input wire [31:0] A,B;
output reg [31:0] ALUOut;
always@(ALUctl or A or B) begin
case (ALUctl)
32'b00: ALUOut = A & B;
32'b01: ALUOut = A | B;
32'b10: ALUOut = A + B;
32'b11: ALUOut = A - B;
default : ALUOut = 0;
endcase
end
endmodule


module registerfile(Read1,Read2,WriteReg ,WriteData,Data1,Data2,Clock);
input [4:0] Read1,Read2,WriteReg; 
input [31:0] WriteData;
input  Clock;
output[31:0] Data1, Data2;
reg[ 31:0] RF [31:0];
assign Data1 = RF[Read1];
assign Data2 = RF[Read2];
always @(posedge Clock)
RF[WriteReg] = WriteData;
endmodule



module testalu;

reg [31:0] a ,b;
reg [4:0]c ;
wire [31:0]out;
 initial 
begin
a = 31'b0101 ;
b = 31'b0101;
#5 c = 5'b00;
#5 c = 5'b01;
#5 c = 5'b10;
#5 c = 5'b11;
end 
MPISALU al (c ,a,b,out);
endmodule


/////////////////////////////////////////////

module CPU (cl,A,B,ALUOut); 

input cl; 

input wire [31:0] A, B; 
wire [5:0] ALUctl;
output reg [31:0] ALUOut;



reg[31:0] PC, Regs[0:31], IMemory[0:1023],DMemory[0:1023], IR; 
wire [4:0] rs, rt;
wire [4:0] rd;
wire [5:0] op;

assign rs = IR[25:21]; 
assign rt = IR[20:16]; 
assign op = IR[31:26];
assign rd = IR[15:11];
assign ALUctl = IR[5:0];






initial 
begin 
PC = 0; 
IMemory[0] = 32'b00000001000010011000100000100000; //add $s1, $t0, $t1
IMemory[1] = 32'b00000001000010011001000000100010; //sub $s2, $t0, $t1 
IMemory[2] = 32'b00000001000010011000000000100100; //and $s0, $t0, $t1 
IMemory[3] = 32'b00000001000010011000000000100101; //or $s0, $t0, $t1
IMemory[4] = 32'b00000001000010011000100000100000; //add $s1, $t0, $t1
IMemory[5] = 32'b00000001000010011001000000100010; //sub $s2, $t0, $t1 
IMemory[6] = 32'b00000001000010011000000000100100; //and $s0, $t0, $t1 
IMemory[7] = 32'b00000001000010011000000000100101; //or $s0, $t0, $t1
IMemory[8] = 32'b00000001000010011000100000100000; //add $s1, $t0, $t1
IMemory[9] = 32'b00000001000010011001000000100010; //sub $s2, $t0, $t1 
IMemory[10] = 32'b00000001000010011000000000100100; //and $s0, $t0, $t1 
IMemory[11] = 32'b00000001000010011000000000100101; //or $s0, $t0, $t1
end 

always @(posedge cl) 
begin 
IR = IMemory[PC>>2]; 
PC = PC + 4;
if (op == 6'b000000)
Regs[rs] <= A;
Regs[rt] <= B;
Regs[rd] <= ALUOut;
case (IR[5:0])
36: ALUOut <= A & B;
37: ALUOut <= A | B;
32: ALUOut <= A + B;
34: ALUOut <= A - B; 
endcase
end
endmodule


module cputest;
wire cc ;
reg [31:0] a , b;
wire [31:0] o;
initial
begin
a =10;
b =10;

end
clock cr (cc);
CPU cppu (cc ,a,b,o);

endmodule
