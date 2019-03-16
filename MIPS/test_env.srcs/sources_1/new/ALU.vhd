----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2018 11:02:46 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC_VECTOR (4 downto 0);
       sw : in STD_LOGIC_VECTOR (15 downto 0);
       led : out STD_LOGIC_VECTOR (15 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0));
end ALU;

architecture Behavioral of ALU is

component MPG
Port(en:out STD_LOGIC;
     input:in STD_LOGIC;
     clk:in STD_LOGIC);    
end component;
component SSD 
   Port ( clk:in STD_LOGIC;
          digit:in STD_LOGIC_VECTOR(15 downto 0);
          an: out STD_LOGIC_VECTOR(3 downto 0);
          cat:out STD_LOGIC_VECTOR(6 downto 0));
end component;

signal A:STD_LOGIC_VECTOR(15 downto 0);
signal B:STD_LOGIC_VECTOR(15 downto 0);
signal S:STD_LOGIC_VECTOR(15 downto 0);
signal count:STD_LOGIC_VECTOR(1 downto 0);
signal rez:STD_LOGIC_VECTOR(15 downto 0);
signal en:STD_LOGIC;

begin

A<=x"000"&sw(3 downto 0);
B<=x"000"&sw(7 downto 0);
S<=x"00"&sw(7 downto 0);

process(clk)
begin
   if rising_edge(clk) then
     if en='1' then
       count<=count+1;
     end if;
   end if;
end process;

process(sw,count)
begin
  case count is
    when "00" =>rez<=A+B;
    when "01" =>rez<=A-B;
    when "10" =>rez<=S(13 downto 0)&"00";
    when "11" =>rez<="00"&S(13 downto 0);
  end case;
end process;

led(7)<='1' when count=x"000" else '0';
  
pp1:MPG port map(en,btn(0),clk);
pp2:SSD port map(clk,rez,cat,an);

end Behavioral;
