----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2019 11:43:27 AM
-- Design Name: 
-- Module Name: ALU_Control - Behavioral
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

entity ALU_Control is
    Port (  ALUOp   : in std_logic_vector(1 downto 0);
            Funct   : in std_logic_vector(5 downto 0);
            ALUCtrl : out std_logic_vector(3 downto 0)
         );
end ALU_Control;

architecture Behavioral of ALU_Control is

begin

process (ALUOp, Funct)
begin
    ALUCtrl <= "1111";
    if (ALUOp = "00") then
        ALUCtrl <= "0001";
    elsif (ALUOp = "01") then --branch
        ALUCtrl <= "0010";
    elsif (ALUOp = "10") then
        ALUCtrl <= "0001";    
    elsif (ALUOp = "11") then        
        case (Funct) is 
            when "100001" =>    ALUCtrl <= "0001"; 
            when "100011" =>    ALUCtrl <= "0010";
            when "011001" =>    ALUCtrl <= "0011";        
            when "100100" =>    ALUCtrl <= "0100";
            when "100101" =>    ALUCtrl <= "0101";
            when "100110" =>    ALUCtrl <= "0110";
            when "000000" =>    ALUCtrl <= "0111";
            when "000010" =>    ALUCtrl <= "1000";
            when "000011" =>    ALUCtrl <= "1001";
            when "101010" =>    ALUCtrl <= "1010"; --slt
            when "101011" =>    ALUCtrl <= "1011"; --sltu
            when "010000" =>    ALUCtrl <= "1100"; --mfhi
            when "010010" =>    ALUCtrl <= "1101"; --mflo     
            when "001000" =>    ALUCtrl <= "1110"; --jr
            when others =>  ALUCtrl <= "1111";
        end case;    
    end if;        
end process;
            
end Behavioral;
