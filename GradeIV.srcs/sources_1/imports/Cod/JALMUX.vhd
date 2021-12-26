library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;



entity JALMUX is
  Port (InstructionIn   :   in  std_logic_vector(5 downto 0);
        PC4in           :   in  std_logic_vector(31 downto 0);    
        WriteDataOut    :   out std_logic_vector(31 downto 0);
	      RegWriteFrmJAL	:   out std_logic       
         );
end JALMUX;

architecture Behavioral of JALMUX is
    signal  PCalfa  :   std_logic_vector(31 downto 0);   
begin
PCalfa  <= PC4in  + x"00000004";
 
process(InstructionIn, PCalfa )
begin

    if (InstructionIn = "000011") then
        WriteDataOut    <=  PCalfa;       
        RegWriteFrmJAL  <=  '1';
    else 
        WriteDataOut    <=  (others => '0');       
        RegWriteFrmJAL  <=  '0';
    end if;
end process;    
          

end Behavioral;
