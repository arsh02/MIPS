----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2019 06:28:43 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
    Port ( clk, reset   : in  STD_LOGIC;
           PCin         : in  STD_LOGIC_VECTOR (31 downto 0);
           PCout        : out  STD_LOGIC_VECTOR (31 downto 0);
	   start	: in	STD_LOGIC
           );
end PC;

architecture Behavioral of PC is	
begin

	process(clk,reset, PCin)
	begin
		if (reset='1') then
		      	PCout <= x"00040000";
		elsif(start = '0') then
	          	PCout <= x"00040000";
		elsif(rising_edge(clk)) then
	          	PCout <= PCin;
		end if;
	end process;

end Behavioral;
