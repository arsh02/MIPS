----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2019 05:31:08 PM
-- Design Name: 
-- Module Name: GPR - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GPR is
  Port (clk, reset  : in std_logic;
        RegWrite    : in std_logic;
	RegWrite31  : in std_logic;
        readreg1    : in std_logic_vector (4 downto 0);
        readreg2    : in std_logic_vector (4 downto 0);
        writereg    : in std_logic_vector (4 downto 0);
        writedata   : in std_logic_vector (31 downto 0);
	   writedata31  : in std_logic_vector (31 downto 0);
        reg1data    : out std_logic_vector (31 downto 0);
        reg2data    : out std_logic_vector (31 downto 0);
        regselbit   : in std_logic_vector (4 downto 0);
        readoutreg  : out std_logic_vector (31 downto 0)       
        );      
end GPR;

architecture Behavioral of GPR is

type gpr_type is array(0 to 31) of std_logic_vector(31 downto 0);
signal gpr: gpr_type;

begin

    process(clk, reset, writereg, RegWrite, RegWrite31, writedata, writedata31)
    begin  
     
        if (reset = '1') then
             gpr(0) <= (others=> '0');   gpr(1) <= (others=> '0');  gpr(2) <= (others=> '0');   gpr(3) <= (others=> '0');
             gpr(4) <= (others=> '0');   gpr(5) <= (others=> '0');  gpr(6) <= (others=> '0');   gpr(7) <= (others=> '0');
             gpr(9) <= (others=> '0');   gpr(10) <= (others=> '0'); gpr(11) <= (others=> '0');  gpr(12) <= (others=> '0');      
             gpr(13) <= (others=> '0');  gpr(14) <= (others=> '0'); gpr(15) <= (others=> '0');  gpr(16) <= (others=> '0');
             gpr(17) <= (others=> '0');  gpr(18) <= (others=> '0'); gpr(19) <= (others=> '0');  gpr(20) <= (others=> '0');
             gpr(21) <= (others=> '0');  gpr(22) <= (others=> '0'); gpr(23) <= (others=> '0');  gpr(24) <= (others=> '0');
             gpr(25) <= (others=> '0');  gpr(26) <= (others=> '0'); gpr(27) <= (others=> '0');  gpr(28) <= (others=> '0');
             gpr(29) <= (others=> '0');  gpr(30) <= (others=> '0'); gpr(31) <= (others=> '0');  gpr(8) <= (others=> '0');            
        elsif (rising_edge(clk)) then  
            if (RegWrite = '1') then 
                gpr(conv_integer(writereg)) <= writedata;	
            end if;  

	    if(RegWrite31 = '1') then
		gpr(31)			    <= writedata31; 
	    end if;
         
        end if;
    end process;
    


  
    

    
    process(readreg1, readreg2, gpr )
    begin
        if (conv_integer(readreg1)= 0) then
            reg1data <= x"00000000";
        else
            reg1data <= gpr(conv_integer(readreg1));
        end if;
        
--        if (conv_integer(readreg2)= 0) then
          if (conv_integer(readreg2)= 0 ) then
            reg2data <= x"00000000";
        else
            reg2data <= gpr(conv_integer(readreg2));
        end if;
               
    end process; 
    
    readoutreg  <= gpr(conv_integer(regselbit));                    




end Behavioral;
