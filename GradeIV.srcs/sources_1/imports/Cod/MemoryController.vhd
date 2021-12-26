-- The MemoryController replaces the IMController in the Harvard Architecture  

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;



entity MemoryController is
  port (clk       : in  std_logic;
        reset     : in  std_logic;
        start     : in  std_logic;
        MemRead   : in  std_logic;
        MemWrite  : in  std_logic;
        DataIn    : in  std_logic_vector (31 downto 0);
        DataAddr  : in  std_logic_vector (7 downto 0);
        PCin      : in  std_logic_vector(7 downto 0);
        Input     : in  std_logic_vector(31 downto 0);
        InstrOut  : out std_logic_vector(31 downto 0);
        DataOut   : out std_logic_vector(31 downto 0);
        DO        : out std_logic_vector (31 downto 0);
        Addr      : out std_logic_vector (7 downto 0);
        CSxI      : out std_logic;
        WExI      : out std_logic;
        PCstart   : out std_logic
        );
end MemoryController;

architecture Behavioral of MemoryController is
  type   state is (LOAD , EXE , EXHOLD, LWMEM, LWHOLD, SWMEM);
  signal currentstate, nextstate : state;

  signal instrcounter, instrcounternext                 : integer;
  signal addrcounter, addrcounternext                   : std_logic_vector(7 downto 0);
  signal PCdiv                                          : std_logic_vector(7 downto 0);
  signal MemDataAddr                                    : std_logic_vector(7 downto 0);
  signal Data, Datanext                               : std_logic_vector(31 downto 0);
  signal Instr1, Instr2, Instr3, Instr4                 : std_logic_vector(7 downto 0);
  signal Instr1next, Instr2next, Instr3next, Instr4next : std_logic_vector(7 downto 0);
  signal addrflag                                       : std_logic;

begin
  PCdiv       <= "00" & PCin (7 downto 2);
  MemDataAddr <= '1' & DataAddr (6 downto 0);
  process(clk, reset)
  begin
    if (reset = '1') then
      Data        <= (others => '0');
      currentstate <= LOAD;
    elsif(rising_edge(clk)) then

      Data        <= Datanext;
      currentstate <= nextstate;
    end if;
  end process;








  
  
  process (currentstate, Start, PCdiv, DataAddr, MemRead, MemWrite, DataIn,
           MemDataAddr, addrcounter, Input, Data)
  begin
    nextstate <= currentstate;
    CSxI      <= '1';
    WExI      <= '0';
    PCstart   <= '0';
    InstrOut  <= (others => '0');
    DataOut   <= (others => '0');
    DO        <= (others => '0');
    Addr      <= (others => '0');
    Datanext <= Data;
    case (currentstate) is
      
      when LOAD => CSxI <= '0';         -- Writing Instructions to Memory
                   WExI     <= '0';
--                   DO       <= Instr;
--                   Addr     <= addrcounter;
--                   InstrOut <= (others => '0');

                   if (Start = '1') then
                     nextstate <= EXHOLD;
                   else
                     nextstate <= LOAD;
                   end if;
                   
      when EXHOLD => CSxI <= '0';  -- Hold state for reading out instructions
                     WExI     <= '0';
                     PCstart  <= '1';
                     Addr     <= PCdiv;
                     InstrOut <= (others => '0');

                     nextstate <= EXE;
                     
      when EXE => CSxI <= '0';  -- Executions of the Instrctions read out of memory
                  WExI     <= '0';
                  PCstart  <= '1';
                  Addr     <= PCdiv;
                  InstrOut <= Input;

                  if (MemRead = '0' and MemWrite = '0') then
                    nextstate <= LWHOLD;
                  elsif (MemRead = '0' and MemWrite = '1') then
                    nextstate <= SWMEM;
                  else
                    nextstate <= EXE;
                  end if;
                  
      when LWHOLD => CSxI <= '0';  -- Hold state for reading out data from the memory
                     WExI     <= '0';
                     PCstart  <= '0';
                     Addr     <= MemDataAddr;
                     DataOut  <= (others => '0');
                     Datanext <= Input;

                     nextstate <= LWMEM;
                     
      when LWMEM => CSxI <= '1';  -- Reading out data from memory for LW instructions
                    WExI    <= '0';
                    PCstart <= '0';
                    Addr    <= MemDataAddr;
                    DataOut <= Data;

                    if (MemRead = '0' and MemWrite = '0') then
                      nextstate <= LWHOLD;
                    elsif (MemRead = '0' and MemWrite = '1') then
                      nextstate <= SWMEM;
                    else
                      nextstate <= EXE;
                    end if;
                    
      when SWMEM => CSxI <= '0';  -- Writing data to the memory for SW instructiona
                    WExI    <= '1';
                    PCstart <= '0';
                    Addr    <= MemDataAddr;
                    DO      <= DataIn;

                    if (MemRead = '0' and MemWrite = '0') then
                      nextstate <= LWHOLD;
                    elsif (MemRead = '0' and MemWrite = '1') then
                      nextstate <= SWMEM;
                    else
                      nextstate <= EXE;
                    end if;
                    
      when others => nextstate <= currentstate;  -- Default case
                     CSxI     <= '1';
                     WExI     <= '1';
                     PCstart  <= '0';
                     InstrOut <= (others => '0');
                     DataOut  <= (others => '0');
                     DO       <= (others => '0');
                     Addr     <= (others => '0');
                     
    end case;

  end process;
  
  


end Behavioral;

