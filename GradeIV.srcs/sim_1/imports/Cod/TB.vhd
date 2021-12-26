----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2019 07:21:55 PM
-- Design Name: 
-- Module Name: TB - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use std.textio.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB is
--  Port ( );
end TB;

architecture Behavioral of TB is

  signal clk, clk_out, reset        : std_logic                     := '0';
  signal start                      : std_logic                     := '0';
  signal output                     : std_logic_vector(31 downto 0) := (others => '0');
  signal regselbit                  : std_logic_vector(4 downto 0);




  component MIPS_top is
    port (
      clk, reset  : in std_logic;
      start       : in std_logic;
      regselbit   : in  std_logic_vector(4 downto 0); 
      readoutreg  : out  std_logic_vector(31 downto 0);
      clk_out     : out std_logic

      );  
  end component;

begin
  MIPS_top_inst : MIPS_top
    port map (
      clk         => clk,
      reset       => reset,
      start       => start,
      regselbit   => regselbit,
      readoutreg  => output,
      clk_out     => clk_out
      );


  clk   <= not(clk) after 20 ns;
  reset <= '1', '0' after 10 ns;
  start <= '0', '1' after 50 ns, '0' after 10 ms;
  regselbit <= "00010";
  
  

end Behavioral;
