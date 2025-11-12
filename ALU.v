// AND gate using structural modeling
module and_gate(input [7:0] A, input [7:0] B, output [7:0] Z);
    and and0(Z[0], A[0], B[0]);
    and and1(Z[1], A[1], B[1]);
    and and2(Z[2], A[2], B[2]);
    and and3(Z[3], A[3], B[3]);
    and and4(Z[4], A[4], B[4]);
    and and5(Z[5], A[5], B[5]);
    and and6(Z[6], A[6], B[6]);
    and and7(Z[7], A[7], B[7]);
endmodule

// OR gate using structural modeling
module or_gate(input [7:0] A, input [7:0] B, output [7:0] Z);
    or o0(Z[0], A[0], B[0]);
    or o1(Z[1], A[1], B[1]);
    or o2(Z[2], A[2], B[2]);
    or o3(Z[3], A[3], B[3]);
    or o4(Z[4], A[4], B[4]);
    or o5(Z[5], A[5], B[5]);
    or o6(Z[6], A[6], B[6]);
    or o7(Z[7], A[7], B[7]);
endmodule

// NOT gate using structural modeling
module not_gate(input [7:0] A, output [7:0] Z);
    not not0(Z[0], A[0]);
    not not1(Z[1], A[1]);
    not not2(Z[2], A[2]);
    not not3(Z[3], A[3]);
    not not4(Z[4], A[4]);
    not not5(Z[5], A[5]);
    not not6(Z[6], A[6]);
    not not7(Z[7], A[7]);
endmodule


// NAND gate using structural modeling
module nand_gate(input [7:0] A, B,  output [7:0] Z);
    nand nand0(Z[0], A[0], B[0]);
    nand nand1(Z[1], A[1], B[1]);
    nand nand2(Z[2], A[2], B[2]);
    nand nand3(Z[3], A[3], B[3]);
    nand nand4(Z[4], A[4], B[4]);
    nand nand5(Z[5], A[5], B[5]);
    nand nand6(Z[6], A[6], B[6]);
    nand nand7(Z[7], A[7], B[7]);
endmodule

// 2x1 Multiplexer using structural modeling
// Uses 2 AND gates, 1 OR gate, and 1 NOT gate
module mux2(
    input [7:0] A, B,
    input Selector,
    output [7:0] Z
);
    wire [7:0] Z1, Z2;
    wire nSelector;

    // NOT for selector
    not (nSelector, Selector);

    // Apply gates bitwise
    and_gate a1 (A, {8{nSelector}}, Z1);
    and_gate a2 (B, {8{Selector}}, Z2);
    or_gate  o1 (Z1, Z2, Z);
endmodule

// 1- bit Full Adder
module Full_Adder (
    output Sum, CarryOut,
    input A, B, CarryIn
);
    wire s1, c1, c2;

    xor G1 (s1, A, B);
    xor G2 (Sum, s1, CarryIn);

    and G3 (c1, A, B);
    and G4 (c2, CarryIn, s1);
    or  G5 (CarryOut, c1, c2);

endmodule

// 8-bit adder
module Adder_8bit (
    output [7:0] Result,
    output CarryOut,
    output C7,
    input [7:0] A_in, B_in,
    input CarryIn
);

    wire [7:0] C;

    assign C[0] = CarryIn;


    Full_Adder FA0 (Result[0], C[1], A_in[0], B_in[0], C[0]); // C[0] = CarryIn
    Full_Adder FA1 (Result[1], C[2], A_in[1], B_in[1], C[1]);
    Full_Adder FA2 (Result[2], C[3], A_in[2], B_in[2], C[2]);
    Full_Adder FA3 (Result[3], C[4], A_in[3], B_in[3], C[3]);
    Full_Adder FA4 (Result[4], C[5], A_in[4], B_in[4], C[4]);
    Full_Adder FA5 (Result[5], C[6], A_in[5], B_in[5], C[5]);
    Full_Adder FA6 (Result[6], C[7], A_in[6], B_in[6], C[6]);
    Full_Adder FA7 (Result[7], CarryOut, A_in[7], B_in[7], C[7]); // C[8] is CarryOut

    assign C7 = C[7];

endmodule

module arithmetic_left_shift(input [7:0] B, output [7:0] Z);
assign Z = (B<<<1);
endmodule

module arithmetic_right_shift(input [7:0] B, output [7:0] Z);
assign Z = (B>>>1);
endmodule

