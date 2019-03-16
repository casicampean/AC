----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2018 11:17:53 AM
-- Design Name: 
-- Module Name: RAM_mem - Behavioral
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

entity RAM_mem is
port ( clk : in std_logic;
       wr : in std_logic;
       adr : in std_logic_vector(3 downto 0);
       wd : in std_logic_vector(15 downto 0);
       rd : out std_logic_vector(15 downto 0));
end RAM_mem;

architecture Behavioral of RAM_mem is
type ram_type is array (0 to 32) of std_logic_vector(15 downto 0);
signal RAM: ram_type:=(
x"0001",
x"0002",
others=>x"0000");
begin
process (clk)
   begin
     if clk'event and clk = '1' then
         if wr = '1' then
           RAM(conv_integer(adr)) <= wd;
        end if;
      end if;
end process;
rd <= RAM( conv_integer(adr));--citire

end Behavioral;
