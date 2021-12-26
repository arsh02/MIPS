library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity MIPS_top is
  Port (
        clk, reset  :   in  std_logic;
        start       :   in  std_logic;
        regselbit   :   in  std_logic_vector(4 downto 0); 
        readoutreg  :   out std_logic_vector(31 downto 0);
        clk_out     :   out std_logic
        );  
end MIPS_top;

architecture Behavioral of MIPS_top is

component ALU is
    Port ( clk, reset   : in std_logic;
           sdata1       : in std_logic_vector (31 downto 0);
           sdata2       : in std_logic_vector (31 downto 0);
           Sign_Extended: in std_logic_vector (31 downto 0);           
           shamt        : in std_logic_vector (4 downto 0);
           alu_control  : in std_logic_vector (3 downto 0);
           ALUSrc       : in std_logic;
           alu_result   : out std_logic_vector (31 downto 0);
		   BNECtrl      : in std_logic;	
           Zero         : out std_logic
           );           
end component;

component ALU_Control is
    Port (  ALUOp   : in std_logic_vector(1 downto 0);
            Funct   : in std_logic_vector(5 downto 0);
            ALUCtrl : out std_logic_vector(3 downto 0)
         );
end component;

component GPR is
  Port (clk, reset  : in std_logic;
        RegWrite    : in std_logic;
	    RegWrite31  : in std_logic;
        readreg1    : in std_logic_vector (4 downto 0);
        readreg2    : in std_logic_vector (4 downto 0);
        writereg    : in std_logic_vector (4 downto 0);
        writedata   : in std_logic_vector (31 downto 0);
        writedata31 : in std_logic_vector (31 downto 0);
        reg1data    : out std_logic_vector (31 downto 0);
        reg2data    : out std_logic_vector (31 downto 0);
        regselbit   : in std_logic_vector (4 downto 0);
        readoutreg  : out std_logic_vector (31 downto 0)       
        );      
end component;

component Reg_Mux is
  Port (SrcReg  : in std_logic_vector(4 downto 0);
        DstReg  : in std_logic_vector(4 downto 0);
        RegDst  : in std_logic;
        WriteReg: out std_logic_vector(4 downto 0)
   );
end component;



component PC is
    Port ( clk, reset   : in  STD_LOGIC;
           PCin         : in  STD_LOGIC_VECTOR (31 downto 0);
           PCout        : out  STD_LOGIC_VECTOR (31 downto 0);
	   start	: in	STD_LOGIC
           );
end component;

component ALU_PC is
  Port (PC_in   : in std_logic_vector(31 downto 0);
        start   : in std_logic;
        PC_out  : out std_logic_vector(31 downto 0)     
  );
end component;

component ALU_BRANCH is
      Port (PCin            : in    std_logic_vector(31 downto 0); 
            ExtendedIn      : in    std_logic_vector(31 downto 0);
            BranchAddResult : out   std_logic_vector(31 downto 0) 
   );
end component;

component Data_Memory is
  Port( MemtoReg        : in std_logic;
        MemDatain       : in std_logic_vector(31 downto 0);
        ALUResult       : in std_logic_vector(31 downto 0);    
        Dataout         : out std_logic_vector(31 downto 0)      
        );
end component;

component SRAM_SP_WRAPPER IS
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

component Sign_Extend is
  Port (instr   : in    std_logic_vector(15 downto 0);
        LUICtrl : in    std_logic;
        extended: out   std_logic_vector(31 downto 0)  
  );
end component;

component ControlUnit is
	Port (	InstructionIn	:	in	std_logic_vector (5 downto 0);
			RegDst			:	out	std_logic;
			Branch			:	out	std_logic;
			Jump			:	out	std_logic;
			MemRead			:	out	std_logic;
			MemtoReg		:	out	std_logic;
			ALUOp			:	out	std_logic_vector (1 downto 0);
			MemWrite		:	out	std_logic;
			ALUSrc			:	out	std_logic;
			LUICtrl         	:   	out 	std_logic;
			RegWrite		:	out	std_logic;
		    	BNECtrl         	:   	out 	std_logic	
					
	);
end component;

component MUX_JUMP is
  Port (
        JumpAddr    :   in      std_logic_vector ( 31 downto 0  );
        BranchOut   :   in      std_logic_vector ( 31 downto 0 );
        JumpControl :   in      std_logic;
        JumpOutput  :   out     std_logic_vector ( 31 downto 0 )   
        );