module left_rotate(input [7:0] A, output [7:0] Z);
assign Z = {A[6:0], A[7]};
endmodule

module right_rotate(input [7:0] A, output [7:0] Z);
assign Z={A[0],A[7:1]};
endmodule

module logic_unit(
    input [7:0] A, B,
    input [1:0] opcode,
    output [7:0] logic_result
);
    // Generate results of gates in the wires
    wire [7:0] and_out, or_out, nand_out, not_out;
    and_gate a1(A,B,and_out);
    or_gate  o1(A,B,or_out);
    nand_gate n1(A,B,nand_out);
    not_gate  n2(A,not_out);

    // Select between not and and gates using opcode 0
    wire [7:0] not_and_result;
    mux2 na(
    .A(not_out),
    .B(and_out),
    .Selector(opcode[0]),
    .Z(not_and_result)
    );

    // Select between or and nand gates using opcode 0
    wire [7:0] or_nand_result;
    mux2 on(
    .A(or_out),
    .B(nand_out),
    .Selector(opcode[0]),
    .Z(or_nand_result)
    );

    // Select between two results using opcode 1
    mux2 final(
    .A(not_and_result),
    .B(or_nand_result),
    .Selector(opcode[1]),
    .Z(logic_result)
    );
endmodule

module shift_unit(
    input [7:0] B,
    input opcode,
    output [7:0] shift_result
);
    // Wires to capture outputs
    wire [7:0] asl_out, asr_out;

    // Generate both shifts
    arithmetic_left_shift  asl(B, asl_out);
    arithmetic_right_shift asr(B, asr_out);

    // Select only one using mux2
    mux2 select_shift(
        .A(asl_out),
        .B(asr_out),
        .Selector(opcode),
        .Z(shift_result)
    );
endmodule

module rotate_unit(
    input [7:0] A,
    input opcode,
    output [7:0] rotate_result
);
    // Wires to capture output
    wire [7:0] rotl_out, rotr_out;

    // Generate both rotations
    left_rotate  rotl(A, rotl_out);
    right_rotate rotr(A, rotr_out);

    // Select only one using mux
    mux2 select_rot(
        .A(rotl_out),
        .B(rotr_out),
        .Selector(opcode),
        .Z(rotate_result)
    );

endmodule

module arithmetic_unit(
input [7:0] A,B,
input [2:0] opcode,
output [7:0] adder_result,
output overflow
);

// Generate needed wires
wire [7:0] B_in;
wire [7:0] A_in, A_Final_in;
wire [7:0] add_result;
wire C7,CarryOut;

