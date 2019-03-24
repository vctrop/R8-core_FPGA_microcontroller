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
    signal RST   :   integer; --std_logic_vector(3 downto 0); -- is regIR(11 downto 8);
    
    -- Status flag signals
    signal N        : std_logic;
    signal Z        : std_logic;
    signal C        : std_logic;
    signal V        : std_logic;
    
    -- Status flags register
    signal flag         : std_logic_vector(3 downto 0);
    alias negativeFlag  : std_logic is flag(0);
    alias zeroFlag      : std_logic is flag(1);
    alias carryFlag     : std_logic is flag(2);
    alias overflowFlag  : std_logic is flag(3);
    --JULIO: eu acho que parece q ficam varios sinais, mas acredito ser o jeito mais simples de fazer isso.
    
    --ALU temporary signal for flag evaluation with an extra bit
    signal ALUout, opA, opB   :   std_logic_vector(16 downto 0);

    -- Instructions formats
    --      1: The target register is not source
    --      2: The target register is ALSO source
    signal instructionFormat1, instructionFormat2: boolean;

begin
    
    -- Instruction decodification
    decodedInstruction <=   ADD     when ir(15 downto 12) = x"0" else                               -- Log/arit 3 reg
                            SUB     when ir(15 downto 12) = x"1" else                               -- Log/arit 3 reg
                            AAND    when ir(15 downto 12) = x"2" else                               -- Log/arit 3 reg
                            OOR     when ir(15 downto 12) = x"3" else                               -- Log/arit 3 reg
                            XXOR    when ir(15 downto 12) = x"4" else                               -- Log/arit 3 reg
                            HALT    when ir(15 downto 12) = x"B" and ir(3 downto 0) = x"6" else
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
            --TODO: ZERAR REGISTRADORES
            registerFile   <= (others => (others=>'0'));
            regPC           <= (others => '0');
            regSP           <= (others => '0');
            regULA          <= (others => '0');
            regIR           <= (others => '0');
            regA            <= (others => '0');
            regB            <= (others => '0');
            flag            <= (others => '0');
            
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
                    registerFile(RST) <= regULA;
                    currentState <= Sfetch;
 
                when Shalt =>
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
    
    --TODO: IMPLEMENTAR O RESTO DAS INSTRUÇÕES DA ULA QUANDO ADICIONARMOR SUPORTE A MAIS INSTRUÇÕES
    ALUout <=   opA and opB                                     when decodedInstruction = AAND else  
                opA or  opB                                     when decodedInstruction = OOR  else   
                opA xor opB                                     when decodedInstruction = XXOR else
                std_logic_vector(signed(opA) -   signed(opB))   when decodedInstruction = SUB  else
                std_logic_vector(signed(opA) +   signed(opB));
                
    N <= '1' when (ALUout(15) = '1') else '0';
    Z <= '1' when (unsigned(ALUout(15 downto 0)) = 0) else '0';
    C <= '1' when (ALUout(16) = '1') else '0';  --might not be correct
    V <= '0'; --TODO: CONDITION FOR OVERFLOW !!
    -- Register file access address
    RS1 <= to_integer(unsigned(regIR(7 downto 4)));
    RS2 <= to_integer(unsigned(regIR(11 downto 8))) when instructionFormat2 or decodedInstruction = PUSH or currentState = Sst else
           to_integer(unsigned(regIR(3 downto 0)));
    RST <= to_integer(unsigned(regIR(11 downto 8)));
    
    -- Memory access interface
    ce <= '1' when rst = '0' and (currentState = Sfetch or currentState = Srts or currentState = Spop or currentState = Sld or currentState = Ssbrt or currentState = Spush or currentState = Sst) else '0';
    rw <= '1' when currentState = Sfetch or currentState = Srts or currentState = Spop or currentState = Sld else '0';

    
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