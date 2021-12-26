----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2019 02:05:10 PM
-- Design Name: 
-- Module Name: Data_Memory - Behavioral
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

entity Data_Memory is
  Port( MemtoReg        : in std_logic;
        MemDatain       : in std_logic_vector(31 downto 0);
        ALUResult       : in std_logic_vector(31 downto 0);    
        Dataout         : out std_logic_vector(31 downto 0)      
        );
end Data_Memory;

architecture Behavioral of Data_Memory is
    
begin

process(MemtoReg,ALUResult,MemDatain)
begin
    if (MemtoReg = '1') then
        Dataout <= MemDatain;
    else
        Dataout <= ALUResult;
    end if;
end process;

end Behavioral;
