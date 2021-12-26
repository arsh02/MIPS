library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;



entity ALU_BRANCH is
  Port (PCin            : in    std_logic_vector(31 downto 0);
        ExtendedIn      : in    std_logic_vector(31 downto 0);
        BranchAddResult : out   std_logic_vector(31 downto 0)       
   );
end ALU_BRANCH;

architecture Behavioral of ALU_BRANCH is

    signal offsetPC    : std_logic_vector(31 downto 0);
    --signal PCsrc        : std_logic;
    
begin


---- shifting left the sign extended by 2
---- and adding it to the PC + 4 

process ( PCin, offsetPC, ExtendedIn )

begin

offsetPC   <= ExtendedIn(29 downto 0) & "00";

BranchAddResult <= offsetPC + PCin;

end process;


end Behavioral;
