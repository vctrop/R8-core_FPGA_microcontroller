-------------------------------------------------------------------------
-- Design unit: CryptoMessage
-- Description: 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity CryptoMessage is
    generic (
        MSG_INTERVAL    : integer;    -- Clock cycles
        FILE_NAME       : string := "UNUSED"
    );
    port ( 
        clk         : in std_logic;
        rst         : in std_logic;
        ack         : in std_logic;
        data_in     : in std_logic_vector(7 downto 0);
        data_out    : out std_logic_vector(7 downto 0);
        data_av     : out std_logic;
        keyExchange : out std_logic;
        eom         : out std_logic
    );
end CryptoMessage;

architecture behavioral of CryptoMessage is
    
    type State is (WAITING, MN_ACK_0, MN_ACK_1, SEND_CHAR, CHAR_ACK_1, CHAR_ACK_0, END_OF_FILE);
    signal currentState : State;
    
    signal lineLength: integer; 
    signal counter: integer;
    signal key, sndExp: std_logic_vector(7 downto 0);
    signal random_num: UNSIGNED(7 downto 0);
    
    constant BASE   : std_logic_vector(7 downto 0) := x"06";
    constant MODULE : integer := 251;
    
    function ExpMod(a,b: in std_logic_vector(7 downto 0); n: in integer range 0 to 255) return std_logic_vector is
        variable f : integer range 0 to 255 := 1;
        variable i : integer range 0 to 7 := 0;
    begin
        
        for i in 7 downto 0 loop
            f := (f * f) mod n;
            
            if b(i) = '1' then 
                f := (f * TO_INTEGER(UNSIGNED(a))) mod n;
            end if;
        end loop;
        
        return STD_LOGIC_VECTOR(TO_UNSIGNED(f,8));
        
    end ExpMod;
begin

    assert FILE_NAME /= "UNUSED"
    report "********************* entity CryptoMessage: missing FILE_NAME *********************"
    severity failure;
    
    KeyExchange <= '1' when currentState = MN_ACK_1 else '0';
    data_av <= '1' when currentState = CHAR_ACK_1 else '0';
    eom <= '1' when currentState = CHAR_ACK_1 and lineLength = 0 else '0';
    
    process(clk,rst)
        file messageFile    : TEXT open READ_MODE is FILE_NAME;
        variable fileLine   : line; -- Stores a read line from a text file
        variable char       : character; -- Stores a single character
        variable readOK     : boolean; -- When false indicates end of line
        variable sndExp     : std_logic_vector(7 downto 0);
    begin
        if rst = '1' then
            counter <= 0;
            currentState <= WAITING;
            
        elsif rising_edge(clk) then
            case currentState is
                
                -- Wait message interval
                when WAITING =>
                    if counter = MSG_INTERVAL then
                        counter <= 0;
                        if not endfile(messageFile) then                           
                            readline(messageFile, fileLine); -- Read a file line into 'fileLine'. Each line is a message.
                            lineLength <= fileLine'length; -- Set the line number of characters
                            sndExp := STD_LOGIC_VECTOR(random_num); -- Get a randon number
                            data_out <= ExpMod(BASE,sndExp,MODULE); -- Generate the magic number     
                            currentState <= MN_ACK_1;
                        else
                            currentState <= END_OF_FILE;
                        end if;                        
                    else
                        counter <= counter + 1;
                        currentState <= WAITING;
                    end if;
                    
                -- Wait for the receiver magic number
                when MN_ACK_1 =>
                    if ack = '1' then
                        key <= ExpMod(data_in,sndExp,MODULE); -- Generates the key from the receiver magic number
                        currentState <= MN_ACK_0;
                    else
                        currentState <= MN_ACK_1;
                    end if;
                    
                -- Wait for complete acknowledment (ack = 0)
                when MN_ACK_0 =>
                    if ack = '0' then
                        currentState <= SEND_CHAR;
                    else
                        currentState <= MN_ACK_0;
                    end if;
                    
                
                -- Send an encrypted character
                when SEND_CHAR =>
                        
                    -- Read a character from the line
                    read(fileLine, char, readOK);
                    
                    if readOK then -- Verifies if the end of line was reached
                        data_out <= key xor STD_LOGIC_VECTOR(TO_UNSIGNED(character'pos(char),8));
                        --data_out <= STD_LOGIC_VECTOR(TO_UNSIGNED(character'pos(char),8));
                        lineLength <= lineLength - 1;
                        currentState <= CHAR_ACK_1;
                    else -- End of line (all characters were read)
                        data_out <= STD_LOGIC_VECTOR(TO_UNSIGNED(character'pos('-'),8));
                        currentState <= WAITING;
                    end if;
                
                -- Wait for receiver read
                when CHAR_ACK_1 =>
                    if ack = '1' then
                        currentState <= CHAR_ACK_0;
                    else
                        currentState <= CHAR_ACK_1;
                    end if;
                    
                -- Wait for complete acknowledment (ack = 0)
                when CHAR_ACK_0 =>
                    if ack = '0' then
                        currentState <= SEND_CHAR;
                    else
                        currentState <= CHAR_ACK_0;
                    end if;
                
                -- End of file. All messages were send.
                when END_OF_FILE =>
                    currentState <= END_OF_FILE;
                when others=>
            end case;
        end if;
    end process;
    
    

    process(clk,rst)
    begin
        if rst = '1' then
            random_num <= (others=>'0');
        elsif rising_edge(clk) then
            random_num <= random_num + 1;
        end if;
    end process;
    
    
    
   
end behavioral;