library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ControlUnit is
	Port (	InstructionIn	:	in	std_logic_vector (5 downto 0);
			RegDst			:	out	std_logic;
			Branch			:	out	std_logic;
			Jump			:	out	std_logic;
			MemRead			:	out	std_logic;
			MemtoReg		:	out	std_logic;
			ALUOp			:	out	std_logic_vector (1 downto 0);
			MemWrite		:	out	std_logic;
			ALUSrc			:	out	std_logic;
			LUICtrl         :   out std_logic;
			RegWrite		:	out	std_logic;
			BNECtrl         :   out std_logic	
	);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin

process	( InstructionIn	)

begin

-- Default Values --	
	
	RegWrite    <=	'0';
	Branch		<=	'0';
	Jump		<=	'0';
	MemRead		<=	'1';
	MemWrite	<=	'0';	
	ALUSrc		<=	'0';
	LUICtrl     	<=  '0';
	BNECtrl     	<=  '0';
	ALUOp		<=	"00";
	MemtoReg	<=	'0';
	RegDst     	<=	'0';

-- Based on the instruction's Opcode -- 
-- send the control signals --
	
	case ( InstructionIn ) is
	
		when "000000"	=>	-- X"00" R-Type
			RegDst		<=	'1';
			ALUOp		<=	"11";
			MemtoReg	<=	'0';
			RegWrite	<=	'1';
			
		when "001001"	=>	-- X"09" ADDU
			RegDst		<=	'0';
			ALUOp		<=	"10";
			MemtoReg	<=	'0';
			RegWrite	<=	'1';
			ALUSrc		<=	'1';			
			
		when "001111"	=>	-- X"0F" LUI
			RegDst		<=	'0';
			MemtoReg	<=	'0';
			RegWrite	<=	'1';
			ALUSrc		<=	'1';
			ALUOp		<=	"10";
			LUICtrl     <=   '1';
			
		when "100011"	=>	-- X"23" LW
			RegDst		<=	'0';
			RegWrite	<=	'1';
			ALUOp		<=	"00";
			ALUSrc		<=	'1';
			MemRead		<=	'0';
			MemWrite	<=	'0';
			MemtoReg	<=	'1';
			
		when "101011"	=>	-- X"2B" SW
            ALUSrc		<=	'1';
            MemRead		<=	'0';
            ALUOp		<=	"00";
            MemWrite	<=	'1';
			
		when "000010"	=>	-- X"02" j
		    Jump <= '1';
		
		when "000011"	=>	-- X"03" jal
		    Jump <= '1'; 
		     
		when "000100"	=>	-- X"04" beq
			ALUOp		<=	"01";
			Branch      <=   '1';
		when "000101"	=>	-- X"05" bne
			ALUOp		<=	"01";
			Branch      <=   '1';
	        BNECtrl     <=   '1';
				
			
	   when others => NULL;		
		
	end case;
	
end process;

end Behavioral;
