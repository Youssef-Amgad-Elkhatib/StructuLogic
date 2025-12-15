# ⚡ StructuLogic: 8-Bit Structural ALU (Verilog)

**StructuLogic** is a digital logic project that implements a fully functional **8-bit Arithmetic Logic Unit (ALU)** using **pure Structural Modeling in Verilog**.  
The design follows a **bottom-up hardware architecture approach**, building complex computation units strictly from primitive logic gates—**without using behavioral operators** such as `+`, `-`, or `==`.

This project is ideal for understanding **low-level hardware design**, gate-level composition, and hierarchical digital systems.

---

## 🌟 Overview

The StructuLogic ALU operates on **8-bit signed integers** and supports a wide range of arithmetic, logical, shift, and rotation operations.

### Key Features
- ✅ **12 Distinct Operations** (Arithmetic, Logic, Shifts, Rotations) 🧮  
- 🚩 **Status Flag Generation** (Zero, Negative, Overflow)  
- 🏗️ **Strict Hierarchical Design**  
  - Gates → Adders / Muxes → Functional Units → Top-Level ALU  
- 🤖 **Self-Checking Testbench**  
  - Automatically verifies correctness against a golden behavioral reference  

---

## 📂 Architecture

The design follows a **clean hierarchical structure**, starting from primitive gates and scaling up to a full ALU.

### 1️⃣ Primitive Gates
Custom gate-level modules:
- `and_gate`
- `or_gate`
- `not_gate`
- `nand_gate`

---

### 2️⃣ Basic Components
- 1-bit and 8-bit **2×1 Multiplexers**
- **Full Adders** (structurally built)

---

### 3️⃣ Functional Sub-Units

#### 🧮 Arithmetic Unit
Handles:
- **ADD** – Addition  
- **SUB** – Subtraction (2’s complement)  
- **INC** – Increment  
- **SEQ** – Set-on-Equal  

#### 🧠 Logic Unit
Handles:
- **AND** – Bitwise AND  
- **OR** – Bitwise OR  
- **NAND** – Bitwise NAND  
- **NOT** – Bitwise NOT  

#### 🔄 Shift & Rotate Units
Handles:
- **ASL** – Arithmetic Shift Left  
- **ASR** – Arithmetic Shift Right  
- **ROL** – Rotate Left  
- **ROR** – Rotate Right  

---

### 4️⃣ Top-Level Integration
- `ALU_8` integrates all sub-units
- Operation selection via **4-bit OpCode**
- Status flags generated in real-time

---

## ⚙️ Supported Operations (OpCode Controlled)

### 🧮 Arithmetic Operations
| Operation | Description |
|---------|------------|
| ADD | `Result = A + B` |
| SUB | `Result = A - B` |
| INC | `Result = A + 1` |
| SEQ | `Result = 1` if `A == B`, else `0` |

---

### 🧠 Logic Operations
| Operation | Description |
|---------|------------|
| AND | `A & B` |
| OR | `A \| B` |
| NAND | `~(A & B)` |
| NOT | `~A` |

---

### 🔄 Shift & Rotate Operations
| Operation | Description |
|---------|------------|
| ASL | Arithmetic Shift Left (`B << 1`) ⚠️ Overflow detected |
| ASR | Arithmetic Shift Right (`B >> 1`) |
| ROL | Rotate Left (MSB → LSB) |
| ROR | Rotate Right (LSB → MSB) |

---

## 🧩 Status Flags

The ALU generates three status flags:

| Flag | Meaning |
|----|--------|
| **Z (Zero)** | High if result = `00000000` |
| **N (Negative)** | High if MSB (sign bit) = 1 |
| **V (Overflow)** | High if signed overflow occurs (`[-128, 127]`) |

---

## 🧪 Verification Workflow

### 🤖 Self-Checking Testbench
Module: `tb_ALU_8bit_selfcheck`

#### Features
- 🔍 **Corner Case Testing**
  - Includes `-128`, `127`, `0`, and edge transitions
- ⚖️ **Golden Reference Model**
  - Behavioral computation used for validation
- 📊 **Automated Reporting**
  - Pass / Fail counters
  - Detailed error logs with timestamps
  - Final summary report

#### 📈 Evaluation Metrics
- **Coverage:** 100% of defined OpCodes tested  
- **Accuracy:** Fully verified against behavioral reference logic  
