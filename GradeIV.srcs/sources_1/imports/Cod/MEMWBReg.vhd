---- MEM/WB reg of 5 stage pipeline ------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- Port definition ---

entity MEMWBReg is
    Port (
            clk, reset          :   in  std_logic;
            ALUResult           :   in  std_logic_vector ( 31 downto 0 );    
--            DMDataout           :   in  std_logic_vector ( 31 downto 0 );
            EXWriteReg          :   in  std_logic_vector ( 4  downto 0 );
            EXMemtoReg          :   in  std_logic;         
            EXRegWrite          :   in  std_logic;
            WBALUResult         :   out std_logic_vector ( 31 downto 0 );    
--            WBDMDataout         :   out std_logic_vector ( 31 downto 0 );
            WBEXWriteReg        :   out std_logic_vector ( 4  downto 0 );
            WBEXMemtoReg        :   out std_logic;         
            WBEXRegWrite        :   out std_logic
         );
end MEMWBReg;

architecture Behavioral of MEMWBReg is

--- Signal Definition to store the in port values ---

signal piplinereg, piplineregnext : std_logic_vector(38 downto 0);

begin

---- DFF for pipeline register -----

process ( clk, reset, piplineregnext )
begin
        if (reset = '1') then
            piplinereg <=   ( others => '0' );
        elsif (rising_edge(clk)) then
            piplinereg <=   piplineregnext;
        end if;
end process;


----- Feeding the IDEXreg and the out port -------
process(reset,piplinereg, ALUResult, EXWriteReg, EXMemtoReg, EXRegWrite  )
begin
piplineregnext <=   piplinereg;
	if (reset = '1') then
		piplineregnext <=   ( others => '0' );
	else
		piplineregnext ( 31  downto 0  )   <=    ALUResult ;
--		piplineregnext ( 63  downto 32 )   <=    DMDataout ;
		piplineregnext ( 36  downto 32 )   <=    EXWriteReg;
		piplineregnext ( 37 )              <=    EXMemtoReg;
		piplineregnext ( 38 )              <=    EXRegWrite;
	end if;
end process;

WBALUResult                        <=    piplinereg ( 31  downto 0  );
--WBDMDataout                        <=    piplinereg ( 63  downto 32 );
WBEXWriteReg                       <=    piplinereg ( 36  downto 32 );
WBEXMemtoReg                       <=    piplinereg ( 37 )           ;
WBEXRegWrite                       <=    piplinereg ( 38 )           ;



end Behavioral;
