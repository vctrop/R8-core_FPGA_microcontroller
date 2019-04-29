-------------------------------------------------------------------------
--
--  R8 PROCESSOR   -  GOLD VERSION  -  05/JAN/2017
--
--  Moraes          - 30/09/2001 - project start
--  Moraes          - 22/11/2001 - instruction decoding bug correction
--  Moraes          - 22/03/2002 - store instruction correction            
--  Moraes          - 05/04/2003 - SIDLE state inclusion in the control unit
--  Calazans        - 02/05/2003 - translation of comments to English. Names of some signals, entities, etc have been changed accordingly
--  Carara          - 01/03/2013 - project split in several files. Each entity is described in a file with the same name.
--  Carara          - 05/01/2017 - library std_logic_unsigned replaced by numeric_std
--  Julio/Victor    - 27/03/2019 - full behavioral implementation
--  Julio/Victor    - 27/04/2019 - added interruption support, rti, pushf and popf instructions
--  Notes: 1) In this version, the structural register bank is designed using for-generate VHDL construction
--         2) The top-level R8 entity is
--
--      entity R8 is
--            port( clk,rst     : in std_logic;
--                  data_in     : in  std_logic_vector(15 downto 0);    -- Data from memory
--                  data_out    : out std_logic_vector(15 downto 0);    -- Data to memory
--                  address     : out std_logic_vector(15 downto 0);    -- Address to memory
--                  ce,rw       : out std_logic );                      -- Memory control
--      end R8;
-- 
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- Design unit: R8
-- Description: Top-level instantiation of the R8 data and control paths
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity R8 is
    generic(
        INTERRUPT_HANDLER_ADDR : std_logic_vector(15 downto 0) := x"000f"
    );
    port( 
        clk     : in std_logic;
        rst     : in std_logic;
        
        -- Memory interface
        data_in : in std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(15 downto 0);
        address : out std_logic_vector(15 downto 0);
        ce      : out std_logic;
        rw      : out std_logic; 
        
        --interruption interface
        intr     : in std_logic
    );
end R8;

architecture behavioral of R8 is
    -- type definitions
    type Instruction is ( 
        ADD, SUB, AAND, OOR, XXOR, ADDI, SUBI, NOT_A, 
        SL0, SL1, SR0, SR1,
        LDL, LDH, LD, ST, LDSP, POP, PUSH, POPF, PUSHF,
        JUMP_R, JUMP_A, JUMP_D, JSRR, JSR, JSRD,
        NOP, HALT,  RTS, RTI, JMP_INTR
    );
    type State is (Sidle, Sfetch, Sreg, Shalt, Salu, Srts, Sldsp, Sld, Sst, Swbk, Sjmp, Ssbrt, Spop, Spush, Spushf, Spopf, Sisr, Srti, Sintr);
    type RegisterArray is array (natural range <>) of std_logic_vector(15 downto 0);
    
    -- instruction type signal to facilitate boolean operations
     signal decodedInstruction : instruction;
    
    -- State registers
    signal currentState : State;
    
    -- Register file
    signal registerFile: RegisterArray(0 to 15);
    
    -- Basic registers
    signal regPC  : std_logic_vector(15 downto 0);
    signal regSP  : std_logic_vector(15 downto 0);
    signal regALU : std_logic_vector(15 downto 0);
    signal regIR  : std_logic_vector(15 downto 0);
    signal regA   : std_logic_vector(15 downto 0);
    signal regB   : std_logic_vector(15 downto 0);
    
    -- Register file adresses 
    signal RS1   :   integer; -- source1 register address
    signal RS2   :   integer; -- source2 register address
    signal RGT   :   integer; -- target register address
    
    -- Status flag signals
    signal N        : std_logic;
    signal Z        : std_logic;
    signal C        : std_logic;
    signal V        : std_logic;
    
    -- Status flags register
    signal regFlags     : std_logic_vector(3 downto 0);
    alias negativeFlag  : std_logic is regFlags(0);
    alias zeroFlag      : std_logic is regFlags(1);
    alias carryFlag     : std_logic is regFlags(2);
    alias overflowFlag  : std_logic is regFlags(3);
    
    --ALU signals for flag evaluation with an extra bit
    signal ALUout, opA, opB     :   std_logic_vector(16 downto 0);
    alias msbOut                :   std_logic is ALUout(15); 
    alias msbA                  :   std_logic is opA(15);
    alias msbB                  :   std_logic is opB(15);
    
    -- necessary signals for overflow evaluation on SUB and SUBI instructions
    signal negativeA                 :   std_logic_vector(16 downto 0);		-- (negativeA = - opA)  
    signal negativeB                 :   std_logic_vector(16 downto 0);

	-- Displacement extension
    signal ext_displacement_JMP_D   : std_logic_vector(15 downto 0);
    signal ext_displacement_JSRD    : std_logic_vector(15 downto 0);
	
	
    -- Instructions formats
    --      1: The target register is not source
    --      2: The target register is ALSO source
    signal instructionFormat1, instructionFormat2: boolean;
    
    --Flag to check if the processor is currently handling an interruption
    signal InterruptionStatus  : std_logic;       

