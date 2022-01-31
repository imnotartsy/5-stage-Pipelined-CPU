library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PipelinedCPU0 is
port(
     clk :in STD_LOGIC;
     rst :in STD_LOGIC;
     --Probe ports used for testing
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end PipelinedCPU0;




architecture rtl of PipelinedCPU0 is
     component PC
          port(
               clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
               write_enable : in  STD_LOGIC; -- Only write if '1'
               rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
               AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
               AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
          );
     end component;

     component IMEM
          port(
               Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
               ReadData : out STD_LOGIC_VECTOR(31 downto 0)
          );
     end component;

     component registers
          port(
               RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
               RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
               WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
               WD       : in  STD_LOGIC_VECTOR (63 downto 0);
               RegWrite : in  STD_LOGIC;
               Clock    : in  STD_LOGIC;
               RD1      : out STD_LOGIC_VECTOR (63 downto 0);
               RD2      : out STD_LOGIC_VECTOR (63 downto 0);
               DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
               DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
          );
     end component;

     component dmem
          port(
               WriteData          : in  STD_LOGIC_VECTOR(63 downto 0);
               Address            : in  STD_LOGIC_VECTOR(63 downto 0);
               MemRead            : in  STD_LOGIC;
               MemWrite           : in  STD_LOGIC;
               Clock              : in  STD_LOGIC;
               ReadData           : out STD_LOGIC_VECTOR(63 downto 0);
               DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
          );
     end component;

     component alucontrol
          port(
               ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
               Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
               Operation : out STD_LOGIC_VECTOR(3 downto 0)
         );
     end component;

     component ALU
          port(
               in0       : in     STD_LOGIC_VECTOR(63 downto 0);
               in1       : in     STD_LOGIC_VECTOR(63 downto 0);
               operation : in     STD_LOGIC_VECTOR(3 downto 0);
               result    : buffer STD_LOGIC_VECTOR(63 downto 0);
               zero      : buffer STD_LOGIC;
               overflow  : buffer STD_LOGIC
          );
     end component;
          
     component MUX5
          port(
              in0    : in STD_LOGIC_VECTOR(4 downto 0);
              in1    : in STD_LOGIC_VECTOR(4 downto 0); 
              sel    : in STD_LOGIC;
              output : out STD_LOGIC_VECTOR(4 downto 0)
          );
     end component;

     component MUX64
          port(
              in0    : in STD_LOGIC_VECTOR(63 downto 0);
              in1    : in STD_LOGIC_VECTOR(63 downto 0); 
              sel    : in STD_LOGIC;
              output : out STD_LOGIC_VECTOR(63 downto 0)
          );
     end component;

     component CPUControl
          port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
               RegDst   : out STD_LOGIC;
               CBranch  : out STD_LOGIC;  --conditional
               MemRead  : out STD_LOGIC;
               MemtoReg : out STD_LOGIC;
               MemWrite : out STD_LOGIC;
               ALUSrc   : out STD_LOGIC;
               RegWrite : out STD_LOGIC;
               UBranch  : out STD_LOGIC; -- This is unconditional
               ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
          );   
     end component; 

     component SignExtend
          port(
               x : in  STD_LOGIC_VECTOR(31 downto 0);
               opcode : in STD_LOGIC_VECTOR(10 downto 0);
               y : out STD_LOGIC_VECTOR(63 downto 0)
          );
     end component;

     component ShiftLeft2
          port(
               x : in  STD_LOGIC_VECTOR(63 downto 0);
               y : out STD_LOGIC_VECTOR(63 downto 0)
          );
     end component;

     component ADD
          port(
               in0    : in  STD_LOGIC_VECTOR(63 downto 0);
               in1    : in  STD_LOGIC_VECTOR(63 downto 0);
               output : out STD_LOGIC_VECTOR(63 downto 0)
     );
     end component;

     -- pc
     signal s_PC : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     signal s_write_enable : std_logic := '1';
     signal s_addressIn : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     signal s_addressInc : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     signal s_addressImm : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     signal s_addressBranch : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     signal s_addressOut : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     
     -- signal s_addressdummy : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     

     signal s_addressBZ : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     signal s_branch_select : std_logic := '0';     
     signal s_bz : STD_LOGIC;

     -- inst
     signal curr_inst : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
     signal s_curr_inst_extend : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     
     -- register
     signal s_rr2 : std_logic_vector(4 downto 0) := "00000";
     signal s_rw : std_logic := '0';
     signal s_wd : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
     signal s_out_rd1 : std_logic_vector(63 downto 0);
     signal s_out_rd2 : std_logic_vector(63 downto 0);

     -- dmem
     signal s_ad : std_logic_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";
     signal s_mr : std_logic := '0';
     signal s_mw : std_logic := '0';
     signal s_rdata : std_logic_vector(63 downto 0);
 
     -- ALUOP
     signal s_aluop : std_logic_vector(1 downto 0) := "00";
     signal s_opcode : std_logic_vector(10 downto 0) := "11111111111";
     signal s_operation : std_logic_vector(3 downto 0) := "0000";

     -- ALU
     signal s_z : std_logic := '0';
     signal s_ov : std_logic := '0';


     -- MUX64 (center)
     signal s_mux64o : std_logic_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";

     -- cpucontrol
     signal s_rd : std_logic := '0';
     signal s_cb : std_logic := '0';
     signal s_mt : std_logic := '0';
     signal s_as : std_logic := '0';
     signal s_ub : std_logic := '0';

     -- debugs
     signal s_DEBUG_TMP_REGS : std_logic_vector(64*4 - 1 downto 0):= x"0000000000000000000000000000000000000000000000000000000000000000";
     signal s_DEBUG_SAVED_REGS : std_logic_vector(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";
     signal s_DEBUG_MEM_CONTENTS : std_logic_vector(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";

begin
     pc_inst: PC 
     port map(
          clk => clk,
          write_enable => s_write_enable,
          rst => rst,
          AddressIn => s_addressIn,
          AddressOut => s_addressOut
     );
     
     imem_inst: imem
     port map(
          Address => s_addressOut,
          ReadData => curr_inst
     );
     
     registers_inst: registers
     port map(
          RR1 => curr_inst(9 downto 5),
          RR2 => s_rr2, 
          WR => curr_inst(4 downto 0),
          WD => s_wd,
          RegWrite => s_rw,
          Clock => clk,
          RD1 => s_out_rd1,
          RD2 => s_out_rd2,
          DEBUG_TMP_REGS => s_DEBUG_TMP_REGS,
          DEBUG_SAVED_REGS => s_DEBUG_SAVED_REGS
     );
     
     dmem_inst: dmem
     port map(
         WriteData => s_out_rd2,
         Address => s_ad,
         MemRead => s_mr,
         MemWrite => s_mw,
         Clock => clk,
         ReadData => s_rdata,
         DEBUG_MEM_CONTENTS => s_DEBUG_MEM_CONTENTS
     );

     alucontrol_inst: alucontrol
     port map(
         ALUOp => s_aluop,
         OpCode => curr_inst(31 downto 21),
         Operation => s_operation
     );

     alu_inst: ALU
     port map(
          in0 => s_out_rd1,
          in1 => s_mux64o,
          operation => s_operation,
          result => s_ad,
          zero => s_z,
          overflow => s_ov
     );

     mux5_inst: MUX5
     port map(
         in0 => curr_inst(20 downto 16),
         in1 => curr_inst(4 downto 0),
         sel => s_rd,
         output => s_rr2
     );

     mux64_center_inst: MUX64
     port map(
         in0 => s_out_rd2,
         in1 => s_curr_inst_extend,
         sel => s_as,
         output => s_mux64o
     );

     mux64_right_inst: MUX64
     port map(
         in0 => s_ad,
         in1 => s_rdata, 
         sel => s_mt,
         output => s_wd
     );

     mux64_top_inst: MUX64
     port map(
         in0 => s_addressInc,
         in1 => s_addressBranch,
         sel => s_branch_select,
         -- output => s_addressdummy
         output => s_addressIn
     );

     cpucontrol_inst: CPUCONTROL
     port map(
          Opcode => curr_inst(31 downto 21),
          RegDst => s_rd,
          Cbranch => s_cb,
          MemRead => s_mr,
          MemtoReg => s_mt,
          MemWrite => s_mw,
          ALUSrc => s_as,
          RegWrite => s_rw,
          UBranch => s_ub,
          ALUOp => s_aluop
     );

     signExtend_inst: SignExtend
     port map(
          x => curr_inst(31 downto 0),
          opcode => curr_inst(31 downto 21),
          y => s_curr_inst_extend
     );

     shiftleft2_inst: ShiftLeft2
     port map(
          x => s_curr_inst_extend,
          y => s_addressImm
     );

     add_inst: ADD
     port map(
          in0 => s_addressImm,
          in1 => s_addressOut,
          output => s_addressBranch
     );

     DEBUG_PC <= s_addressOut;
     -- s_addressIn <= std_logic_vector(unsigned(s_addressOut) + 4);
     
     s_addressInc <= std_logic_vector(unsigned(s_addressOut) + 4);

     DEBUG_INSTRUCTION <= curr_inst;
     
     --s_addressBranch <= std_logic_vector(unsigned(s_addressOut) + unsigned(s_addressImm));

     s_bz <= s_z and s_cb;
     s_branch_select <= s_bz or s_ub;

  

     DEBUG_TMP_REGS <= s_DEBUG_TMP_REGS;
     DEBUG_SAVED_REGS <= s_DEBUG_SAVED_REGS;
     DEBUG_MEM_CONTENTS <= s_DEBUG_MEM_CONTENTS;

end rtl;