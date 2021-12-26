library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity ALU_PC is
  Port (
        start   : in std_logic;
        PC_in   : in std_logic_vector(31 downto 0);
        PC_out  : out std_logic_vector(31 downto 0)     
  );
end ALU_PC;

architecture Behavioral of ALU_PC is
 
begin


process( start, PC_in )
begin    
    if ( start = '1' ) then
        PC_out <= PC_in + x"00000004";
    else
        PC_out <= PC_in;
    end if;    
end process;

end Behavioral;