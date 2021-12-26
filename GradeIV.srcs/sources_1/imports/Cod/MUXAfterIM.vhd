library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity MUXAfterIM is
    Port ( clk, reset   : in  std_logic;
           start        : in  std_logic;
           MemRead      : in STD_LOGIC;
           MemWrite     : in STD_LOGIC;
           Input        : in  std_logic_vector(31 downto 0);
           MuxDataOut   : out std_logic_vector(31 downto 0);
           LWDataOut    : out std_logic_vector(31 downto 0)
           );           
end MUXAfterIM;


architecture Behavioral of MUXAfterIM is
	
	type state is (LOAD, EXE, LWMEM, SWMEM );
	signal CS, NS	: state;	

begin



process (clk, reset)
begin 
	if (reset = '1') then
		CS <= LOAD;
	elsif (rising_edge(clk)) then
		CS <= NS;
	end if;
end process;

process (CS, start, Input, MemRead, MemWrite)
begin
NS <= CS;

   case (CS) is
   
    when LOAD   =>  MuxDataOut  <= x"00000000";
                    LWDataOut   <= x"00000000"; 
                     
                       if (Start = '1') then
                           NS   <=  EXE;
                       else
                           NS   <=  LOAD;
                       end if;
                   
   when EXE    =>   MuxDataOut <= Input;  
                    LWDataOut   <= x"00000000";
                    
                       if (MemRead = '0' and MemWrite = '1') then
                           NS    <=  LWMEM;    
                       elsif (MemRead = '0' and MemWrite = '0') then
                           NS   <=  SWMEM;
                       else
                           NS   <=  EXE;
                       end if;
                   
   when LWMEM  =>   MuxDataOut <= x"00000000";  
                    LWDataOut   <= Input; 
  
                   if (MemRead = '0' and MemWrite = '1') then
                       NS    <=  LWMEM;    
                   elsif (MemRead = '0' and MemWrite = '0') then
                       NS   <=  SWMEM;
                   else
                       NS   <=  EXE;
                   end if; 
                   
   when SWMEM  =>   MuxDataOut  <= x"00000000";
                    LWDataOut   <= x"00000000"; 
                   
                   if (MemRead = '0' and MemWrite = '1') then
                       NS    <=  LWMEM;    
                   elsif (MemRead = '0' and MemWrite = '0') then
                       NS   <=  SWMEM;
                   else
                       NS   <=  EXE;
                   end if;
                   
    when others=>  NULL;
    
    end case;
    end process;
		
end Behavioral;
