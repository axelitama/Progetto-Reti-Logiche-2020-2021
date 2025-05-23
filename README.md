# Histogram Equalization Hardware Component

This repository contains the VHDL implementation of a hardware component for image histogram equalization, developed for the course of **Reti Logiche** (Digital Logic Design) a.y. 2020–2021 at **Politecnico di Milano** .


## Component Interface

```vhdl
entity project_reti_logiche is
  port (
    i_clk     : in  std_logic;
    i_rst     : in  std_logic;
    i_start   : in  std_logic;
    i_data    : in  std_logic_vector(7 downto 0);
    o_address : out std_logic_vector(15 downto 0);
    o_done    : out std_logic;
    o_en      : out std_logic;
    o_we      : out std_logic;
    o_data    : out std_logic_vector(7 downto 0)
  );
end project_reti_logiche;
```

**Signal Description**

| Signal      | Direction | Description                          |
| ----------- | --------- | ------------------------------------ |
| `i_clk`     | In        | Clock signal                         |
| `i_rst`     | In        | Asynchronous reset                   |
| `i_start`   | In        | Start processing                     |
| `i_data`    | In        | Data read from RAM                   |
| `o_address` | Out       | Address for memory access            |
| `o_done`    | Out       | Set to 1 when processing is complete |
| `o_en`      | Out       | Memory enable signal                 |
| `o_we`      | Out       | Write enable (1 = write, 0 = read)   |
| `o_data`    | Out       | Data to be written to memory         |

**Memory Map**

  Address | Content
----------|-----------------------------
0         | Number of columns
1         | Number of rows
2 .. N    | Original image pixels
N+1 .. M  | Equalized image pixels

**Constraints**

- **Max image size:** 128 × 128 pixels
- **Pixel format:** 8-bit grayscale
- **Memory interface:** 16-bit address bus


## Histogram Equalization Algorithm

Given the image's minimum (`MIN_PIXEL_VALUE`) and maximum (`MAX_PIXEL_VALUE`) grayscale values, the component transforms each pixel using the following algorithm:

```mathematics
  DELTA_VALUE = MAX_PIXEL_VALUE – MIN_PIXEL_VALUE
  SHIFT_LEVEL = (8 – FLOOR(LOG2(DELTA_VALUE + 1)))
  TEMP_PIXEL = (CURRENT_PIXEL_VALUE - MIN_PIXEL_VALUE) << SHIFT_LEVEL
  NEW_PIXEL_VALUE = MIN(255, TEMP_PIXEL)
```

## Architecture
The VHDL component is divided into two main modules:
- **Data Path**: combines combinational and sequential logic, including computation units and registers for image processing and histogram equalisation.
- **Control Unit**: a Moore finite state machine that coordinates the data path operations.

The architecture uses modular components (adders, subtractors, muxes, registers) to facilitate structural description and synthesis efficiency.


## Testing
Pre-synthesis and post-synthesis simulations were performed to validate functionality and performance.
Functional testing confirmed the correctness of equalization on multiple input images, including boundary and corner cases.

Post-syntesis simulation details:
- Tool: Vivado
- FPGA target: Xilinx Artix-7 xc7a200tfbg484-1
- Max data path delay: 4.531 ns
- Slack: 95.318 ns
- Design clock period: 100 ns


## More Information

For more information consider the report file [relazione.pdf](relazione.pdf) in Italian.

Schemes and diagrams of the Data Path and the FSM Control Unit can be found in [deliverables](deliverables).