end component;

component MUXBranch is
    Port (
            Branch          : in    std_logic;
            Zero            : in    std_logic;
            PCin            : in    std_logic_vector(31 downto 0);
            BranchAddResult : in    std_logic_vector(31 downto 0);
            PCout           : out   std_logic_vector(31 downto 0)
            
        );
end component;

component ShiftLeftJUMP is
    Port (
            InstrionIn  :   in      std_logic_vector ( 25 downto 0 );
            PC4         :   in      std_logic_vector ( 3 downto 0  );
            JumpAddr    :   out     std_logic_vector ( 31 downto 0  )
        );
end component;




component ForwardignUnit is
    Port ( 
            EXWriteReg          :   in  std_logic_vector ( 4  downto 0 );
            WBEXWriteReg        :   in  std_logic_vector ( 4  downto 0 );
            IDEXInstructionRT   :   in  std_logic_vector ( 4  downto 0 );
            IDEXInstructionRS   :   in  std_logic_vector ( 4  downto 0 );
            EXRegWrite          :   in  std_logic;
            WBEXRegWrite        :   in  std_logic;
            ForwardA            :   out std_logic_vector  (1  downto 0);
            ForwardB            :   out std_logic_vector  (1  downto 0)             
         );
end component;


component ForwardingMUXes is
    Port ( 
            ForwardA            :   in  std_logic_vector ( 1  downto 0 );
            ForwardB            :   in  std_logic_vector ( 1  downto 0 );
            WBMUXDataoutout     :   in  std_logic_vector ( 31 downto 0 );
            IDEXreg1data        :   in  std_logic_vector ( 31 downto 0 );
            IDEXreg2data        :   in  std_logic_vector ( 31 downto 0 );
            EXaluresult         :   in  std_logic_vector ( 31 downto 0 );
            ALUOperand1         :   out std_logic_vector ( 31 downto 0 );
            ALUOperand2         :   out std_logic_vector ( 31 downto 0 )
         );
end component;

component EXMEMReg is
    Port ( 
            clk, reset          :   in  std_logic;
            Zero                :   in  std_logic;
            BranchPCout         :   in  std_logic_vector ( 31 downto 0);
            aluresult           :   in  std_logic_vector ( 31 downto 0);
            sdata2              :   in  std_logic_vector ( 31 downto 0);
            WriteReg            :   in  std_logic_vector ( 4  downto 0);
            JumpAddr            :   in  std_logic_vector ( 31 downto 0);
            IDEXBranch          :   in  std_logic;
            IDEXJump            :   in  std_logic;
            IDEXMemRead         :   in  std_logic;
            IDEXMemWrite        :   in  std_logic;
            IDEXMemtoReg        :   in  std_logic;         
            IDEXRegWrite        :   in  std_logic;
            EXZero              :   out std_logic;
            EXBranchPCout       :   out std_logic_vector ( 31 downto 0);
            EXaluresult         :   out std_logic_vector ( 31 downto 0);
            EXsdata2            :   out std_logic_vector ( 31 downto 0);
            EXJumpAddr          :   out std_logic_vector ( 31 downto 0);
            EXWriteReg          :   out std_logic_vector ( 4  downto 0);
            EXBranch            :   out std_logic;
            EXJump              :   out std_logic;
            EXMemRead           :   out std_logic;
            EXMemWrite          :   out std_logic;
            EXMemtoReg          :   out std_logic;         
            EXRegWrite          :   out std_logic
         );
end component;