// Select B based on opcode
mux2 B_res(
.A(B),
.B(8'b00000000),
.Selector(opcode[1]),
.Z(B_in)
);

// Select A based on opcode
mux2 A_res(
.A(A),
.B(~A),
.Selector(opcode[0]),
.Z(A_in)
);

mux2 A_Final(
.A(A_in),
.B(A),
.Selector(opcode[2]),
.Z(A_Final_in)
);

// Adder
Adder_8bit add(
.Result(add_result),
.CarryOut(CarryOut),
.C7(C7),
.A_in(A_Final_in),
.B_in(B_in),
.CarryIn(opcode[1]|opcode[0])
);

// Set on Equal
// or all bits, if result equals 1, then the result wasn't zero, therefore they weren't equal else they are 1
wire [7:0] eq_result;
assign eq_result = (~(|add_result)) ? 8'b00000001 : 8'b00000000;

// Choose final result between adder result and set on equal result based on opcode 2
mux2 final_result(
.A(add_result),
.B(eq_result),
.Selector(opcode[2]),
.Z(adder_result)
);

assign overflow = C7 ^ CarryOut;
endmodule

module ALU_8 (output [7:0] Result, output Zero, Negative, Overflow,
input [7:0] A, B, input [3:0] AluOp);

// Wires for results of 4 subsets
wire [7:0] arithmetic_result;
wire [7:0] logic_result;
wire [7:0] shift_result;
wire [7:0] rotate_result;
wire [7:0] arithmetic_shift_result;
wire [7:0] logical_rotate_result;
wire overflow;

// Generate results of the subsets in the wires
logic_unit lu(
.A(A),
.B(B),
.opcode(AluOp[1:0]),
.logic_result(logic_result)
);

shift_unit su(
.B(B),
.opcode(AluOp[0]),
.shift_result(shift_result)
);

rotate_unit ru(
.A(A),
.opcode(AluOp[0]),
.rotate_result(rotate_result)
);

arithmetic_unit au(
.A(A),
.B(B),
.opcode(AluOp[2:0]),
.adder_result(arithmetic_result),
.overflow(overflow)
);

// Result Output
mux2 as_res(
.A(arithmetic_result),
.B(shift_result),
.Selector(AluOp[2] & AluOp[1]),
.Z(arithmetic_shift_result)
);

mux2 lr_res(
.A(logic_result),
.B(rotate_result),
.Selector(AluOp[2]),
.Z(logical_rotate_result)
);

mux2 final_result(
.A(arithmetic_shift_result),
.B(logical_rotate_result),
.Selector(AluOp[3]),
.Z(Result)
);

assign Zero = ~(|Result);

assign Negative = Result[7];

assign Overflow=overflow;

endmodule



`timescale 1ns/1ps

module tb_ALU_8bit_selfcheck();
    reg [7:0] A, B;
    reg [3:0] ALUOp;
    wire [7:0] Result;
    wire Zero, Negative, Overflow;

    integer pass_count = 0;
    integer fail_count = 0;
    integer total = 0;
    reg [7:0] expected;
    reg exp_zero, exp_neg, exp_overflow;

    // Instantiate the ALU
    ALU_8 inst (
        .Result(Result),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .A(A),
        .B(B),
        .AluOp(ALUOp)
    );

    task check;
        input [3:0] op;
        input [7:0] a, b, exp;
        input expZ, expN, expO;
        begin
            ALUOp = op; A = a; B = b;
            #5; // wait for output to settle
            total = total + 1;
            if (Result === exp && Zero === expZ && Negative === expN && Overflow === expO) begin
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
                $display("❌ FAIL @ time=%0t | AluOp=%b | A=%d | B=%d | Got=%d | Exp=%d | Zero=%b (Exp %b) | Neg=%b (Exp %b) | Overflow=%b (Exp %b)",
                    $time, ALUOp, A, B, Result, exp, Zero, expZ, Negative, expN, Overflow, expO);
            end
        end
    endtask

    initial begin
        $display("----- Starting ALU Self-Checking Testbench -----");

        // ADD (0000)
        check(4'b0000, 10, 5, 15, 0, 0, 0);
        check(4'b0000, 0, 0, 0, 1, 0, 0);
        check(4'b0000, 127, 127, 254, 0, 1, 1); // Overflow

        // SUB (0001) -> B - A
        check(4'b0001, 20, 50, 30, 0, 0, 0); // 50-20=30
        check(4'b0001, 10, 100, 90, 0, 0, 0); // 100-10=90
        check(4'b0001, 50, 50, 0, 1, 0, 0);   // 50-50=0

        // INC (0010)
        check(4'b0010, 10, 0, 11, 0, 0, 0);
        check(4'b0010, 255, 0, 0, 1, 0, 1); // 255+1=0 with overflow

        // Set-on-equal (0101)
        check(4'b0101, 10, 10, 1, 0, 0, 0); // A==B -> 1
        check(4'b0101, 10, 5, 0, 1, 0, 0);  // A!=B -> 0

        // Arithmetic left shift (0110)
        check(4'b0110, 0, 170, 84, 0, 0, 0); // 0b10101010 << 1 = 0b01010100 (84)

        // Arithmetic right shift (0111)
        check(4'b0111, 0, 170, 85, 0, 0, 0); // 0b10101010 >>> 1 = 0b11010101 (213, sign preserved)

        // NOT (1000)
        check(4'b1000, 204, 0, 51, 0, 0, 0); // ~204=51

        // AND (1001)
        check(4'b1001, 204, 170, 136, 0, 1, 0); // 0b11001100 & 0b10101010 = 0b10001000=136

        // OR (1010)
        check(4'b1010, 204, 170, 238, 0, 1, 0); // 0b11001100 | 0b10101010 = 0b11101110=238

        // NAND (1011)
        check(4'b1011, 204, 170, 119, 0, 0, 0); // ~(A&B)=~0b10001000=0b01110111=119

        $display("------------------------------------------------");
        $display("✅ Tests Completed: %0d total | %0d passed | %0d failed", total, pass_count, fail_count);
        $display("------------------------------------------------");
        if (fail_count == 0)
            $display("🎉 All ALU tests passed successfully!");
        else
            $display("⚠️ Some tests failed! Please review details above.");
        $finish;
    end
endmodule
