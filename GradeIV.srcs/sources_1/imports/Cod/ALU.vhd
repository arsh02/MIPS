library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all; 


entity ALU is
  port (clk, reset     : in  std_logic;
         sdata1        : in  std_logic_vector (31 downto 0);
         sdata2        : in  std_logic_vector (31 downto 0);
         Sign_Extended : in  std_logic_vector (31 downto 0);
         shamt         : in  std_logic_vector (4 downto 0);
         alu_control   : in  std_logic_vector (3 downto 0);
         ALUSrc        : in  std_logic;
         alu_result    : out std_logic_vector (31 downto 0);
         BNECtrl       : in  std_logic;
         Zero          : out std_logic
         );           
end ALU;

architecture Behavioral of ALU is

  signal a, b                     : unsigned (31 downto 0);
  signal result                   : unsigned (31 downto 0);
  signal result_mu, result_munext : unsigned (63 downto 0);
  signal shift                    : integer;
  signal hi                       : unsigned (31 downto 0);
  signal lo                       : unsigned(31 downto 0);

  
begin

  a     <= unsigned(sdata1);
  b     <= unsigned(sdata2) when ALUSrc = '0' else unsigned(Sign_Extended);
  shift <= conv_integer(shamt);

  process(BNECtrl, result)
  begin
    Zero <= '0';

    if (BNECtrl = '1') then
      if (result = X"00000000") then
        Zero <= '0';
      else
        Zero <= '1';
      end if;
    else
      if (result = X"00000000") then
        Zero <= '1';
      else
        Zero <= '0';
      end if;
    end if;
  end process;

  process (clk, reset, result_munext)
  begin

    if (reset = '1') then
      result_mu <= (others => '0');
    elsif(rising_edge(clk)) then
      result_mu <= result_munext;
    end if;
  end process;

--process(a,b, mult, result_mu)
--begin
--result_munext <= result_mu; 

--    if (mult = '1') then
--        result_munext <=   unsigned(a*b);
--    else
--        result_munext <= result_mu;  
--    end if;
--end process;         


  process (a, b, alu_control, shift, HI, LO, result_mu)
  begin
    result <= (others => '0');

    result_munext <= result_mu;
    case (alu_control) is
      
      when "0001" => result        <= unsigned(a + b);
      when "0010" => result        <= unsigned(a - b);
      when "0011" => result_munext <= unsigned(a * b);
      when "0100" => result        <= unsigned(a and b);
      when "0101" => result        <= unsigned(a or b);
      when "0110" => result        <= unsigned(a xor b);
      when "0111" => result        <= SHIFT_LEFT(unsigned(b), shift);
      when "1000" => result        <= SHIFT_RIGHT(unsigned (b), shift);
--        when "1001" =>  result          <= unsigned (to_stdlogicvector(to_bitvector(std_logic_vector(b)) SRA shift));
      when "1001" => result        <= unsigned (SHIFT_RIGHT(signed(b), shift));
      when "1011" => if (a < b) then
                        result <= x"00000001";
                      else
                        result <= x"00000000";
                      end if;
      when "1010" => if (a(31) = '1' and b(31) = '1') then
                       if (a(30 downto 0) > b(30 downto 0)) then
                         result <= x"00000001";
                       else
                         result <= x"00000000";
                       end if;
    elsif(a(31) = '1' and b(31) = '0') then
      result <= x"00000001";
    elsif(a(31) = '0' and b(31) = '1') then
      result <= x"00000000";
    elsif(a(31) = '0' and b(31) = '0') then
      if (a(30 downto 0) < b(30 downto 0)) then
        result <= x"00000001";
      else
        result <= x"00000000";
      end if;
    end if;

    when "1100" => result <= result_mu(63 downto 32);
    when "1101" => result <= result_mu(31 downto 0);
    when "1110" => result <= a;


    when others => result <= X"00000000";
    
  end case;
end process;





alu_result <= std_logic_vector(result);
-- LO         <= result_mu(31 downto 0);
-- HI         <= result_mu(63 downto 32);        
end Behavioral;
