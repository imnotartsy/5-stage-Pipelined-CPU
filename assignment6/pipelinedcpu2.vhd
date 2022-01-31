library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PipelinedCPU2 is
port(
    clk :in std_logic;
    rst :in std_logic;
    -- Probe ports used for testing
    DEBUG_IF_FLUSH : out std_logic; -- * NEW *
    DEBUG_REG_EQUAL : out std_logic; -- * NEW *
    -- Forwarding control signals
    DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
    DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
    --The current address (AddressOut from the PC)
    DEBUG_PC : out std_logic_vector(63 downto 0);
    --Value of PC.write_enable
    DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
    --The current instruction (Instruction output of IMEM)
    DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
    --DEBUG ports from other components
    DEBUG_TMP_REGS : out std_logic_vector(64*4-1 downto 0);
    DEBUG_SAVED_REGS : out std_logic_vector(64*4-1 downto 0);
    DEBUG_MEM_CONTENTS : out std_logic_vector(64*4-1 downto 0)
);
end PipelinedCPU2;



architecture rtl of PipelinedCPU2 is
    component PC
        port(
            clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
            write_enable : in  STD_LOGIC; -- Only write if '1'
            rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
            AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- "0000000000000000000000000000000000000000000000000000000000000000"; -- Next PC address
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

    component PipelinedRegister_IFID
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            fl  : in STD_LOGIC;
            en  : in STD_LOGIC;
    
            in_inst : in STD_LOGIC_VECTOR(31 downto 0);
            in_pc   : in STD_LOGIC_VECTOR(63 downto 0);
    
            out_inst : out STD_LOGIC_VECTOR(31 downto 0);
            out_pc   : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    component PipelinedRegister_IDEX
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            -- fl  : in STD_LOGIC; 
            en  : in STD_LOGIC;
    
            in_inst : in STD_LOGIC_VECTOR(31 downto 0);
            in_pc   : in STD_LOGIC_VECTOR(63 downto 0);
            in_CBranch  : in STD_LOGIC;  -- conditional
            in_UBranch  : in STD_LOGIC;  -- unconditional
            in_MemRead  : in STD_LOGIC;
            in_MemtoReg : in STD_LOGIC;
            in_MemWrite : in STD_LOGIC;
            in_RegWrite : in STD_LOGIC;
            in_ALUSrc   : in STD_LOGIC;
            in_ALUOp    : in STD_LOGIC_VECTOR(1 downto 0);
            in_readdata1   : in STD_LOGIC_VECTOR(63 downto 0);
            in_readdata2   : in STD_LOGIC_VECTOR(63 downto 0);
            in_signextend  : in STD_LOGIC_VECTOR(63 downto 0);

            in_rn : in STD_LOGIC_VECTOR(4 downto 0);
            in_rm : in STD_LOGIC_VECTOR(4 downto 0);
    
    
            out_inst : out STD_LOGIC_VECTOR(31 downto 0);
            out_pc   : out STD_LOGIC_VECTOR(63 downto 0);
            out_CBranch  : out STD_LOGIC; -- conditional
            out_UBranch  : out STD_LOGIC; -- unconditional
            out_MemRead  : out STD_LOGIC;
            out_MemtoReg : out STD_LOGIC;
            out_MemWrite : out STD_LOGIC;
            out_RegWrite : out STD_LOGIC;
            out_ALUSrc   : out STD_LOGIC;
            out_ALUOp    : out STD_LOGIC_VECTOR(1 downto 0);
            out_readdata1 : out STD_LOGIC_VECTOR(63 downto 0);
            out_readdata2 : out STD_LOGIC_VECTOR(63 downto 0);
            out_signextend : out STD_LOGIC_VECTOR(63 downto 0);
          
            out_rn : out STD_LOGIC_VECTOR(4 downto 0);
            out_rm : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;


    component PipelinedRegister_EXMEM
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            en  : in STD_LOGIC;
    
            in_CBranch  : in STD_LOGIC; -- conditional
            in_UBranch  : in STD_LOGIC; -- unconditional
    
            in_MemRead  : in STD_LOGIC;
            in_MemtoReg : in STD_LOGIC;
            in_MemWrite : in STD_LOGIC;
            in_RegWrite : in STD_LOGIC;
            
    
            in_ADDres   : in STD_LOGIC_VECTOR(63 downto 0); --addressBranch
            in_z        : in STD_LOGIC;
            in_ALUres   : in STD_LOGIC_VECTOR(63 downto 0);
            in_readdata2 : in STD_LOGIC_VECTOR(63 downto 0);
            in_endinst  : in STD_LOGIC_VECTOR(4 downto 0);
        
    
        
            out_CBranch  : out STD_LOGIC; -- conditional
            out_UBranch  : out STD_LOGIC; -- unconditional
            out_MemRead  : out STD_LOGIC;
            out_MemtoReg : out STD_LOGIC;
            out_MemWrite : out STD_LOGIC;
            out_RegWrite : out STD_LOGIC;
    
            out_ADDres   : out STD_LOGIC_VECTOR(63 downto 0); --addressBranch
            out_z        : out STD_LOGIC;
            out_ALUres   : out STD_LOGIC_VECTOR(63 downto 0);
            out_readdata2 : out STD_LOGIC_VECTOR(63 downto 0);
            out_endinst  : out STD_LOGIC_VECTOR(4 downto 0)
    
        );
    end component;


    component PipelinedRegister_MEMWB
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            en  : in STD_LOGIC;
    
            in_MemtoReg : in STD_LOGIC;
            in_RegWrite : in STD_LOGIC;
    
            in_daddress : in STD_LOGIC_VECTOR(63 downto 0);
            in_rdata    : in STD_LOGIC_VECTOR(63 downto 0);
            in_endinst  : in STD_LOGIC_VECTOR(4 downto 0);
        
    
            out_MemtoReg : out STD_LOGIC;
            out_RegWrite : out STD_LOGIC;
            
            out_daddress : out STD_LOGIC_VECTOR(63 downto 0);
            out_rdata    : out STD_LOGIC_VECTOR(63 downto 0);
            out_endinst  : out STD_LOGIC_VECTOR(4 downto 0)
    
        );
    end component;

    component Forwarder 
        port(
            IDEX_rn : in STD_LOGIC_VECTOR(4 downto 0);
            IDEX_rm : in STD_LOGIC_VECTOR(4 downto 0);
    
            EXMEM_WB_rw : in STD_LOGIC;
            EXMEM_rd : in STD_LOGIC_VECTOR(4 downto 0);
    
            MEMWB_WB_rw : in STD_LOGIC;
            MEMWB_rd : in STD_LOGIC_VECTOR(4 downto 0);
    
            ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
            ForwardB : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    component HazardDetector
        port(    
            IDEX_rd : in std_logic_vector(4 downto 0);
            IFID_rn : in std_logic_vector(4 downto 0);
            IFID_rm : in std_logic_vector(4 downto 0);
            IDEX_mr : in std_logic;
            
            IFID_rst : out std_logic;
            IFID_en : out std_logic;
            PC_en   : out std_logic;
            control_en : out std_logic
        );
    end component;

    -- pc
    signal s_PC : std_logic_vector(63 downto 0)      := (others => '0');
    signal s_PC_ifid : std_logic_vector(63 downto 0) := (others => '0');
    signal s_PC_idex : std_logic_vector(63 downto 0) := (others => '0');

    signal curr_inst : std_logic_vector(31 downto 0)   := (others => '0');
    signal s_inst_ifid : std_logic_vector(31 downto 0) := (others => '0');
    signal s_inst_idex : std_logic_vector(31 downto 0) := (others => '0');
    signal s_inst_exmem : std_logic_vector(4 downto 0) := "00000";
    -- signal s_inst_memwb : std_logic_vector(4 downto 0) := "00000";
    

    signal s_write_enable : std_logic := '1';
    signal s_write_enable_hazard_detect : std_logic := '1';
    signal s_addressIn : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal s_addressInc : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal s_addressImm : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal s_addressBranch : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal s_addressBranch_exmem : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    
    
    signal s_addressOut : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    
    -- signal s_addressdummy : STD_LOGIC_VECTOR(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    

    signal s_addressBZ : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal s_branch_select : std_logic := '0';     
    signal s_bz : STD_LOGIC := '0';

    -- inst
    signal s_curr_inst_extend : std_logic_vector(63 downto 0) := (others => '0');
    signal s_curr_inst_extend_idex : std_logic_vector(63 downto 0) := (others => '0');
    
    -- register
    signal s_rr2 : std_logic_vector(4 downto 0) := (others => '0');
    signal s_rw : std_logic := '0';

    signal s_wr_memwb : std_logic_vector(4 downto 0) := (others => '0');
    signal s_wd : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal s_out_rd1 : std_logic_vector(63 downto 0) := (others => '0');
    signal s_out_rd2 : std_logic_vector(63 downto 0) := (others => '0');

    signal s_rw_id : std_logic := '0';
    signal s_rw_idex : std_logic := '0';
    signal s_out_rd1_idex : std_logic_vector(63 downto 0) := (others => '0');
    signal s_out_rd2_idex : std_logic_vector(63 downto 0):= (others => '0');
    signal s_out_rd2_exmem : std_logic_vector(63 downto 0):= (others => '0');
    signal s_out_rd2_hazard : std_logic_vector(63 downto 0):= (others => '0');

    signal s_rw_exmem : std_logic := '0';
    signal s_rw_memwb : std_logic := '0';

    signal s_rn_idex : std_logic_vector(4 downto 0) := (others => '0');
    signal s_rm_idex : std_logic_vector(4 downto 0) := (others => '0');

    -- dmem
    signal s_ad : std_logic_vector(63 downto 0) := (others => '0');
    signal s_ad_exmem : std_logic_vector(63 downto 0) := (others => '0');
    signal s_ad_memwb : std_logic_vector(63 downto 0) := (others => '0');
    
    signal s_mr : std_logic := '0';
    signal s_mw : std_logic := '0';
    signal s_rdata : std_logic_vector(63 downto 0) := (others => '0');

    signal s_mr_id : std_logic := '0';
    signal s_mw_id : std_logic := '0';

    signal s_mr_idex : std_logic := '0';
    signal s_mw_idex : std_logic := '0';

    signal s_mr_exmem : std_logic := '0';
    signal s_mw_exmem : std_logic := '0';
    signal s_rdata_memwb : std_logic_vector(63 downto 0):= (others => '0');

    -- ALUOP
    signal s_aluop : std_logic_vector(1 downto 0) := (others => '0');
    signal s_aluop_id : std_logic_vector(1 downto 0) := (others => '0');
    signal s_aluop_idex : std_logic_vector(1 downto 0) := (others => '0');
    signal s_opcode : std_logic_vector(10 downto 0) := (others => '0');
    signal s_operation : std_logic_vector(3 downto 0) := (others => '0');

    -- ALU
    signal s_z : std_logic := '0';
    signal s_z_exmem : std_logic := '0';
    signal s_ov : std_logic := '0';
    signal s_alu_in1 : std_logic_vector(63 downto 0) := (others => '0');
    signal s_alu_in2 : std_logic_vector(63 downto 0) := (others => '0');


    -- MUX64 (center)
    signal s_mux64o : std_logic_vector(63 downto 0) := (others => '0');

    -- cpucontrol
    signal s_rd : std_logic := '0';
    signal s_cb : std_logic := '0';
    signal s_mt : std_logic := '0';
    signal s_as : std_logic := '0';
    signal s_ub : std_logic := '0';

    signal s_rd_id : std_logic := '0';
    signal s_cb_id : std_logic := '0';
    signal s_mt_id : std_logic := '0';
    signal s_as_id : std_logic := '0';
    signal s_ub_id : std_logic := '0';

    signal s_cb_idex : std_logic := '0';
    signal s_ub_idex : std_logic := '0';
    signal s_mt_idex : std_logic := '0';
    signal s_as_idex : std_logic := '0';

    signal s_cb_exmem : std_logic := '0';
    signal s_ub_exmem : std_logic := '0';
    signal s_mt_exmem : std_logic := '0';

    signal s_mt_memwb : std_logic := '0';

    signal s_cpucontrol_en : std_logic := '0';

    -- debugs
    signal s_DEBUG_TMP_REGS : std_logic_vector(64*4 - 1 downto 0):= (others => '0');
    signal s_DEBUG_SAVED_REGS : std_logic_vector(64*4 - 1 downto 0) := (others => '0');
    signal s_DEBUG_MEM_CONTENTS : std_logic_vector(64*4 - 1 downto 0) := (others => '0');

    -- enables
    signal s_ifid_en  : std_logic := '1';
    signal s_ifid_en_hazard_detect : std_logic := '1';
    signal s_idex_en  : std_logic := '1';
    signal s_exmem_en : std_logic := '1';
    signal s_memwb_en : std_logic := '1';
    -- signal s_ifid_en  : std_logic := '0';
    -- signal s_idex_en  : std_logic := '0';
    -- signal s_exmem_en : std_logic := '0';
    -- signal s_memwb_en : std_logic := '0';

    -- forwarding and hazards
    signal s_forwarda : std_logic_vector(1 downto 0) := (others => '0');
    signal s_forwardb : std_logic_vector(1 downto 0) := (others => '0');
    signal s_forwardc : std_logic_vector(1 downto 0) := (others => '0');


    signal s_hazard_idex_rst : std_logic := '0';

    signal s_control_en : std_logic := '1';
    -- signal s_idex_fl    : std_logic := '0';
    signal s_ifid_fl    : std_logic := '0';

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
        RR1 => s_inst_ifid(9 downto 5),
        RR2 => s_rr2, 
        WR => s_wr_memwb,
        WD => s_wd,
        RegWrite => s_rw_memwb,
        Clock => clk,
        RD1 => s_out_rd1,
        RD2 => s_out_rd2,
        DEBUG_TMP_REGS => s_DEBUG_TMP_REGS,
        DEBUG_SAVED_REGS => s_DEBUG_SAVED_REGS
    );
    
    dmem_inst: dmem
    port map(
        WriteData => s_out_rd2_exmem,
        Address => s_ad_exmem,
        MemRead => s_mr_exmem,
        MemWrite => s_mw_exmem,
        Clock => clk,
        ReadData => s_rdata,
        DEBUG_MEM_CONTENTS => s_DEBUG_MEM_CONTENTS
    );

    alucontrol_inst: alucontrol
    port map(
        ALUOp => s_aluop_idex,
        OpCode => s_inst_idex(31 downto 21), -- idex
        Operation => s_operation
    );

    alu_inst: ALU
    port map(
        in0 => s_alu_in1,
        in1 => s_alu_in2,
        operation => s_operation,
        result => s_ad,
        zero => s_z,
        overflow => s_ov
    );

    mux5_inst: MUX5
    port map(
        in0 => s_inst_ifid(20 downto 16),
        in1 => s_inst_ifid(4 downto 0),
        sel => s_rd,
        output => s_rr2
    );

    mux64_center_inst: MUX64
    port map(
        in0 => s_out_rd2_idex,
        in1 => s_curr_inst_extend_idex,
        sel => s_as_idex,
        output => s_mux64o
    );

    mux64_right_inst: MUX64
    port map(
        in0 => s_ad_memwb, --**
        in1 => s_rdata_memwb, 
        sel => s_mt_memwb,
        output => s_wd
    );
    
    mux64_top_inst: MUX64
    port map(
        in0 => s_addressInc,
        in1 => s_addressBranch,
        sel => s_branch_select,
        output => s_addressIn
    );

    cpucontrol_inst: CPUCONTROL
    port map(
        Opcode => s_inst_ifid(31 downto 21),
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
        x => s_inst_ifid(31 downto 0),
        opcode => s_inst_ifid(31 downto 21),
        y => s_curr_inst_extend
    );

    shiftleft2_inst: ShiftLeft2
    port map(
        x => s_curr_inst_extend, --_idex,
        y => s_addressImm
    );

    add_inst: ADD
    port map(
        in0 => s_addressImm,
        in1 => s_pc_ifid,--idex,
        output => s_addressBranch
    );

    pr_idif_inst: PipelinedRegister_IFID
    port map(
        clk => clk,
        rst => rst,
        fl => s_ifid_fl,
        en => s_ifid_en,

        in_inst => curr_inst,
        in_pc   => s_addressOut,

        out_inst => s_inst_ifid,
        out_pc   => s_PC_ifid
    );

    pr_idex_inst: PipelinedRegister_IDEX
    port map(
        clk => clk,
        rst => rst,
        en  => s_idex_en,
        -- fl  => s_idex_fl,

        in_inst => s_inst_ifid,
        in_pc   => s_PC_ifid,
        in_CBranch  => s_cb_id,
        in_UBranch  => s_ub_id,
        in_MemRead  => s_mr_id,
        in_MemtoReg => s_mt_id,
        in_MemWrite => s_mw_id,
        in_RegWrite => s_rw_id,
        in_ALUSrc   => s_as_id,
        in_ALUOp    => s_aluop_id,
        in_readdata1  => s_out_rd1,
        in_readdata2  => s_out_rd2,
        in_signextend => s_curr_inst_extend,

        in_rn => s_inst_ifid(9 downto 5),
        in_rm => s_rr2,


        out_inst => s_inst_idex,
        out_pc   => s_PC_idex,
        out_CBranch  => s_cb_idex,
        out_UBranch  => s_ub_idex,
        out_MemRead  => s_mr_idex,
        out_MemtoReg => s_mt_idex,
        out_MemWrite => s_mw_idex,
        out_RegWrite => s_rw_idex,
        out_ALUSrc   => s_as_idex,
        out_ALUOp    => s_aluop_idex,
        out_readdata1  => s_out_rd1_idex,
        out_readdata2  => s_out_rd2_idex,
        out_signextend => s_curr_inst_extend_idex,

        out_rn => s_rn_idex,
        out_rm => s_rm_idex
    );


    pr_exmem_inst: PipelinedRegister_EXMEM
    port map(
        clk => clk,
        rst => rst,
        en  => s_exmem_en,

        in_CBranch  => s_cb_idex,
        in_UBranch  => s_ub_idex,

        in_MemRead  => s_mr_idex,
        in_MemtoReg => s_mt_idex,
        in_MemWrite => s_mw_idex,
        in_RegWrite => s_rw_idex,
        

        in_ADDres    => s_addressBranch, --unnecessary
        in_z         => s_z, 
        in_ALUres    => s_ad,
        in_readdata2 => s_out_rd2_idex,
        in_endinst   => s_inst_idex(4 downto 0),



        out_CBranch   => s_cb_exmem,
        out_UBranch   => s_ub_exmem,
        out_MemRead   => s_mr_exmem,
        out_MemtoReg  => s_mt_exmem,
        out_MemWrite  => s_mw_exmem,
        out_RegWrite  => s_rw_exmem,

        out_ADDres    => s_addressBranch_exmem,
        out_z         => s_z_exmem,
        out_ALUres    => s_ad_exmem,
        out_readdata2 => s_out_rd2_exmem,
        out_endinst   => s_inst_exmem
    );


    pc_memwb_inst: PipelinedRegister_MEMWB
    port map (
        clk => clk,
        rst => rst,
        en  => s_memwb_en,

        in_MemtoReg => s_mt_exmem,
        in_RegWrite => s_rw_exmem,
        in_daddress => s_ad_exmem,
        in_rdata    => s_rdata,
        in_endinst  => s_inst_exmem,


        out_MemtoReg => s_mt_memwb,
        out_RegWrite => s_rw_memwb,
        out_daddress => s_ad_memwb,
        out_rdata    => s_rdata_memwb,
        out_endinst  => s_wr_memwb
    );
    
    forwarder_inst: Forwarder
    port map(
        IDEX_rn => s_rn_idex,
        IDEX_rm => s_rm_idex,

        EXMEM_WB_rw => s_rw_exmem,
        EXMEM_rd => s_inst_exmem,

        MEMWB_WB_rw => s_rw_memwb,
        MEMWB_rd => s_wr_memwb,

        ForwardA => s_forwarda,
        ForwardB => s_forwardb
    );

    hazarddector_inst : HazardDetector
    port map(    
        IDEX_rd => s_inst_idex(4 downto 0),
        IFID_rn => s_inst_ifid(9 downto 5),
        IFID_rm => s_rr2,
        IDEX_mr => s_mr_idex,

        IFID_en => s_ifid_en_hazard_detect,
        PC_en   => s_write_enable_hazard_detect,
        control_en => s_control_en
    );

    

    -- s_alu_in2 <= s_ad_exmem when s_forwardb = "10" else
    --     s_wd;  -- when s_forwarda = "00" 
    

    s_alu_in1 <= s_ad_exmem when s_forwarda = "10" else
                 s_wd       when s_forwarda = "01" else
                 s_out_rd1_idex; -- when s_forwarda = "00" 

    s_alu_in2 <= s_ad_exmem when s_forwardb = "10" else
                 s_wd       when s_forwardb = "01" else
                 s_mux64o;    -- when s_forwarda = "00" 
    
    s_cb_id <= s_cb when s_control_en = '1' else '0';
    s_mr_id <= s_mr when s_control_en = '1' else '0';
    s_mt_id <= s_mt when s_control_en = '1' else '0';
    s_mw_id <= s_mw when s_control_en = '1' else '0';
    s_as_id <= s_as when s_control_en = '1' else '0';
    s_rw_id <= s_rw when s_control_en = '1' else '0';
    s_ub_id <= s_ub when s_control_en = '1' else '0';
    s_aluop_id <= s_aluop when s_control_en = '1' else "00";

    s_forwardc <= "01" when ((s_cb = '1') and (s_rw_idex = '1') and s_rr2 = s_inst_idex(4 downto 0)) else -- stall ifid and pc(?)
                  "10" when ((s_cb = '1') and (s_rw_exmem = '1') and s_rr2 = s_inst_exmem) else
                  "11" when ((s_cb = '1') and (s_rw_memwb = '1') and s_rr2 = s_wr_memwb) else
                  "00";
        

    -- s_idex_en <= '0' when s_forwardc = "01" else '1';
    s_ifid_en <= '0' when s_forwardc = "01" else '1'; --s_ifid_en_hazard_detect;
    s_write_enable <= '0' when s_forwardc = "01" else '1';--s_write_enable_hazard_detect;
    

    DEBUG_FORWARDA <= s_forwarda;
    DEBUG_FORWARDB <= s_forwardb;      
    
    
    DEBUG_PC <= s_addressOut;
    -- s_addressIn <= std_logic_vector(unsigned(s_addressOut) + 4);
    
    s_addressInc <= std_logic_vector(unsigned(s_addressOut) + 4);

    DEBUG_INSTRUCTION <= curr_inst;
    DEBUG_PC_WRITE_ENABLE <= s_write_enable;
    
    --s_addressBranch <= std_logic_vector(unsigned(s_addressOut) + unsigned(s_addressImm));

    -- s_bz <= s_z_exmem and s_cb_exmem;
    -- s_branch_selec    <= s_bz or s_ub_exmem;

    -- s_bz <= s_z and s_cb;
    s_out_rd2_hazard <=  s_out_rd2    when s_forwardc = "01" else
                         s_ad_exmem   when s_forwardc = "10" else
                         s_wd;        --when s_forwardc = "11" else
                         --s_out_rd2;
    s_bz <= '1' when (s_out_rd2_hazard = x"0000000000000000" and s_cb = '1') else '0';
    s_branch_select <= s_bz or s_ub;

    s_ifid_fl <= '1' when ((s_branch_select = '1') and (s_write_enable = '1')) else '0';


    DEBUG_IF_FLUSH <= s_ifid_fl;
    DEBUG_REG_EQUAL <= '1' when ((s_branch_select = '1') and (s_write_enable = '1')) else '0';
    DEBUG_TMP_REGS <= s_DEBUG_TMP_REGS;
    DEBUG_SAVED_REGS <= s_DEBUG_SAVED_REGS;
    DEBUG_MEM_CONTENTS <= s_DEBUG_MEM_CONTENTS;

end rtl;