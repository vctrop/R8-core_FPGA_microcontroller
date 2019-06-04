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
        LDL, LDH, LD, ST, LDSP, LDISRA, LDTSRA,  POP, PUSH, POPF, PUSHF,
        JUMP_R, JUMP_A, JUMP_D, JSRR, JSR, JSRD,
        NOP, HALT,  RTS, RTI, JMP_ISR, JMP_TSR, DIV, MUL, MFH, MFL, MFC, SWI, INVALID
    );
    type State is (Sidle, Sfetch, Sreg, Shalt, Salu, Srts, Sldsp, Sld, Sst, Swbk, Sjmp, Ssbrt, 
    Spop, Spush, Spushf, Spopf, Srti, Sintr, Smfh, Smfl, Smul, Sdiv, Sldisra, Sldtsra, Smfc, Strap);
    type RegisterArray is array (natural range <>) of std_logic_vector(15 downto 0);
    
    -- instruction type signal to facilitate boolean operations
     signal decodedInstruction : instruction;
    
    -- State registers
    signal currentState : State;
    
    -- Register file
    signal registerFile: RegisterArray(0 to 15);
    
    -- Basic registers
    signal regPC    : std_logic_vector(15 downto 0);
    signal regSP    : std_logic_vector(15 downto 0);
    signal regISRA  : std_logic_vector(15 downto 0);    --interruption subroutine address
    signal regTSRA  : std_logic_vector(15 downto 0);    --trap subroutine address
    signal regALU   : std_logic_vector(15 downto 0);
    signal regIR    : std_logic_vector(15 downto 0);
    signal regA     : std_logic_vector(15 downto 0);
    signal regB     : std_logic_vector(15 downto 0);
    
    -- Division and multiplication registers
    signal regHigh  : std_logic_vector(15 downto 0);
    signal regLow   : std_logic_vector(15 downto 0);
    
    signal mulResult   : std_logic_vector(31 downto 0);
    
    -- Register file adresses 
    signal RS1   :   integer; -- source1 register address
    signal RS2   :   integer; -- source2 register address
    signal RGT   :   integer; -- target register address
    
    -- Status flag signals
    signal N        : std_logic;
    signal Z        : std_logic;
    signal C        : std_logic;
    signal V        : std_logic;
    
    signal high_Z   : std_logic;
    signal high_N   : std_logic;
    signal low_Z    : std_logic;
    signal low_N    : std_logic;
    
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
    
    --Flag to check if the processor is currently handling an interruption or trap
    signal InterruptionStatus  : std_logic; 
    signal TrapStatus          : std_logic;
    
    --trap cause register
    --1: Invalid instruction
    --8: SYSCALL/ SWI
    --12: Signed overflow
    --15: Division by zero
    signal regCause : std_logic_vector(7 downto 0);
	signal TrapSignal : std_logic;	--signal that is set on the event of a trap. set back to 0 once the processor executes JMP_TSR pseudo instruction
	
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
                            LDSP    when regIR(15 downto 8) = x"B0" and regIR(3 downto 0) = x"7" else
                            LDISRA  when regIR(15 downto 8) = x"B1" and regIR(3 downto 0) = x"7" else
                            LDTSRA  when regIR(15 downto 8) = x"B2" and regIR(3 downto 0) = x"7" else
                            
                            PUSH    when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"A" else 
                            POP     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"9" else
                            POPF    when regIR(15 downto 12) = x"B" and regIR(7 downto 0) = x"1B" else
                            PUSHF   when regIR(15 downto 12) = x"B" and regIR(7 downto 0) = x"2B" else
                            
                            JSR     when regIR(15 downto 8) = x"C0" and regIR(3 downto 0) = x"B" else
                            JSRR    when regIR(15 downto 8) = x"C0" and regIR(3 downto 0) = x"A" else
                            JSRD    when regIR(15 downto 12) = x"F" else
                            RTS     when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"8" else
                            RTI     when regIR(15 downto 12) = x"B" and regIR(7 downto 0) = x"0B" else
                            
                            MFH     when regIR(15 downto 12) = x"B" and regIR(7 downto 0) = x"3B" else
                            MFL     when regIR(15 downto 12) = x"B" and regIR(7 downto 0) = x"4B" else
                            MFC     when regIR(15 downto 12) = x"B" and regIR(7 downto 0) = x"5B" else
                            -- -- Jump instructions (18). 
                            -- -- Here the status flags are tested to jump or not 
                            JUMP_R  when regIR(15 downto 8) = x"C0" and (
                                     regIR(3 downto 0) = x"0" or                           -- JMPR
                                    (regIR(3 downto 0) = x"1" and negativeFlag = '1') or   -- JMPNR
                                    (regIR(3 downto 0) = x"2" and zeroFlag = '1') or       -- JMPZR
                                    (regIR(3 downto 0) = x"3" and carryFlag = '1') or      -- JMPCR
                                    (regIR(3 downto 0) = x"4" and overflowFlag = '1')      -- JMPVR
                                    ) else 
					
                            JUMP_A  when regIR(15 downto 8) = x"C0" and (
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
							
							--failed jumps are decoded as NOP
                            NOP  	when (regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"5") or 	-- NOP
									regIR(15 downto 8) = x"C0" or regIR(15 downto 12) = x"E" 			-- Failed jump
									else   									
									
                            MUL     when regIR(15 downto 8) = x"C1" else
                            DIV     when regIR(15 downto 8) = x"C2" else
                            
                            SWI     when regIR = x"B0EB" else                                      --software kernel trap / software interrupt
							JMP_TSR when regIR = x"B0DB" else									   --reserved for TRAP handler jump
                            JMP_ISR when regIR = x"B0FB" else                                      --reserved for interruption handler jump
                            INVALID;

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
            regSP           <= x"7FFF";                     -- conventional stack start adress
            regISRA         <= x"0040";          			-- conventional handler address           
            regTSRA         <= x"0040";
            regALU          <= (others => '0');
            regIR           <= (others => '0');
            regA            <= (others => '0');
            regB            <= (others => '0');
            regHigh         <= (others => '0');
            regLow          <= (others => '0');
            regFlags        <= (others => '0');
            regCause        <= (others => '0');
            TrapStatus         <= '0';
            InterruptionStatus <= '0';
			TrapSignal 		   <= '0';
            
        elsif rising_edge(clk) then    
            case currentState is
                when Sidle =>
                    currentState <= Sfetch;
           
                when Sfetch =>
					if TrapSignal = '1' and TrapStatus = '0' then
						regIR <= x"B0DB";										--JMP_TSR microinstruction 
						currentState <= Strap;
						TrapSignal <= '0';
						TrapStatus <= '1';
                    elsif intr ='1' and InterruptionStatus = '0' and TrapStatus = '0' then 
                        InterruptionStatus <= '1';
                        currentState <= Sintr; 
                        regIR <= x"B0FB";                                  			--JMP_ISR microinstruction   
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
                    elsif decodedInstruction = MUL then
                        currentState <= Smul;
                    elsif decodedInstruction = DIV then
                        currentState <= Sdiv;
					elsif decodedInstruction = MFH then
						currentState <= Smfh;
					elsif decodedInstruction = MFL then
						currentState <= Smfl;
                    elsif decodedInstruction = MFC then
						currentState <= Smfc;
					elsif decodedInstruction = SWI then
						TrapSignal <= '1';
						regCause <= x"08";
						currentState <= Sfetch;
					elsif decodedInstruction = INVALID or decodedInstruction = JMP_TSR or decodedInstruction = JMP_ISR then -- if the processor decodes a JMP_TSR or JMP_ISR and reaches this state, it is an invalid instruction
						TrapSignal <= '1';
						regCause <= x"01";
						currentState <= Sfetch;
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
                        
                    elsif decodedInstruction = LDISRA then   
                        currentState <= Sldisra;
                        
                    elsif decodedInstruction = LDTSRA then   
                        currentState <= Sldtsra;
					
					elsif (decodedInstruction = ADD or decodedInstruction = ADDI or decodedInstruction = SUB or decodedInstruction = SUBI) and V = '1'  then
						currentState <= Sfetch;
						TrapSignal <= '1';
						regCause <= x"0C";
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
					if TrapStatus = '1' then						  -- if trap is being handled, clear trap status
						TrapStatus <= '0';
					else 
						InterruptionStatus <= '0';                     -- if interruption is being handled, clear intr status
					end if;
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
                    regPC <= regISRA;
                    currentState <= Sfetch;
				
				when Strap =>
                    regSP <= std_logic_vector(unsigned(regSP)-1);
                    regPC <= regTSRA;
                    currentState <= Sfetch;
					
                when Smfh =>
                    registerFile(RGT) <= regHigh;
                    currentState <= Sfetch;
                    negativeFlag <= high_N;
                    zeroFlag <= high_Z;
                
                when Smfl =>
                    registerFile(RGT) <= regLow;
                    currentState <= Sfetch;
                    negativeFlag <= low_N;
                    zeroFlag <= low_Z;
                    
                when Smfc =>
                    registerFile(RGT) <= x"00" & regCause;
                    currentState <= Sfetch;
                    
                when Smul =>
                    regHigh <= mulResult(31 downto 16);
                    regLow  <= mulResult(15 downto 0);
                    currentState <= Sfetch;
                    
                when Sdiv =>
                    if regB = x"0000" then  
						TrapSignal <= '1';			-- zero division trap
						regCause <= x"0F";
					else
                        regHigh <= std_logic_vector(unsigned(regA) mod unsigned(regB));
                        regLow  <= std_logic_vector(signed(regA)  /  signed(regB));
                    end if;
                    currentState <= Sfetch;
                    
                when Sldisra =>
                    regISRA <= regALU;
                    currentState <= Sfetch;
                    
                when Sldtsra =>
                    regTSRA <= regALU;
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
                        regPC               when decodedInstruction = JUMP_R or decodedInstruction = JUMP_A or decodedInstruction=JUMP_D or decodedInstruction=JSRR or decodedInstruction=JSR or decodedInstruction=JSRD  or decodedInstruction = JMP_ISR or decodedInstruction = JMP_TSR else
                        (x"000" & regFlags) when decodedInstruction = PUSHF else
                        regB;
    
    negativeA <= '0' & std_logic_vector(signed(not opA(15 downto 0)) + 1);
    negativeB <= '0' & std_logic_vector(signed(not opB(15 downto 0)) + 1);
    
    mulResult <=    std_logic_vector(signed(regA) *  signed(regB)) when decodedInstruction = MUL else
                    x"00000000";
    
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
                opA                                                         when decodedInstruction = LDSP or decodedInstruction = LDISRA or decodedInstruction = JUMP_A  or decodedInstruction = JSR else
                std_logic_vector(unsigned(opB)      +   1)                  when decodedInstruction = POP   or decodedInstruction = POPF    or decodedInstruction = RTS or decodedInstruction = RTI else
                std_logic_vector(signed(opA)        +   signed(negativeB))  when decodedInstruction = SUB   else 
                std_logic_vector(signed(negativeA)  +   signed(opB))        when decodedInstruction = SUBI  else
                std_logic_vector(signed(opA)        +   signed(opB));
    
    -- Combinatorial flag attribution
    N <= '1' when (ALUout(15) = '1')                    else '0';
    Z <= '1' when (unsigned(ALUout(15 downto 0)) = 0)   else '0';
    C <= '1' when (ALUout(16) = '1')                    else '0';     
    V <= ((not msbA) and  (not msbB) and msbOut) or (msbA and      msbB  and (not msbOut)) when decodedInstruction = ADD or decodedInstruction = ADDI       else        -- overflow under addition
         ((not msbA) and       msbB  and msbOut) or (msbA and (not msbB) and (not msbOut)) when decodedInstruction = SUB                                    else        -- overflow under subtraction
         ((not msbB) and       msbA  and msbOut) or (msbB and (not msbA) and (not msbOut));
    
    high_N  <= '1' when (regHigh(15) = '1')     else '0';
    low_N   <= '1' when (regLow(15) = '1')      else '0';
    high_Z  <= '1' when (unsigned(regHigh) = 0) else '0';
    low_Z   <= '1' when (unsigned(regLow) = 0)  else '0';
    
    
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
