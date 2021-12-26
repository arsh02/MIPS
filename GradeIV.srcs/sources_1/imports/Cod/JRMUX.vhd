library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JRMUX is
  Port (
	ALUCtrl	    :   in  std_logic_vector( 3 downto 0);
        PCin        :   in  std_logic_vector(31 downto 0);
        ALUResultIn :   in  std_logic_vector(31 downto 0);
        PCout       :   out std_logic_vector(31 downto 0)
  );
end JRMUX;

architecture Behavioral of JRMUX is

begin

process(ALUCtrl,ALUResultIn,PCin)
begin
    if (ALUCtrl = "1110" ) then 
        PCout   <=  ALUResultIn;
    else
        PCout   <=  PCin;
    end if;
end process;


end Behavioral;
