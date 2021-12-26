---- EX/MEM reg of 5 stage pipeline ------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- Port definition ---

entity EXMEMReg is
    Port ( 
            clk, reset          :   in  std_logic;
            Zero                :   in  std_logic;
            BranchPCout         :   in  std_logic_vector ( 31 downto 0);
            aluresult           :   in  std_logic_vector ( 31 downto 0);
            sdata2              :   in  std_logic_vector ( 31 downto 0);
            JumpAddr            :   in  std_logic_vector ( 31 downto 0);
            WriteReg            :   in  std_logic_vector ( 4  downto 0);
            IDEXBranch          :   in  std_logic;
            IDEXJump            :   in  std_logic;
            IDEXMemRead         :   in  std_logic;
            IDEXMemWrite        :   in  std_logic;
            IDEXMemtoReg        :   in  std_logic;         
            IDEXRegWrite        :   in  std_logic;
            EXZero              :   out std_logic;
            EXBranchPCout       :   out std_logic_vector ( 31 downto 0);
            EXaluresult         :   out std_logic_vector ( 31 downto 0);
            EXsdata2            :   out std_logic_vector ( 31 downto 0);
            EXJumpAddr          :   out std_logic_vector ( 31 downto 0);
            EXWriteReg          :   out std_logic_vector ( 4  downto 0);
            EXBranch            :   out std_logic;
            EXJump              :   out std_logic;
            EXMemRead           :   out std_logic;
            EXMemWrite          :   out std_logic;
            EXMemtoReg          :   out std_logic;         
            EXRegWrite          :   out std_logic
         );
end EXMEMReg;

architecture Behavioral of EXMEMReg is

--- Signal Definition to store the in port values ---
signal piplinereg, piplineregnext : std_logic_vector(139 downto 0);

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

process(reset, piplinereg, Zero, BranchPCout, aluresult, sdata2, WriteReg, IDEXBranch, IDEXJump, IDEXMemRead, IDEXMemWrite, IDEXMemtoReg, IDEXRegWrite, JumpAddr  )
begin
piplineregnext <=   piplinereg;
	if (reset = '1') then
		piplineregnext <=   ( others => '0' );
	else

		piplineregnext (0)                 <=    Zero;
		piplineregnext ( 32   downto 1  )  <=    BranchPCout;
		piplineregnext ( 64   downto 33 )  <=    aluresult;
		piplineregnext ( 96   downto 65 )  <=    sdata2;
		piplineregnext ( 101  downto 97 )  <=    WriteReg;
		piplineregnext ( 102 )             <=    IDEXBranch;
		piplineregnext ( 103 )             <=    IDEXJump;
		piplineregnext ( 104 )             <=    IDEXMemRead;
		piplineregnext ( 105 )             <=    IDEXMemWrite;
		piplineregnext ( 106 )             <=    IDEXMemtoReg;         
		piplineregnext ( 107 )             <=    IDEXRegWrite;
		piplineregnext ( 139  downto 108)  <=    JumpAddr;
	end if;
end process;

EXZero                             <=    piplinereg (0)               ;
EXBranchPCout                      <=    piplinereg ( 32   downto 1  );
EXaluresult                        <=    piplinereg ( 64   downto 33 );
EXsdata2                           <=    piplinereg ( 96   downto 65 );
EXWriteReg                         <=    piplinereg ( 101  downto 97 );
EXBranch                           <=    piplinereg ( 102 )           ;
EXJump                             <=    piplinereg ( 103 )           ;
EXMemRead                          <=    piplinereg ( 104 )           ;
EXMemWrite                         <=    piplinereg ( 105 )           ;
EXMemtoReg                         <=    piplinereg ( 106 )           ;
EXRegWrite                         <=    piplinereg ( 107 )           ;
EXJumpAddr                         <=    piplinereg ( 139  downto 108);

end Behavioral;
