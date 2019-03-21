-------------------------------------------------------------------------
-- Design unit: ALU
-- Description: Aritmetic/Logic Unit
--      Aritmetic operations performed by an adder defined in R8_pkg
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.R8_pkg.all;

entity ALU is
    port( 
        A           : in std_logic_vector(15 downto 0); -- Operand A
        B           : in std_logic_vector(15 downto 0); -- Operand B
        result      : out std_logic_vector(15 downto 0);-- Operation result
        n           : out std_logic;                    -- Negative flag
        z           : out std_logic;                    -- Zero flag
        c           : out std_logic;                    -- Carry flag
        v           : out std_logic;                    -- Overflow flag
        operation   : in Instruction                  
    );
end ALU;

architecture behavioral of ALU is

    signal temp: std_logic_vector(15 downto 0);
    
    -- Adder interface signals
    signal adder_opA, adder_opB, adder_out: std_logic_vector(15 downto 0);
    signal carry_in: std_logic;

begin
      
    -- Sets the adder A input 
    adder_opA <=    "00000000" & A(7 downto 0)                      when operation = ADDI else    -- unsigned add
                    not ("00000000" & A(7 downto 0))                when operation = SUBI else    -- unsigned sub           
                    A(11) & A(11) & A(11) & A(11) & A(11 downto 0)  when operation = JSRD else    -- signal extention
                    A(9) & A(9) & A(9) & A(9) & A(9) & A(9) & A(9 downto 0) when operation = JUMP_D else -- signal extention
                    A; -- ADD, SUB, LD, ST
             
    -- Sets the adder B input
    adder_opB <= not B  when operation = SUB  else B; 
             
    -- Sets the adder carry_in input
    carry_in <= '1' when operation=SUB or operation=SUBI else '0';
    
    -- Performs the addition
    Adder(adder_opA, adder_opB, carry_in, adder_out, c, v); 
    
    
    
    temp <= A and B                         	when operation = AAND else  
            A or  B                         	when operation = OOR  else   
            A xor B                         	when operation = XXOR else  
            B(15 downto 8) & A(7 downto 0)  	when operation = LDL   else  -- A: immediate operand (wrapped in the instruction)
            A(7 downto 0)  & B(7 downto 0)  	when operation = LDH   else  -- A: immediate operand (wrapped in the instruction)
            A(14 downto 0) & '0'            	when operation = SL0   else
            A(14 downto 0) & '1'            	when operation = SL1   else
            '0' & A(15 downto 1)            	when operation = SR0   else
            '1' & A(15 downto 1)            	when operation = SR1   else
            not A                           	when operation = NOT_A  else 
            STD_LOGIC_VECTOR(UNSIGNED(B) + 1)	when operation = RTS or operation = POP else  
            A                               	when operation = JUMP_A or operation = JSR  or operation = LDSP else      
            adder_out;     -- by default the ALU operation is adder_out!!
            
            
    result <= temp;    

    -- Generates the zero flag
    z <= '1' when UNSIGNED(temp) = 0 else '0';
    
    -- Generates the negative flag
    n <= temp(15);
    
end behavioral;

