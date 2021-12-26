library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftLeftJUMP is
    Port (
            InstrionIn  :   in      std_logic_vector ( 25 downto 0 );
            PC4         :   in      std_logic_vector ( 3 downto 0  );
            JumpAddr    :   out     std_logic_vector ( 31 downto 0  )
        );
end ShiftLeftJUMP;

architecture Behavioral of ShiftLeftJUMP is

signal InstructionInSig : std_logic_vector ( 27 downto 0 );

begin

-- Shift left 2 and concatenate PC + 4
-- to get jump address

process(InstrionIn, PC4 , InstructionInSig)
begin

InstructionInSig <= InstrionIn & "00";

JumpAddr <= PC4 & InstructionInSig;

end process;

end Behavioral;
