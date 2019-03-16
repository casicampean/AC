----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2018 10:17:39 AM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
   Port(clk:in STD_LOGIC;
       instr:in STD_LOGIC_VECTOR(15 downto 0);
       wd:in STD_LOGIC_VECTOR(15 downto 0);
       regWrite:in STD_LOGIC;
       regDest:in STD_LOGIC;
       extOpt:in STD_LOGIC;
       rd1:out STD_LOGIC_VECTOR(15 downto 0);
       rd2:out STD_LOGIC_VECTOR(15 downto 0);
       ext_imm:out STD_LOGIC_VECTOR(15 DOWNTO 0);
       opcode:out STD_LOGIC_VECTOR(2 downto 0);
       func:out STD_LOGIC_VECTOR(2 downto 0);
       sa:out STD_LOGIC);
end ID;

architecture Behavioral of ID is

component reg_file 
Port(clk:in STD_LOGIC;
     reg1:in STD_LOGIC_VECTOR(2 downto 0);
     reg2:in STD_LOGIC_VECTOR(2 downto 0);
     wa:in STD_LOGIC_VECTOR(2 downto 0);
     wd : in std_logic_vector (15 downto 0);
     wen : in std_logic;
     rd1 : out std_logic_vector (15 downto 0);
     rd2 : out std_logic_vector (15 downto 0));
end component;
signal muxWa:STD_LOGIC_VECTOR(2 downto 0);
begin

p1:reg_file port map(clk,instr(12 downto 10),instr(9 downto 7),muxWa,wd,regWrite,rd1,rd2);

muxWA<=instr(9 downto 7) when regDest='0' else instr(6 downto 4);
func<=instr(2 downto 0);
sa<=instr(3);
opcode<=instr(15 downto 13);
process(instr(6 downto 0),extOpt)
begin
    if extOpt='0' then
    ext_imm(15 downto 7)<="000000000";
    ext_imm(6 downto 0)<=instr(6 downto 0);
    else
         ext_imm(15 downto 7)<=(others =>instr(6));
         ext_imm(6 downto 0)<=instr(6 downto 0);
         end if;
         end process;
        
    
   

end Behavioral;
