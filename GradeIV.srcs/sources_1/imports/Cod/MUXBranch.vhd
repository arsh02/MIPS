library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity MUXBranch is
    Port (
            Branch          : in    std_logic;
            Zero            : in    std_logic;
            PCin            : in    std_logic_vector(31 downto 0);
            BranchAddResult : in    std_logic_vector(31 downto 0);
            PCout           : out   std_logic_vector(31 downto 0)
            
        );
end MUXBranch;

architecture Behavioral of MUXBranch is

    signal PCsrc        : std_logic;
    
begin

--- Using AND to get the control signal for branch mux

PCsrc       <= Branch and Zero ;


--- Branch mux to choose between branch or PC+4

process(PCSrc, BranchAddResult, PCin)
begin
    if (PCSrc = '1') then
        PCout <= BranchAddResult;
    else
        PCout <= PCin;
    end if;
end process;

end Behavioral;
