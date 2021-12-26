----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/17/2019 02:48:07 PM
-- Design Name: 
-- Module Name: PCIMMux - Behavioral
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

entity PCIMMux is
  Port (start   :   in std_logic;
        PCin    :   in std_logic_vector(7 downto 0);
        PCtb    :   in  std_logic_vector(7 downto 0);
        PCout   :   out std_logic_vector(7 downto 0)
   );
end PCIMMux;

architecture Behavioral of PCIMMux is
    signal PCdiv    :   std_logic_vector(7 downto 0);
begin
    PCdiv   <= "00" & PCin (7 downto 2);
    
process(start, PCdiv,PCtb )
begin
    if (start = '1') then
        PCout   <=  PCdiv;
    else
        PCout   <=  PCtb;
    end if;
end process;

end Behavioral;