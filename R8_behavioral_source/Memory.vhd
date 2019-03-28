-------------------------------------------------------------------------
-- Design unit: Memory
-- Description: Synchronous parameterizable 16 bits word memory.
--          Word addressed
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;   
use std.textio.all;
use work.Util_package.all;

entity Memory is
    generic (
        SIZE            : integer := 32;    -- Memory depth
        START_ADDRESS   : std_logic_vector(31 downto 0) := (others=>'0');   -- Lowest address
        imageFileName   : string := "UNUSED"    -- Memory content to be loaded
    );
    port( 
        clk             : in std_logic;
        ce_n            : in std_logic; 
        we_n            : in std_logic;
        oe_n            : in std_logic;
        address         : in std_logic_vector(15 downto 0);
        data            : inout std_logic_vector(15 downto 0)
    );
end Memory;


architecture behavioral of Memory is 
    
    type Memory is array (0 to SIZE-1) of std_logic_vector(15 downto 0);
    signal memoryArray : Memory;
    
        ----------------------------------------------------------------------------
        -- This procedure loads the memory array with the specified file in 
        -- the following format
        -- 
        -- ATTENTION!!! - There is a tab (\t) character between the strings!!!
        --
        -- 0000    4000    XOR R0,R0,R0
        -- 0001    7100    LDL R1,#N
        -- 0002    8101    LDH R1,#N
        -- 0003    9110    LD R1,R1,R0
        -- 0004    7201    LDL R2,#VECT1
        --  ...
        ----------------------------------------------------------------------------
        function MemoryLoad(imageFileName: in string) return Memory is
            
            file imageFile : TEXT open READ_MODE is imageFileName;
            variable memoryArray: Memory;
            variable fileLine   : line;             -- Stores a read line from a text file
            variable str        : string(1 to 4);   -- Stores an 4 characters string
            variable char       : character;        -- Stores a single character
            variable bool       : boolean;          -- 
            variable address, data: std_logic_vector(15 downto 0);
                    
            begin
            
                while NOT (endfile(imageFile)) loop -- Main loop to read the file
                    
                    -- Read a file line into 'fileLine'
                    readline(imageFile, fileLine);  
                        
                    -- Read the address character by character and stores in 'str'
                    for i in 1 to 4 loop
                        read(fileLine, char, bool);
                        str(i) := char;
                    end loop;
                    
                    -- Converts the string address 'str' to std_logic_vector
                    address := StringToStdLogicVector(str);
                    
                    -- Read the tab character between address and code
                    read(fileLine, char, bool);
                    
                    -- Read the code/data character by character and stores in 'str'
                    for i in 1 to 4 loop
                        read(fileLine, char, bool);
                        str(i) := char;
                    end loop;
                    
                    -- Converts the string code/data 'str' to std_logic_vector
                    data := StringToStdLogicVector(str);
                    
                    -- Stores the 'data' into the memoryArray
                    memoryArray(TO_INTEGER(UNSIGNED(address))) := data;
                        
                end loop;
                
                return memoryArray;
                
    end MemoryLoad;
	
	signal address_un: UNSIGNED(15 downto 0);

begin     

	address_un <= UNSIGNED(address);
      
    -- Writes in memory SYNCHRONOUSLY
    process(clk)
        variable memoryLoaded: boolean := false;    -- Indicates if the memory was already loaded
    begin       
        
        -- Memory initialization
        if not memoryLoaded then
            if imageFileName /= "UNUSED" then               
                memoryArray <= MemoryLoad(imageFileName);
                
                assert false  
                    report "Memory loaded from image file: " & imageFileName
                severity Note;
            else
                assert false  
                    report "Memory not loaded."
                severity Note;
            end if;
                
            memoryLoaded := true;
        end if;
        
        
        -- Synchronous memory writing
        if rising_edge(clk) then
            if ce_n = '0' and we_n = '0' then    
                if TO_INTEGER(address_un) >= 0 and TO_INTEGER(address_un) <= SIZE then
                    memoryArray(TO_INTEGER(address_un)) <= data;
                end if;
            end if;
        end if;
        
    end process;   
	  
     -- Asynchronous memory reading
     data <=  memoryArray(TO_INTEGER(address_un)) when (ce_n = '0' and oe_n = '0' and TO_INTEGER(address_un) < SIZE) else (others=>'Z');
     
end behavioral;