component IDEXReg is
    Port (
            clk, reset          :   in  std_logic;
            IFIDregPCOut        :   in  std_logic_vector (31 downto 0);
            reg1data            :   in  std_logic_vector (31 downto 0);
            reg2data            :   in  std_logic_vector (31 downto 0);
            extended            :   in  std_logic_vector (31 downto 0);
            InstructionRT       :   in  std_logic_vector (4  downto 0);
            InstructionRS       :   in  std_logic_vector (4  downto 0);
            InstructionRDst     :   in  std_logic_vector (4  downto 0);
	    shamt		:   in  std_logic_vector (4 downto 0);
            IntructionJump      :   in  std_logic_vector (25 downto 0);
            RegDst              :	in	std_logic;
            Branch              :   in  std_logic;
            Jump                :   in  std_logic;
            MemRead             :   in  std_logic;
            MemtoReg            :   in  std_logic;
            ALUOp               :   in  std_logic_vector (1 downto 0);
            MemWrite            :   in  std_logic;
            ALUSrc              :   in  std_logic;            
            RegWrite            :   in  std_logic;
            BNECtrl             :   in  std_logic;
            IDEXregPCOut        :   out std_logic_vector (31 downto 0);
            IDEXreg1data        :   out std_logic_vector (31 downto 0);
            IDEXreg2data        :   out std_logic_vector (31 downto 0);
            IDEXextended        :   out std_logic_vector (31 downto 0);
            IDEXInstructionRT   :   out std_logic_vector (4  downto 0);
            IDEXInstructionRDst :   out std_logic_vector (4  downto 0);
	        IDEXShamt   	    :   out std_logic_vector (4  downto 0);
            IDEXInstructionRS   :   out  std_logic_vector (4  downto 0);
            IDEXIntructionJump  :   out std_logic_vector (25 downto 0);       
            IDEXRegDst          :   out std_logic;
            IDEXBranch          :   out std_logic;
            IDEXJump            :   out std_logic;
            IDEXMemRead         :   out std_logic;
            IDEXMemtoReg        :   out std_logic;
            IDEXALUOp           :   out std_logic_vector (1 downto 0);
            IDEXMemWrite        :   out std_logic;
            IDEXALUSrc          :   out std_logic;            
            IDEXRegWrite        :   out std_logic;
            IDEXBNECtrl         :   out std_logic
     );
end component;


component IFIDReg is
    Port (  
            clk, reset          :   in  std_logic;
            FourAddedPCin       :   in  std_logic_vector(31 downto 0);
            Instr               :   in  std_logic_vector(31 downto 0);
            IFIDregPCOut        :   out std_logic_vector(31 downto 0)
--            IFIDreginstr        :   out std_logic_vector(31 downto 0)
         );
end component;

component MEMWBReg is
    Port (
            clk, reset          :   in  std_logic;
            ALUResult           :   in  std_logic_vector ( 31 downto 0 );    
--            DMDataout           :   in  std_logic_vector ( 31 downto 0 );
            EXWriteReg          :   in  std_logic_vector ( 4  downto 0 );
            EXMemtoReg          :   in  std_logic;         
            EXRegWrite          :   in  std_logic;
            WBALUResult         :   out std_logic_vector ( 31 downto 0 );    
--            WBDMDataout         :   out std_logic_vector ( 31 downto 0 );
            WBEXWriteReg        :   out std_logic_vector ( 4  downto 0 );
            WBEXMemtoReg        :   out std_logic;         
            WBEXRegWrite        :   out std_logic
         );
end component;

component JALMUX is
  Port (InstructionIn   :   in  std_logic_vector(5 downto 0);
        PC4in           :   in  std_logic_vector(31 downto 0);    
        WriteDataOut    :   out std_logic_vector(31 downto 0);
	      RegWriteFrmJAL	:   out std_logic       
         );
end component;

component JRMUX is
  Port (
        ALUCtrl	    :   in  std_logic_vector( 3 downto 0);
        PCin        :   in  std_logic_vector(31 downto 0);
        ALUResultIn :   in  std_logic_vector(31 downto 0);
        PCout       :   out std_logic_vector(31 downto 0)
  );
end component;

component MUXAfterIM is
    Port ( clk, reset   : in  std_logic;
       start        : in  std_logic;
       MemRead      : in STD_LOGIC;
       MemWrite     : in STD_LOGIC;
       Input        : in  std_logic_vector(31 downto 0);
       MuxDataOut   : out std_logic_vector(31 downto 0);
       LWDataOut    : out std_logic_vector(31 downto 0)
       );          
end component;



component MemoryController is
    Port ( clk          : in STD_LOGIC;
       reset        : in STD_LOGIC;
       start        : in std_logic;
       MemRead      : in STD_LOGIC;
       MemWrite     : in STD_LOGIC;
       DataIn       : in STD_LOGIC_VECTOR (31 downto 0);
       DataAddr     : in STD_LOGIC_VECTOR (7 downto 0);
       PCin         : in std_logic_vector(7 downto 0);
       DO           : out STD_LOGIC_VECTOR (31 downto 0);
       Input        : in  std_logic_vector(31 downto 0);
       InstrOut     : out std_logic_vector(31 downto 0);
       DataOut      : out std_logic_vector(31 downto 0);
       Addr         : out STD_LOGIC_VECTOR (7 downto 0);
       CSxI         : out STD_LOGIC;
       WExI         : out std_logic;
       PCstart      : out std_logic    
       );
