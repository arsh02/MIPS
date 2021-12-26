---- IF/EX reg of 5 stage pipeline ------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- Port definition ---
entity IDEXReg is
    Port (
            clk, reset          :   in  std_logic;
            IFIDregPCOut        :   in  std_logic_vector (31 downto 0);
            reg1data            :   in  std_logic_vector (31 downto 0);
            reg2data            :   in  std_logic_vector (31 downto 0);
            extended            :   in  std_logic_vector (31 downto 0);
            InstructionRT       :   in  std_logic_vector (4  downto 0);
            InstructionRDst     :   in  std_logic_vector (4  downto 0);
            InstructionRS       :   in  std_logic_vector (4  downto 0);
            IntructionJump      :   in  std_logic_vector (25 downto 0);
	    shamt		:   in  std_logic_vector (4 downto 0);                    
            RegDst              :	in	std_logic;
            Branch              :   in  std_logic;
            Jump                :   in  std_logic;
            MemRead             :   in  std_logic;
            MemtoReg            :   in  std_logic;
            ALUOp               :   in  std_logic_vector (1 downto 0);
            MemWrite            :   in  std_logic;
            ALUSrc              :   in  std_logic;            
            RegWrite            :   in  std_logic;
            BNECtrl             :   in  std_logic;
            IDEXregPCOut        :   out std_logic_vector (31 downto 0);
            IDEXreg1data        :   out std_logic_vector (31 downto 0);
            IDEXreg2data        :   out std_logic_vector (31 downto 0);
            IDEXextended        :   out std_logic_vector (31 downto 0);
            IDEXInstructionRT   :   out std_logic_vector (4  downto 0);
            IDEXInstructionRDst :   out std_logic_vector (4  downto 0);
            IDEXInstructionRS   :   out std_logic_vector (4  downto 0);
	    IDEXShamt   	:   out std_logic_vector (4  downto 0);
            IDEXIntructionJump  :   out std_logic_vector (25 downto 0);            
            IDEXRegDst          :   out std_logic;
            IDEXBranch          :   out std_logic;
            IDEXJump            :   out std_logic;
            IDEXMemRead         :   out std_logic;
            IDEXMemtoReg        :   out std_logic;
            IDEXALUOp           :   out std_logic_vector (1 downto 0);
            IDEXMemWrite        :   out std_logic;
            IDEXALUSrc          :   out std_logic;            
            IDEXRegWrite        :   out std_logic;
            IDEXBNECtrl         :   out std_logic
     );
end IDEXReg;

architecture Behavioral of IDEXReg is

--- Signal Definition to store the in port values ---
signal piplinereg, piplineregnext : std_logic_vector(184 downto 0);

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
--process (IFIDregPCOut,reg1data,reg2data,extended,InstructionRT,InstructionRDst,RegDst,Branch,Jump, MemRead, MemtoReg,ALUOp,MemWrite, 
--        ALUSrc, RegWrite, BNECtrl, IntructionJump )
--begin
process(reset, piplinereg, IFIDregPCOut, reg1data, reg2data, extended, InstructionRT, InstructionRDst, RegDst, Branch, Jump, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, BNECtrl, IntructionJump, InstructionRS, shamt)
begin
piplineregnext <=   piplinereg;
	if (reset = '1') then
		piplineregnext <=   ( others => '0' );
	else	
		piplineregnext ( 31  downto 0  )  <=   IFIDregPCOut;
		piplineregnext ( 63  downto 32 )  <=   reg1data;
		piplineregnext ( 95  downto 64 )  <=   reg2data;
		piplineregnext ( 127 downto 96 )  <=   extended;
		piplineregnext ( 132 downto 128)  <=   InstructionRT;
		piplineregnext ( 137 downto 133)  <=   InstructionRDst;
		piplineregnext ( 138 )            <=   RegDst;
		piplineregnext ( 139 )            <=   Branch;
		piplineregnext ( 140 )            <=   Jump;
		piplineregnext ( 141 )            <=   MemRead;
		piplineregnext ( 142 )            <=   MemtoReg;
		piplineregnext ( 144 downto 143)  <=   ALUOp;
		piplineregnext ( 145 )            <=   MemWrite;
		piplineregnext ( 146 )            <=   ALUSrc;
		piplineregnext ( 147 )            <=   RegWrite;
		piplineregnext ( 148 )            <=   BNECtrl;
		piplineregnext ( 174 downto 149)  <=   IntructionJump;
		piplineregnext ( 179 downto 175)  <=   InstructionRS;
		piplineregnext ( 184 downto 180)  <=   shamt;
        end if;
end process;

        
        
        
IDEXregPCOut                      <=   piplinereg ( 31  downto 0  );
IDEXreg1data                      <=   piplinereg ( 63  downto 32 );
IDEXreg2data                      <=   piplinereg ( 95  downto 64 );
IDEXextended                      <=   piplinereg ( 127 downto 96 );
IDEXInstructionRT                 <=   piplinereg ( 132 downto 128);
IDEXInstructionRDst               <=   piplinereg ( 137 downto 133);
IDEXRegDst                        <=   piplinereg ( 138 )          ;
IDEXBranch                        <=   piplinereg ( 139 )          ;
IDEXJump                          <=   piplinereg ( 140 )          ;
IDEXMemRead                       <=   piplinereg ( 141 )          ;
IDEXMemtoReg                      <=   piplinereg ( 142 )          ;
IDEXALUOp                         <=   piplinereg ( 144 downto 143);
IDEXMemWrite                      <=   piplinereg ( 145 )          ;
IDEXALUSrc                        <=   piplinereg ( 146 )          ;
IDEXRegWrite                      <=   piplinereg ( 147 )          ;
IDEXBNECtrl                       <=   piplinereg ( 148 )          ;
IDEXIntructionJump                <=   piplinereg ( 174 downto 149); 
IDEXInstructionRS                 <=   piplinereg ( 179 downto 175);
IDEXShamt			  <=   piplinereg ( 184 downto 180);

end Behavioral;
