---- IF/ID reg of 5 stage pipeline ------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


---- Port definition ---
entity IFIDReg is
    Port (  
            clk, reset          :   in  std_logic;
            FourAddedPCin       :   in  std_logic_vector(31 downto 0);
            Instr               :   in  std_logic_vector(31 downto 0);
            IFIDregPCOut        :   out std_logic_vector(31 downto 0)
--            IFIDreginstr        :   out std_logic_vector(31 downto 0)
         );
end IFIDReg;

architecture Behavioral of IFIDReg is

--- Signal Definition to store the in port values ---
signal piplinereg, piplineregnext : std_logic_vector(31 downto 0);

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

process ( reset, FourAddedPCin, piplinereg)
begin
 piplineregnext <=   piplinereg;
	if( reset = '1' ) then
		piplineregnext <= ( others => '0' );
	else
	----- Feeding the IFIDreg and the out port -------
	 piplineregnext ( 31 downto 0 )  <=  FourAddedPCin;
--	 piplineregnext ( 63 downto 32 )  <=  Instr;
	end if;
end process;
-- piplineregnext ( 63 downto 32 ) <=  Instr;    
 IFIDregPCOut                    <=  piplinereg( 31 downto 0 );
-- IFIDreginstr                    <=  piplinereg( 63 downto 32 );


end Behavioral;