end component;








  
    signal  PC4toIFIDRegSig             :   std_logic_vector ( 31 downto 0 );
    signal  PC4fromIFIDRegSig           :   std_logic_vector ( 31 downto 0 );
    signal  PC4fromIDEXRegSig           :   std_logic_vector ( 31 downto 0 );
    signal  PC4fromALUBranchSig         :   std_logic_vector ( 31 downto 0 );
    signal  PC4fromEXMEMRegSig          :   std_logic_vector ( 31 downto 0 );
    signal  AddrfromBMuxtoJMuxSig       :   std_logic_vector ( 31 downto 0 );
    signal  AddrfromJumpMuxSig          :   std_logic_vector ( 31 downto 0 );
    signal  AddrfromJumpRMuxSig         :   std_logic_vector ( 31 downto 0 );
    signal  PCtoIMSig                   :   std_logic_vector ( 31 downto 0 );
    signal  InstructiontoIFIDRegSig     :   std_logic_vector ( 31 downto 0 );
    signal  InstructionFrmIFIDRegSig    :   std_logic_vector ( 31 downto 0 );
    signal  InstructionFrmIMMux		:   std_logic_vector ( 31 downto 0 );
    signal  ReadData1toIDEXRegSig       :   std_logic_vector ( 31 downto 0 );
    signal  ReadData2toIDEXRegSig       :   std_logic_vector ( 31 downto 0 );
    signal  SignExtentoIDEXRegSig       :   std_logic_vector ( 31 downto 0 );
    signal  ReadData1fromIDEXRegSig     :   std_logic_vector ( 31 downto 0 );
    signal  ReadData2fromIDEXRegSig     :   std_logic_vector ( 31 downto 0 );
    signal  SignExtenfromIDEXRegSig     :   std_logic_vector ( 31 downto 0 );
    signal  InstrRTfromIDEXRegSig       :   std_logic_vector ( 4  downto 0 );
    signal  InstrRDstfromIDEXRegSig     :   std_logic_vector ( 4  downto 0 );
    signal  ALUResultToEXMEMRegSig      :   std_logic_vector ( 31 downto 0 );
    signal  RegDstMuxToEXMEMRegSig      :   std_logic_vector ( 4  downto 0 );
    signal  IntstrJFromIDEXRegSig       :   std_logic_vector ( 25 downto 0 );
    signal  JumpAddrToEXMemSig          :   std_logic_vector ( 31 downto 0 );
    signal  JumpAddrFromEXMemSig        :   std_logic_vector ( 31 downto 0 );
    signal  ALUResultFromEXMEMRegSig    :   std_logic_vector ( 31 downto 0 );
    signal  ReadData2fromEXRegSig       :   std_logic_vector ( 31 downto 0 );
    signal  RegDstMuxFromEXMEMRegSig    :   std_logic_vector ( 4  downto 0 );
    signal  RegDstMuxFromWBRegSig       :   std_logic_vector ( 4  downto 0 );
    signal  RYsig                       :   std_logic;
    signal  RYsig1                      :   std_logic;
    signal  DataOutFromDMSig            :   std_logic_vector ( 31 downto 0 );
    signal  ALUResultFromWBRegSig       :   std_logic_vector ( 31 downto 0 );
    signal  DataOutDMFromWBRegSig       :   std_logic_vector ( 31 downto 0 );
    signal  DataOutWBMUXSig             :   std_logic_vector ( 31 downto 0 );
    signal  RegDstsigToIDEX             :   std_logic;
    signal  BranchsigToIDEX             :   std_logic;
    signal  JumpsigToIDEX               :   std_logic;
    signal  MemReadsigToIDEX            :   std_logic;
    signal  MemtoRegsigToIDEX           :   std_logic;
    signal  ALUOpsigToIDEX              :   std_logic_vector ( 1  downto 0 );
    signal  MemWritesigToIDEX           :   std_logic;
    signal  ALUSrcsigToIDEX             :   std_logic;    
    signal  BNECtrlsigToIDEX            :   std_logic;
    signal  RegWritesigToIDEX           :   std_logic;
    signal  RegDstsigFromIDEX           :   std_logic;
    signal  BranchsigFromIDEX           :   std_logic;
    signal  JumpsigFromIDEX             :   std_logic;
    signal  MemReadsigFromIDEX          :   std_logic;
    signal  MemtoRegsigFromIDEX         :   std_logic;
    signal  ALUOpsigFromIDEX            :   std_logic_vector ( 1  downto 0 );
    signal  MemWritesigFromIDEX         :   std_logic;
    signal  ALUSrcsigFromIDEX           :   std_logic;    
    signal  BNECtrlsigFromIDEX          :   std_logic;
    signal  RegWritesigFromIDEX         :   std_logic;  
    signal  ZeroToEX                    :   std_logic;
    signal  ZeroSigFromEX               :   std_logic;
    signal  LUICtrlsig                  :   std_logic;
    signal  ALUCtrlSig                  :   std_logic_vector (3 downto 0);        
    signal  BranchsigFromEX             :   std_logic;    
    signal  JumpsigFromEX               :   std_logic;    
    signal  MemReadsigFromEX            :   std_logic;    
    signal  MemWritesigFromEX           :   std_logic;    
    signal  MemtoRegsigFromEX           :   std_logic;    
    signal  RegWritesigFromEX           :   std_logic;    
    signal  MemtoRegsigFromWB           :   std_logic;    
    signal  RegWritesigFromWB           :   std_logic;
    signal  IntrRSFromIDEXSig           :   std_logic_vector ( 4  downto 0 );
    signal  ShiftsigFromIDEX            :   std_logic_vector ( 4  downto 0 );
    signal  FMUX1toALUSig               :   std_logic_vector ( 31 downto 0 );
    signal  FMUX2toALUSig               :   std_logic_vector ( 31 downto 0 );
    signal  ForwardASig                 :   std_logic_vector ( 1  downto 0 );
    signal  ForwardBSig                 :   std_logic_vector ( 1  downto 0 );
    signal  PCIMMuxtoIMSig              :   std_logic_vector ( 7  downto 0 );
    signal  DstRegFromJALMUX            :   std_logic_vector ( 4  downto 0 );
    signal  DataFromJALMUX              :   std_logic_vector ( 31 downto 0 ); 
    signal  ReadsigFromIMcontroller     :   std_logic;
    signal  WritesigFromIMcontroller    :   std_logic;
    signal  AddrFromController          :   std_logic_vector ( 7  downto 0 );
    signal  InstrFromController         :   std_logic_vector ( 31 downto 0 );
    signal  Ntclock			            :   std_logic; 
    signal  RegWrite31sig		        :   std_logic; 
    signal  PCstartsig		            :   std_logic;     
    signal  AddrtoMemory                :   std_logic_vector ( 7  downto 0 );
    signal  DatatoMemory                :   std_logic_vector ( 31 downto 0 );    
    signal  ReadtoMemory		        :   std_logic; 
    signal  WritetoMemory               :   std_logic;    
    

