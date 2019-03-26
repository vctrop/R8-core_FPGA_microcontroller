-------------------------------------------------------------------------
--
--  R8 PROCESSOR   -  GOLD VERSION  -  05/JAN/2017
--
--  moraes - 30/09/2001  - project start
--  moraes - 22/11/2001  - instruction decoding bug correction
--  moraes - 22/03/2002  - store instruction correction            
--  moraes - 05/04/2003  - SIDLE state inclusion in the control unit
--  calazans - 02/05/2003  - translation of comments to English. Names of
--    some signals, entities, etc have been changed accordingly
--  carara - 03/2013 - project split in several files. Each entity is described in a file with the same name.
--  carara - 5/01/2017 - library std_logic_unsigned replaced by numeric_std
--
-- 
--  Notes: 1) In this version, the register bank is designed using 
--    for-generate VHDL construction
--         2) The top-level R8 entity is
--
--      entity R8 is
--            port( clk,rst: in std_logic;
--                  data_in:  in  std_logic_vector(15 downto 0);    -- Data from memory
--                  data_out: out std_logic_vector(15 downto 0);    -- Data to memory
--                  address: out std_logic_vector(15 downto 0);     -- Address to memory
--                  ce,rw: out std_logic );                         -- Memory control
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
use work.R8_pkg.all;

entity R8 is
    port( 
        clk     : in std_logic;
        rst     : in std_logic;
        
        -- Memory interface
        data_in : in std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(15 downto 0);
        address : out std_logic_vector(15 downto 0);
        ce      : out std_logic;
        rw      : out std_logic 
    );
end R8;

architecture behavioral of R8 is
    type State is (Sidle, Sfetch, Sreg, Shalt, Salu, Srts, Spop, Sldsp, Sld, Sst, Swbk, Sjmp, Ssbrt, Spush);
    type RegisterArray is array (natural range <>) of std_logic_vector(15 downto 0);
    
    -- 
     signal decodedInstruction : instruction;
    
    -- State registers
    signal currentState : State;
    
    -- Register file
    signal registerFile: RegisterArray(0 to 15);
    
    -- Basic registers
    signal regPC  : std_logic_vector(15 downto 0);
    signal regSP  : std_logic_vector(15 downto 0);
    signal regULA : std_logic_vector(15 downto 0);
    signal regIR  : std_logic_vector(15 downto 0);
    signal regA   : std_logic_vector(15 downto 0);
    signal regB   : std_logic_vector(15 downto 0);
    
    -- Register file indices 
    signal RS1   :   integer; --std_logic_vector(3 downto 0); -- is regIR(7 downto 4);
    signal RS2   :   integer; --std_logic_vector(3 downto 0); -- is regIR(3 downto 0);
    signal RGT   :   integer; --std_logic_vector(3 downto 0); -- is regIR(11 downto 8);
    
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
    
    --ALU signal for flag evaluation with an extra bit
    signal ALUout, opA, opB     :   std_logic_vector(16 downto 0);
    alias msbA                  :   std_logic is opA(15);
    alias msbB                  :   std_logic is opB(15);
    alias msbOut                :   std_logic is ALUout(15); 
       
    signal notB                 :   std_logic_vector(16 downto 0);

    -- Instructions formats
    --      1: The target register is not source
    --      2: The target register is ALSO source
    signal instructionFormat1, instructionFormat2: boolean;