begin
    -- Instruction decoding
    decodedInstruction <=   ADD     when regIR(15 downto 12) = x"0" else                               
                            SUB     when regIR(15 downto 12) = x"1" else                               
                            AAND    when regIR(15 downto 12) = x"2" else                               
                            OOR     when regIR(15 downto 12) = x"3" else                               
                            XXOR    when regIR(15 downto 12) = x"4" else 
                            ADDI    when regIR(15 downto 12) = x"5" else
                            SUBI    when regIR(15 downto 12) = x"6" else
                            LDL     when regIR(15 downto 12) = x"7" else
                            LDH     when regIR(15 downto 12) = x"8" else
                            LD      when regIR(15 downto 12) = x"9" else
                            ST      when regIR(15 downto 12) = x"A" else
                            SL0     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"0" else
                            SL1     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"1" else
                            SR0     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"2" else
                            SR1     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"3" else
                            NOT_A   when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"4" else                              
                            HALT    when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"6" else
                            LDSP    when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"7" else
                            
                            PUSH    when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"A" else 
                            POP     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"9" else
                            POPF    when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"C" else
                            PUSHF   when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"D" else
                            
                            JSR     when regIR(15 downto 12) = x"C" and regIR(3 downto 0) = x"B" else
                            JSRR    when regIR(15 downto 12) = x"C" and regIR(3 downto 0) = x"A" else
                            JSRD    when regIR(15 downto 12) = x"F" else
                            RTS     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"8" else
                            RTI     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"B" else

                            -- -- Jump instructions (18). 
                            -- -- Here the status flags are tested to jump or not
                            JUMP_R  when regIR(15 downto 12) = x"C" and (
                                     regIR(3 downto 0) = x"0" or                           -- JMPR
                                    (regIR(3 downto 0) = x"1" and negativeFlag = '1') or   -- JMPNR
                                    (regIR(3 downto 0) = x"2" and zeroFlag = '1') or       -- JMPZR
                                    (regIR(3 downto 0) = x"3" and carryFlag = '1') or      -- JMPCR
                                    (regIR(3 downto 0) = x"4" and overflowFlag = '1')      -- JMPVR
                                    ) else 

                            JUMP_A  when regIR(15 downto 12) = x"C" and (
                                     regIR(3 downto 0) = x"5" or                           -- JMP
                                    (regIR(3 downto 0) = x"6" and negativeFlag = '1') or   -- JMPN
                                    (regIR(3 downto 0) = x"7" and zeroFlag = '1') or       -- JMPZ
                                    (regIR(3 downto 0) = x"8" and carryFlag = '1') or      -- JMPC
                                    (regIR(3 downto 0) = x"9" and overflowFlag = '1')      -- JMPV
                                    ) else 

                            JUMP_D  when regIR(15 downto 12) = x"D" or (                           -- JMPD
                                        regIR(15 downto 12) = x"E" and ( 
                                            (regIR(11 downto 10) = "00" and negativeFlag = '1') or -- JMPND
                                            (regIR(11 downto 10) = "01" and zeroFlag = '1') or     -- JMPZD
                                            (regIR(11 downto 10) = "10" and carryFlag = '1') or    -- JMPCD
                                            (regIR(11 downto 10) = "11" and overflowFlag = '1')    -- JMPVD
                                        )   
                                    )  else 

                            JMP_INTR when regIR = x"B00E" else                                      --reserved for interruption handler jump
                            NOP;

    -- The target register is not source
    instructionFormat1 <= true when decodedInstruction=ADD or decodedInstruction=SUB or decodedInstruction=AAND or decodedInstruction=OOR or decodedInstruction=XXOR or decodedInstruction=NOT_A or decodedInstruction=SL0 or decodedInstruction=SR0 or decodedInstruction=SL1 or decodedInstruction=SR1 else false;
    -- The target register is ALSO source
    instructionFormat2 <= true when decodedInstruction=ADDI or decodedInstruction=SUBI or decodedInstruction=LDL or decodedInstruction=LDH else false; 
    
    -- Sequential logic
    process(rst, clk)
    begin
        if rst = '1' then
            currentState <= Sidle;
            registerFile    <= (others => (others=>'0'));	
            regPC           <= (others => '0');
            regSP           <= x"7FFF";                     --conventional stack start adress
            regALU          <= (others => '0');
            regIR           <= (others => '0');
            regA            <= (others => '0');
            regB            <= (others => '0');
            regFlags        <= (others => '0');
            InterruptionStatus <= '0';
            
        elsif rising_edge(clk) then    
            case currentState is
                when Sidle =>
                    currentState <= Sfetch;
           
                when Sfetch =>
                    if intr ='1' and InterruptionStatus = '0' then
                        InterruptionStatus <= '1';
                        currentState <= Sintr; 
                        regIR <= x"B00E";                                       --JMP_INTR microinstruction   
                    else    
                        regIR <= data_in;                                       -- regIR <= MEM[ADDRESS]
                        regPC <= std_logic_vector(unsigned(regPC)+1);           -- PC++
                        currentState <= Sreg;
                    end if;
                    

                when Sreg =>
                    regA <= registerFile(RS1);
                    regB <= registerFile(RS2);
                    
                    if decodedInstruction = HALT then
                        currentState <= Shalt;
                    else
                       currentState <= Salu;
                    end if;
                    
                when Salu =>
                    if (instructionFormat1 or decodedInstruction = ADDI or decodedInstruction = SUBI) then
                        zeroFlag <= Z;
                        negativeFlag <= N;
                    end if;
                    if (decodedInstruction = ADD or decodedInstruction = ADDI or decodedInstruction = SUB or decodedInstruction = SUBI) then
                        overflowFlag <= V;
                        carryFlag <= C;
                    end if;
                    
                    regALU <= ALUout(15 downto 0);
                
                    -- Next state logic
                    if decodedInstruction = PUSH then   
                        currentState <= Spush;
                
                    elsif decodedInstruction = POP then   
                        currentState <= Spop;
                    
                    elsif decodedInstruction = RTS then   
                        currentState <= Srts;

                    elsif decodedInstruction = RTI then   
                        currentState <= Srti;        

                    elsif decodedInstruction = LDSP then   
                        currentState <= Sldsp;
                    
                    elsif decodedInstruction = LD then   
                        currentState <= Sld;
                          
                    elsif decodedInstruction = ST then   
                        currentState <= Sst;
                          
                    elsif instructionFormat1 or instructionFormat2 then   
                        currentState <= Swbk;
                    
                    elsif decodedInstruction = JUMP_R or decodedInstruction = JUMP_A or decodedInstruction = JUMP_D then   
                        currentState <= Sjmp;
                          
                    elsif decodedInstruction = JSRR or decodedInstruction = JSR or decodedInstruction = JSRD then   
                        currentState <= Ssbrt; 
                        
                    elsif decodedInstruction = PUSHF then
                        currentState <= Spushf;
                        
                    elsif decodedInstruction = POPF then
                        currentState <= Spopf;

                    else                                -- ** ATTENTION ** NOP and jumps with corresponding flag=0 execute in just 3 clock cycles 
                        currentState <= Sfetch;   
                    end if;
                    
                when Swbk =>
                    registerFile(RGT) <= regALU;
                    currentState <= Sfetch;
					
				when Sld =>
					registerFile(RGT) <= data_in;
					currentState <= Sfetch;
					
				when Sst =>
					currentState <= Sfetch;
					
				when Sjmp =>
					regPC <= regALU;				-- Only jumps that pass the conditional test reach this state
					currentState <= Sfetch;
                    
                when Sldsp =>
                    regSP <= regALU;
                    currentState <= Sfetch;
                    
                when Ssbrt =>
                    regPC <= regALU;
                    regSP <= std_logic_vector(unsigned(regSP)-1);
                    currentState <= Sfetch;
                    
                when Srts =>
                    regPC <= data_in;
                    regSP <= regALU;
                    currentState <= Sfetch;
                
                when Srti =>
                    InterruptionStatus <= '0';                     --returns from interruption
                    regPC <= data_in;
                    regSP <= regALU;
                    currentState <= Sfetch;
                
                when Spush =>
                    regSP <= std_logic_vector(unsigned(regSP)-1);   -- Doesn't use ALU because the decrement hardware is needed anyway (Ssbrt)
                    currentState <= Sfetch;
                
                when Spop =>
                    registerFile(RGT) <= data_in;
                    regSP <= regALU;
                    currentState <= Sfetch;
                    
                when Spushf =>
                    regSP <= std_logic_vector(unsigned(regSP)-1);
                    currentState <= Sfetch;
                    
                when Spopf =>
                    regFlags <= data_in(3 downto 0);
                    regSP <= regALU;
                    currentState <= Sfetch;
                    
                when Sintr =>
                    regSP <= std_logic_vector(unsigned(regSP)-1);
                    regPC <= INTERRUPT_HANDLER_ADDR;
                    currentState <= Sfetch;

                when others  =>
                    currentState <= Shalt;              --HALT loops forever
                
                
            end case;
        end if;
    
    end process;
    
	-- extend displacement for JMP_D and JSRD operations
    ext_displacement_JMP_D  <= std_logic_vector(resize(signed(regIR(9 downto 0)), regIR'length));
    ext_displacement_JSRD   <= std_logic_vector(resize(signed(regIR(11 downto 0)), regIR'length));
    
    --ALU operator selection
    opA(16) <= '0';                     -- extra bit for evaluating carry flag
    opB(16) <= '0';
 
    opA(15 downto 0) <= (x"00" & regIR(7 downto 0)) 	            when instructionFormat2             else
                        ext_displacement_JMP_D                      when decodedInstruction = JUMP_D    else
                        ext_displacement_JSRD                       when decodedInstruction = JSRD      else 
                        regA;
                        
    opB(15 downto 0) <= regSP               when decodedInstruction = RTS or decodedInstruction = RTI or decodedInstruction = POP or decodedInstruction = POPF else
                        regPC               when decodedInstruction = JUMP_R or decodedInstruction = JUMP_A or decodedInstruction=JUMP_D or decodedInstruction=JSRR or decodedInstruction=JSR or decodedInstruction=JSRD  or decodedInstruction = JMP_INTR else
                        (x"000" & regFlags) when decodedInstruction = PUSHF else
                        regB;
    
    negativeA <= '0' & std_logic_vector(signed(not opA(15 downto 0)) + 1);
    negativeB <= '0' & std_logic_vector(signed(not opB(15 downto 0)) + 1);
    
    ALUout <=   opA and opB                                                 when decodedInstruction = AAND  else  
                opA or  opB                                                 when decodedInstruction = OOR   else   
                opA xor opB                                                 when decodedInstruction = XXOR  else
                opB(16 downto 8) & opA(7 downto 0)  	                    when decodedInstruction = LDL   else  -- A: immediate operand (wrapped in the instruction)
                opA(8 downto 0)  & opB(7 downto 0)  	                    when decodedInstruction = LDH   else  -- A: immediate operand (wrapped in the instruction)
                opA(15 downto 0) & '0'            	                        when decodedInstruction = SL0   else  -- We use an extra bit in shift instructions to check flags
                opA(15 downto 0) & '1'            	                        when decodedInstruction = SL1   else
                "00" & opA(15 downto 1)            	                        when decodedInstruction = SR0   else
                "01" & opA(15 downto 1)            	                        when decodedInstruction = SR1   else
                not opA                           	                        when decodedInstruction = NOT_A else 
                opA                                                         when decodedInstruction = LDSP  or decodedInstruction = JUMP_A  or decodedInstruction = JSR else
                std_logic_vector(unsigned(opB)      +   1)                  when decodedInstruction = POP   or decodedInstruction = POPF    or decodedInstruction = RTS or decodedInstruction = RTI else
                std_logic_vector(signed(opA)        +   signed(negativeB))  when decodedInstruction = SUB   else 
                std_logic_vector(signed(negativeA)  +   signed(opB))        when decodedInstruction = SUBI  else
                std_logic_vector(signed(opA)        +   signed(opB));
                
    N <= '1' when (ALUout(15) = '1')                    else '0';
    Z <= '1' when (unsigned(ALUout(15 downto 0)) = 0)   else '0';
    C <= '1' when (ALUout(16) = '1')                    else '0';     
    V <= ((not msbA) and  (not msbB) and msbOut) or (msbA and      msbB  and (not msbOut)) when decodedInstruction = ADD or decodedInstruction = ADDI       else        -- overflow under addition
         ((not msbA) and       msbB  and msbOut) or (msbA and (not msbB) and (not msbOut)) when decodedInstruction = SUB                                    else        -- overflow under subtraction
         ((not msbB) and       msbA  and msbOut) or (msbB and (not msbA) and (not msbOut));
    
    -- Register file access address
    RS1 <= to_integer(unsigned(regIR(7 downto 4)));
    RS2 <= to_integer(unsigned(regIR(11 downto 8))) when instructionFormat2 or decodedInstruction = PUSH or currentState = Sst else
           to_integer(unsigned(regIR(3 downto 0)));
    RGT <= to_integer(unsigned(regIR(11 downto 8)));
    
    -- Memory access interface
    ce <= '1' when rst = '0' and (currentState = Sfetch or currentState = Srts or currentState = Srti or currentState = Spop or currentState = Sld or currentState = Ssbrt or currentState = Spush or currentState = Sst or currentState = Spushf or currentState = Spopf or currentState = Sintr) else '0';
    rw <= '1' when currentState = Sfetch or currentState = Srts or currentState = Srti or currentState = Spop or currentState = Sld or currentState = Spopf  else '0';
	
	address <= 	regSP   when currentState = Spush or currentState = Ssbrt or currentState = Spushf  or currentState = Sintr  else
				regPC   when currentState = Sfetch  else
				regALU;
    
    data_out <= registerFile(RS2) when decodedInstruction = ST else
                opB(15 downto 0);
	
end behavioral;