begin
    
    clk_out  <=  clk;
    
    ALU_inst    : ALU
    port map(
            clk             => clk,
            reset           => reset,
            sdata1          => FMUX1toALUSig,
            sdata2          => FMUX2toALUSig,
            Sign_Extended   => SignExtenfromIDEXRegSig,
            shamt           => ShiftsigFromIDEX,
            alu_control     => ALUCtrlSig,
            ALUSrc          => ALUSrcsigFromIDEX,
            alu_result      => ALUResultToEXMEMRegSig,
            BNECtrl         => BNECtrlsigFromIDEX,
            Zero            => ZeroToEX
            );
            
            
    ALU_control_inst    : ALU_Control
    port map(
            ALUOp           => ALUOpsigFromIDEX,
            Funct           => IntstrJFromIDEXRegSig( 5 downto 0),
            ALUCtrl         => ALUCtrlSig
    );  
    
    
    GPR_inst    : GPR
    port map(
            clk         => clk,
            reset       => reset,
            RegWrite    => RegWritesigFromWB,
              RegWrite31  => RegWrite31sig,
            readreg1    => InstructionFrmIMMux( 25 downto 21 ),
            readreg2    => InstructionFrmIMMux( 20 downto 16 ), 
            writereg    => RegDstMuxFromWBRegSig,
            writedata   => DataOutWBMUXSig,
              writedata31 => DataFromJALMUX,
            reg1data    => ReadData1toIDEXRegSig,
            reg2data    => ReadData2toIDEXRegSig,
            regselbit   => regselbit,
            readoutreg  => readoutreg
    );     
    
    Reg_Mux_inst    : Reg_Mux
    port map(
            SrcReg  => InstrRTfromIDEXRegSig,
            DstReg  => InstrRDstfromIDEXRegSig,
            RegDst  => RegDstsigFromIDEX,
            WriteReg=> RegDstMuxToEXMEMRegSig
    );  
    



    
    PC_inst         : PC
    port map(
             clk    => clk,
             reset  => reset,
             PCin   => AddrfromJumpRMuxSig,
             PCout  => PCtoIMSig,
	     start   => start
    );   
    
    ALU_PC_inst     : ALU_PC
    port map(
            start   => PCstartsig,
            PC_in   => PCtoIMSig,
            PC_out  => PC4toIFIDRegSig
    );
    
    ALU_BRANCH_inst   : ALU_BRANCH
    port map(
            PCin            => PC4fromIDEXRegSig,
            ExtendedIn      => SignExtenfromIDEXRegSig,
            BranchAddResult => PC4fromALUBranchSig
    );
    
    Data_Memory_MUX_inst    : Data_Memory
    port map(
            MemtoReg    =>  MemtoRegsigFromWB,
            MemDatain   =>  DataOutDMFromWBRegSig, 
            ALUResult   =>  ALUResultFromWBRegSig,
            Dataout     =>  DataOutWBMUXSig
    ); 
    

    
    Sign_Extend_inst    : Sign_Extend
    port map(
            instr   => InstructionFrmIMMux( 15 downto 0 ),
            LUICtrl => LUICtrlsig,
            extended=> SignExtentoIDEXRegSig
    );
    
    ControlUnit_inst        : ControlUnit
    port map(
            InstructionIn   =>   InstructionFrmIMMux( 31 downto 26 ),
            RegDst          =>   RegDstsigToIDEX  ,
            Branch          =>   BranchsigToIDEX  ,
            Jump            =>   JumpsigToIDEX    ,
            MemRead         =>   MemReadsigToIDEX ,
            MemtoReg        =>   MemtoRegsigToIDEX,
            ALUOp           =>   ALUOpsigToIDEX   ,
            MemWrite        =>   MemWritesigToIDEX,
            ALUSrc          =>   ALUSrcsigToIDEX  ,
            LUICtrl         =>   LUICtrlsig       ,
            BNECtrl         =>   BNECtrlsigToIDEX ,
            RegWrite        =>   RegWritesigToIDEX
    );
    
    MUX_JUMP_inst           : MUX_JUMP
    port map(
            JumpAddr      =>        JumpAddrFromEXMemSig,
            BranchOut     =>        AddrfromBMuxtoJMuxSig,
            JumpControl   =>        JumpsigFromEX,
            JumpOutput    =>        AddrfromJumpMuxSig              
    );
    
    MUXBranchinst           :   MUXBranch
    Port map(
                Branch          =>      BranchsigFromEX,
                Zero            =>      ZeroSigFromEX,
                PCin            =>      PC4toIFIDRegSig,
                BranchAddResult =>      PC4fromEXMEMRegSig,
                PCout           =>      AddrfromBMuxtoJMuxSig
                
            );
    
    ShiftLeftJUMPinst        :  ShiftLeftJUMP
    Port map(
                InstrionIn  =>  IntstrJFromIDEXRegSig,
                PC4         =>  PC4fromIDEXRegSig( 31 downto 28 ),
                JumpAddr    =>  JumpAddrToEXMemSig
            );
    
    ForwardignUnitinst      :   ForwardignUnit
    Port map( 
                EXWriteReg           =>     RegDstMuxFromEXMEMRegSig,
                WBEXWriteReg         =>     RegDstMuxFromWBRegSig,
                IDEXInstructionRT    =>     InstrRTfromIDEXRegSig,
                IDEXInstructionRS    =>     IntrRSFromIDEXSig,    
                EXRegWrite           =>     RegWritesigFromEX,
                WBEXRegWrite         =>     RegWritesigFromWB,
                ForwardA             =>     ForwardASig,
                ForwardB             =>     ForwardBSig    
             );
    
    
    ForwardingMUXesinst     :   ForwardingMUXes
    Port map(                        
                ForwardA             =>     ForwardASig,
                ForwardB             =>     ForwardBSig, 
                WBMUXDataoutout      =>     DataOutWBMUXSig,
                IDEXreg1data         =>     ReadData1fromIDEXRegSig,
                IDEXreg2data         =>     ReadData2fromIDEXRegSig,
                EXaluresult          =>     ALUResultFromEXMEMRegSig,
                ALUOperand1          =>     FMUX1toALUSig,
                ALUOperand2          =>     FMUX2toALUSig
             );
                 
    
    EXMEMReginst    :   EXMEMReg
        Port map( 
                clk                 =>       clk,  
                reset               =>       reset,
                Zero                =>       ZeroToEX,
                BranchPCout         =>       PC4fromALUBranchSig,
                aluresult           =>       ALUResultToEXMEMRegSig,
                sdata2              =>       ReadData2fromIDEXRegSig,
                WriteReg            =>       RegDstMuxToEXMEMRegSig,
                JumpAddr            =>       JumpAddrToEXMemSig,
                IDEXBranch          =>       BranchsigFromIDEX  ,
                IDEXJump            =>       JumpsigFromIDEX    ,
                IDEXMemRead         =>       MemReadsigFromIDEX ,
                IDEXMemWrite        =>       MemWritesigFromIDEX,
                IDEXMemtoReg        =>       MemtoRegsigFromIDEX,
                IDEXRegWrite        =>       RegWritesigFromIDEX,
                EXZero              =>       ZeroSigFromEX,
                EXBranchPCout       =>       PC4fromEXMEMRegSig,
                EXaluresult         =>       ALUResultFromEXMEMRegSig,
                EXsdata2            =>       ReadData2fromEXRegSig,
                EXWriteReg          =>       RegDstMuxFromEXMEMRegSig,
                EXJumpAddr          =>       JumpAddrFromEXMemSig,
                EXBranch            =>       BranchsigFromEX  ,
                EXJump              =>       JumpsigFromEX    ,
                EXMemRead           =>       MemReadsigFromEX ,
                EXMemWrite          =>       MemWritesigFromEX,
                EXMemtoReg          =>       MemtoRegsigFromEX,
                EXRegWrite          =>       RegWritesigFromEX
             );
    
    IDEXReginst     :   IDEXReg
        Port map(
                clk                 =>      clk,  
                reset               =>      reset,
                IFIDregPCOut        =>      PC4fromIFIDRegSig,
                reg1data            =>      ReadData1toIDEXRegSig,
                reg2data            =>      ReadData2toIDEXRegSig,
                extended            =>      SignExtentoIDEXRegSig,
                InstructionRT       =>      InstructionFrmIMMux( 20 downto 16 ),
                InstructionRS       =>      InstructionFrmIMMux( 25 downto 21 ),
                InstructionRDst     =>      InstructionFrmIMMux( 15 downto 11 ),
                IntructionJump      =>      InstructionFrmIMMux( 25 downto 0  ), 
		        shamt		        =>      InstructionFrmIMMux( 10 downto 6 ),           
                RegDst              =>      RegDstsigToIDEX  , 
                Branch              =>      BranchsigToIDEX  , 
                Jump                =>      JumpsigToIDEX    , 
                MemRead             =>      MemReadsigToIDEX , 
                MemtoReg            =>      MemtoRegsigToIDEX, 
                ALUOp               =>      ALUOpsigToIDEX   , 
                MemWrite            =>      MemWritesigToIDEX, 
                ALUSrc              =>      ALUSrcsigToIDEX  , 
                RegWrite            =>      RegWritesigToIDEX, 
                BNECtrl             =>      BNECtrlsigToIDEX , 
                IDEXregPCOut        =>      PC4fromIDEXRegSig,      
                IDEXreg1data        =>      ReadData1fromIDEXRegSig,
                IDEXreg2data        =>      ReadData2fromIDEXRegSig,
                IDEXextended        =>      SignExtenfromIDEXRegSig,
                IDEXInstructionRT   =>      InstrRTfromIDEXRegSig,
                IDEXInstructionRS   =>      IntrRSFromIDEXSig,      
                IDEXInstructionRDst =>      InstrRDstfromIDEXRegSig,      
                IDEXIntructionJump  =>      IntstrJFromIDEXRegSig,
                IDEXRegDst          =>      RegDstsigFromIDEX  ,
                IDEXBranch          =>      BranchsigFromIDEX  ,
                IDEXJump            =>      JumpsigFromIDEX    ,
		        IDEXShamt	        =>      ShiftsigFromIDEX, 
                IDEXMemRead         =>      MemReadsigFromIDEX ,
                IDEXMemtoReg        =>      MemtoRegsigFromIDEX,
                IDEXALUOp           =>      ALUOpsigFromIDEX   ,
                IDEXMemWrite        =>      MemWritesigFromIDEX,
                IDEXALUSrc          =>      ALUSrcsigFromIDEX  ,
                IDEXRegWrite        =>      RegWritesigFromIDEX ,
                IDEXBNECtrl         =>      BNECtrlsigFromIDEX
         );
    
    
    IFIDReginst     :   IFIDReg                    
        Port map(  
                clk                 =>      clk,       
                reset               =>      reset,
                FourAddedPCin       =>      PC4toIFIDRegSig,
                Instr               =>      InstructionFrmIMMux,
                IFIDregPCOut        =>      PC4fromIFIDRegSig
--                IFIDreginstr        =>      InstructionFrmIFIDRegSig
             );
    
    MEMWBReginst    :   MEMWBReg
        Port map(
                clk                 =>      clk,  
                reset               =>      reset,
                ALUResult           =>      ALUResultFromEXMEMRegSig,
--                DMDataout           =>      DataOutFromDMSig,
                EXWriteReg          =>      RegDstMuxFromEXMEMRegSig,
                EXMemtoReg          =>      MemtoRegsigFromEX,
                EXRegWrite          =>      RegWritesigFromEX,
                WBALUResult         =>      ALUResultFromWBRegSig,
--                WBDMDataout         =>      DataOutDMFromWBRegSig,
                WBEXWriteReg        =>      RegDstMuxFromWBRegSig,
                WBEXMemtoReg        =>      MemtoRegsigFromWB,
                WBEXRegWrite        =>      RegWritesigFromWB
             );
            
    
        
             
