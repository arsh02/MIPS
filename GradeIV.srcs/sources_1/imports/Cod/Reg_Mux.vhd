----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2019 07:13:42 PM
-- Design Name: 
-- Module Name: Reg_Mux - Behavioral
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

entity Reg_Mux is
  Port (SrcReg  : in std_logic_vector(4 downto 0);
        DstReg  : in std_logic_vector(4 downto 0);
        RegDst  : in std_logic;
        WriteReg: out std_logic_vector(4 downto 0)
   );
end Reg_Mux;

architecture Behavioral of Reg_Mux is

begin

Process(RegDst, DstReg, SrcReg)
begin
     
    if (RegDst = '1') then
        WriteReg <= DstReg;
    else 
        WriteReg <= SrcReg;
    end if;
end process;
        


end Behavioral;
