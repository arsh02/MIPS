----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2019 02:08:23 PM
-- Design Name: 
-- Module Name: Sign_Extend - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sign_Extend is
  Port (instr   : in std_logic_vector(15 downto 0);
        LUICtrl : in std_logic;
        extended: out std_logic_vector(31 downto 0)  
  );
end Sign_Extend;

architecture Behavioral of Sign_Extend is

begin
    
process (LUICtrl, instr)

begin    
    if (LUICtrl = '1') then
            extended(31 downto 16) <= instr;
            extended(15 downto 0)  <= (others => '0');
    elsif (instr(15) = '1') then
            extended(31 downto 16) <= X"FFFF";
            extended(15 downto 0)  <= instr;
    else	     
            extended(31 downto 16) <= (others => '0');
            extended(15 downto 0)  <= instr;
    end if;

end process;

end Behavioral;
