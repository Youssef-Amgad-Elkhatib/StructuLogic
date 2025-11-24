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

// 1-bit 2x1 Multiplexer using structural modeling
// Uses 2 AND gates, 1 OR gate, and 1 NOT gate
module mux2_1bit(
    input A, B,
    input Selector,
    output Z
);
    wire Z1, Z2;
    wire nSelector;

    // NOT for selector
    not (nSelector, Selector);

    // Apply gates bitwise
    and(Z1, nSelector, A);
    and(Z2, Selector, B);
    or(Z, Z2, Z1);
endmodule

// 8-bit 2x1 Multiplexer using structural modeling
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

module arithmetic_left_shift(
    input [7:0] B,
    output [7:0] result,
    output overflow
);
    wire signed [7:0] B_temp = B;
    wire signed [8:0] temp = B_temp <<< 1;

    assign result   = temp[7:0];
    assign overflow = temp[8] ^ temp[7];
endmodule


module arithmetic_right_shift(input signed [7:0]  B, output [7:0] Z);
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
    output [7:0] shift_result,
    output overflow
);
    wire [7:0] asl_out, asr_out;
    wire asl_overflow;

    // Generate both shifts
    arithmetic_left_shift  asl(B, asl_out, asl_overflow);
    arithmetic_right_shift asr(B, asr_out);

    // Select only one using mux2
    mux2 select_shift(
        .A(asl_out),
        .B(asr_out),
        .Selector(opcode),
        .Z(shift_result)
    );

    // Overflow occurs only for ASL
    assign overflow = (opcode == 0) ? asl_overflow : 1'b0;

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
.B(8'b00000001),
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

// Adder
Adder_8bit add(
.Result(add_result),
.CarryOut(CarryOut),
.C7(C7),
.A_in(A_in),
.B_in(B_in),
.CarryIn(opcode[0])
);

// Set on Equal
// or all bits, if result equals 1, then the result wasn't zero, therefore they weren't equal else they are 1
wire [7:0] eq_result;
assign eq_result = ~((|add_result)) ? 8'b00000001 : 8'b00000000;

// Choose final result between adder result and set on equal result based on opcode 2
mux2 final_result(
.A(add_result),
.B(eq_result),
.Selector(opcode[2]),
.Z(adder_result)
);

assign overflow =(~(opcode[2]))? (C7 ^ CarryOut): 1'b0;
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
wire overflow_arithmetic,overflow_shift,overflow_candidate;

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
.shift_result(shift_result),
.overflow(overflow_shift)
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
.overflow(overflow_arithmetic)
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

// Select between arithmetic operations overflow and left shift overflow
mux2_1bit overflowCandidate(
.A(overflow_arithmetic),
.B(overflow_shift),
.Selector(AluOp[2] & AluOp[1] & ~AluOp[3] & ~AluOp[0]),
.Z(overflow_candidate)
);

// Select between overflow and no overflow operations
mux2_1bit overflowFinal(
.A(overflow_candidate),
.B(1'b0),
.Selector(AluOp[3] | (AluOp[2] & AluOp[1] & AluOp[0])),
.Z(Overflow)
);

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

    ALU_8 alu (
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
            #5;
            total = total + 1;
            if (Result === exp && Zero === expZ && Negative === expN && Overflow === expO) begin
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL @ time=%0t | AluOp=%b | A=%d | B=%d | Got=%d | Exp=%d | Zero=%b (Exp %b) | Neg=%b (Exp %b) | Overflow=%b (Exp %b)",
                    $time, ALUOp, $signed(A), $signed(B), $signed(Result), $signed(exp), Zero, expZ, Negative, expN, Overflow, expO);
            end
        end
    endtask

    initial begin
        $display("----- Starting ALU Self-Checking Testbench -----");

        // ----------------------------------------------------------------------
        // ADD (0000)
        // ----------------------------------------------------------------------
        $display("\n--- Testing ADD (0000) ---");
        check(4'b0000, 8'd10, 8'd5, 8'd15, 0, 0, 0);
        check(4'b0000, 8'd0, 8'd0, 8'd0, 1, 0, 0);
        check(4'b0000, 8'd50, 8'd70, 120, 0, 0, 0);
        check(4'b0000, 8'd60, -50, 10, 0, 0, 0);
        check(4'b0000, -5, 8'd10, 5, 0, 0, 0);
        check(4'b0000, -10, 5, -5, 0, 1, 0);
        check(4'b0000, -1, -1, -2, 0, 1, 0);
        check(4'b0000, 63, 63, 126, 0, 0, 0);
        check(4'b0000, 127, -1, 126, 0, 0, 0);
        check(4'b0000, -128, -1, 127, 0, 0, 1);

        // ----------------------------------------------------------------------
        // SUB (0001)
        // ----------------------------------------------------------------------
        $display("\n--- Testing SUB (0001) ---");
        check(4'b0001, 8'd20, 8'd50, 30, 0, 0, 0);
        check(4'b0001, -128, 127, -1, 0, 1, 1);
        check(4'b0001, 8'd50, 8'd50, 0, 1, 0, 0);
        check(4'b0001, 8'd1, 0, -1, 0, 1, 0);
        check(4'b0001, -2, -1, 1, 0, 0, 0);
        check(4'b0001, 127, 1, -126, 0, 1, 0);
        check(4'b0001, 1, -128, -129, 0, 0, 1);
        check(4'b0001, -128, 1, 129, 0, 1, 1);
        check(4'b0001, 5, -5, -10, 0, 1, 0);
        check(4'b0001, 10, 100, 90, 0, 0, 0);

        // ----------------------------------------------------------------------
        // INC (0010)
        // ----------------------------------------------------------------------
        $display("\n--- Testing INC (0010) ---");
        check(4'b0010, 8'd10, 0, 11, 0, 0, 0);
        check(4'b0010, 0, 5, 1, 0, 0, 0);
        check(4'b0010, 127, 0, -128, 0, 1, 1);
        check(4'b0010, -1, 0, 0, 1, 0, 0);
        check(4'b0010, -128, 0, -127, 0, 1, 0);
        check(4'b0010, -2, 0, -1, 0, 1, 0);
        check(4'b0010, 1, 0, 2, 0, 0, 0);
        check(4'b0010, 126, 0, 127, 0, 0, 0);
        check(4'b0010, -64, 0, -63, 0, 1, 0);
        check(4'b0010, 120, 0, 121, 0, 0, 0);

        // ----------------------------------------------------------------------
        // Set-on-Equal (0101)
        // ----------------------------------------------------------------------
        $display("\n--- Testing Set-on-Equal (0101) ---");
        check(4'b0101, 8'd10, 8'd10, 1, 0, 0, 0);
        check(4'b0101, 8'd10, 8'd5, 0, 1, 0, 0);
        check(4'b0101, 127, 127, 1, 0, 0, 0);
        check(4'b0101, 126, -128, 0, 1, 0, 0);
        check(4'b0101, -1, -1, 1, 0, 0, 0);
        check(4'b0101, 127, -128, 0, 1, 0, 0);
        check(4'b0101, 0, 0, 1, 0, 0, 0);
        check(4'b0101, 100, 1, 0, 1, 0, 0);
        check(4'b0101, -56, -56, 1, 0, 0, 0);
        check(4'b0101, -56, -55, 0, 1, 0, 0);

        // ----------------------------------------------------------------------
        // Arithmetic left shift (0110)
        // ----------------------------------------------------------------------
        $display("\n--- Testing Arithmetic Left Shift (0110) ---");
        check(4'b0110, 0, 10, 20, 0, 0, 0);
        check(4'b0110, 0, 0, 0, 1, 0, 0);
        check(4'b0110, 0, 63, 126, 0, 0, 0);
        check(4'b0110, 0, -128, 0, 1, 0, 1);
        check(4'b0110, 0, 1, 2, 0, 0, 0);
        check(4'b0110, 0, -1, -2, 0, 1, 0);
        check(4'b0110, 0, 64, -128, 0, 1, 1);
        check(4'b0110, 0, -64, -128, 0, 1, 0);
        check(4'b0110, 0, -86, -172, 0, 0, 1);
        check(4'b0110, 0, 77, 154, 0, 1, 1);

        // ----------------------------------------------------------------------
        // Arithmetic right shift (0111)
        // ----------------------------------------------------------------------
        $display("\n--- Testing Arithmetic Right Shift (0111) ---");
        check(4'b0111, 0, 10, 5, 0, 0, 0);
        check(4'b0111, 0, 0, 0, 1, 0, 0);
        check(4'b0111, 0, 127, 63, 0, 0, 0);
        check(4'b0111, 0, -128, -64, 0, 1, 0);
        check(4'b0111, 0, -1, -1, 0, 1, 0);
        check(4'b0111, 0, -2, -1, 0, 1, 0);
        check(4'b0111, 0, 1, 0, 1, 0, 0);
        check(4'b0111, 0, 3, 1, 0, 0, 0);
        check(4'b0111, 0, -86, -43, 0, 1, 0);
        check(4'b0111, 0, -56, -28, 0, 1, 0);

        // ----------------------------------------------------------------------
        // NOT (1000)
        // ----------------------------------------------------------------------
        $display("\n--- Testing NOT (1000) ---");
        check(4'b1000, 8'd204, 0, -205, 0, 0, 0);
        check(4'b1000, 0, 0, -1, 0, 1, 0);
        check(4'b1000, -1, 0, 0, 1, 0, 0);
        check(4'b1000, 127, 0, -128, 0, 1, 0);
        check(4'b1000, -128, 0, 127, 0, 0, 0);
        check(4'b1000, 1, 0, -2, 0, 1, 0);
        check(4'b1000, -2, 0, 1, 0, 0, 0);
        check(4'b1000, 85, 0, -86, 0, 1, 0);
        check(4'b1000, -86, 0, 85, 0, 0, 0);
        check(4'b1000, -16, 0, 15, 0, 0, 0);

        // ----------------------------------------------------------------------
        // AND (1001)
        // ----------------------------------------------------------------------
        $display("\n--- Testing AND (1001) ---");
        check(4'b1001, 12, -10, 4, 0, 0, 0);
        check(4'b1001, -128, 127, 0, 1, 0, 0);
        check(4'b1001, -1, 0, 0, 1, 0, 0);
        check(4'b1001, -1, -1, -1, 0, 1, 0);
        check(4'b1001, 127, -128, 0, 1, 0, 0);
        check(4'b1001, -128, -128, -128, 0, 1, 0);
        check(4'b1001, 15, -16, 0, 1, 0, 0);
        check(4'b1001, 15, 1, 1, 0, 0, 0);
        check(4'b1001, -127, 127, 1, 0, 0, 0);
        check(4'b1001, -86, -86, -86, 0, 1, 0);

        // ----------------------------------------------------------------------
        // OR (1010)
        // ----------------------------------------------------------------------
        $display("\n--- Testing OR (1010) ---");
        check(4'b1010, 12, -10, -2, 0, 1, 0);
        check(4'b1010, -128, 127, -1, 0, 1, 0);
        check(4'b1010, -1, 0, -1, 0, 1, 0);
        check(4'b1010, -1, -1, -1, 0, 1, 0);
        check(4'b1010, 127, -128, -1, 0, 1, 0);
        check(4'b1010, -128, -128, -128, 0, 1, 0);
        check(4'b1010, 15, -16, -1, 0, 1, 0);
        check(4'b1010, 1, 1, 1, 0, 0, 0);
        check(4'b1010, 10, -6, -6, 0, 1, 0);
        check(4'b1010, -86, -86, -86, 0, 1, 0);

        // ----------------------------------------------------------------------
        // NAND (1011)
        // ----------------------------------------------------------------------
        $display("\n--- Testing NAND (1011) ---");
        check(4'b1011, 12, -10, -5, 0, 1, 0);
        check(4'b1011, -128, 127, -1, 0, 1, 0);
        check(4'b1011, -1, 0, -1, 0, 1, 0);
        check(4'b1011, -1, -1, 0, 1, 0, 0);
        check(4'b1011, 127, -128, -1, 0, 1, 0);
        check(4'b1011, -128, -128, 127, 0, 0, 0);
        check(4'b1011, 15, -16, -1, 0, 1, 0);
        check(4'b1011, 1, 1, -2, 0, 1, 0);
        check(4'b1011, -16, 1, -1, 0, 1, 0);
        check(4'b1011, -86, -86, 85, 0, 0, 0);

        // ----------------------------------------------------------------------
        // ROTATE LEFT (1100)
        // ----------------------------------------------------------------------
        $display("\n--- Testing ROTATE LEFT (1100) ---");
        check(4'b1100, 8'd10, 8'd3, 20, 0, 0, 0);
        check(4'b1100, 127, 2, -2, 0, 1, 0);
        check(4'b1100, 0, 0, 0, 1, 0, 0);
        check(4'b1100, 1, 0, 2, 0, 0, 0);
        check(4'b1100, -128, 0, 1, 0, 0, 0);
        check(4'b1100, -1, 0, -1, 0, 1, 0);
        check(4'b1100, -86, 0, 85, 0, 0, 0);
        check(4'b1100, 85, 0, -86, 0, 1, 0);
        check(4'b1100, -64, 0, -127, 0, 1, 0);
        check(4'b1100, 64, 0, -128, 0, 1, 0);

        // ----------------------------------------------------------------------
        // ROTATE RIGHT (1101)
        // ----------------------------------------------------------------------
        $display("\n--- Testing ROTATE RIGHT (1101) ---");
        check(4'b1101, 20, 0, 10, 0, 0, 0);
        check(4'b1101, 0, 0, 0, 1, 0, 0);
        check(4'b1101, 1, 5, -128, 0, 1, 0);
        check(4'b1101, 127, 4, -65, 0, 1, 0);
        check(4'b1101, -128, 0, 64, 0, 0, 0);
        check(4'b1101, -1, 0, -1, 0, 1, 0);
        check(4'b1101, -86, 0, 85, 0, 0, 0);
        check(4'b1101, 85, 0, -86, 0, 1, 0);
        check(4'b1101, 2, 0, 1, 0, 0, 0);
        check(4'b1101, -63, 0, -32, 0, 1, 0);

        $display("------------------------------------------------");
        $display("Tests Completed: %0d total | %0d passed | %0d failed", total, pass_count, fail_count);
        $display("------------------------------------------------");
        if (fail_count == 0)
            $display("All ALU tests passed successfully!");
        else
            $display("⚠Some tests failed! Please review details above.");
        $finish;
    end

endmodule
