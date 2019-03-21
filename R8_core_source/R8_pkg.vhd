library IEEE;
use IEEE.Std_Logic_1164.all;

package R8_pkg is  
       
    -- The 'instruction' enumeration indicates the decoded one by the control path  -- 28 instructions
    -- The 15 conditional jumps are grouped in just 3 instruction classes: 
    --      JUMP_R: JMPR, JMPNR, JMPZR, JMPCR, JMPVR        - Register relative jump
    --      JUMP_A: JMP, JMPN, JMPZ, JMPC, JMPV             - Absolute jump
    --      JUMP_D: JMPD, JMPND, JMPZD, JMPCD, JMPVD        - Displacement jump
    type Instruction is ( 
        ADD, SUB, AAND, OOR, XXOR, ADDI, SUBI, NOT_A, 
        SL0, SL1, SR0, SR1,
        LDL, LDH, LD, ST, LDSP, POP, PUSH,
        JUMP_R, JUMP_A, JUMP_D, JSRR, JSR, JSRD,
        NOP, HALT,  RTS
    );
  
    type Microinstruction is record
        mPC     : std_logic_vector(1 downto 0);  -- PC input MUX control
        mSP     : std_logic;                     -- SP input MUX control (stack-pointer)
        mAddr   : std_logic_vector(1 downto 0);  -- MUX to select source for the memory address
        mRegs   : std_logic;                     -- MUX to select source for the register bank input
        mS2     : std_logic;                     -- Register file source2 MUX control
        ma      : std_logic;                     -- ALU A operand MUX control
        mb      : std_logic_vector(1 downto 0);  -- ALU B operand MUX control
        wPC     : std_logic;                     -- PC write enable
        wSP     : std_logic;                     -- SP write enable
        wIR     : std_logic;                     -- IR write enable
        wAB     : std_logic;                     -- RA and RB write enable
        wRalu   : std_logic;                     -- RALU write enable
        wReg    : std_logic;                     -- Register file write enable  
        wnz     : std_logic;                     -- Negative and zero flags write enable
        wcv     : std_logic;                     -- Carry and overflow flags write enable
        ce,rw   : std_logic;                     -- Chip enable and RW controls
        inst    : instruction;                   -- ALU operation specification
    end record;
         
    -- Ripple carry adder
    procedure Adder(signal A,B: in std_logic_vector(15 downto 0); signal carry_in: in STD_LOGIC;
                    signal S: out std_logic_vector(15 downto 0); signal carry_out, overflow:out STD_LOGIC);
                       
  
end R8_pkg;

package body R8_pkg is
 
    -- Ripple carry adder implementation
    procedure Adder(signal A,B: in std_logic_vector(15 downto 0); signal carry_in: in STD_LOGIC;
                    signal S: out std_logic_vector(15 downto 0); signal carry_out, overflow:out STD_LOGIC) is             
    
        variable previousCarry, carry : std_logic;
    
    begin    
        for i in 0 to 15 loop
            if i = 0 then 
                carry := carry_in;  
            end if;
            
            previousCarry := carry;
                  
            S(i) <= A(i) xor B(i) xor carry;
            carry := (A(i) and B(i)) or (A(i) and carry) or (B(i) and carry);
        
        end loop;
        
            carry_out <= carry;
            overflow <= previousCarry xor carry;
            
    end Adder;
  
  
end R8_pkg;