library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ForwardingMUXes is
    Port ( 
            ForwardA            :   in  std_logic_vector ( 1  downto 0 );
            ForwardB            :   in  std_logic_vector ( 1  downto 0 );
            WBMUXDataoutout     :   in  std_logic_vector ( 31 downto 0 );
            IDEXreg1data        :   in  std_logic_vector ( 31 downto 0 );
            IDEXreg2data        :   in  std_logic_vector ( 31 downto 0 );
            EXaluresult         :   in  std_logic_vector ( 31 downto 0 );
            ALUOperand1         :   out std_logic_vector ( 31 downto 0 );
            ALUOperand2         :   out std_logic_vector ( 31 downto 0 )
         ); 
         
end ForwardingMUXes;

architecture Behavioral of ForwardingMUXes is

signal  WBMUXDataoutoutSig  :   std_logic_vector ( 31 downto 0 );
signal  EXaluresultSig      :   std_logic_vector ( 31 downto 0 );
signal  IDEXreg1dataSig     :   std_logic_vector ( 31 downto 0 );
signal  IDEXreg2dataSig     :   std_logic_vector ( 31 downto 0 );


begin

---Signal definitions---

    WBMUXDataoutoutSig   <=  WBMUXDataoutout;
    EXaluresultSig       <=  EXaluresult;
    IDEXreg1dataSig      <=  IDEXreg1data;
    IDEXreg2dataSig      <=  IDEXreg2data;
    
    
    
----- Implementing Muxes to decide which input to be fed to 
----- ipnput1 of ALU and input 1 of mux which decides input2 
----- of ALU based on control signals from Forwarding unit

process(ForwardA, EXaluresultSig,  WBMUXDataoutoutSig, IDEXreg1data)

begin

    if( ForwardA = "10" ) then
        ALUOperand1 <=  EXaluresultSig;
    elsif ( ForwardA = "01" ) then
        ALUOperand1 <=  WBMUXDataoutoutSig;
    else
        ALUOperand1 <=  IDEXreg1data;
    end if;
end process;

process(ForwardB, EXaluresultSig,  WBMUXDataoutoutSig, IDEXreg2data)

begin    
    if( ForwardB = "10" ) then
        ALUOperand2 <=  EXaluresultSig;
    elsif ( ForwardB = "01" ) then
        ALUOperand2 <=  WBMUXDataoutoutSig;
    else
        ALUOperand2 <=  IDEXreg2data;
    end if;


end process;


end Behavioral;
