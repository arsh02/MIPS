library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity ForwardignUnit is
    Port ( 
            EXWriteReg          :   in  std_logic_vector ( 4  downto 0 );
            WBEXWriteReg        :   in  std_logic_vector ( 4  downto 0 );
            IDEXInstructionRT   :   in  std_logic_vector ( 4  downto 0 );
            IDEXInstructionRS   :   in  std_logic_vector ( 4  downto 0 );
            EXRegWrite          :   in  std_logic;
            WBEXRegWrite        :   in  std_logic;
            ForwardA            :   out std_logic_vector  (1  downto 0);
            ForwardB            :   out std_logic_vector  (1  downto 0)             
         );
end ForwardignUnit;

architecture Behavioral of ForwardignUnit is

begin


----- Conditions to avoid EX hazard 
----- and MEM Hazard plus sending
----- the control signal out -----


process( EXWriteReg, WBEXWriteReg, IDEXInstructionRS, EXRegWrite, WBEXRegWrite )

begin

    if( (EXRegWrite = '1') and (not( EXWriteReg = "00000" )) and ( EXWriteReg = IDEXInstructionRS )) then
        ForwardA <= "10";
    elsif ( (WBEXRegWrite = '1') and (not( WBEXWriteReg = "00000" )) and (WBEXWriteReg = IDEXInstructionRS)
            and not( (EXRegWrite = '1') and (not( EXWriteReg = "00000" )) and ( EXWriteReg = IDEXInstructionRS ))) then
        ForwardA <= "01";
    else
        ForwardA <= "00";
    end if;    
        
end process;


process( EXWriteReg, WBEXWriteReg, IDEXInstructionRT, EXRegWrite, WBEXRegWrite )

begin

    if( (EXRegWrite = '1') and (not( EXWriteReg = "00000" )) and ( EXWriteReg = IDEXInstructionRT )) then
        ForwardB <= "10";
    elsif ( (WBEXRegWrite = '1') and (not( WBEXWriteReg = "00000" )) and (WBEXWriteReg = IDEXInstructionRT)
            and not( (EXRegWrite = '1') and (not( EXWriteReg = "00000" )) and ( EXWriteReg = IDEXInstructionRT ))) then
        ForwardB <= "01";
    else
        ForwardB <= "00";
    end if;    
        
end process;


end Behavioral;
