# 🧮 Assignment 1 — RTL Design Fundamentals

![Verilog](https://img.shields.io/badge/Verilog-HDL-1f6feb?style=flat-square)
![SystemVerilog](https://img.shields.io/badge/Testbench-SystemVerilog-2ea44f?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-QuestaSim-red?style=flat-square)

Four small, self-contained RTL designs, each paired with a **directed, self-checking
testbench**. This assignment focuses on the fundamentals: registered datapaths,
opcode-driven ALUs, pipelining, and writing testbenches that check their own results
instead of relying on manual waveform inspection.

## 📦 Modules

| Folder | Module | Description |
|---|---|---|
| 🔢 [`ALU`](./ALU) | `alu_4bit` | Registered 4-bit ALU — add, subtract, bitwise NOT, reduction-OR |
| 🚀 [`DSP_`](./DSP_) | `dsp` | 3-stage pipelined multiply-accumulate (MAC) slice, `p = (d ± b) × a ± c` |
| ➕ [`adder`](./adder) | `adder` | Registered 4-bit signed adder (5-bit result, overflow-safe) |
| 🥇 [`periority_encoder`](./periority_encoder) | `priority_enc` | Registered 4-to-2 priority encoder with `valid` flag |

## ✅ Verification Approach

- Directed corner-case stimulus (zero, max-positive, max-negative operands)
- Self-checking: each testbench compares the DUT output against a reference value
  and reports an `ERROR_COUNT` at the end
- Async/sync reset checks
- Code coverage collected via `+cover -covercells` (see each folder's `report.txt`)

## ▶️ Running a Test

```bash
cd ALU        # or DSP_ / adder / periority_encoder
vsim -do run.do
```

Each `run.do` compiles the DUT + testbench, runs to completion, and saves a
coverage database (`.ucdb`).
