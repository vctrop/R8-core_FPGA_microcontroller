-----------------------------------------------------------------------------------
-- Design unit: Control path
-- Description: R8 behavioral control path. Control signals generated based on FSM.
-----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.R8_pkg.all;

entity ControlPath is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        uins    : out microinstruction;             -- Control signals to data path
        flag    : in std_logic_vector(3 downto 0);  -- Status flag from data path
        ir      : in std_logic_vector(15 downto 0)  -- Current instruction from data path 
    );
end ControlPath;

architecture ControlPath of ControlPath is

    -- 13 states
    type State  is (Sidle, Sfetch, Sreg, Shalt, Salu, Srts, Spop, Sldsp, Sld, Sst, Swbk, Sjmp, Ssbrt, Spush);
    signal currentState, nextState : State;

    signal decodedInstruction : instruction;
    
    -- Status flags
    alias negativeFlag  : std_logic is flag(0);
    alias zeroFlag      : std_logic is flag(1);
    alias carryFlag     : std_logic is flag(2);
    alias overflowFlag  : std_logic is flag(3);
    
    -- Instructions formats
    --      1: The target register is not source
    --      2: The target register is ALSO source
    signal instructionFormat1, instructionFormat2: boolean;
    
  
begin
   
    ----------------------------------------------------------------------------------------
    -- Instruction decoding --
    ----------------------------------------------------------------------------------------
    decodedInstruction <=   ADD     when ir(15 downto 12) = x"0" else
                            SUB     when ir(15 downto 12) = x"1" else
                            AAND    when ir(15 downto 12) = x"2" else
                            OOR     when ir(15 downto 12) = x"3" else
                            XXOR    when ir(15 downto 12) = x"4" else
                            ADDI    when ir(15 downto 12) = x"5" else
                            SUBI    when ir(15 downto 12) = x"6" else
                            LDL     when ir(15 downto 12) = x"7" else
                            LDH     when ir(15 downto 12) = x"8" else
                            LD      when ir(15 downto 12) = x"9" else
                            ST      when ir(15 downto 12) = x"A" else
                            SL0     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"0" else
                            SL1     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"1" else
                            SR0     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"2" else
                            SR1     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"3" else
                            NOT_A   when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"4" else
                            NOP     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"5" else
                            HALT    when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"6" else
                            LDSP    when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"7" else
                            RTS     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"8" else
                            POP     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"9" else
                            PUSH    when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"A" else 
               
                            -- Jump instructions (18). 
                            -- Here the status flags are tested to jump or not
                            JUMP_R  when ir(15 downto 12) = x"C" and (
                                     ir(3 downto 0) = x"0" or                           -- JMPR
                                    (ir(3 downto 0) = x"1" and negativeFlag = '1') or   -- JMPNR
                                    (ir(3 downto 0) = x"2" and zeroFlag = '1') or       -- JMPZR
                                    (ir(3 downto 0) = x"3" and carryFlag = '1') or      -- JMPCR
                                    (ir(3 downto 0) = x"4" and overflowFlag = '1')      -- JMPVR
                                    ) else 

                            JUMP_A  when ir(15 downto 12) = x"C" and (
                                     ir(3 downto 0) = x"5" or                           -- JMP
                                    (ir(3 downto 0) = x"6" and negativeFlag = '1') or   -- JMPN
                                    (ir(3 downto 0) = x"7" and zeroFlag = '1') or       -- JMPZ
                                    (ir(3 downto 0) = x"8" and carryFlag = '1') or      -- JMPC
                                    (ir(3 downto 0) = x"9" and overflowFlag = '1')      -- JMPV
                                    ) else 

                            JUMP_D  when ir(15 downto 12) = x"D" or (                           -- JMPD
                                        ir(15 downto 12) = x"E" and ( 
                                            (ir(11 downto 10) = "00" and negativeFlag = '1') or -- JMPND
                                            (ir(11 downto 10) = "01" and zeroFlag = '1') or     -- JMPZD
                                            (ir(11 downto 10) = "10" and carryFlag = '1') or    -- JMPCD
                                            (ir(11 downto 10) = "11" and overflowFlag = '1')    -- JMPVD
                                        )   
                                    )  else 

                            JSRR  when ir(15 downto 12) = x"C" and ir(3 downto 0) = x"A" else
                            JSR   when ir(15 downto 12) = x"C" and ir(3 downto 0) = x"B" else
                            JSRD  when ir(15 downto 12) = x"F" else

                            NOP ;   -- IMPORTANT: default condition in case of conditional jumps with corresponding flag = '0';
        
    -- The decoded instruction determines the ALU operation
    uins.inst <= decodedInstruction; 

    -- The target register is not source
    instructionFormat1 <= true when decodedInstruction=ADD or decodedInstruction=SUB or decodedInstruction=AAND or decodedInstruction=OOR or decodedInstruction=XXOR or decodedInstruction=NOT_A or decodedInstruction=SL0 or decodedInstruction=SR0 or decodedInstruction=SL1 or decodedInstruction=SR1 else false;

    -- The target register is ALSO source
    instructionFormat2 <= true when decodedInstruction=ADDI or decodedInstruction=SUBI or decodedInstruction=LDL or decodedInstruction=LDH else false; 
              
  
  
  
  
    -----------------------------------------------------------------------------
    -- FSM state register --
    -----------------------------------------------------------------------------
    process(rst, clk)
    begin
        if rst = '1' then 
            currentState <= Sidle;    -- Sidle is the state the machine stays while processor is being reset
                            
        elsif rising_edge(clk) then
            currentState <= nextState;
        end if;
    end process;
    
    
    -------------------------------------------------------------------------------
    -- FSM next state combinational logic
    -------------------------------------------------------------------------------
    process(currentState, decodedInstruction)     
    begin
  
        case currentState is
                  
            when Sidle =>  
                nextState <= Sfetch;
       
            
            -- First clock cycle after reset and after each instruction ends execution
            when Sfetch =>  
                nextState <= Sreg;
              
  
          
            -- Second clock cycle of every instruction
            when Sreg =>   
                if decodedInstruction = HALT then      -- HALT fount => stop generating microinstructions
                    nextState <= Shalt;
                else
                   nextState <= Salu;
                end if;
                
  
            
            -- Third clock cycle of every instruction - there are 9 distinct destination states from here
            when Salu =>
                if decodedInstruction = PUSH then   
                    nextState <= Spush;
                
                elsif decodedInstruction = POP then   
                    nextState <= Spop;
                
                elsif decodedInstruction = RTS then   
                    nextState <= Srts;
            
                elsif decodedInstruction = LDSP then   
                    nextState <= Sldsp;
                
                elsif decodedInstruction = LD then   
                    nextState <= Sld;
                      
                elsif decodedInstruction = ST then   
                    nextState <= Sst;
                      
                elsif instructionFormat1 or instructionFormat2 then   
                    nextState <= Swbk;
                
                elsif decodedInstruction = JUMP_R or decodedInstruction = JUMP_A or decodedInstruction = JUMP_D then   
                    nextState <= Sjmp;
                      
                elsif decodedInstruction = JSRR or decodedInstruction = JSR or decodedInstruction = JSRD then   
                    nextState <= Ssbrt; 
            
                else    -- ** ATTENTION ** NOP and jumps with corresponding flag=0 execute in just 3 clock cycles 
                    nextState <= Sfetch;   
                end if;
  
            
            -- Fourth clock cycle of several instructions 
            when Spop | Srts | Sldsp | Sld | Sst | Swbk | Sjmp | Ssbrt | Spush =>  
                nextState <= Sfetch;    -- Go back to fetch        
            
            
            
            -- The HALT instruction locks the processor until external reset occurs
            when Shalt  =>  
                nextState <= Shalt;    
  
        
        end case;  
    end process; 
  
  
  
    
    --------------------------------------------------------------------------------
    -- Control signals generation to data path and memory
    --      7 multiplexers control
    --      8 registers write enable
    --      2 memory access controls
    --------------------------------------------------------------------------------

    -- Controls the MUX connected to the PC register input
    uins.mPC <= "10" when currentState = Sfetch else    -- PC++
                "00" when currentState=Srts     else    -- Data from memory
                "01";                                   -- RALU register

    
    -- Controls the MUX connected to the SP register input
    -- The SP register employs pos-decrement for PUSH and pre-increment for POP
    uins.mSP <= '1' when  decodedInstruction=JSRR or decodedInstruction=JSR or decodedInstruction=JSRD or decodedInstruction=PUSH else  '0';
  
              
    -- Controls the MUX connected to the memory address input
    uins.mAddr <= "10" when currentState = Spush or  currentState = Ssbrt else  -- In subroutine call memory is addressed by SP to store PC
                  "01" when currentState = Sfetch else    -- In instruction fetch memory is addressed by PC
                  "00";                                   -- RALU register. Used for LD/ST instructions.

    -- Controls the MUX connected to the register file data input (inREG)
    -- Selects the data source to register file: memory (1) or RALU register (0)
    uins.mRegs <= '1' when decodedInstruction = LD or decodedInstruction = POP else '0';
       
    -- Controls the MUX inside the register file
    -- Selects which instruction register field is used as index to the read port 2 (source2)
    --      mS2 = 0: IR[3:0]
    --      mS2 = 1: IR[11:8]
    uins.mS2 <= '1' when instructionFormat2 or decodedInstruction = PUSH or currentState = Sst else '0';
 
    
    -- Controls the MUX connected to the opA ALU input
    -- The first ALU operand is the instruction register when the instruction has format 2 or 
    -- is a JUMP_A/JSR with short offset 
    uins.ma <= '1' when instructionFormat2 or decodedInstruction = JUMP_D or decodedInstruction = JSRD else '0';   

    -- Controls the MUX connected to the opB ALU input
    uins.mb <=  "01"  when  decodedInstruction = RTS or decodedInstruction = POP else   -- SP register
                
                -- in jumps and JSR instructions, the PC resgister is the ALU second operand
                "10"  when  decodedInstruction=JUMP_R or decodedInstruction=JUMP_A or decodedInstruction=JUMP_D or decodedInstruction=JSRR or decodedInstruction=JSR or decodedInstruction=JSRD  else                 
                "00";   -- RB register      

  
    -- Controls the registers writing
    uins.wPC   <= '1' when currentState = Sfetch or currentState = Sjmp or currentState = Ssbrt or currentState = Srts else '0';
    uins.wSP   <= '1' when currentState = Sldsp  or currentState = Srts or currentState = Ssbrt or currentState = Spush or currentState = Spop else '0';
    uins.wIR   <= '1' when currentState = Sfetch else '0';
    uins.wAB   <= '1' when currentState = Sreg else '0';
    uins.wRalu <= '1' when currentState = Salu else '0';
    uins.wReg  <= '1' when currentState = Swbk or currentState = Sld or currentState = Spop else '0';
    uins.wnz   <= '1' when currentState = Salu and (instructionFormat1 or decodedInstruction = ADDI or decodedInstruction = SUBI) else '0';
    uins.wcv   <= '1' when currentState = Salu and (decodedInstruction = ADD or decodedInstruction = ADDI or decodedInstruction = SUB or decodedInstruction = SUBI) else '0';
  
    
    -- Controls the memory access
    --      rw = 0: write
    --      rw = 1: read
    uins.ce <= '1' when rst = '0' and (currentState = Sfetch or currentState = Srts or currentState = Spop or currentState = Sld or currentState = Ssbrt or currentState = Spush or currentState = Sst) else '0';
    uins.rw <= '1' when currentState = Sfetch or currentState = Srts or currentState = Spop or currentState = Sld else '0';
  
end ControlPath;