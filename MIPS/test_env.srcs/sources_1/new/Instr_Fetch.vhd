----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2018 10:28:41 AM
-- Design Name: 
-- Module Name: Instr_Fetch - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instr_Fetch is
    Port(buton:in STD_LOGIC;
         clk:in STD_LOGIC;
         PcSrc:in STD_LOGIC;
         Jump:in STD_LOGIC;
         BrAdr : in STD_LOGIC_VECTOR (15 downto 0);
         JumpAdr : in STD_LOGIC_VECTOR (15 downto 0);
         Instr:out STD_LOGIC_VECTOR (15 downto 0);
         count2:out STD_LOGIC_VECTOR (15 downto 0));
end Instr_Fetch;

architecture Behavioral of Instr_Fetch is

type ROM_type is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal ROM:ROM_type:=(
0=>B"001_000_000_0000000",
1=>B"001_000_001_0001010",	 --addi $1,$0,10  $1<-10
2=>B"001_000_010_0000101",	 --addi $2,$0,5   $2<-5
3=>B"000_001_010_011_0_000", --add $3,$1,$2   $3<-15


5=>B"000_011_001_100_0_001", --sub $4,$3,$1   $4<-10 


6=>B"000_000_100_101_1_010", --sll $5,$4,1    $5<-1010=10	  



7=>B"000_000_100_110_1_011", --srl $6,$4,1    $6<-2
8=>B"000_101_110_010_0_100", --and $2,$5,$6   $2<-2


9=>B"000_110_011_100_0_101", --or  $4,$6,$3   $4<-15
10=>B"000_011_010_101_0_110", --xor $5,$3,$2   $5<-13 
11=>B"000_010_011_001_0_111", --nor $1,$2,$3  $1<-FFF0
12=>B"011_100_010_0000000",--sw $2,0($4)
13=>B"110_101_011_0001100",--ori $3,$5,12   $3<-13
14=>B"101_011_101_0001100",--andi $5,$3,12  $5<-12
15=>B"100_101_100_0000001",--beq $5,$4,1

16=>B"111_0000000001110",--j 14	 

17=>B"010_100_110_0000000",--lw $6,0($4)
18=>B"000_001_010_011_0_001",--
19=>B"000_001_010_011_0_001",--
others=>x"0000");

signal count:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal sumatorOut:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal muxOut1,muxOut2:STD_LOGIC_VECTOR(15 downto 0);
signal BrAdd:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal IAdd:STD_LOGIC_VECTOR(15 downto 0):=x"0000";


begin
process(clk,buton)
begin
    if rising_edge(clk) then
      if buton='1' then
           count<=muxOut2;          
      end if;
    end if;
  end process;
  
  sumatorOut<=count+1;
  Instr<=ROM(conv_integer(count));
  muxOut1<=sumatorOut when PcSrc='0' else BrAdr;
  muxOut2<=muxOut1 when Jump='0' else JumpAdr;
  count2<=sumatorOut;
  
  


end Behavioral;