--    SRAM_SP_WRAPPER_inst    : SRAM_SP_WRAPPER
--             port map(
--                     ClkxCI      => clk,
--                     CSxSI       => ReadtoMemory,            -- Active Low
--                     WExSI       => WritetoMemory,            --Active Low
--                     AddrxDI     => AddrtoMemory,
--                     RYxSO       => RYsig,
--                     DataxDI     => DatatoMemory,
--                     DataxDO     => DataOutFromDMSig       
--             );

    SRAM_SP_WRAPPER_inst    : SRAM_SP_WRAPPER
             port map(
                    a           => AddrtoMemory,
                    d           => DatatoMemory,
                    clk         => clk, 
                    we          => WritetoMemory,
                    spo         => DataOutFromDMSig    
             );      
             
        
    JALMUXinst      :   JALMUX
      Port map  (
            InstructionIn           =>      InstructionFrmIMMux( 31 downto 26 ),
            PC4in                   =>      PC4toIFIDRegSig,
            WriteDataOut            =>      DataFromJALMUX,
            RegWriteFrmJAL          =>      RegWrite31sig    
             );
             
    JRMUXinst       :   JRMUX
      Port map(
	    ALUCtrl		    =>	    ALUCtrlSig,
            PCin                    =>      AddrfromJumpMuxSig,
            ALUResultIn             =>      ALUResultToEXMEMRegSig,
            PCout                   =>      AddrfromJumpRMuxSig    
            );
    
 
    
    MemoryController_inst       :       MemoryController
    port map 
        (   clk                     =>  clk,
            reset                   =>  reset,
            start                   =>  start,
            MemRead                 =>  MemReadsigFromIDEX,
            MemWrite                =>  MemWritesigFromIDEX,
            DataIn                  =>  ReadData2fromEXRegSig,
            DataAddr                =>  ALUResultFromEXMEMRegSig(9 downto 2),
            PCin                    =>  PCtoIMSig( 7 downto 0 ),
            DO                      =>  DatatoMemory,
            Addr                    =>  AddrtoMemory,
            CSxI                    =>  ReadtoMemory,
            WExI                    =>  WritetoMemory,
            Input                   => DataOutFromDMSig,
            InstrOut                => InstructionFrmIMMux,
            DataOut                 => DataOutDMFromWBRegSig,  
            PCstart                 =>  PCstartsig 
        );

 
    
end Behavioral;