begin
    
    -- Instruction decodification
    decodedInstruction <=   ADD     when regIR(15 downto 12) = x"0" else                               -- Log/arit 3 reg
                            SUB     when regIR(15 downto 12) = x"1" else                               -- Log/arit 3 reg
                            AAND    when regIR(15 downto 12) = x"2" else                               -- Log/arit 3 reg
                            OOR     when regIR(15 downto 12) = x"3" else                               -- Log/arit 3 reg
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
                            NOT_A   when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"4" else                              -- Log/arit 3 reg
                            HALT    when regIR(15 downto 12) = x"B" and regIR(3 downto 0) = x"6" else
                            -- LDSP    when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"7" else
                            -- RTS     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"8" else
                            -- POP     when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"9" else
                            -- PUSH    when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"A" else 
               
                            -- -- Jump instructions (18). 
                            -- -- Here the status flags are tested to jump or not
                            -- JUMP_R  when ir(15 downto 12) = x"C" and (
                                     -- ir(3 downto 0) = x"0" or                           -- JMPR
                                    -- (ir(3 downto 0) = x"1" and negativeFlag = '1') or   -- JMPNR
                                    -- (ir(3 downto 0) = x"2" and zeroFlag = '1') or       -- JMPZR
                                    -- (ir(3 downto 0) = x"3" and carryFlag = '1') or      -- JMPCR
                                    -- (ir(3 downto 0) = x"4" and overflowFlag = '1')      -- JMPVR
                                    -- ) else 

                            -- JUMP_A  when ir(15 downto 12) = x"C" and (
                                     -- ir(3 downto 0) = x"5" or                           -- JMP
                                    -- (ir(3 downto 0) = x"6" and negativeFlag = '1') or   -- JMPN
                                    -- (ir(3 downto 0) = x"7" and zeroFlag = '1') or       -- JMPZ
                                    -- (ir(3 downto 0) = x"8" and carryFlag = '1') or      -- JMPC
                                    -- (ir(3 downto 0) = x"9" and overflowFlag = '1')      -- JMPV
                                    -- ) else 

                            -- JUMP_D  when ir(15 downto 12) = x"D" or (                           -- JMPD
                                        -- ir(15 downto 12) = x"E" and ( 
                                            -- (ir(11 downto 10) = "00" and negativeFlag = '1') or -- JMPND
                                            -- (ir(11 downto 10) = "01" and zeroFlag = '1') or     -- JMPZD
                                            -- (ir(11 downto 10) = "10" and carryFlag = '1') or    -- JMPCD
                                            -- (ir(11 downto 10) = "11" and overflowFlag = '1')    -- JMPVD
                                        -- )   
                                    -- )  else 

                            -- JSRR  when ir(15 downto 12) = x"C" and ir(3 downto 0) = x"A" else
                            -- JSR   when ir(15 downto 12) = x"C" and ir(3 downto 0) = x"B" else
                            -- JSRD  when ir(15 downto 12) = x"F" else
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
            regSP           <= (others => '0');
            regULA          <= (others => '0');
            regIR           <= (others => '0');
            regA            <= (others => '0');
            regB            <= (others => '0');
            regFlags        <= (others => '0');
            
        elsif rising_edge(clk) then    
            case currentState is
                when Sidle =>
                    currentState <= Sfetch;
           
                when Sfetch =>
                    regPC <= std_logic_vector(unsigned(regPC)+1);       -- PC++
                    regIR <= data_in;                                   -- IR <= MEM[ADDRESS]
                    currentState <= Sreg;
                    
                when Sreg =>
                    regA <= registerFile(RS1);
                    regB <= registerFile(RS2);
                    
                    if decodedInstruction = HALT then      -- HALT fount => stop generating microinstructions
                        currentState <= Shalt;
                    else
                       currentState <= Salu;
                    end if;
                    
                when Salu =>
                    
                    --flag register writing for certain instructions
                    if (instructionFormat1 or decodedInstruction = ADDI or decodedInstruction = SUBI) then
                        zeroFlag <= Z;
                        negativeFlag <= N;
                    end if;
                    if (decodedInstruction = ADD or decodedInstruction = ADDI or decodedInstruction = SUB or decodedInstruction = SUBI) then
                        overflowFlag <= V;
                        carryFlag <= C;
                    end if;
                    
                    regULA <= ALUout(15 downto 0);
                
                    --next state logic
                    if decodedInstruction = PUSH then   
                    currentState <= Spush;
                
                    elsif decodedInstruction = POP then   
                        currentState <= Spop;
                    
                    elsif decodedInstruction = RTS then   
                        currentState <= Srts;
                
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
                
                    else    -- ** ATTENTION ** NOP and jumps with corresponding flag=0 execute in just 3 clock cycles 
                        currentState <= Sfetch;   
                    end if;
                    
                when Swbk =>
                    registerFile(RGT) <= regULA;
                    currentState <= Sfetch;
					
				when Sld =>
					registerFile(RGT) <= data_in;
					currentState <= Sfetch;
					
				when Sst =>
					currentState <= Sfetch;
 		--TODO: *ATENTION!!!!!!* THIS MUST BE CHANGED TO:
		--when Shalt =>
		--WHEN EVERY SINGLE INSTRUCTION IS IMPLEMENTED!!!
                when others  =>
                    currentState <= Shalt;              --HALT loops forever
                
                
            end case;
        end if;
    
    end process;
    
    --ULA operator selection
    opA(16) <= '0';             --extra bit for considering carry and overload
    opB(16) <= '0';
 
    opA(15 downto 0) <= (x"00" & regIR(7 downto 0)) when instructionFormat2 or decodedInstruction = JUMP_D or decodedInstruction = JSRD else
                        regA;
                        
    opB(15 downto 0) <= regSP when decodedInstruction = RTS or decodedInstruction = POP else
                        regPC when decodedInstruction=JUMP_R or decodedInstruction=JUMP_A or decodedInstruction=JUMP_D or decodedInstruction=JSRR or decodedInstruction=JSR or decodedInstruction=JSRD  else
                        regB;
    notB <= '0' & std_logic_vector(signed(not opB(15 downto 0)) + 1);
    
    --TODO: IMPLEMENTAR O RESTO DAS INSTRUÇÕES DA ULA QUANDO ADICIONARMOR SUPORTE A MAIS INSTRUÇÕES    
    ALUout <=   opA and opB                                     when decodedInstruction = AAND  else  
                opA or  opB                                     when decodedInstruction = OOR   else   
                opA xor opB                                     when decodedInstruction = XXOR  else
                opB(16 downto 8) & opA(7 downto 0)  	        when decodedInstruction = LDL            else  -- A: immediate operand (wrapped in the instruction)
                opA(8 downto 0)  & opB(7 downto 0)  	        when decodedInstruction = LDH            else  -- A: immediate operand (wrapped in the instruction)
                opA(15 downto 0) & '0'            	            when decodedInstruction = SL0            else  -- We use an extra bit in shift instructions to check flags
                opA(15 downto 0) & '1'            	            when decodedInstruction = SL1            else
                "00" & opA(15 downto 1)            	            when decodedInstruction = SR0            else
                "01" & opA(15 downto 1)            	            when decodedInstruction = SR1            else
                not opA                           	            when decodedInstruction = NOT_A          else 
                std_logic_vector(signed(opA) +   signed(notB))   when decodedInstruction = SUB or decodedInstruction = SUBI else
                std_logic_vector(signed(opA) +   signed(opB));
                
    N <= '1' when (ALUout(15) = '1') else '0';
    Z <= '1' when (unsigned(ALUout(15 downto 0)) = 0) else '0';
    C <= '1' when (ALUout(16) = '1') else '0';
    -- TODO: IMPLEMENTAR MESMA LÓGICA DE OVERFLOW PARA INSTRUÇÕES IMEDIATAS (ADDI, SUBI)
    V <= ((not msbA) and  (not msbB) and msbOut) or (msbA and      msbB  and (not msbOut)) when decodedInstruction = ADD      else              -- overflow under addition
         ((not msbA) and       msbB  and msbOut) or (msbA and (not msbB) and (not msbOut)) when decodedInstruction = SUB;                       -- overflow under subtraction
    
    -- Register file access address
    RS1 <= to_integer(unsigned(regIR(7 downto 4)));
    RS2 <= to_integer(unsigned(regIR(11 downto 8))) when instructionFormat2 or decodedInstruction = PUSH or currentState = Sst else
           to_integer(unsigned(regIR(3 downto 0)));
    RGT <= to_integer(unsigned(regIR(11 downto 8)));
    
    -- Memory access interface
    ce <= '1' when rst = '0' and (currentState = Sfetch or currentState = Srts or currentState = Spop or currentState = Sld or currentState = Ssbrt or currentState = Spush or currentState = Sst) else '0';
    rw <= '1' when currentState = Sfetch or currentState = Srts or currentState = Spop or currentState = Sld else '0';
	
	address <= 	regSP when currentState = Spush or  currentState = Ssbrt else
				regPC when currentState = Sfetch else
				regULA;
    
	--data out recieves data directly read from register file when operation is ST, otherwise opB **ATTENTION** ANY CHANGES TO opb MAY AFFECT THIS!!!!!
	data_out <= registerFile(RS2) when regIR(15 downto 12) = x"A" else opB(15 downto 0);
	
end behavioral;

architecture structural of R8 is   

    signal flag: std_logic_vector(3 downto 0);
    signal uins: Microinstruction;
    signal instruction: std_logic_vector(15 downto 0);

begin   
  
    DATA_PATH: entity work.DataPath 
        port map(
            uins        => uins, 
            clk         => clk,
            rst         => rst,
            instruction => instruction,
            address     => address,
            data_in     => data_in, 
            data_out    => data_out, 
            flag        => flag
        );

    CONTROL_PATH: entity work.ControlPath 
        port map(
            uins        => uins, 
            clk         => clk, 
            rst         => rst, 
            flag        => flag, 
            ir          => instruction
        );

    -- Memory signals
    ce <= uins.ce;
    rw <= uins.rw;

end structural;