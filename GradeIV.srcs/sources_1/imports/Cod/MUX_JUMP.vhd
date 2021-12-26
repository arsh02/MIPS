library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX_JUMP is
  Port (
        JumpAddr    :   in      std_logic_vector ( 31 downto 0  );
        BranchOut   :   in      std_logic_vector ( 31 downto 0 );
        JumpControl :   in      std_logic;
        JumpOutput  :   out     std_logic_vector ( 31 downto 0 )     
   );
end MUX_JUMP;

architecture Behavioral of MUX_JUMP is

begin


process ( JumpControl, JumpAddr, BranchOut )

begin

--- based on the Jumpcontrol signal from 
--- control unit, send jump adress or
--- Branch out

    if (JumpControl = '1') then
        JumpOutput <= JumpAddr;
    else 
        JumpOutput <= BranchOut;
    end if;


end process;
end Behavioral;
